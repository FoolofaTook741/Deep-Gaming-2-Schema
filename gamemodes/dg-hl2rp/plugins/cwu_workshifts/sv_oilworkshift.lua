local OIL_GOAL    = 2000
local BASE_PAYOUT = 12000
local DATA_FILE   = "impulse_oil_log.json"
local MIN_GROUP   = 4
local MAX_GROUP   = 10

util.AddNetworkString("OilNPC_OpenMenu")
util.AddNetworkString("OilWorkshift_Form")
util.AddNetworkString("OilWorkshift_Begin")
util.AddNetworkString("OilWorkshift_Payout")
util.AddNetworkString("OilWorkshift_Update")
util.AddNetworkString("OilWorkshift_GoalMet")
util.AddNetworkString("OilWorkshift_End")
util.AddNetworkString("OilWorkshift_Broadcast")

local function CleanupOilProps()
	local classes = {
		"impulse_hl2rp_oildrum",
		"impulse_hl2rp_citybarrel",
		"impulse_hl2rp_oilcart",
	}
	for _, class in ipairs(classes) do
		for _, ent in ipairs(ents.FindByClass(class)) do
			if IsValid(ent) then ent:Remove() end
		end
	end
	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) then
			while ply:HasInventoryItem("item_oilcan") do
				ply:TakeInventoryItemClass("item_oilcan")
			end
		end
	end
end

impulse.OilWorkshift = impulse.OilWorkshift or {
	active          = false,
	forming         = false,
	formingSquadID  = nil,
	oilDeposited    = 0,
	bonusCredits    = 0,
	reservoirLiters = 0,
	supervisorID    = 0,
	supervisorName  = "",
	squadSize       = 0,
	goalMet         = false,
	paid            = false,
}

local function LoadLog()
	if file.Exists(DATA_FILE, "DATA") then
		local decoded = util.JSONToTable(file.Read(DATA_FILE, "DATA") or "")
		if decoded then
			impulse.OilCompletedShifts = decoded.completedShifts or 0
			impulse.OilShiftLog        = decoded.log or {}
			return
		end
	end
	impulse.OilCompletedShifts = 0
	impulse.OilShiftLog        = {}
end

local function SaveLog()
	file.Write(DATA_FILE, util.TableToJSON({
		completedShifts = impulse.OilCompletedShifts,
		log             = impulse.OilShiftLog,
	}, true))
end

LoadLog()

local function BroadcastChat(msgType, supervisorName, completedShifts, extra)
	for _, ply in ipairs(player.GetAll()) do
		net.Start("OilWorkshift_Broadcast")
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
	local ws = impulse.OilWorkshift
	if not ws.formingSquadID then return 0 end
	return GetSquadSize(ws.formingSquadID)
end

local function AutoCreateSquad(supervisor)
	local existing = supervisor:GetSyncVar(SYNC_CWU_SQUAD)
	if existing and existing ~= 0 then return existing end

	local squads = {}
	local biggest = 0
	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		local sq = ply:GetSyncVar(SYNC_CWU_SQUAD)
		if not sq then continue end
		squads[sq] = true
		if sq > biggest then biggest = sq end
	end

	local lowestFree = 1
	for i = 1, biggest + 1 do
		if not squads[i] then lowestFree = i; break end
	end

	supervisor:SetSyncVar(SYNC_CWU_SQUADLEAD, true, true)
	supervisor:SetSyncVar(SYNC_CWU_SQUAD, lowestFree, true)
	return lowestFree
end

local plyMeta = FindMetaTable("Player")
local origCanJoin = plyMeta.CWUSquadCanJoin
function plyMeta:CWUSquadCanJoin(squadID)
	local ws = impulse.OilWorkshift
	if ws and ws.formingSquadID and ws.formingSquadID == squadID and ws.active then
		return false
	end
	return origCanJoin(self, squadID)
end

local function PushUpdate()
	local ws       = impulse.OilWorkshift
	local sqSize   = (ws.forming or ws.active) and GetFormingSquadSize() or 0
	for _, ply in ipairs(player.GetAll()) do
		net.Start("OilWorkshift_Update")
			net.WriteBool(ws.active)
			net.WriteBool(ws.forming)
			net.WriteInt(ws.reservoirLiters or 0, 32)
			net.WriteInt(ws.oilDeposited    or 0, 32)
			net.WriteInt(ws.bonusCredits    or 0, 32)
			net.WriteInt(sqSize, 8)
			net.WriteInt(MIN_GROUP, 8)
			net.WriteInt(ws.scaledGoal    or OIL_GOAL, 32)
			net.WriteInt(ws.scaledPayout  or BASE_PAYOUT, 32)
		net.Send(ply)
	end
end

impulse.OilPushUpdate = PushUpdate

net.Receive("OilWorkshift_Form", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU or (ply:GetTeamRank() or 0) < RANK_SUPERVISOR then
		ply:Notify("Only CWU Supervisors can form an oil workshift.")
		return
	end
	local ws = impulse.OilWorkshift
	if ws.active or ws.forming then
		ply:Notify("An oil workshift is already active or forming.")
		return
	end

	local squadID = AutoCreateSquad(ply)
	if not squadID then
		ply:Notify("Could not create a workshift group.")
		return
	end

	ws.forming        = true
	ws.formingSquadID = squadID
	ws.supervisorID   = ply:SteamID64() or 0
	ws.supervisorName = ply:Nick()

	BroadcastChat("forming", ply:Nick(), 0)
	PushUpdate()
end)

net.Receive("OilWorkshift_Begin", function(len, ply)
	if not IsValid(ply) then return end
	if ply:Team() ~= TEAM_CWU or (ply:GetTeamRank() or 0) < RANK_SUPERVISOR then
		ply:Notify("Only CWU Supervisors can begin a workshift.")
		return
	end
	local ws = impulse.OilWorkshift
	if not ws.forming then
		ply:Notify("No workshift is currently forming.")
		return
	end
	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the workshift organiser can begin the shift.")
		return
	end

	local size = GetFormingSquadSize()
	if size < MIN_GROUP then
		ply:Notify("Not enough workers. Need at least " .. MIN_GROUP .. " (currently " .. size .. ").")
		return
	end

	local scale       = math.Clamp(size, 1, MAX_GROUP) / MAX_GROUP
	local scaledGoal  = math.max(1, math.Round(OIL_GOAL * scale))
	local scaledPay   = math.Round(BASE_PAYOUT * scale)

	ws.forming          = false
	ws.active           = true
	ws.oilDeposited     = 0
	ws.bonusCredits     = 0
	ws.reservoirLiters  = 0
	ws.squadSize        = size
	ws.scaledGoal       = scaledGoal
	ws.scaledPayout     = scaledPay
	ws.goalMet          = false
	ws.paid             = false

	BroadcastChat("start", ply:Nick(), 0, tostring(size))

	local barrelsNeeded = math.ceil(scaledGoal / 40)
	local crudeNeeded   = barrelsNeeded * 200
	ply:Notify("Shift goal: " .. barrelsNeeded .. " barrels (" .. crudeNeeded .. "L crude) needed to produce " .. scaledGoal .. "L refined oil.")

	PushUpdate()
end)

net.Receive("OilWorkshift_Payout", function(len, ply)
	if not IsValid(ply) then return end
	local ws = impulse.OilWorkshift
	if not ws.active then ply:Notify("No active oil workshift."); return end
	if not ws.goalMet then ply:Notify("Goal not met yet (" .. ws.oilDeposited .. "L / " .. (ws.scaledGoal or OIL_GOAL) .. "L)."); return end
	if ws.paid then ply:Notify("This workshift has already been paid out."); return end
	if ply:Team() ~= TEAM_CWU or (ply:GetTeamRank() or 0) < RANK_SUPERVISOR then
		ply:Notify("Only the workshift supervisor can collect payout.")
		return
	end
	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the shift lead can collect the payout.")
		return
	end

	ws.paid = true
	local total = (ws.scaledPayout or BASE_PAYOUT) + (ws.bonusCredits or 0)
	ply:GiveMoney(total)

	impulse.OilCompletedShifts = (impulse.OilCompletedShifts or 0) + 1
	table.insert(impulse.OilShiftLog, {
		date       = os.date("%Y-%m-%d %H:%M"),
		supervisor = ply:Nick(),
		oilLiters  = ws.oilDeposited,
		bonus      = ws.bonusCredits,
		workers    = ws.squadSize,
		payout     = total,
	})
	SaveLog()

	BroadcastChat("end", ws.supervisorName, impulse.OilCompletedShifts)

	CleanupOilProps()

	impulse.OilWorkshift = {
		active          = false,
		forming         = false,
		formingSquadID  = nil,
		oilDeposited    = 0,
		bonusCredits    = 0,
		reservoirLiters = 0,
		supervisorID    = 0,
		supervisorName  = "",
		squadSize       = 0,
		goalMet         = false,
		paid            = false,
	}

	net.Start("OilWorkshift_End")
	net.Broadcast()
	PushUpdate()
end)

net.Receive("OilWorkshift_End", function(len, ply)
	if not IsValid(ply) then return end
	local ws = impulse.OilWorkshift
	if not ws.active and not ws.forming then return end
	if ply:Team() ~= TEAM_CWU or (ply:GetTeamRank() or 0) < RANK_SUPERVISOR then
		ply:Notify("Only a CWU Supervisor can cancel the workshift.")
		return
	end
	if ply:SteamID64() ~= tostring(ws.supervisorID) then
		ply:Notify("Only the shift lead can cancel the workshift.")
		return
	end

	local wasForming = ws.forming
	local supName    = ws.supervisorName

	impulse.OilWorkshift = {
		active          = false,
		forming         = false,
		formingSquadID  = nil,
		oilDeposited    = 0,
		bonusCredits    = 0,
		reservoirLiters = 0,
		supervisorID    = 0,
		supervisorName  = "",
		squadSize       = 0,
		goalMet         = false,
		paid            = false,
	}

	if wasForming then
		BroadcastChat("cancel", supName, 0)
	else
		BroadcastChat("cancelactive", supName, 0)
		CleanupOilProps()
	end

	net.Start("OilWorkshift_End")
	net.Broadcast()
	PushUpdate()
end)

function impulse.OilNPC_SendMenu(caller)
	local ws           = impulse.OilWorkshift
	local completed    = impulse.OilCompletedShifts or 0
	local isSupervisor = caller:Team() == TEAM_CWU and (caller:GetTeamRank() or 0) >= RANK_SUPERVISOR
	local isShiftLead  = caller:SteamID64() == tostring(ws.supervisorID)
	local sqSize       = (ws.forming or ws.active) and GetFormingSquadSize() or 0

	net.Start("OilNPC_OpenMenu")
		net.WriteBool(ws.active or false)
		net.WriteBool(ws.forming or false)
		net.WriteInt(ws.oilDeposited or 0, 32)
		net.WriteInt(ws.reservoirLiters or 0, 32)
		net.WriteInt(ws.bonusCredits or 0, 32)
		net.WriteBool(ws.goalMet or false)
		net.WriteBool(ws.paid or false)
		net.WriteString(ws.supervisorName or "")
		net.WriteInt(sqSize, 8)
		net.WriteInt(MIN_GROUP, 8)
		net.WriteInt(ws.scaledGoal   or OIL_GOAL, 32)
		net.WriteInt(ws.scaledPayout or BASE_PAYOUT, 32)
		net.WriteInt(completed, 16)
		net.WriteBool(isSupervisor)
		net.WriteBool(isShiftLead)
	net.Send(caller)
end

hook.Add("PlayerInitialSpawn", "OilWorkshift_SyncNewPlayer", function(ply)
	timer.Simple(3, function()
		if IsValid(ply) then PushUpdate() end
	end)
end)