SWEP.Gun							= ("weapon_wallhammershield")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "ULTRASH0CK WH SHIELD"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Ultrash0ck"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= false
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Wallhammer Shield"
SWEP.Type							= "Payback Shield"
SWEP.DrawAmmo						= false
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 65
SWEP.Slot							= 2
SWEP.SlotPos						= 100
SWEP.QuickDraw 						= true

SWEP.FiresUnderwater 				= false

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 0
SWEP.Primary.DefaultClip			= 0
SWEP.Primary.RPM					= 0
SWEP.Primary.RPM_Burst				= 0
SWEP.Primary.Ammo					= "none"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc17.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 0
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Single"
}

SWEP.IronRecoilMultiplier			= 0.44
SWEP.CrouchRecoilMultiplier			= 0.33
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.18
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 5
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel 						= "models/synapse/weapons/c_combine_hand_shield.mdl"
SWEP.WorldModel						= "models/weapons/heavyshotgun/w_shotgun_heavy.mdl"
SWEP.ViewModelFOV					= 45
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "physgun"

SWEP.ShowWorldModel = true

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0,-2.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(0,5,0)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.15
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.01
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 2
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.RunSightsPos = Vector(2, -9.5, -15)
SWEP.RunSightsAng = Vector(39, -0.5, -2)

SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.AllowThirdperson = true
SWEP.ThirdpersonDistance = 50

-- Sound definitions - relative paths for resource.AddFile compatibility
local EQUIP_SOUND = "handshield/wpn_charger_flashbang_shield_up_01.wav"
local UNEQUIP_SOUND = "handshield/wpn_charger_flashbang_shield_down_01.wav"
local LOOP_SOUND = "handshield/wpn_charger_flashbang_shield_lp_01.wav"
local WINDUP_SOUND = "handshield/wpn_charger_flashbang_windup_blast_01.wav"

-- Force precache on both client and server
sound.Add({
	name = "shield_equip",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 70,
	pitch = 100,
	sound = EQUIP_SOUND
})

sound.Add({
	name = "shield_unequip",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 70,
	pitch = 100,
	sound = UNEQUIP_SOUND
})

sound.Add({
	name = "shield_loop",
	channel = CHAN_ITEM,
	volume = 0.6,
	level = 70,
	pitch = 100,
	sound = LOOP_SOUND
})

sound.Add({
	name = "shield_charge",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 70,
	pitch = 100,
	sound = WINDUP_SOUND
})

SWEP.VElements = {}
SWEP.WElements = {}

DEFINE_BASECLASS(SWEP.Base)

if SERVER then
	local CMoveData = FindMetaTable("CMoveData")
	function CMoveData:RemoveKeys(keys)
		local newbuttons = bit.band(self:GetButtons(), bit.bnot(keys))
		self:SetButtons(newbuttons)
	end

	hook.Add("SetupMove", "RestrictChargerMovement", function(ply, mvd, cmd)
		if ply.restrictMovement then
			mvd:RemoveKeys(IN_DUCK + IN_JUMP + IN_SPEED)
		end
	end)
end

function SWEP:Deploy()
	-- Track equipped time for auto-unequip after 20 seconds
	--self.equipTime = CurTime()
	
	-- Play the player animation
	if SERVER then
		if type(self.Owner.ForceSequence) == "function" then
			self.Owner:ForceSequence("shield_equip")
		end
		self:RestrictMovement()

		self.voiceLinePlayed = false

		local iChanceForVoice = math.random( 1, 6 )
		if iChanceForVoice == 1 then
			local phrases = {
				"PREPARING WALL",
				"RAISING WALL"
			}

			local randomPhrase = phrases[math.random(#phrases)]
			self.Owner:ConCommand("say /rs " .. randomPhrase)
			self.voiceLinePlayed = true
		end
	end

	-- Setup shield with delay (reduced to 1 second as requested)
	timer.Simple(0.7, function()
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon() == self then
			-- Setup shield world model
			self:SetupShield()

			-- Play sound when the shield appears
			self:EmitSound("shield_equip")

			-- Start the looping sound
			timer.Simple(0.5, function()
				if IsValid(self) and SERVER then
					-- Start the looping sound
					self.loopSoundPlaying = true
					self:EmitSound("shield_loop")

					if not self.voiceLinePlayed then
						local iChanceForVoice = math.random(1, 2)
						if iChanceForVoice == 1 then
							local phrases = {
								"WALL UP",
								"SHIELD UP",
								"WALL IS ON"
							}

							local randomPhrase = phrases[math.random(#phrases)]
							self.Owner:ConCommand("say /rs " .. randomPhrase)
							self.voiceLinePlayed = true
						end
					end

					local entIndex = self:EntIndex()
					timer.Create("shield_loop_timer" .. entIndex, 7, 0, function()
						if not IsValid(self) or not IsValid(self:GetOwner()) then
							timer.Remove("shield_loop_timer" .. entIndex)
							return
						end

						if self:GetOwner():GetActiveWeapon() == self and IsValid(self.shieldProp) then
							self:EmitSound("shield_loop")
						end
					end)
				end
			end)
		end
	end)

	if CLIENT then
		self.playedUnequip = false
	end

	return BaseClass.Deploy(self)
end

function SWEP:RestrictMovement()
    local pPlayer = self:GetOwner()
    if not IsValid(pPlayer) then return end

    self._originalRunSpeed = pPlayer:GetRunSpeed()
    self._originalWalkSpeed = pPlayer:GetWalkSpeed()
    self._originalJumpPower = pPlayer:GetJumpPower()

    pPlayer:SetWalkSpeed(60)
    pPlayer:SetRunSpeed(60)
    pPlayer:SetJumpPower(0)
    pPlayer.disableSprint = true
    pPlayer.restrictMovement = true
end

function SWEP:UnrestrictMovement()
    local pPlayer = self:GetOwner()
    if not IsValid(pPlayer) then return end

    pPlayer:SetRunSpeed(self._originalRunSpeed or 160)
    pPlayer:SetWalkSpeed(self._originalWalkSpeed or 80)
    pPlayer:SetJumpPower(self._originalJumpPower or 160)
    pPlayer.disableSprint = false
    pPlayer.restrictMovement = false
end

function SWEP:Holster(target)
	-- Call base class first to avoid double animations
	BaseClass.Holster(self, target)
	
	if SERVER then
		-- Play the unequip sound first
		self:EmitSound("shield_unequip")

		-- Play the player unequip animation
		if type(self.Owner.ForceSequence) == "function" then
			self.Owner:ForceSequence("shield_unequip")
		end
		self:UnrestrictMovement()

		-- Stop the loop sound
		self:StopSound("shield_loop")
		self.loopSoundPlaying = false

		-- Remove shield prop
		if IsValid(self.shieldProp) then
			self.shieldProp:Remove()
		end
	end

	return true
end

function SWEP:OnRemove()
	if SERVER then
		self:UnrestrictMovement()

		-- Stop loop sound
		self:StopSound("shield_loop")
		self.loopSoundPlaying = false

		-- Remove shield prop
		if IsValid(self.shieldProp) then
			self.shieldProp:Remove()
		end
	end

	return BaseClass.OnRemove(self)
end

function SWEP:OnDrop()
	if SERVER then
		self:UnrestrictMovement()

		-- Stop loop sound
		self:StopSound("shield_loop")
		self.loopSoundPlaying = false

		-- Remove shield prop
		if IsValid(self.shieldProp) then
			self.shieldProp:Remove()
		end
	end

	return BaseClass.OnDrop(self)
end

if SERVER then
    hook.Add("OnPlayerChangedTeam", "ShieldMovementCleanup", function(ply)
        timer.Simple(0, function()
            ply.restrictMovement = false
	        ply.disableSprint = false
	        ply:SetJumpPower(160)
	        ply:SetRunSpeed(impulse.Config.JogSpeed)
	    	ply:SetWalkSpeed(impulse.Config.WalkSpeed)
	        end)
    end)
end

SWEP.canBeDestroyedByDamage = false
SWEP.onlyExplosionDamage = false
SWEP.defaultHealth = 5000

function SWEP:SetupShield()
	if CLIENT then return end

	self.shieldProp = ents.Create("prop_physics")
	self.shieldProp:SetModel("models/synapse/props/combine_hand_shield.mdl")
	self.shieldProp:Spawn()
	self.shieldProp:SetModelScale(0, 0)
	local phys = self.shieldProp:GetPhysicsObject()

	if not IsValid(phys) then
		self.Owner:ChatPrint("not valid physics object!")
		return
	end

	phys:SetMass(5000)

	local nothand = false

	local attach = self.Owner:LookupAttachment("anim_attachment_shield")

	up = 2
	forward = 20
	aforward = 0
	aup = 0
	right = 0

	if nothand then
		up = 0
		forward = 0
		aforward = 0
		aup = 0
		right = 0
	end

	local attachTable = self.Owner:GetAttachment(attach)
	self.shieldProp:SetPos(attachTable.Pos + attachTable.Ang:Up()*up + attachTable.Ang:Forward()*forward + attachTable.Ang:Right()*right)
	attachTable.Ang:RotateAroundAxis(attachTable.Ang:Forward(),aforward)
	attachTable.Ang:RotateAroundAxis(attachTable.Ang:Up(),aup)
	self.shieldProp:SetAngles(attachTable.Ang)
	self.shieldProp:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.shieldProp:SetParent(self.Owner, attach)

	timer.Simple(0.2, function()
		if IsValid(self) and IsValid(self.shieldProp) then
			self.shieldProp:SetModelScale(1.1, 0)
		end
	end)
end

function SWEP:CreateFlashSprite()
	if CLIENT then return end
	if not IsValid(self.shieldProp) then return end

	if IsValid(self.flashSprite) then return end

	local eFlashSprite = ents.Create("env_sprite")

	local shieldPos = self.shieldProp:GetPos()
	local shieldAng = self.shieldProp:GetAngles()
	local spritePos = shieldPos + shieldAng:Forward() * 20

	eFlashSprite:SetPos(spritePos)
	eFlashSprite:SetAngles(shieldAng)
	eFlashSprite:SetParent(self.shieldProp)
	eFlashSprite:SetKeyValue("model", "sprites/blueflare1.vmt")
	eFlashSprite:SetKeyValue("scale", "5")
	eFlashSprite:SetKeyValue("rendermode", "5")
	eFlashSprite:SetKeyValue("rendercolor", "87 53 240")
	eFlashSprite:Spawn()

	eFlashSprite:Fire("HideSprite", "", 0)

	self.flashSprite = eFlashSprite
end

function SWEP:Flash()
	if CLIENT then return end

	local pCharger = self:GetOwner()
	if not IsValid(pCharger) then return end

	if not IsValid(self.shieldProp) then return end
	if not IsValid(self.flashSprite) then
		self:CreateFlashSprite()
	end

	local vPos = self.shieldProp:GetPos()

	for _, eEnt in pairs(ents.FindInSphere(vPos, 224)) do
		-- Check if IsCombine exists, default to false for Sandbox
		local isCombine = type(eEnt.IsCombine) == "function" and eEnt:IsCombine() or false
		
		if IsValid(eEnt) and eEnt:IsPlayer() and not isCombine then
			local vPlayerPos = eEnt:GetPos()

			local shieldForward = pCharger:GetAimVector()
			local nScannerDot = shieldForward:Dot((vPlayerPos - vPos):GetNormal())
			local nPlayerDot = eEnt:GetAimVector():Dot((vPos - vPlayerPos):GetNormal())
			local nThreshold = 0.2 + math.Clamp((0.6 / 384) * vPlayerPos:Distance(vPos), 0, 0.6)

			-- Check if CanSeeEntity exists, use simple visibility check for Sandbox
			local canSeeShield = type(eEnt.CanSeeEntity) == "function" and eEnt:CanSeeEntity(self.shieldProp, 0.75) or true
			
			if eEnt ~= pCharger and canSeeShield and nPlayerDot >= nThreshold and nScannerDot >= nThreshold then
				-- Only apply effects if framework methods exist
				if type(eEnt.ScreenFade) == "function" then
					local fadeColor = Color(255, 255, 255, 255)
					if type(eEnt.GetInvertedFlash) == "function" and eEnt:GetInvertedFlash() then
						fadeColor = Color(0, 0, 0, 255)
					end
					eEnt:ScreenFade(SCREENFADE.IN, fadeColor, 1, 3)
				end

				if eEnt._iUntimedSequence and type(eEnt.LeaveSequence) == "function" then
					eEnt:LeaveSequence()
				end
				
				if type(Monolith) == "table" and type(Monolith.Acts) == "table" and type(Monolith.Acts.StopAct) == "function" then
					Monolith.Acts:StopAct(eEnt)
				end

				if type(eEnt.ForceSequence) == "function" then
					eEnt:ForceSequence("photo_react_blind")
				end
			end
		end
	end

	if IsValid(self.flashSprite) then
		self.flashSprite:Fire("ShowSprite", "", 0)
		self.flashSprite:Fire("HideSprite", "", 0.1)
	end

	local flashLight = ents.Create("light_dynamic")
	if IsValid(flashLight) then
		flashLight:SetPos(vPos)
		flashLight:SetKeyValue("brightness", "8")
		flashLight:SetKeyValue("distance", "448")
		flashLight:SetKeyValue("_light", "87 53 240 255")
		flashLight:SetParent(self.shieldProp)
		flashLight:Spawn()
		flashLight:Fire("TurnOn", "", 0)
		flashLight:Fire("TurnOff", "", 0.1)
		SafeRemoveEntityDelayed(flashLight, 0.2)
	end
end

function SWEP:PrimaryAttack()
	if not self.NextAttack then self.NextAttack = 0 end
	if self.NextAttack > CurTime() then return end

	self:EmitSound("shield_charge")

	if SERVER then
		timer.Simple(1, function()
			self:Flash()
		end)
	end

	self.NextAttack = CurTime() + 30

	return BaseClass.PrimaryAttack(self)
end