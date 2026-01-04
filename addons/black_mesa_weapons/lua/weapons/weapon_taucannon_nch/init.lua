--[[SECURE]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("animations.lua")

include("shared.lua")

function SWEP:OnOvercharge(victim, damage, damage_type, attacker, inflictor)
    local dmg = DamageInfo() 
	dmg:SetDamage(damage)
	dmg:SetAttacker(attacker)
	dmg:SetInflictor(inflictor)
	dmg:SetDamageType(damage_type)
	victim:TakeDamageInfo(dmg)
end