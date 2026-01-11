AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("PinnaclePurchaseVehicle")

local Vehicles = {
    ["lvs_wheeldrive_hl2_combine_apc_armed"] = {
        Cost = 2000,
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-10811.891601563, 145.67665100098, 8316.607421875)
    },
    ["lvs_helicopter_hl2_combine_dropship_bypass"] = {
        Cost = 18000,
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-11393.229492188, 620.19006347656, 8407.421875)
    },
    ["lvs_helicopter_hl2_combine_hunter"] = {
        Cost = 25000,
        class = CLASS_NOMAD,
        faction = TEAM_OTA,
        spawnVec = Vector(-11393.229492188, 620.19006347656, 8407.421875)
    }
}

local ExploitAttempts = ExploitAttempts or {}

local function LogExploitAttempt(ply, reason, vehicleID)
    if not IsValid(ply) then return end

    ExploitAttempts[ply] = (ExploitAttempts[ply] or 0) + 1

    local msg = string.format(
        "[VEHICLE-REQ BLOCKED] %s (%s | %s) | Vehicle: %s | Reason: %s | Attempts: %d",
        ply:Nick(),
        ply:SteamID(),
        ply:SteamID64(),
        tostring(vehicleID),
        reason,
        ExploitAttempts[ply]
    )


	if ExploitAttempts[ply] >= 5 then
		impulse.debugPrint("[VEHICLE-REQ] WARNING: Repeated exploit attempts by " .. ply:Nick())
		impulse.debugPrint("[VEHICLE-REQ] Taking action against " .. ply:SteamID())
	end

    print(msg)
end

net.Receive("PinnaclePurchaseVehicle", function(_, ply)
    local vehicleID = net.ReadString()
    local data = Vehicles[vehicleID]

    if not data then
        LogExploitAttempt(ply, "Invalid vehicle ID", vehicleID)
        return
    end

    if ply:Team() ~= data.faction then
        LogExploitAttempt(ply, "Wrong faction", vehicleID)
        return ply:Notify("You are not in the correct faction.")
    end

    if ply:GetTeamClass() ~= data.class then
        LogExploitAttempt(ply, "Wrong class", vehicleID)
        return ply:Notify("You are not the correct class.")
    end

    if OCAAB_CUR_FUNDS < data.Cost then
        LogExploitAttempt(ply, "Insufficient funds", vehicleID)
        return ply:Notify("You do not have enough OCAAB.")
    end

    ExploitAttempts[ply] = nil

    OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - data.Cost

    net.Start("DeepAdjustFunds")
        net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()

    local ent = ents.Create(vehicleID)
    if not IsValid(ent) then return end

    ent:SetPos(data.spawnVec)
    ent:Spawn()

    ply:Notify("Vehicle requisition approved.")
end)

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSkin(1)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

util.AddNetworkString("PinnacleVehicleTerminalOpen")

function ENT:OnTakeDamage(dmg) 
	return false
end

function ENT:Use(activator, caller)
	if activator:IsCP() and (activator:Team() == TEAM_CA or activator:GetTeamClass()) then
		if not self.User then
			self:EmitBudgetSound("ambient/machines/keyboard_slow_1second.wav")
			net.Start("PinnacleVehicleTerminalOpen")
			net.Send(activator)
		else
			activator:Notify("Terminal already in use.")
		end
	else
		self:EmitBudgetSound("buttons/combine_button_locked.wav")
		activator:Notify("You cannot access this terminal.")
	end
	self.nextTry = CurTime() + 1.5
end

local useSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle4.wav"
}

function ENT:EmitUseSound()
	self:EmitSound(useSounds[math.random(1, #useSounds)])
end