AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/breenconsole.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end

    self.Cooldowns = {}
    self.COOLDOWN  = 1
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    local sid = activator:SteamID()
    if self.Cooldowns[sid] and CurTime() < self.Cooldowns[sid] then
        activator:Notify("Please wait before using this again.")
        return
    end
    self.Cooldowns[sid] = CurTime() + self.COOLDOWN

    if activator:IsCollaborator() then
        DyePaintMachineOpen(activator, self)
    else
        DyeShopOpen(activator, self)
    end
end