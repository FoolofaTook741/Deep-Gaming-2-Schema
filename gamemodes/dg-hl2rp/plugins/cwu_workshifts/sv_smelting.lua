local smeltGoal = 200 --not used anymore as the main goal, refinedGoal is
local refinedGoal = 200 -- set this value to determine how much refinining needs to be done.
local basePayout = 8000
local recycleBonus = 25
local turtleBonus = 50
local completedCooldown = 20 * 60
local cancelledCooldown = 5 * 60

impulse.SmeltingRecycleBonus = recycleBonus
impulse.SmeltingTurtleBonus = turtleBonus

util.AddNetworkString("SmeltingNPC_OpenMenu")
util.AddNetworkString("SmeltingWorkshift_Start")
util.AddNetworkString("SmeltingWorkshift_Payout")
util.AddNetworkString("SmeltingWorkshift_Update")
util.AddNetworkString("SmeltingWorkshift_Broadcast")
util.AddNetworkString("SmeltingWorkshift_Cancel")

impulse.SmeltingWorkshift = impulse.SmeltingWorkshift or {
	active         = false,
	smeltCount     = 0,
	refinedCount   = 0,
	bonusCredits   = 0,
	smeltGoal      = smeltGoal,
	refinedGoal    = refinedGoal,
	supervisorID   = 0,
	supervisorName = "",
	paid           = false,
}

local DATA_FILE = "impulse_smelting_log.json"

local function LoadShiftLog()
	if file.Exists(DATA_FILE, "DATA") then
		local raw = file.Read(DATA_FILE, "DATA")
		local decoded = util.JSONToTable(raw)
		if decoded then
			impulse.SmeltingCompletedShifts = decoded.completedShifts or 0
			impulse.SmeltingShiftLog        = decoded.log or {}
			return
		end
	end
	impulse.SmeltingCompletedShifts = 0
	impulse.SmeltingShiftLog        = {}
end

local function SaveShiftLog()
	local data = {
		completedShifts = impulse.SmeltingCompletedShifts,
		log             = impulse.SmeltingShiftLog,
	}
	file.Write(DATA_FILE, util.TableToJSON(data, true))
end

LoadShiftLog()

local function BroadcastAll(msg)
	for _, ply in ipairs(player.GetAll()) do
		ply:ChatPrint(msg)
	end
end

local function BroadcastCWU(msg)
	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		ply:ChatPrint(msg)
	end
end

local function BroadcastChat(msgType, supervisorName, completedShifts)
	for _, ply in ipairs(player.GetAll()) do
		net.Start("SmeltingWorkshift_Broadcast")
			net.WriteString(msgType)
			net.WriteString(supervisorName)
			net.WriteInt(completedShifts or 0, 16)
		net.Send(ply)
	end
end

function impulse.SmeltingPushUpdate()
	local ws = impulse.SmeltingWorkshift
	local payoutReady = ws.active and ws.refinedCount >= ws.refinedGoal and not ws.paid

	for _, ply in ipairs(player.GetAll()) do
		net.Start("SmeltingWorkshift_Update")
			net.WriteBool(ws.active)
			net.WriteInt(ws.smeltCount, 16)
			net.WriteInt(ws.smeltGoal, 16)
			net.WriteInt(ws.refinedCount, 16)
			net.WriteInt(ws.refinedGoal, 16)
			net.WriteInt(ws.bonusCredits, 16)
			net.WriteString(ws.supervisorName)
			net.WriteInt(impulse.SmeltingCompletedShifts, 16)
			net.WriteBool(payoutReady)
		net.Send(ply)
	end
end

local function StartSmeltingWorkshift(supervisor)
	local ws = impulse.SmeltingWorkshift

	if ws.active then
		supervisor:Notify("A smelting workshift is already in progress!")
		return
	end

	if impulse.SmeltingCooldownEnd and CurTime() < impulse.SmeltingCooldownEnd then
		local remaining = math.ceil(impulse.SmeltingCooldownEnd - CurTime())
		local mins = math.floor(remaining / 60)
		local secs = remaining % 60
		supervisor:Notify("The refinery is on cooldown. Available in " .. mins .. "m " .. secs .. "s.")
		return
	end

	ws.active          = true
	ws.smeltCount      = 0
	ws.refinedCount    = 0
	ws.bonusCredits    = 0
	ws.smeltGoal       = smeltGoal
	ws.refinedGoal     = refinedGoal
	ws.paid            = false
	ws.supervisorID    = supervisor:SteamID64() or 0
	ws.supervisorName  = supervisor:Nick()
	ws.startTime       = os.time()

	BroadcastAll(
		"[CIVIC BROADCAST] " .. supervisor:Nick() ..
		" has started a REFINERY SMELTING workshift. Report to the refinery with your CWU unit!"
	)
	BroadcastChat("start", supervisor:Nick(), 0)

	impulse.SmeltingPushUpdate()
end

local function CleanupSmeltingProps()
	for _, ent in ipairs(ents.GetAll()) do
		if not IsValid(ent) then continue end
		if ent:GetNWBool("IsSmeltingItem", false) 
		or ent:GetNWBool("IsRecycleItem", false) then
			ent:Remove()
		end
		if ent:GetClass() == "impulse_hl2rp_copperbar" then
			ent:Remove()
		end
	end
end

net.Receive("DeepStartWorkshift", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU then return end
	if ply:GetTeamClass() ~= CLASS_REFINERY then return end
	if ply:GetTeamRank() < RANK_SUPERVISOR then return end

	local wsType = net.ReadString()
	if wsType == "mining" then
		StartSmeltingWorkshift(ply)
	end
end)

net.Receive("SmeltingWorkshift_Start", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU then return end
	if ply:GetTeamClass() ~= CLASS_REFINERY then return end
	if ply:GetTeamRank() < RANK_SUPERVISOR then return end

	StartSmeltingWorkshift(ply)
end)

hook.Add("EntityRemoved", "SmeltingFizzleTrack", function(ent)
	if not IsValid(ent) then return end
	if not ent:GetNWBool("IsSmeltingItem", false) then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end
	if ws.paid then return end

	ws.smeltCount = ws.smeltCount + 1

	--BroadcastCWU("[REFINERY] Scrap smelted: " .. ws.smeltCount .. " available for copper processing.")

	impulse.SmeltingPushUpdate()
end)

hook.Add("Use", "SmeltingRefineryCollect", function(ent, activator, caller, useType, value)
	if not IsValid(ent) or ent:GetClass() ~= "deep_refinery" then return end
	if not IsValid(activator) or not activator:IsPlayer() then return end
	if activator:Team() ~= TEAM_CWU or activator:GetTeamClass() ~= CLASS_REFINERY then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end

	if not ent.smeltingCopperReady then return end

	ent.smeltingCopperReady = false
	activator:GiveInventoryItem("item_steelbar", 1)
	activator:Notify("You collected a steel bar from the refinery.")
end)

net.Receive("SmeltingWorkshift_Payout", function(len, ply)
	if not IsValid(ply) then return end

	local ws = impulse.SmeltingWorkshift

	if not ws.active then
		ply:Notify("There is no active workshift.")
		return
	end

	if ply:Team() ~= TEAM_CWU or ply:GetTeamClass() ~= CLASS_REFINERY or ply:GetTeamRank() < RANK_SUPERVISOR then
		ply:Notify("Only the workshift Supervisor can collect the workshift payout.")
		return
	end

	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the shift lead can collect the workshift payout.")
		return
	end

	if ws.refinedCount < ws.refinedGoal then
		ply:Notify("The refined steel goal has not been met yet. (" .. ws.refinedCount .. "/" .. ws.refinedGoal .. ")")
		return
	end

	if ws.paid then
		ply:Notify("This workshift has already been paid out.")
		return
	end

	ws.paid = true

	CleanupSmeltingProps()

	local totalPayout = basePayout + (ws.bonusCredits or 0)
	ply:GiveMoney(totalPayout)
	ply:Notify("Workshift payout collected: " .. totalPayout .. " credits (" .. basePayout .. " base + " .. (ws.bonusCredits or 0) .. " recycle bonus). Distribute to your workers.")

	BroadcastAll(
		"[CIVIC BROADCAST] Smelting workshift completed by " .. ply:Nick() ..
		". " .. ws.refinedCount .. " steel bars delivered. Well done, workers!"
	)
	BroadcastChat("end", ws.supervisorName, impulse.SmeltingCompletedShifts + 1)

	impulse.SmeltingCompletedShifts = impulse.SmeltingCompletedShifts + 1

	table.insert(impulse.SmeltingShiftLog, {
		completedAt   = os.date("%Y-%m-%d %H:%M:%S"),
		supervisor    = ws.supervisorName,
		steelDelivered = ws.refinedCount,
		bonusCredits  = ws.bonusCredits,
		totalPayout   = totalPayout,
		shiftNumber   = impulse.SmeltingCompletedShifts,
	})

	SaveShiftLog()

	impulse.SmeltingCooldownEnd = CurTime() + completedCooldown

	impulse.SmeltingWorkshift = {
		active         = false,
		smeltCount     = 0,
		refinedCount   = 0,
		bonusCredits   = 0,
		smeltGoal      = smeltGoal,
		refinedGoal    = refinedGoal,
		supervisorID   = 0,
		supervisorName = "",
		paid           = false,
	}

	impulse.SmeltingPushUpdate()
end)

net.Receive("SmeltingWorkshift_Cancel", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU or ply:GetTeamRank() < RANK_SUPERVISOR then
		ply:Notify("Only a CWU Supervisor can cancel the workshift.")
		return
	end

	local ws = impulse.SmeltingWorkshift
	if not ws.active then
		ply:Notify("There is no active workshift to cancel.")
		return
	end

	local supervisorName = ws.supervisorName
	BroadcastChat("cancel", supervisorName, 0)

	impulse.SmeltingCooldownEnd = CurTime() + cancelledCooldown

	CleanupSmeltingProps()

	impulse.SmeltingWorkshift = {
		active         = false,
		smeltCount     = 0,
		refinedCount   = 0,
		bonusCredits   = 0,
		smeltGoal      = smeltGoal,
		refinedGoal    = refinedGoal,
		supervisorID   = 0,
		supervisorName = "",
		paid           = false,
	}

	impulse.SmeltingPushUpdate()
end)

function impulse.SmeltingNPC_SendMenu(caller)
	if not caller:GetTeamRank() then
		caller:Notify("You must be on the refinery branch to speak to this person!")
		return
	end

	local ws = impulse.SmeltingWorkshift
	local payoutReady = ws.active and ws.refinedCount >= ws.refinedGoal and not ws.paid

	net.Start("SmeltingNPC_OpenMenu")
		net.WriteBool(ws.active)
		net.WriteInt(ws.smeltCount, 16)
		net.WriteInt(ws.smeltGoal, 16)
		net.WriteInt(ws.refinedCount, 16)
		net.WriteInt(ws.refinedGoal, 16)
		net.WriteInt(ws.bonusCredits, 16)
		net.WriteString(ws.supervisorName)
		net.WriteInt(impulse.SmeltingCompletedShifts, 16)
		net.WriteBool(payoutReady)
		net.WriteBool(caller:GetTeamRank() >= RANK_SUPERVISOR)
	net.Send(caller)
end
