local ITEM = {}

ITEM.UniqueID = "wep_osr"
ITEM.Name = "O.S.I.S.R."
ITEM.Desc =  "The O.S.I.S.R. was a long ranged sniper rifle that fires powerful anti-matter rounds with removed tracers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a_gib01.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
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
