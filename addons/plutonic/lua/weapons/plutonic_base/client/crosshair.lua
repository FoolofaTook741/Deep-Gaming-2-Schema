SWEP.CrosshairAlpha = 1
SWEP.CrosshairSpread = 0
function SWEP:ShouldDrawCrosshair()
	if self.NoCrosshair then return false end
	if hook.Run("ShouldDrawLocalPlayer", self:GetOwner()) then return true end
	if self:GetReloading() or (self:IsSprinting() and self.LoweredPos) then return false end
	if self:GetIronsights() and not self.IronsightsCrosshair and self.VMIronsights > 0.1 then return false end

	return true
end