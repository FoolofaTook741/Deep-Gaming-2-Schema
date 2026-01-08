local ITEM = {}

ITEM.UniqueID = "wep_incendiaryb"
ITEM.Name = "Incendiary Grenade"
ITEM.Desc =  "A powerful impact grenade that emits flames around the areaa of detonation."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_eq_flashbang.mdl")
ITEM.FOV = 20.924068767908
ITEM.CamPos = Vector(36.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_incendiary"
ITEM.WeaponOverrideClip = 1





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
