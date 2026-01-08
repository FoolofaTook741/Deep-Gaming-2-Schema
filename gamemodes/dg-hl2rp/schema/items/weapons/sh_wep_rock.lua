local ITEM = {}

ITEM.UniqueID = "wep_rock"
ITEM.Name = "Rock"
ITEM.Desc =  "A rock, the primary armament of a caveman."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_debris/concrete_chunk05g.mdl")
ITEM.FOV = 20.924068767908
ITEM.CamPos = Vector(36.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 4.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_rock"
ITEM.WeaponOverrideClip = 1



function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
