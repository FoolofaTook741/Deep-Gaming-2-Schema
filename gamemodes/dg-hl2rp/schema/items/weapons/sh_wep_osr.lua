local ITEM = {}

ITEM.UniqueID = "wep_osr"
ITEM.Name = "O.S.I.S.R."
ITEM.Desc =  "The O.S.I.S.R. was a long ranged sniper rifle that fires powerful anti-matter rounds with removed tracers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/tnb/weapons/w_cisr.mdl")
ITEM.FOV = 13.091690544413
ITEM.CamPos = Vector(-110.02865600586, -91.690544128418, 56.73352432251)
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
