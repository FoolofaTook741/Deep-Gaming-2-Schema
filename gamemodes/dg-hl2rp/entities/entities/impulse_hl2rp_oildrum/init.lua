AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self._spawnTime = CurTime()
end

function ENT:Think()

    local ws = impulse.OilWorkshift
    if not (ws and ws.active) then
        if not self._noShiftTime then
            self._noShiftTime = CurTime() + 600
        elseif CurTime() > self._noShiftTime then
            self:Remove()
        end
    else
        self._noShiftTime = nil
    end
    self:NextThink(CurTime() + 30)
    return true
end
