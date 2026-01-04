local ITEM = {}

ITEM.UniqueID = "wep_m4a1"
ITEM.Name = "M4A1"
ITEM.Desc =  "The M4A1 is an assault rifle developed by Colt chambered in 5.56x45. The M4A1 was known as the flagship of the United States military prior to their defeat against the Combine."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw/vmwm_xm4_bocw.mdl")
ITEM.FOV = 16.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_m4a1"

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
