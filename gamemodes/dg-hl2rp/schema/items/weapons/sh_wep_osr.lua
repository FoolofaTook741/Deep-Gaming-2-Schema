local ITEM = {}

ITEM.UniqueID = "wep_osr"
ITEM.Name = "O.S.I.S.R."
ITEM.Desc =  "The O.S.I.S.R. was a long ranged sniper rifle that fires powerful anti-matter rounds with removed tracers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/tnb/weapons/w_cisr.mdl")
iconFOV = 14.214899713467
iconCamPos = Vector(-69.684814453125, -143.0372467041, 5.5014328956604)
ITEM.Weight = 9

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.WeaponClass = "plutonic_osr"
ITEM.CombineWeapon = true

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
