AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/powerbox01a.mdl")
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:DrawShadow(false)
    local physObj = self:GetPhysicsObject()
    self:GetNearbyForcefields()

    if (IsValid(physObj)) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end
    self:SetColor(Color(255, 255, 255, 255))
end

function ENT:SpawnFunction(ply, trace, class)
    local angles = (trace.HitPos - ply:GetPos()):Angle()
    angles.r = 0
    angles.p = 0
    angles.y = angles.y + 180

    local entity = ents.Create(class)
    entity:SetPos(trace.HitPos)
    entity:SetAngles(angles)
    entity:Spawn()

    return entity
end

function ENT:GetNearbyForcefields()
	for v,k in ipairs((ents.FindByClass("impulse_hl2rp_forcefield_left"))) do
        local dist = k:GetPos():Distance(self:GetPos())

        if (dist < 300) then
            self:SetForcefield(k)
        end
	end
end

function ENT:GetEMPCooldown()
    return (self.EMPCOOLDOWN or 0)
end

function ENT:DisableForcefield()
    local forcefieldref = self:GetForcefield()
    if not forcefieldref:GetFFEMP() then
		if CurTime() < self:GetEMPCooldown() then return end
		self.EMPCOOLDOWN = CurTime() + 1800
    
        --forcefieldref:SetFFStatus(false)
        forcefieldref:SetFFEMP(true)
    end
end

function ENT:Use(activator, caller)
    if activator:Team() == TEAM_CP and activator:GetTeamClass() == CLASS_GRID then
        local forcefieldref = self:GetForcefield()
        if forcefieldref:GetFFEMP() then
            activator:Notify("You have repaired the forcefield.")
            forcefieldref:SetFFEMP(false)
        end
    elseif activator.IsARebel and activator:HasInventoryItemSpecific("item_emp") then
        self:DisableForcefield()
    end
end

function ENT:Think()
    if IsValid(self:GetForcefield()) then return end
    self:SetColor(Color(255, 0, 0, 255)) -- IF INVALID 
    self:GetNearbyForcefields()
end