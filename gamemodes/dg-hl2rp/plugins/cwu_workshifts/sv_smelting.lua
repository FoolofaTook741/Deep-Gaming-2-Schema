local smeltGoal = 200
local refinedGoal = 200 --use this one to define the goals, it scales based on group
local basePayout = 8000
local recycleBonus = 40
local turtleBonus = 75
local completedCooldown = 20 * 60
local cancelledCooldown = 5 * 60
local minGroupSize = 4
local maxGroupSize = 10

impulse.SmeltingRecycleBonus = recycleBonus
impulse.SmeltingTurtleBonus = turtleBonus

util.AddNetworkString("SmeltingNPC_OpenMenu")
util.AddNetworkString("SmeltingWorkshift_Form")
util.AddNetworkString("SmeltingWorkshift_Begin")
util.AddNetworkString("SmeltingWorkshift_Payout")
util.AddNetworkString("SmeltingWorkshift_Update")
util.AddNetworkString("SmeltingWorkshift_Broadcast")
util.AddNetworkString("SmeltingWorkshift_Cancel")

impulse.SmeltingWorkshift = impulse.SmeltingWorkshift or {
	active         = false,
	forming        = false,
	formingSquadID = nil,
	smeltCount     = 0,
	refinedCount   = 0,
	bonusCredits   = 0,
	smeltGoal      = smeltGoal,
	refinedGoal    = refinedGoal,
	scaledPayout   = basePayout,
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

local function BroadcastCWU(msg)
	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		ply:ChatPrint(msg)
	end
end

local function BroadcastChat(msgType, supervisorName, completedShifts, extra)
	for _, ply in ipairs(player.GetAll()) do
		net.Start("SmeltingWorkshift_Broadcast")
			net.WriteString(msgType)
			net.WriteString(supervisorName)
			net.WriteInt(completedShifts or 0, 16)
			net.WriteString(extra or "")
		net.Send(ply)
	end
end

local function GetSquadSize(squadID)
	local count = 0
	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		if ply:GetSyncVar(SYNC_CWU_SQUAD) == squadID then
			count = count + 1
		end
	end
	return count
end

local function GetFormingSquadSize()
	local ws = impulse.SmeltingWorkshift
	if not ws.formingSquadID then return 0 end
	return GetSquadSize(ws.formingSquadID)
end

local function AutoCreateSquad(supervisor)
	local existingSquad = supervisor:GetSyncVar(SYNC_CWU_SQUAD)
	if existingSquad and existingSquad ~= 0 then
		return existingSquad
	end

	local lowestFree = 1
	local squads = {}
	local biggestSquad = 0

	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		local squad = ply:GetSyncVar(SYNC_CWU_SQUAD)
		if not squad then continue end
		squads[squad] = true
		if squad > biggestSquad then
			biggestSquad = squad
		end
	end

	for i = 1, biggestSquad + 1 do
		if not squads[i] then
			lowestFree = i
			break
		end
	end

	supervisor:SetSyncVar(SYNC_CWU_SQUADLEAD, true, true)
	supervisor:SetSyncVar(SYNC_CWU_SQUAD, lowestFree, true)

	return lowestFree
end

local plyMeta = FindMetaTable("Player")
local OriginalCWUSquadCanJoin = plyMeta.CWUSquadCanJoin
function plyMeta:CWUSquadCanJoin(squadID)
	local ws = impulse.SmeltingWorkshift
	if ws and ws.formingSquadID and ws.formingSquadID == squadID and ws.active then
		return false
	end
	return OriginalCWUSquadCanJoin(self, squadID)
end

local function GetDisplayPayout(ws, squadSize)
	if ws.active then
		return ws.scaledPayout or basePayout
	end
	if ws.forming then
		local size = squadSize or GetFormingSquadSize()
		local scale = math.Clamp(math.max(size, 1), 1, maxGroupSize) / maxGroupSize
		return math.Round(basePayout * scale)
	end
	return basePayout
end

function impulse.SmeltingPushUpdate()
	local ws = impulse.SmeltingWorkshift
	local payoutReady = ws.active and ws.refinedCount >= ws.refinedGoal and not ws.paid
	local squadSize = (ws.forming or ws.active) and GetFormingSquadSize() or 0
	local displayPayout = GetDisplayPayout(ws, squadSize)

	for _, ply in ipairs(player.GetAll()) do
		net.Start("SmeltingWorkshift_Update")
			net.WriteBool(ws.active)
			net.WriteBool(ws.forming or false)
			net.WriteInt(ws.smeltCount, 16)
			net.WriteInt(ws.smeltGoal, 16)
			net.WriteInt(ws.refinedCount, 16)
			net.WriteInt(ws.refinedGoal, 16)
			net.WriteInt(ws.bonusCredits, 16)
			net.WriteInt(displayPayout, 16)
			net.WriteString(ws.supervisorName)
			net.WriteInt(impulse.SmeltingCompletedShifts, 16)
			net.WriteBool(payoutReady)
			net.WriteInt(squadSize, 8)
			net.WriteInt(minGroupSize, 8)
		net.Send(ply)
	end
end

local function CleanupSmeltingProps()
	local toRemove = {}
	for _, ent in ipairs(ents.GetAll()) do
		if not IsValid(ent) then continue end
		if ent:GetNWBool("IsSmeltingItem", false)
		or ent:GetNWBool("IsRecycleItem", false)
		or ent:GetClass() == "impulse_hl2rp_copperbar" then
			table.insert(toRemove, ent)
		end
	end
	for _, ent in ipairs(toRemove) do
		if IsValid(ent) then ent:Remove() end
	end
end

local function FormSmeltingWorkshift(ply)
	local ws = impulse.SmeltingWorkshift

	if ws.active or ws.forming then
		ply:Notify("A smelting workshift is already in progress or being formed!")
		return
	end

	if impulse.SmeltingCooldownEnd and CurTime() < impulse.SmeltingCooldownEnd then
		local remaining = math.ceil(impulse.SmeltingCooldownEnd - CurTime())
		local mins = math.floor(remaining / 60)
		local secs = remaining % 60
		ply:Notify("The refinery is on cooldown. Available in " .. mins .. "m " .. secs .. "s.")
		return
	end

	local squadID = AutoCreateSquad(ply)
	if not squadID then
		ply:Notify("Could not create a workshift group. All squad slots may be full.")
		return
	end

	ws.forming        = true
	ws.formingSquadID = squadID
	ws.supervisorID   = ply:SteamID64() or 0
	ws.supervisorName = ply:Nick()

	BroadcastChat("forming", ply:Nick(), 0)

	impulse.SmeltingPushUpdate()
end

net.Receive("SmeltingWorkshift_Form", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU then return end
	if ply:GetTeamClass() ~= CLASS_REFINERY then return end
	if ply:GetTeamRank() < RANK_SUPERVISOR then return end
	FormSmeltingWorkshift(ply)
end)

net.Receive("SmeltingWorkshift_Begin", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU then return end
	if ply:GetTeamClass() ~= CLASS_REFINERY then return end
	if ply:GetTeamRank() < RANK_SUPERVISOR then return end

	local ws = impulse.SmeltingWorkshift

	if not ws.forming then
		ply:Notify("No workshift group is being formed.")
		return
	end

	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the workshift organiser can begin the shift.")
		return
	end

	local squadSize = GetFormingSquadSize()
	if squadSize < minGroupSize then
		ply:Notify("Not enough workers. Need at least " .. minGroupSize .. " (currently " .. squadSize .. ").")
		return
	end

	local scale        = math.Clamp(squadSize, 1, maxGroupSize) / maxGroupSize
	local scaledGoal   = math.max(1, math.Round(refinedGoal * scale))
	local scaledSmelt  = math.max(1, math.Round(smeltGoal * scale))
	local scaledPayout = math.Round(basePayout * scale)

	ws.active        = true
	ws.forming       = false
	ws.smeltCount    = 0
	ws.refinedCount  = 0
	ws.bonusCredits  = 0
	ws.smeltGoal     = scaledSmelt
	ws.refinedGoal   = scaledGoal
	ws.scaledPayout  = scaledPayout
	ws.paid          = false
	ws.startTime     = os.time()

	BroadcastChat("start", ply:Nick(), 0, tostring(squadSize))

	impulse.SmeltingPushUpdate()
end)

net.Receive("DeepStartWorkshift", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU then return end
	if ply:GetTeamClass() ~= CLASS_REFINERY then return end
	if ply:GetTeamRank() < RANK_SUPERVISOR then return end

	local wsType = net.ReadString()
	if wsType == "mining" then
		FormSmeltingWorkshift(ply)
	end
end)

hook.Add("EntityRemoved", "SmeltingFizzleTrack", function(ent)
	if not IsValid(ent) then return end
	if not ent:GetNWBool("IsSmeltingItem", false) then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end
	if ws.paid then return end

	ws.smeltCount = ws.smeltCount + 1

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

	local totalPayout = (ws.scaledPayout or basePayout) + (ws.bonusCredits or 0)
	ply:GiveMoney(totalPayout)
	ply:Notify("Workshift payout collected: " .. totalPayout .. " credits (" .. (ws.scaledPayout or basePayout) .. " base + " .. (ws.bonusCredits or 0) .. " recycle bonus). Distribute to your workers.")

	BroadcastChat("end", ws.supervisorName, impulse.SmeltingCompletedShifts + 1)

	impulse.SmeltingCompletedShifts = impulse.SmeltingCompletedShifts + 1

	table.insert(impulse.SmeltingShiftLog, {
		completedAt    = os.date("%Y-%m-%d %H:%M:%S"),
		supervisor     = ws.supervisorName,
		steelDelivered = ws.refinedCount,
		bonusCredits   = ws.bonusCredits,
		totalPayout    = totalPayout,
		shiftNumber    = impulse.SmeltingCompletedShifts,
	})

	SaveShiftLog()

	impulse.SmeltingCooldownEnd = CurTime() + completedCooldown

	impulse.SmeltingWorkshift = {
		active         = false,
		forming        = false,
		formingSquadID = nil,
		smeltCount     = 0,
		refinedCount   = 0,
		bonusCredits   = 0,
		smeltGoal      = smeltGoal,
		refinedGoal    = refinedGoal,
		scaledPayout   = basePayout,
		supervisorID   = 0,
		supervisorName = "",
		paid           = false,
	}

	impulse.SmeltingPushUpdate()
end)

net.Receive("SmeltingWorkshift_Cancel", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU or ply:GetTeamClass() ~= CLASS_REFINERY or ply:GetTeamRank() < RANK_SUPERVISOR then
		ply:Notify("Only a CWU Refinery Supervisor can cancel the workshift.")
		return
	end

	local ws = impulse.SmeltingWorkshift
	if not ws.active and not ws.forming then
		ply:Notify("There is no active workshift to cancel.")
		return
	end

	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the shift lead can cancel the workshift.")
		return
	end

	local supervisorName = ws.supervisorName
	BroadcastChat("cancel", supervisorName, 0)

	if ws.active then
		impulse.SmeltingCooldownEnd = CurTime() + cancelledCooldown
		CleanupSmeltingProps()
	end

	impulse.SmeltingWorkshift = {
		active         = false,
		forming        = false,
		formingSquadID = nil,
		smeltCount     = 0,
		refinedCount   = 0,
		bonusCredits   = 0,
		smeltGoal      = smeltGoal,
		refinedGoal    = refinedGoal,
		scaledPayout   = basePayout,
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

	if caller:GetTeamClass() ~= CLASS_REFINERY then
		caller:Notify("You must be on the refinery branch to speak to this person!")
		return
	end

	local ws = impulse.SmeltingWorkshift
	local payoutReady = ws.active and ws.refinedCount >= ws.refinedGoal and not ws.paid
	local squadSize = (ws.forming or ws.active) and GetFormingSquadSize() or 0
	local isShiftLead = caller:SteamID64() == tostring(ws.supervisorID)
	local displayPayout = GetDisplayPayout(ws, squadSize)

	net.Start("SmeltingNPC_OpenMenu")
		net.WriteBool(ws.active)
		net.WriteBool(ws.forming or false)
		net.WriteInt(ws.smeltCount, 16)
		net.WriteInt(ws.smeltGoal, 16)
		net.WriteInt(ws.refinedCount, 16)
		net.WriteInt(ws.refinedGoal, 16)
		net.WriteInt(ws.bonusCredits, 16)
		net.WriteInt(displayPayout, 16)
		net.WriteString(ws.supervisorName)
		net.WriteInt(impulse.SmeltingCompletedShifts, 16)
		net.WriteBool(payoutReady)
		net.WriteBool(caller:GetTeamRank() >= RANK_SUPERVISOR)
		net.WriteInt(squadSize, 8)
		net.WriteInt(minGroupSize, 8)
		net.WriteBool(isShiftLead)
	net.Send(caller)
end