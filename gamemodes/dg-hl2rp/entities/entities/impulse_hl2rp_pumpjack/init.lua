AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local FILL_COOLDOWN = 5
local CONTAM_CHANCE = 20

function ENT:Initialize()
    self:SetModel("models/tsbb/pump_jack.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-104 + 30, -32, 12), Vector(60 + 30, 47, 200))
    self.cooldowns = {}
end

function ENT:SpawnFunction(ply, trace, class)
    if not gamemode.Call("PlayerSpawnSENT", ply, class) then return end

    local ent = ents.Create(class)
    ent:SetPos(trace.HitPos)
    ent:SetAngles(Angle(0, ply:EyeAngles().y + 90, 0))
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
        activator:Notify("You cannot interact with this.")
        return
    end

    local ws = impulse.OilWorkshift
    if not ws or not ws.active then
        activator:Notify("[PUMP JACK] No oil refinery workshift is active.")
        return
    end

    local sid = activator:SteamID()
    if self.cooldowns[sid] and CurTime() < self.cooldowns[sid] then
        activator:Notify("[PUMP JACK] Still pressurizing. Wait " .. math.ceil(self.cooldowns[sid] - CurTime()) .. " more seconds.")
        return
    end

    local contaminated = math.random(1, 100) <= CONTAM_CHANCE

    local drum = ents.Create("impulse_hl2rp_oildrum")
    if not IsValid(drum) then
        activator:Notify("[PUMP JACK] Failed to create drum. Contact an admin.")
        return
    end
    drum:SetPos(self:GetPos() + Vector(-115, 0, 15))
    drum:SetNWBool("Contaminated", contaminated)
    drum:SetNWString("OwnerSID", sid)
    drum:Spawn()
    drum:Activate()

    self:EmitSound("ambient/materials/bump1.wav")
    self.cooldowns[sid] = CurTime() + FILL_COOLDOWN

    if contaminated then
        activator:Notify("[PUMP JACK] Filled a 200L drum - WARNING: crude appears contaminated. Filter it at the boiler for full reservoir credit.")
    else
        activator:Notify("[PUMP JACK] Filled a 200L drum of crude oil. Carry it to the crude reservoir.")
    end
end