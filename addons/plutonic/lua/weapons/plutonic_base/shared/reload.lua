-- Separating for my fucking brains sake.
function SWEP:CanReload()
	if self:GetOwner():IsNPC() then return self:Clip1() < self.Primary.ClipSize and not self:GetReloading() and self:GetNextPrimaryFire() < CurTime() end
	if self:GetReloading() then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	if self:Ammo1() == 0 then return false end
	--[[ Chambering
	if self.CannotChamber then
		return self:Clip1() < self.Primary.ClipSize
	else
		if self:Clip1() == 0 then return self:Clip1() < self.Primary.ClipSize + 1 end

		return self:Clip1() < self.Primary.ClipSize + 1
	end]]--

	-- regular magazine reload only
    return self:Clip1() < self.Primary.ClipSize
end

function SWEP:Reload()
	if not self:CanReload() then return end

	self:GetOwner():DoReloadEvent()

	if not self.DoEmptyReloadAnim or self:Clip1() ~= 0 then
		self:PlayAnim(ACT_VM_RELOAD)
	else
		self:PlayAnim(ACT_VM_RELOAD_EMPTY)
	end

	self:QueueIdle()
	
	if self.ReloadSound then
		self:EmitSound(Sound(self.ReloadSound))
	elseif self.OnReload then
		self.OnReload(self)
	end

	if self.ReloadWorldSound and SERVER then 
		self:EmitWorldSound(self.ReloadWorldSound)
	end

	self:SetReloading(true)
	self:SetReloadTime(CurTime() + self:GetOwner():GetViewModel():SequenceDuration())

	hook.Run("LongswordWeaponReload", self:GetOwner(), self)
end

function SWEP:FinishReload()
	self:SetReloading(false)
	--[[local amount
	 one in the chamber
	if self.CannotChamber then
		amount = math.min(self:GetMaxClip1() - self:Clip1(), self:Ammo1())
	else
		if self:Clip1() == 0 then
			amount = math.min(self:GetMaxClip1() - self:Clip1(), self:Ammo1())
		else
			amount = math.min((self:GetMaxClip1() + 1) - self:Clip1(), self:Ammo1())
		end
	end]]-- 

    local amount = math.min(self:GetMaxClip1() - self:Clip1(), self:Ammo1())

	self:SetClip1(self:Clip1() + amount)
	self:GetOwner():RemoveAmmo(amount, self:GetPrimaryAmmoType())
end