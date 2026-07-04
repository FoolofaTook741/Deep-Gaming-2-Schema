include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end


function ENT:Initialize()
    self:ResetSequence(self:LookupSequence("idleoff"))
    self:SetPlaybackRate(1)
end

function ENT:Think()
    self:FrameAdvance()

    local pressed = self:GetNWBool("Pressed", false)
    if pressed and not self._wasPressed then
        self:ResetSequence(self:LookupSequence("turn_ON"))
        self:SetPlaybackRate(1)
        self._wasPressed = true
    elseif not pressed and self._wasPressed then
        self:ResetSequence(self:LookupSequence("idleoff"))
        self:SetPlaybackRate(1)
        self._wasPressed = false
    end
end