AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Chen's Ammo Crate"
ENT.Category = "Other"
ENT.Spawnable = true

ENT.HUDName = "Ammo Crate [Deployed]"
ENT.HUDDesc = "Press 'E' to retrieve additional munitions."

CHENBOXMAXCLIPS = 4

if (SERVER) then

	local ammoValues = {
		["Pistol"] = 12,
		["357"] = 6,
		["SniperRound"] = 15,
		["SMG1"] = 40,
		["slam"] = 3,
		["Grenade"] = 1,
		["AR2"] = 30,
		["Buckshot"] = 12,
		["SniperPenetratedRound"] = 2,
		["AlyxGun"] = 50,
		["XBowBolt"] = 3,
		["AR2AltFire"] = 1, 
		["Rifle"] = 30,
	}

	function ENT:Initialize()
		self:SetModel("models/Items/item_item_crate.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(3)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(true)
		end
		maxuses = 24
		self.uses = 0
	end

	function ENT:Use(activator, caller, useType, value)
		if not activator:IsPlayer() then return end
		local weapon = activator:GetActiveWeapon()
		local ammo = weapon:GetPrimaryAmmoType()
		local ammoName = game.GetAmmoName(weapon:GetPrimaryAmmoType())
		if ammoName == "Grenade" or ammoName == "slam" or ammoName == "AR2AltFire" then 
			return
		end
		if ammoValues[ammoName] then
			local ammoCount = activator:GetAmmoCount(ammoName)
			if ammoCount and ammoCount < ammoValues[ammoName] * 6 then
				activator:GiveAmmo(math.floor(ammoValues[ammoName]), weapon:GetPrimaryAmmoType(), true)
			else
				self:EmitSound("items/ammocrate_close.wav")
				return
			end
			self:EmitSound("items/ammo_pickup.wav")	
			if self.uses + 1 > maxuses then
				self:Remove()
			end
			self.uses = self.uses + 1
			return
		end
		return	
	end
end