AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/breenconsole.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    if self.impulseSaveKeyValue then
        self:SetBlock(self.impulseSaveKeyValue["Block"])
    else
        self:SetColor(Color(255, 0, 0, 255))
    end
end

function ENT:Use(caller, activator)
    if (self.nextTry or 0) > CurTime() then return end

	if activator:IsPlayer() && activator:Alive() && activator:OnGround() then
		if (activator:GetPos() - self:GetPos()):LengthSqr() < (180 ^ 2) then -- make sure the player is looking bit of the terminal that has all the controls
		    self:EmitBudgetSound("ambient/machines/keyboard_slow_1second.wav")
            net.Start("impulseHL2RPBlockTerminalDerma")
            net.WriteInt(self:GetBlock(), 8)
            net.Send(activator)
		end
	end

	self.nextTry = CurTime() + 1.5
end
