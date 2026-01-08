local ITEM = {}

ITEM.UniqueID = "wep_skeleton"
ITEM.Name = "Skeleton Knife"
ITEM.Desc = "A sharp knife, used for quick strikes in close quarters."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/w_eq_throwingknife_thrown.mdl")
ITEM.FOV = 24.462750716332
ITEM.CamPos = Vector(-12.607449531555, 15.472779273987, 61.318050384521)
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1


ITEM.WeaponClass = "plutonic_skeleton"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
