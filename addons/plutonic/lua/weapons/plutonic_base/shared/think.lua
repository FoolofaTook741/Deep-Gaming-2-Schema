function SWEP:IdleThink()
	if self:GetNextIdle() == 0 then return; end
	if CurTime() > self:GetNextIdle() then
		self:SetNextIdle(0);
		if self.IdleSequence then
			local vm = self:GetOwner():GetViewModel();
			local transition = vm:FindTransitionSequence(vm:GetSequence(), vm:LookupSequence(self.IdleSequence));
			if transition ~= -1 then
				vm:SetSequence(transition);
			else
				vm:SetSequence(self.IdleSequence);
			end
		else
			self:SendWeaponAnim(self:Clip1() > 0 and ACT_VM_IDLE or ACT_VM_IDLE_EMPTY);
		end
	end
end

function SWEP:SprintChanged(is_sprinting)
	if not self.UseSprintSequence then return; end
	local vm = self:GetOwner():GetViewModel();
	if is_sprinting then
		local transition = vm:FindTransitionSequence(vm:GetSequence(), vm:LookupSequence(self.SprintSequence));
		print(transition, vm:GetSequence(), vm:LookupSequence(self.SprintSequence));
		if transition ~= -1 then
			self:PlaySequence(transition);
		else
			self:PlaySequence(self.SprintSequence);
		end
	else
		self:PlayAnim(ACT_VM_IDLE);
	end
end

SWEP.__sprinting = false;
function SWEP:SprintThink()
	local sprinting = self:IsSprinting();
	if sprinting ~= self.__sprinting then
		self:SprintChanged(sprinting);
		self.__sprinting = sprinting;
	end
end

function SWEP:Think()
	self.EquippedAttachments = self.EquippedAttachments or {};
	self.AttachmentEntCache = self.AttachmentEntCache or {};

	self:FiremodeThink()

	if Plutonic.IsClient then
		self:ViewmodelThink();
	end


	if SERVER then
		self:HolsterThink();
		self:SprintThink();
	end

	self:IronsightsThink();
	self:RecoilThink();
	self:IdleThink();
	if self.CustomThink then
		self.CustomThink(self);
	end

	if self:GetBursting() then
		self:BurstThink();
	end

	if self:GetReloading() then
		self:ReloadThink();
	end

	if not Plutonic.IsClient then return; end
end

function SWEP:RecoilThink()
	self:SetRecoil(math.Clamp(self:GetRecoil() - FrameTime() * (self.Primary.RecoilRecoveryRate or 1.4), 0, self.Primary.MaxRecoil or 1));
end

function SWEP:BurstThink()
	if self.Burst and (self.nextBurst or 0) < CurTime() then
		self:TakePrimaryAmmo(1);
		self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self:CalculateSpread());
		self:AddRecoil();
		self:ViewPunch();
		self:EmitSound(self.Primary.Sound);
		self.Burst = self.Burst - 1;
		if self.Burst < 1 then
			self:SetBursting(false);
			self.Burst = nil;
		else
			self.nextBurst = CurTime() + self.Primary.Delay;
		end
	end
end

-- ADS noises
sound.Add(
	{
		name = "Plutonic.ADS.In",
		sound = {"weapons/ins2/uni/uni_ads_in_01.wav", "weapons/ins2/uni/uni_ads_in_02.wav", "weapons/ins2/uni/uni_ads_in_03.wav", "weapons/ins2/uni/uni_ads_in_04.wav", "weapons/ins2/uni/uni_ads_in_05.wav", "weapons/ins2/uni/uni_ads_in_06.wav"},
		level = 60,
		channel = CHAN_AUTO,
		pitch = {95, 105}
	}
);

sound.Add(
	{
		name = "Plutonic.ADS.Out",
		sound = {"weapons/ins2/uni/uni_ads_out_01.wav"},
		level = 60,
		channel = CHAN_AUTO,
		pitch = {95, 105}
	}
);

function SWEP:IronsightsThink()
	if (self.CanDecreaseBlowback or 0) < CurTime() then
		self:SetIronsightsRecoil(math.Clamp(self:GetIronsightsRecoil() - (FrameTime() * 600), 0, 1));
	end

	if not self:CanIronsight() then
		self:SetIronsights(false);

		return;
	end

	if self:GetOwner():KeyDown(IN_ATTACK2) and not self:GetIronsights() then
		self:SetIronsights(true);
		self:EmitSound("Plutonic.ADS.In");
		--self:SetHoldType( IronsightsIO[self.HoldType] or "ar2" )
		if CLIENT then
			self.VMIronsights = math.ease.InSine(self.VMIronsights or 0);
		end
	elseif not self:GetOwner():KeyDown(IN_ATTACK2) and self:GetIronsights() then
		self:SetIronsights(false);
		self:EmitSound("Plutonic.ADS.Out");
		--self:SetHoldType( self.HoldType )
		if CLIENT then
			self.VMIronsights = math.ease.OutExpo(self.VMIronsights or 0);
		end
	end
end

function SWEP:ReloadThink()
	if self:GetReloadTime() < CurTime() then
		self:FinishReload();
	end
end

function SWEP:FiremodeThink()
	local ply = self:GetOwner()

	if ply:KeyDown(IN_USE) and ply:KeyDown(IN_RELOAD) and self.FireModes then
		return self:ToggleFireMode()
	end
end