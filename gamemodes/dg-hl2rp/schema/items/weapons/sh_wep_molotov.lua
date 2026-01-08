local ITEM = {}

ITEM.UniqueID = "wep_molotov"
ITEM.Name = "Molotov Cocktail"
ITEM.Desc =  "An improvised incendiary weapon contaning flammable liquids."
ITEM.Category = "Grenades"
ITEM.Model = Model("models/props_junk/glassbottle01a.mdl")
ITEM.FOV = 20.924068767908
ITEM.CamPos = Vector(36.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_molotov"
ITEM.WeaponOverrideClip = 1





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
