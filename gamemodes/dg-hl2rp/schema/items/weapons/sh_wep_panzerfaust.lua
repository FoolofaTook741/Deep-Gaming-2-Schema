local ITEM = {}

ITEM.UniqueID = "wep_panzerfaust"
ITEM.Name = "M320 GL (AP)"
ITEM.Desc =  "The M320 GL is an American made grenade launcher that can hold 1 40mm grenade at a time."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/syndod/w_panzerfaust.mdl")
ITEM.FOV = 24.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "orb"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_panzerfaust"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
