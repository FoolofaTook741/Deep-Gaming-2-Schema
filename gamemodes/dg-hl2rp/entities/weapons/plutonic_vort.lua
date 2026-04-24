AddCSLuaFile()
if SERVER then
	util.AddNetworkString("impulseHL2RPVortBeam")
end
SWEP.Base = "plutonic_base_melee"

SWEP.PrintName = "Vortigaunt Powers"
SWEP.Category = "Deep Gaming [Plutonic]"

SWEP.Instructions = "Primary Attack: Vortigaunt Beam | Secondary Attack: Vortigaunt Heal | Reload: Summon Antlion"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("")
SWEP.ViewModel = Model("models/weapons/c_vortbeamvm.mdl")
SWEP.ViewModelFOV = 54

SWEP.CenteredPos = Vector(0, 0, 0)
SWEP.CenteredAng = Angle(0,0,0)

SWEP.Slot = 4
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.MuzzleEffect = "muzzleflash_ak74"

SWEP.BlowbackPos = Vector(0, 0, 0)
SWEP.BlowbackAngle = Angle(0, 0, 0)

SWEP.Primary.Sound = ""
SWEP.Primary.ImpactSound = ""
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 2.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 0 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.4
SWEP.Primary.Delay = 2.8
SWEP.Primary.Range = 9000
SWEP.Secondary.Delay = 2
SWEP.Secondary.Automatic = true
SWEP.Primary.ImpactEffect = "none"
SWEP.Primary.StunTime = 0.2
SWEP.Projectile = {}
SWEP.Projectile.Model = Model("models/items/ar2_grenade.mdl")
SWEP.Projectile.Touch = true
SWEP.Projectile.FireSound = Sound("BaseGrenade.Explode")
SWEP.Projectile.ForceMod = 4
SWEP.DamagedAmount = 0
SWEP.IsAlwaysRaised = true
SWEP.NextHealThink = CurTime() + 1
SWEP.Primary.FlashTime = 0
local charge = Sound("npc/vort/attack_charge.wav")
local shoot  = Sound("npc/vort/attack_shoot.wav")

local Clamp = math.Clamp

--[[
	HEALING MECHANIC:

	Health Regens every 0.75 seconds
	It heals to your pure health value, meaning it only gives back what you lost from vort energy
	does this using FUNNY FUICKING MATH :)
]]

function SWEP:VortBeam()
	-- server networks the effect, clients run it since it uses control points.
	if SERVER then
		local ply = self.Owner
		if not IsValid(ply) then return end
		local blastPos = ply:GetEyeTrace().HitPos
		if not blastPos then return end -- literally impossible
		local rf = RecipientFilter()
		rf:AddPVS(ply:GetPos())
		rf:AddPVS(blastPos)
		net.Start("impulseHL2RPVortBeam")
		net.WriteEntity(ply)
		net.WriteVector(blastPos)
		net.Send(rf)
	end
end
--[[
old effect code was rushed and so poorly written oml
]]

function SWEP:PrePrimaryAttack()
	local vm = self.Owner:GetViewModel()
	--vm:SendViewModelMatchingSequence(vm:LookupSequence("altfire"))
	
	local ply = self.Owner
	local blastPos = ply:GetEyeTrace().HitPos
	if SERVER then
		local edf = EffectData()
		local blastPos = ply:GetEyeTrace().HitPos
		self:VortBeam()
		ply:EmitSound(charge)
		ply:ForceSequence("dispel", nil, nil, true)
		timer.Simple(0.35,function()
			ply:StopSound(charge)
			ply:EmitSound(shoot)
			local blastPos = ply:GetEyeTrace().HitPos
			local vortSkillData = ply.vortComputedSkills
			local damageMultiplier = (vortSkillData.power_overload or 1)
			if ply.UsedEnrichedVortessence == true then
				util.BlastDamage(self,ply,blastPos,190,40*damageMultiplier)
			elseif ply.UsedVortessence == true then
				util.BlastDamage(self,ply,blastPos,150,35*damageMultiplier)
			else
				util.BlastDamage(self,ply,blastPos,100,30*damageMultiplier)
			end
			local edf = EffectData()
			edf:SetOrigin(blastPos)
			edf:SetNormal(VectorRand())
			edf:SetRadius(128)
			util.Effect("cball_explode", edf)
		end) 
		timer.Simple(0.85,function()
			vm:SendViewModelMatchingSequence(vm:LookupSequence("idle"))
		end)
		return
	end
	
	
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self.Owner
		local sid = ply:SteamID64()
		local pos = ply:GetPos()
		local vortSkillData = ply.vortComputedSkills
		local restorativePulseLevel = vortSkillData.restorative_pulse or 0
		
		if ply.UsedVortessence == true && !timer.Exists(sid .. "healcooldown") then
			ply:EmitSound("npc/vort/health_charge.wav")
			timer.Adjust(ply:SteamID() .. "vortessence", math.Clamp(timer.TimeLeft(ply:SteamID() .. "vortessence") - 2, 1, 99999), 1)
			for k, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(pos) < 140 then
					if v:Team() != TEAM_ZOMBIE and not v:IsCP() then
						if v:Health() + 2 <= v:GetMaxHealth() then
							v:SetHealth(v:Health() + (2 + restorativePulseLevel) * (1 - (v.Antiheal or 0)))
						else
							v:SetHealth(v:GetMaxHealth())
						end
					end
				end
			end
			timer.Create(sid .. "healcooldown", 2, 1, function() timer.Remove(sid .. "healcooldown") end)
		elseif !timer.Exists(sid .. "healcooldown") && ply.UsedEnrichedVortessence == true then
			timer.Adjust(ply:SteamID() .. "enrichedvortessence", math.Clamp(timer.TimeLeft(ply:SteamID() .. "enrichedvortessence") - 1, 1, 99999), 1)
			ply:EmitSound("npc/vort/health_charge.wav")
			for k, v in pairs(player.GetAll()) do
				if v:GetPos():Distance(pos) < 280 then
					if v:Team() != TEAM_ZOMBIE and not v:IsCP() then
						if v:Health() + 3 <= v:GetMaxHealth() then
							v:SetHealth(v:Health() + (3 + restorativePulseLevel) * (1 - (ply.Antiheal or 0)))
						else
							v:SetHealth(v:GetMaxHealth())
						end
					end
				end
			end
			timer.Create(sid .. "healcooldown", 2, 1, function() timer.Remove(sid .. "healcooldown") end)
		elseif !timer.Exists(sid .. "healcooldown") then
			timer.Create(sid .. "healcooldown", 4, 1, function() timer.Remove(sid .. "healcooldown") end)
			if ply:Health() + 2 <= ply:GetMaxHealth() then
				ply:SetHealth(ply:Health() + (3 + restorativePulseLevel) * (1 - (ply.Antiheal or 0)))
			else
				ply:SetHealth(ply:GetMaxHealth())
			end
			ply:EmitSound("npc/vort/health_charge.wav")
		end
		return
	end
end

function SWEP:Reload()
    local ply = self.Owner
    local sid = ply:SteamID64()
    local pos = ply:GetPos()
    if ply.UsedEnrichedVortessence && !timer.Exists(sid .. "summonedantlion") then
        local vortSkillData = ply.vortComputedSkills
        local healthMultiplier = vortSkillData.antlion or 1
        ply:EmitSound("npc/vort/vort_dispell.wav")
        local antlion = ents.Create("npc_antlion")
        antlion:SetModel("models/antlion.mdl")
        antlion:SetHealth(250 * healthMultiplier)
        antlion:SetPos(pos + Vector(40, 0, 10))
        antlion:Spawn()
		antlion.IsPlayerOwned = true
        antlion:AddEntityRelationship(ply, D_LI, 999) -- Still seems to attack owner?

        for k, v in pairs(player.GetAll()) do
            if v ~= ply then
                if v:Team() == TEAM_CITIZEN or v:Team() == TEAM_VORT or v:Team() == TEAM_CWU then
                    antlion:AddEntityRelationship(v, D_LI, 199)
                elseif v:GetMoveType() == MOVETYPE_NOCLIP then
                    antlion:AddEntityRelationship(v, D_LI, 199)
                elseif v:Team() == TEAM_CP or v:Team() == TEAM_OTA or v:Team() == TEAMw_CA then
                    antlion:AddEntityRelationship(v, D_HT, 99)
                elseif v:Team() == TEAM_ZOMBIE then
                    antlion:AddEntityRelationship(v, D_HT, 99)
                end
            end
        end

        timer.Create(sid .. "summonedantlion", 300, 0, function()
            timer.Remove(sid .. "summonedantlion")
        end)
    end
end


if CLIENT then
	
	net.Receive("impulseHL2RPVortBeam",function()
		local ply = net.ReadEntity()
		local blastPos = net.ReadVector()
		local id = 4
		local mdl = ply
		local isVort = ply == LocalPlayer()
		local isTP = impulse.GetSetting("view_thirdperson")
		timer.Simple(0.35,function()
			local id = 4
			local mdl = ply
			if isVort then
				if not isTP then
					id = 1
					mdl = ply:GetViewModel()
				end
			end
			local d = CreateParticleSystem(mdl,"vortigaunt_beam", PATTACH_POINT_FOLLOW,id,Vector(0,0,0))
    			if isVort then
				if not isTP then
					d:SetIsViewModelEffect(true)
				end
			end
    			d:AddControlPoint(1, Entity(0), 0, 0, blastPos)
		
		end)
	end)
end
