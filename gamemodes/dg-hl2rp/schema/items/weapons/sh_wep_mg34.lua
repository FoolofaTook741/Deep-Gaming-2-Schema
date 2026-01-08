local ITEM = {}

ITEM.UniqueID = "wep_mg34"
ITEM.Name = "Rheinmetall MG-42"
ITEM.Desc =  "A powerful German machine gun nicknamed the buzzsaw."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/doi/w_mg42.mdl")
ITEM.Mass = 1
ITEM.FOV = 20.75787965616
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Weight = 12

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.WeaponClass = "plutonic_mg34"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
