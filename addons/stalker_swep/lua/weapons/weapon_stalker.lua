if SERVER then
	AddCSLuaFile()
	SWEP.Weight = 15
end

CreateConVar("sh_blooddrop","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_beam_decal","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_beam_impactparticles","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_dynamiclight","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))

CreateConVar("sh_bloodamount","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_damage","3",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_propvaporizer","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_secondaryparticle","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_shake","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_screenflash","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_corpsedissolve","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_ignite","1",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_unlimited_throw","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
CreateConVar("sh_deploy_sounds","0",bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))

if ( CLIENT ) then
	SWEP.PrintName		= "Stalker Head - Unlimited"			
	SWEP.Author			= "Hds46"
	SWEP.Category		= "Other"
	SWEP.Slot			= 1
	SWEP.SlotPos		= 4
	SWEP.IconLetter		= "x"
end

if CLIENT then

hook.Add("PopulateToolMenu","STALKERHEAD_Menu", function()
	spawnmenu.AddToolMenuOption("Utilities","Scripts","Stalker Head","Stalker Head","","",STALKERHEAD_Menu)
end)
end

game.AddParticles( "particles/warp_fx.pcf" )
PrecacheParticleSystem( "houndeye_sonic_attack" )

------------General Swep Info---------------
SWEP.Author         = "Hds46"
SWEP.Contact        = "None"
SWEP.Purpose        = "Get out of here stalker"
SWEP.Instructions   = "Left Click - Laser. \nRight Click - Scream. \nReload - Throw."
SWEP.Spawnable      = true
SWEP.AdminOnly      = true
-----------------------------------------------

-----------------Models---------------------------
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = true

SWEP.HoldType = "normal"

SWEP.WorldModel = "models/weapons/w_pistol.mdl"
-----------------------------------------------

-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "None"
SWEP.IsAlwaysRaised = true
-------------End Primary Fire Attributes------------------------------------
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
-------------End Secondary Fire Attributes--------------------------------

SWEP.ViewModelFOV = 55.170418573746
SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.027, 0.027, 0.027), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

-----------------------------------------------------
SWEP.HighLaser_Time               = 0
SWEP.LowLaser_Time                = 0
SWEP.UnderwaterLaser_Time         = 0
SWEP.SparkTime                    = 0
SWEP.AmmoTime                     = 0
SWEP.AmmoTime2                    = 0
SWEP.PropDissolveTime             = 0
SWEP.DistanceTime                 = 0
SWEP.ImpactTime                   = 0
SWEP.ScreamTime                   = 0
-----------------------------------------------------

SWEP.HighDamage = 3

SWEP.Radius = 100

function SWEP:OnRestore()
	self.HighLaser_Time               = 0
	self.LowLaser_Time                = 0
	self.UnderwaterLaser_Time         = 0
	self.SparkTime                    = 0
	self.AmmoTime                     = 0
	self.AmmoTime2                    = 0
	self.PropDissolveTime             = 0
	self.DistanceTime                 = 0
	self.ImpactTime                   = 0
	self.ScreamTime                   = 0

	self.ChargeFrac = 1
	self.NextHitEffect = CurTime()
	self.NextHitEffect2 = CurTime()

	self.HighDamage = 3

	self.Radius = 100
	if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
		local traceeffect = EffectData()
		traceeffect:SetEntity(self.Weapon)
		util.Effect("sbeam_effect", traceeffect)
	end
end

local PropClasses = {"prop_physics","prop_physics_multiplayer","prop_physics_override","prop_physics_respawnable","prop_ragdoll","prop_ragdoll_attached"}

if CLIENT then
killicon.Add("weapon_stalkerhead","icon/stalker_killicon", Color( 255, 255, 255, 255 ))
killicon.Add("weapon_stalkerhead_ammo","icon/stalker_killicon", Color( 255, 255, 255, 255 ))
killicon.Add("sent_stalkerhead","icon/stalker_killicon", Color( 255, 255, 255, 255 ))
SWEP.IconLetter  = "x"
SWEP.WepSelectIcon      = Material("icon/stalker_icon.png")
SWEP.BounceWeaponIcon   = false

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.WepSelectIcon )
	
	-- Lets get a sin wave to make it bounce
	local fsin = 0
	
	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end
	
	-- Borders
	y = y + 15
	x = x + 55
	wide = wide 
	
	-- Draw that mother
	surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide/1.7-fsin*2 , ( wide / 2 ) + (fsin) )
	
	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end
end

function SWEP:Reload()
if !GetConVar("sh_unlimited_throw"):GetBool() then return end
if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
if SERVER then
self.Owner:EmitSound("npc/zombie/claw_miss1.wav")
local stalker_head = ents.Create("sent_stalkerhead")
stalker_head:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*10 + self.Owner:GetRight()*5)
stalker_head:SetAngles(self.Owner:EyeAngles())
if self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() then
stalker_head:SetNWBool("StalkerAttack",true)
stalker_head:SetNWBool("IsThrowedByPlayer",true)
else
stalker_head:SetNWBool("StalkerAttack",false)
stalker_head.DelayLaser = 0
end
stalker_head:Spawn()
stalker_head:SetNWInt("blood_amount",self:GetNWInt("blood_amount"))
stalker_head:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*400 + Vector(0,0,300))
self:Remove()
end
end 

local function DissolveEntityRag(ent,type)
local entnametodissolve = "entname" .. ent:EntIndex()
ent:SetKeyValue("targetname",entnametodissolve)
local dissolver = ents.Create("env_entity_dissolver")
dissolver:SetPos(ent:GetPos())
dissolver:SetKeyValue("target", entnametodissolve)
dissolver:Spawn()
dissolver:SetKeyValue("dissolvetype",tonumber(type))
dissolver:Fire("Dissolve", entnametodissolve, 0)
dissolver:Fire("kill", "", 0.1)
end

function SWEP:DissolveEntity(ent,type)
local entnametodissolve = "entname" .. ent:EntIndex()
ent:SetKeyValue("targetname",entnametodissolve)
local dissolver = ents.Create("env_entity_dissolver")
dissolver:SetPos(ent:GetPos())
dissolver:SetKeyValue("target", entnametodissolve)
dissolver:Spawn()
dissolver:SetOwner(self.Owner)
dissolver:SetPhysicsAttacker(self.Owner)
dissolver:SetKeyValue("dissolvetype",tonumber(type))
dissolver:Fire("Dissolve", entnametodissolve, 0)
dissolver:Fire("kill", "", 0.1)
end


function SWEP:Think()
    if IsValid(self.Owner) and IsValid(self.SoundEntBeam) and SERVER then
	self.SoundEntBeam:SetPos(self.Owner:GetEyeTrace().HitPos)
	end
	if self.NextBlood == nil then
	self.NextBlood = 0
	end
	if IsValid(self.Owner) and SERVER then
	if self.NextBlood < CurTime() then
	self:SetNWInt("blood_amount",self:GetNWInt("blood_amount") - 1)
	self.NextBlood = CurTime() + 1
	end
	end
    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.Owner:KeyReleased( IN_ATTACK ) and !self.Owner:Crouching() then
	if IsValid(self.SoundEntBeam) then
	if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
	self.SoundEntBeam:Remove()
	end
	if ( self.High ) then self.High:ChangeVolume( 0, 0.02 ) self.High:Stop() self.High = nil end
	if self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) > 0 then
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	elseif IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.Owner:KeyReleased( IN_ATTACK2 ) and !self.Owner:Crouching() then
	if ( self.Low ) then self.Low:ChangeVolume( 0, 0.02 ) self.Low:Stop() self.Low = nil end
	if self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) > 0 then
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	end
    if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
		if self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() then
			self:SetNWBool("de_high",true)
			if !IsValid(self.SoundEntBeam) and SERVER then
				self.SoundEntBeam = ents.Create("base_anim")
				self.SoundEntBeam:SetModel(self.WorldModel)
				self.SoundEntBeam:SetPos(self.Owner:GetEyeTrace().HitPos)
				self.SoundEntBeam:Spawn()
				self.SoundEntBeam:SetNoDraw(true)
				self.SoundEntBeam:SetNotSolid(true)
				self.SoundEntBeam:Activate()
				if !self.SoundEntBeam.High then
					self.SoundEntBeam.High = CreateSound(self.SoundEntBeam,"ambient/energy/force_field_loop1.wav")
					self.SoundEntBeam.High:PlayEx( 1, 90 )
				end
			end
		else
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
			self:SetNWBool("de_high",false)
			if IsValid(self.SoundEntBeam) then
				if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
				self.SoundEntBeam:Remove()
			end
			if ( self.High ) then self.High:ChangeVolume( 0, 0.02 ) self.High:Stop() self.High = nil end
			if ( self.Low ) then self.Low:ChangeVolume( 0, 0.02 ) self.Low:Stop() self.Low = nil end
		end
		if self:GetNWBool("de_high") == true and self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() and self.HighLaser_Time < CurTime() then
			local tr = self.Owner:GetEyeTrace()
			local vm = self.Owner:GetViewModel()
			vm:SetSequence(1)
			vm:SetPlaybackRate( 3 )
			if IsValid(tr.Entity) and tr.Entity and SERVER and self.HighLaser_Time < CurTime() then
				if IsValid(tr.Entity:GetPhysicsObject()) then
					tr.Entity:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector()*8016)
					if !tr.Entity:IsNPC() and !tr.Entity:IsPlayer() and !tr.Entity:IsNextBot() then
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( self.Owner )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageType( DMG_ENERGYBEAM )
						dmginfo:SetDamage( GetConVar("sh_damage"):GetInt() or 8 )
						tr.Entity:TakeDamageInfo( dmginfo )
					end
					if !GetConVar("sh_propvaporizer"):GetBool() and GetConVar("sh_ignite"):GetBool() then
						tr.Entity:Ignite(3,5)
					end
					for i=1,#PropClasses,1 do
						if string.find(tr.Entity:GetClass(),PropClasses[i]) and GetConVar("sh_propvaporizer"):GetBool() then
							if tr.Entity:CPPIGetOwner() then
								self:DissolveEntity(tr.Entity,3)
							end
						end
					end
				end
				self.HighLaser_Time = CurTime() + 0.08
			end
			if SERVER and self.PropDissolveTime < CurTime() then
				for k,v in pairs(ents.FindInSphere(tr.HitPos,self.Radius)) do
					if IsValid(v) and IsValid(tr.Entity) and v == tr.Entity and (v:IsNPC() or v:IsNextBot() or (v:IsPlayer() and v:Alive()) or (v:IsPlayer())) then
						local dmg = GetConVar("sh_damage"):GetInt() or 8
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( self.Owner )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageType( DMG_ENERGYBEAM )
						dmginfo:SetDamage( dmg )
						dmginfo:SetDamageForce( self.Owner:GetAimVector()*(1000*math.Clamp(dmg/100,1,dmg)) + Vector(math.random(-400,400)*math.Clamp(dmg/100,1,dmg),math.random(-400,400)*math.Clamp(dmg/100,1,dmg),math.random(100,500)*math.Clamp(dmg/100,1,dmg)) )
						if GetConVar("sh_corpsedissolve"):GetBool() then
							v:SetNWBool("instadissolve_damage", true)
							v:SetShouldServerRagdoll( true )
							timer.Create("fix_instdissolve" .. v:EntIndex(),0.2,1,function()
								if IsValid(v) then
									v:SetNWBool("instadissolve_damage", false)
									if v:IsPlayer() then
										v:SetShouldServerRagdoll( false )
									end
								end
							end)
						end
						v:TakeDamageInfo( dmginfo )
						if GetConVar("sh_ignite"):GetBool() then
							v:Ignite(3,5)
						end
						if v:IsPlayer() and v:Alive() and GetConVar("sh_screenflash"):GetBool() and SERVER then
							v:ScreenFade(bit.bor(SCREENFADE.IN,SCREENFADE.PURGE),Color(255,255,255,150),0.2,0)
						end
						if string.find(v:GetClass(),"npc_strider") or string.find(v:GetClass(),"npc_combinegunship") or string.find(v:GetClass(),"npc_helicopter") or string.find(v:GetClass(),"npc_combinedropship") then
							v:SetHealth(v:Health() - dmg)
						end
					end
				end
				self.PropDissolveTime = CurTime() + 0.08
			end
		end
    end
end

if SERVER then
	hook.Add("CreateEntityRagdoll","dis_rag_instant",function(target,rag)
		if target:GetNWBool("instadissolve_damage") then
			DissolveEntityRag(rag,3)
		end
	end)
end

function SWEP:PrimaryAttack()
	if self.Owner:Crouching() then
		return
	elseif IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.Owner:KeyDown(IN_ATTACK) and self.AmmoTime < CurTime() then
		if GetConVar("sh_shake"):GetBool() and SERVER then
			self.Owner:SendLua("util.ScreenShake( LocalPlayer():GetPos() ,1,1,0.3,1)")
		end
		if !self.High then
			self.High = CreateSound(self.Owner,"npc/stalker/laser_burn.wav")
			self.High:Play()
			if self.ScreamTime < CurTime() then
				self.ScreamTime = CurTime() + 10
			end
		end
		self.AmmoTime = CurTime() + 0.08
		self.AmmoTime2 = CurTime() + 1
	end
end

function SWEP:Deploy()
	self.ChargeFrac = 1
	if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
		self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Weapon:SequenceDuration() )
		if SERVER and GetConVar("sh_deploy_sounds"):GetBool() then
			self.Owner:EmitSound("stalker/stalker_ambient01.wav",80,100,1)
		end
	end
	if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
		local traceeffect = EffectData()
		traceeffect:SetEntity(self.Weapon)
		util.Effect("sbeam_effect", traceeffect)
	end
end

function SWEP:Holster()
	self:SetNWBool("de_high",false)
	if IsValid(self.delight) and SERVER then
		self.delight:Remove()
	end
	if self.High then
		self.High:Stop()
		self.High = nil
	end
	if IsValid(self.SoundEntBeam) then
		if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
		self.SoundEntBeam:Remove()
	end
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	if IsValid(self) and IsValid(self.Owner) and self.Owner:IsPlayer() and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():SetMaterial("")
	end
	self:SetMaterial("")
	return true
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	self:SetNWBool("de_high",false)
	if IsValid(self.delight) and SERVER then
		self.delight:Remove()
	end
	if self.High then
		self.High:Stop()
		self.High = nil
	end
	if IsValid(self.SoundEntBeam) then
		if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
		self.SoundEntBeam:Remove()
	end
	if IsValid(self) and IsValid(self.Owner) and self.Owner:IsPlayer() and IsValid(self.Owner:GetViewModel()) then
	self.Owner:GetViewModel():SetMaterial("")
	end
	self:SetMaterial("")
end

function SWEP:OnDrop()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	self:SetNWBool("de_high",false)
	if self.High then
		self.High:Stop()
		self.High = nil
	end
	if IsValid(self.SoundEntBeam) then
		if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
		self.SoundEntBeam:Remove()
	end
	if IsValid(self) and IsValid(self.Owner) and self.Owner:IsPlayer() and IsValid(self.Owner:GetViewModel()) then
	self.Owner:GetViewModel():SetMaterial("")
	end
	self:SetMaterial("")
end

function SWEP:DoImpactEffect( tr, nDamageType )
return true
end

function SWEP:SecondaryAttack()
	if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() and self.AmmoTime < CurTime() and self.AmmoTime2 < CurTime() then
		if SERVER then
			self.Owner:EmitSound("npc/stalker/go_alert2a.wav",80,100,0.4)
			if GetConVar("sh_shake"):GetBool() then
				self.Owner:SendLua("util.ScreenShake( LocalPlayer():GetPos() ,3,4,1,2)")
			end
		end
		
		if GetConVar("sh_secondaryparticle"):GetBool() then
			ParticleEffect( "houndeye_sonic_attack", self.Owner:GetShootPos() + self.Owner:GetAimVector()*10, Angle(0,0,0), self.Owner )
		end
		for k,v in pairs(ents.FindInSphere(self:GetPos(),350)) do
			if v:IsNPC() and SERVER then
				v:AddEntityRelationship( self.Owner, D_FR, 1 )
				local npc = v
				local owner = self.Owner
				timer.Simple(5,function()
					if IsValid(npc) and IsValid(owner) and SERVER then
						npc:AddEntityRelationship( owner, D_HT, 1 )
					end
				end)
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( self.Owner )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamageType( DMG_GENERIC )
				dmginfo:SetDamage( 20 )
				dmginfo:SetDamageForce( (self.Owner:GetPos() - v:GetPos())*-200 )
				v:TakeDamageInfo( dmginfo )
				local npc = v
				local owner = self.Owner
				timer.Simple(0.05,function()
					if IsValid(npc) and IsValid(owner) and npc:GetClass()!="npc_strider" then
						npc:SetVelocity((owner:GetPos() - npc:GetPos())*-10 + npc:GetUp()*150)
					end
				end)
			end
		end
		self.AmmoTime = CurTime() + 3
		self.AmmoTime2 = CurTime() + 3
		self.Weapon:SetNextPrimaryFire( CurTime() + 3 )
	end
end

function SWEP:Initialize()

	-- other initialize code goes here
	self:SetNWInt("blood_amount", GetConVar("sh_bloodamount"):GetInt() or 30)
	self.ChargeFrac = 1
	self.NextHitEffect    = CurTime();
	self.NextHitEffect2    = CurTime();
	self:SetHoldType( self.HoldType )
	self:SetWeaponHoldType( self.HoldType )

	if CLIENT then
	
		-- Create a new table for every weapon instance
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		
		-- init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				-- Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

if CLIENT then
	local LaserMaterial = Material( "cable/redlaser" );

	local MuzzleMaterial = CreateMaterial( "LaserGunMuzzle2", "UnlitGeneric",
	{
		["$basetexture"] = "sprites/redglow1",
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$additive"] = 1
	} );
	local MuzzleMaterial2 = CreateMaterial( "LaserGunMuzzle3", "UnlitGeneric",
	{
		["$basetexture"] = "sprites/yellowflare",
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$additive"] = 1
	} );

	local MuzzleColor = Color( 255, 255, 255 );

	------------------------------------------------------------------------------------------------------
	--    Purpose: draw the beam effect, sparks and decals
	------------------------------------------------------------------------------------------------------

    function SWEP:CreateLight(pos,size,numb)
        local dlight = DynamicLight( self:EntIndex()+numb)
        if ( dlight ) then
			dlight.Pos =  pos
            dlight.r = 255
            dlight.g = 91
            dlight.b = 91
            dlight.Brightness = 4
            dlight.Size =size
            dlight.Decay = size*5
            dlight.DieTime = CurTime() + 0.2
        end
    end

function SWEP:DrawLaserBeam( viewSpace )
	
	if self.NextBloodDrop == nil then
		self.NextBloodDrop = 0
	end
	
	if self.NextBloodDrop < CurTime() then
		if IsValid(self.Owner) and self:GetNWInt("blood_amount") > 0 and GetConVar("sh_blooddrop"):GetBool() then
			local weaponModel = ( viewSpace ) and self.Owner:GetViewModel() or self;
			local muzzle = weaponModel:GetAttachment( weaponModel:LookupAttachment( "muzzle" ) );
			
			local LightColor = render.GetLightColor( muzzle.Pos ) * 255
			LightColor.r = math.Clamp( LightColor.r, 70, 255 )
			
			
			local emitter = ParticleEmitter( muzzle.Pos )
			for i=1, math.random(3,5) do
			local mat
			if math.random(0,10) >= 5 then
			--mat = "particle/water/waterdrop_001a"
			else
			--mat = "effects/slime1"
			end
			local particle = emitter:Add( "effects/blood_drop", muzzle.Pos + Vector(math.random(-5,5),math.random(-5,5),-10) + self.Owner:GetAimVector()*-4)
			particle:SetVelocity(Vector(0,0,0))
			particle:SetDieTime( 1.5 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
			local size = math.Rand( 3, 5 )
			particle:SetStartSize( size )
			particle:SetEndSize( size )
			particle:SetRoll( 0 )
			local size2 = math.Rand( 8, 12 )
			particle:SetStartLength( size2 )
			particle:SetEndLength( size2 )
			particle:SetColor( LightColor.r*0.5, 0, 0 )
			particle:SetGravity( Vector( 0, 0, -100 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0 )
			particle:SetAirResistance( 5 )
			end            
			emitter:Finish()
			
			if math.random(0,10) >= 8 then
				local traceworld = {}
				traceworld.start = self.Owner:GetPos() + Vector(math.Rand(-10,10),math.Rand(-10,10),0)
				traceworld.endpos = traceworld.start - Vector(0,0,50)
				traceworld.fliter = {self,self.Owner}
				traceworld.mask = MASK_NPCWORLDSTATIC
				local trw = util.TraceLine(traceworld)
				local worldpos1 = trw.HitPos - trw.HitNormal
				local worldpos2 = trw.HitPos + trw.HitNormal
				util.Decal("blood",worldpos1,worldpos2)
			end
		end
		self.NextBloodDrop = CurTime() + math.Rand(1,1.5)
	end

    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    -- get the proper muzzle attachment
    local weaponModel = ( viewSpace ) and self.Owner:GetViewModel() or self;
    local muzzle = weaponModel:GetAttachment( weaponModel:LookupAttachment( "muzzle" ) );
    local tr = self.Owner:GetEyeTraceNoCursor();
    
    MuzzleColor.a = self.ChargeFrac * 255;
    
    local muzzleSize = 16 + math.Rand( -self.ChargeFrac, self.ChargeFrac );
    if IsValid(self.Owner) and self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() then
        
        muzzleSize = muzzleSize * 2;
        
    end
    
    local muzzleOffset = muzzle.Ang:Forward();
    muzzleOffset:Mul( ( weaponModel == self ) and 0 or 8 );
    
    local muzzlePos = muzzle.Pos + muzzleOffset + Vector(0,0,33) + self:GetForward() * 15;
    
    if IsValid(self.Owner) and self.Owner:KeyDown(IN_ATTACK) and !self.Owner:Crouching() then
		if GetConVar("sh_dynamiclight"):GetBool() then
			self:CreateLight(muzzlePos,100,0);
			self:CreateLight(tr.HitPos,150,1);
		end
        
		render.SetMaterial( MuzzleMaterial );
		render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
		render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
		render.SetMaterial( MuzzleMaterial2 );
		render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
		render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
		render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
        
        render.SetMaterial( LaserMaterial );
        render.DrawBeam( muzzlePos, tr.HitPos, math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        render.DrawBeam( muzzlePos, tr.HitPos,  math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        
        local increment = tr.HitPos - muzzlePos;
        local distance = increment:Length();
        local num = math.Clamp( math.floor( distance / 40 ), 8, 100 );
        
        increment:Normalize();
        increment:Mul( distance / num );
        
        render.StartBeam( num + 1 );
            
            -- don't add a wiggle to the first cp
            render.AddBeam( muzzlePos, 5, 1 );
            
            for i = 1, num do
                
                local vectorRand = VectorRand();
                vectorRand:Mul( 1.1 );
                
                muzzlePos:Add( increment );
                render.AddBeam( muzzlePos + vectorRand, 5, 1 );
                
            end
            
        render.EndBeam();
        
        if( CurTime() > self.NextHitEffect ) then
            
            self:DoHitEffects( tr );
            self.NextHitEffect = CurTime() + 0.01;
            
        end
		
		if( CurTime() > self.NextHitEffect2 ) then
            
            self:DoHitEffects2( tr );
            self.NextHitEffect2 = CurTime() + math.Rand(0.1,0.2);
            
        end
        
    end
    
    return muzzle, tr;
    
end

------------------------------------------------------------------------------------------------------
--    Purpose: draw the beam in view model space
------------------------------------------------------------------------------------------------------
function SWEP:DoHitEffects( tr )
    if !GetConVar("sh_beam_decal"):GetBool() then return end
    util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
end

function SWEP:DoHitEffects2( tr )
	if !tr.HitWorld then return end
	if tr.HitSky then return end
	if !GetConVar("sh_beam_impactparticles"):GetBool() then return end
	for i=1,math.random(1,3) do
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal*2 )
	effectdata:SetNormal( tr.HitNormal )
	effectdata:SetStart( self:GetForward()*-1 )
	util.Effect( "stalker_beam_impact", effectdata )
	end
	local emitter = ParticleEmitter( self:GetPos() );
        for i = 1, math.random(2,5) do
            
            local velocity = ( tr.HitNormal + VectorRand() ):GetNormalized();
            velocity:Mul( math.Rand( 100, 125 ) );
            
            local p = emitter:Add( "effects/spark", tr.HitPos );
            p:SetVelocity( velocity );
            p:SetDieTime( 2 );
            p:SetStartSize( math.Rand( 3, 5 ) );
            p:SetEndSize( 2 );
            p:SetStartAlpha( 200 );
            p:SetEndAlpha( 0 );
            p:SetStartLength( 7 );
            p:SetEndLength( 5 );
            p:SetGravity( physenv.GetGravity() );
            p:SetCollide( true );
            p:SetBounce( 0.4 );
			p:SetColor(255,200,200)
            
        end
	emitter:Finish()
end

local function PostPlayerDraw( pl )
    
    local activeWeapon = pl:GetActiveWeapon();
    
    if( activeWeapon.DrawLaserBeam ) then
        
        local muzzle, tr = activeWeapon:DrawLaserBeam( false );
        
        -- make sure the beam always draws
        -- TODO: this breaks the player's shadow
		if muzzle != nil then
        activeWeapon:SetRenderBoundsWS( muzzle.Pos, tr.HitPos );
		end
        
    end
    
end
hook.Add( "PostPlayerDraw", "StalkerBeam_PostPlayerDraw", PostPlayerDraw );


	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		self:DrawLaserBeam( true );
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end
		self.Owner:GetViewModel():SetMaterial("hud/800corner1")

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				if v.material == "models/flesh" then
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				local normal = -model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*5 )
                local oldEC = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC )
				local normal = model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*53 )
                local oldEC2 = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC2 )
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				else
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				local normal = model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*53.8 )
                local oldEC = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC )
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
                --local normal = model:GetUp()
                --local position = normal:Dot( model:GetPos() + model:GetUp()*65 )
                --local oldEC = render.EnableClipping( true )
                --render.PushCustomClipPlane( normal, position )
                --model:DrawModel()
                --render.PopCustomClipPlane()
                --render.EnableClipping( oldEC )
				if v.material == "models/flesh" then
				local normal = -model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*-5 )
                local oldEC = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC )
				local normal = model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*65 )
                local oldEC2 = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC2 )
				else
                local normal = model:GetUp()
                local position = normal:Dot( model:GetPos() + model:GetUp()*65.8 )
                local oldEC = render.EnableClipping( true )
                render.PushCustomClipPlane( normal, position )
                model:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping( oldEC )
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			-- Technically, if there exists an element with the same name as a bone
			-- you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r -- Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		-- Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				-- make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			-- !! WORKAROUND !! --
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			-- !! ----------- !! --
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				-- !! WORKAROUND !! --
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				-- !! ----------- !! --
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	-- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	-- Does not copy entities of course, only copies their reference.
	-- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) -- recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

if CLIENT then

local LaserMaterial = Material( "cable/redlaser" );

local MuzzleMaterial = CreateMaterial( "LaserGunMuzzle2", "UnlitGeneric",
{
    ["$basetexture"] = "sprites/redglow1",
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
    ["$additive"] = 1
} );
local MuzzleMaterial2 = CreateMaterial( "LaserGunMuzzle3", "UnlitGeneric",
{
    ["$basetexture"] = "sprites/yellowflare",
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
    ["$additive"] = 1
} );

local MuzzleColor = Color( 255, 255, 255 );

local EFFECT={}

function EFFECT:Init(data)
self.WeaponEnt = data:GetEntity()
self.Gmoder = self.WeaponEnt:GetOwner()
end

function EFFECT:Think()
if IsValid(self.WeaponEnt) and IsValid(self.Gmoder) and self.Gmoder:Alive() and IsValid(self.Gmoder:GetActiveWeapon()) and self.Gmoder:GetActiveWeapon()==self.WeaponEnt then
local weaponModel = ( IsValid(self.Gmoder:GetViewModel()) ) and self.Gmoder:GetViewModel() or self.WeaponEnt;
local muzzle = weaponModel:GetAttachment( weaponModel:LookupAttachment( "muzzle" ) );
if muzzle == nil then return end
local tr = self.Gmoder:GetEyeTraceNoCursor();
self.WeaponEnt:SetRenderBoundsWS( muzzle.Pos, tr.HitPos );
self:SetRenderBoundsWS( muzzle.Pos, tr.HitPos );
return true
end
end

function EFFECT:Render( )
if IsValid(self.WeaponEnt) and self.WeaponEnt:GetNWBool("de_high") == true and IsValid(self.Gmoder) and self.Gmoder:Alive() and IsValid(self.Gmoder:GetActiveWeapon()) and self.Gmoder:GetActiveWeapon()==self.WeaponEnt and !self.Gmoder:InVehicle() and LocalPlayer():ShouldDrawLocalPlayer() then
   if !(self.WeaponEnt:GetNextPrimaryFire() < CurTime()) then return end
    -- get the proper muzzle attachment
    local weaponModel = self.WeaponEnt;
    local muzzle = weaponModel:GetAttachment( weaponModel:LookupAttachment( "muzzle" ) );
	if muzzle == nil then return end
    local tr = self.Gmoder:GetEyeTraceNoCursor();
	self.WeaponEnt:SetRenderBoundsWS( muzzle.Pos, tr.HitPos );
	self:SetRenderBoundsWS( muzzle.Pos, tr.HitPos );
    
    MuzzleColor.a = 1 * 255;
    
    local muzzleSize = 16 + math.Rand( -1, 1 );
    if IsValid(self.Gmoder) and self.Gmoder:KeyDown(IN_ATTACK) and !self.Gmoder:Crouching() then
        
        muzzleSize = muzzleSize * 2;
        
    end
    
    local muzzleOffset = muzzle.Ang:Forward();
    muzzleOffset:Mul( ( weaponModel == self.WeaponEnt ) and 0 or 8 );
    
    local muzzlePos = muzzle.Pos + muzzleOffset + Vector(0,0,30) + self.Gmoder:GetForward() * 15;
    
    if IsValid(self.Gmoder) and self.Gmoder:KeyDown(IN_ATTACK) and !self.Gmoder:Crouching() then
        
		    render.SetMaterial( MuzzleMaterial );
    render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
    render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
		render.SetMaterial( MuzzleMaterial2 );
		render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
		    render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
            render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
        
        render.SetMaterial( LaserMaterial );
        render.DrawBeam( muzzlePos, tr.HitPos, math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        render.DrawBeam( muzzlePos, tr.HitPos,  math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        
        local increment = tr.HitPos - muzzlePos;
        local distance = increment:Length();
        local num = math.Clamp( math.floor( distance / 40 ), 8, 100 );
        
        increment:Normalize();
        increment:Mul( distance / num );
        
        render.StartBeam( num + 1 );
            
            -- don't add a wiggle to the first cp
            render.AddBeam( muzzlePos, 5, 1 );
            
            for i = 1, num do
                
                local vectorRand = VectorRand();
                vectorRand:Mul( 1.1 );
                
                muzzlePos:Add( increment );
                render.AddBeam( muzzlePos + vectorRand, 5, 1 );
                
            end
            
        render.EndBeam();
        
        if( CurTime() > self.WeaponEnt.NextHitEffect ) then
            
            util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
            self.WeaponEnt.NextHitEffect = CurTime() + 0.01;
            
        end
        
    end
end -- sdsd
end

effects.Register(EFFECT, "sbeam_effect", true)
end
