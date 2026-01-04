function SWEP:CalculateSpread()
	local spread = self.Primary.Cone
	if self:GetOwner():IsNPC() then return spread end
	local maxSpeed = self.LoweredPos and self:GetOwner():GetWalkSpeed() or self:GetOwner():GetRunSpeed()
	spread = spread + self.Primary.Cone * math.Clamp(self:GetOwner():GetVelocity():Length2D() / maxSpeed, 0, self.Spread.VelocityMod)
	spread = spread + self:GetRecoil() * self.Spread.RecoilMod
	if not self:GetOwner():IsOnGround() then
		spread = spread * self.Spread.AirMod
	end

	if self:GetOwner():IsOnGround() and self:GetOwner():Crouching() then
		spread = spread * self.Spread.CrouchMod
	end

	if self:GetIronsights() then
		spread = spread * (self.Spread.IronsightsMod or 1)
	end

	spread = math.Clamp(spread, self.Spread.Min, self.Spread.Max)
	if Plutonic.IsClient then
		self.LastSpread = Lerp(FrameTime() * 8, self.LastSpread or 0, spread)
	end

	return spread
end

function SWEP:AddRecoil()
	self:SetRecoil(math.Clamp(self:GetRecoil() + self.Primary.Recoil * 0.4, 0, self.Primary.MaxRecoil or 1))
	self:DoRecoil()
end

SWEP.Primary.RecoilSide = 0.15   -- Horizontal recoil strength
SWEP.Primary.RecoilUp = 0.25     -- Vertical recoil strength (up)
SWEP.Primary.RecoilDown = 0.05   -- Vertical recoil strength (down)
function SWEP:DoRecoil()
	local recoil = self:GetRecoil()
	local maxDown = self.Primary.RecoilDown * recoil
	local maxSide = self.Primary.RecoilSide * recoil
	local side = math.Rand(-maxSide, maxSide)
	local up = math.Rand(-maxDown, maxDown)
	self:GetOwner():ViewPunch(Angle(up, side, side * .34))
end