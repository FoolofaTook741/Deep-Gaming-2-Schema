local ITEM = {}

ITEM.UniqueID = "wep_heavyrestraints"
ITEM.Name = "Elastic Restraints"
ITEM.Desc =  "These sturdy cuffs bound by elastic."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/xqm/polex1.mdl")
ITEM.FOV = 18.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "cuffs"
ITEM.CanStack = true

ITEM.WeaponClass = "weapon_cuff_elastic"

function ITEM:OnEquip(ply)
    ply:Say("/me equips a " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips a " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
