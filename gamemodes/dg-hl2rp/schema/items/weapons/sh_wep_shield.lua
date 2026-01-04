local ITEM = {}

ITEM.UniqueID = "wep_shield"
ITEM.Name = "Civil Protection Ballistic Shield"
ITEM.Desc =  "A small shield distributed to members of the GRID division of the Civil Protection allowing for a powerful breakthrough into enemy strongpoints."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/pg_props/pg_weapons/pg_cp_shield_w.mdl")
ITEM.FOV = 36.2249283667622
ITEM.CamPos = Vector(-5, -5, -5)
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.CanStack = false


ITEM.UseName = "Equip [Single Use]"

function ITEM:OnUse(ply)
	ply:Give("weapon_smallcombineshield")
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
