local ITEM = {}

ITEM.UniqueID = "wep_stunstick"
ITEM.Name = "Stun Baton"
ITEM.Desc =  "An electrified baton that can be used to stun disobedient citizens."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
ITEM.FOV = 25
ITEM.Weight = 1.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_stunstick"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_stunstick"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end





impulse.RegisterItem(ITEM)

local BATON_DRAWN_SPEED = impulse.Config.JogSpeed * 1.1

if SERVER then
	hook.Add("PlayerSwitchWeapon", "MPF_StunstickSpeedBonus", function(ply, oldWeapon, newWeapon)
		if not IsValid(ply) or ply:Team() ~= TEAM_CP or ply.IsAugmented then return end

		local newClass = IsValid(newWeapon) and newWeapon:GetClass() or ""
		local oldClass = IsValid(oldWeapon) and oldWeapon:GetClass() or ""

		if newClass == "plutonic_stunstick" then
			ply:SetRunSpeed(BATON_DRAWN_SPEED)
		elseif oldClass == "plutonic_stunstick" then
			ply:SetRunSpeed(impulse.Config.JogSpeed)
		end
	end)

	hook.Add("PlayerDeath", "MPF_StunstickSpeedBonus_Death", function(ply)
		if not IsValid(ply) or ply:Team() ~= TEAM_CP then return end
		ply:SetRunSpeed(impulse.Config.JogSpeed)
	end)
end