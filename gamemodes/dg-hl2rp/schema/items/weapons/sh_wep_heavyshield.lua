local ITEM = {}

ITEM.UniqueID = "wep_heavyshield"
ITEM.Name = "Civil Protection Heavy Shield"
ITEM.Desc =  "A large shield distributed to members of the GRID division of the Civil Protection allowing for a powerful breakthrough into enemy strongpoints."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/pg_props/pg_weapons/pg_cp_shield_w.mdl")
ITEM.FOV = 36.2249283667622
ITEM.CamPos = Vector(-5, -5, -5)
ITEM.Weight = 8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.Illegal = true
ITEM.Equipable = true

ITEM.UseName = "Equip [Single Use]"

function ITEM:OnUse(ply)
	ply:Give("weapon_combineshield")
	return true
end

impulse.RegisterItem(ITEM)
