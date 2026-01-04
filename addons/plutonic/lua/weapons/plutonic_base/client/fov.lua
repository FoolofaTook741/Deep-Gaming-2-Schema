SWEP.FOVMultiplier = 1
SWEP.LastFOVUpdate = 0 -- gets called many times per frame... weird.
function SWEP:TranslateFOV(fov)
	if self.LastFOVUpdate < CurTime() then
		self.FOVMultiplier = Lerp(FrameTime() * (5 * (self.IronsightsSpeed / 4)), self.FOVMultiplier, self:GetIronsights() and self.IronsightsFOV or 1)
		self.LastFOVUpdate = CurTime()
		self.VMRecoilFOV = self.VMRecoilFOV or 0
		self.VMRecoilFOV = Lerp(FrameTime() * 8, self.VMRecoilFOV or 1, 0)
	end

	if self.scopedIn then return fov * (self.FOVScoped or 1) end
	if self:GetIronsights() then return (fov * self.FOVMultiplier) + (.8 * self.VMRecoilFOV) end

	return fov * self.FOVMultiplier
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then return self.IronsightsSensitivity end
end