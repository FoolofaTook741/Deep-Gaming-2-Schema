local ITEM = {}

ITEM.UniqueID = "wep_restraints"
ITEM.Name = "Rope Restraints"
ITEM.Desc =  "These flimsy cuffs bound by rope can be used to kidnap members of the Combine for ransom or torture purposes."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/xqm/polex1.mdl")
ITEM.FOV = 18.2249283667622 
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 1.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "cuffs"
ITEM.CanStack = true

ITEM.WeaponClass = "weapon_cuff_rope"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
