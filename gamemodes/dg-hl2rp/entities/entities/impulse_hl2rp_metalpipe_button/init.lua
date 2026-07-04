AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_mining/freightelevatorbutton02.mdl")
    --self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.useDelay = 0
    self:SetPlaybackRate(1)
    self:ResetSequence(self:LookupSequence("idleoff"))
end

function ENT:Use(caller, activator)
    if self.useDelay > CurTime() then return end
    if not IsValid(caller) or not caller:IsPlayer() then return end
    if caller:Team() ~= TEAM_CWU then return end

    local nearest = nil
    local nearestDist = 1000 ^ 2

    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_metalpipe")) do
        if not IsValid(ent) then continue end
        local dist = self:GetPos():DistToSqr(ent:GetPos())
        if dist < nearestDist then
            nearestDist = dist
            nearest = ent
        end
    end

    if not IsValid(nearest) then
        caller:Notify("No pipe found nearby.")
        return
    end

    self.useDelay = CurTime() + 2
    self:EmitSound("buttons/button4.wav")

    self:SetNWBool("Pressed", true)
	timer.Simple(self:SequenceDuration(self:LookupSequence("turn_ON")), function()
	    if IsValid(self) then
	        self:SetNWBool("Pressed", false)
	    end
	end)
    nearest:Use(caller, caller)
end