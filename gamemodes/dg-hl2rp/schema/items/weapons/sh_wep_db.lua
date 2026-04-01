local ITEM = {}

ITEM.UniqueID = "wep_db"
ITEM.Name = "Double Barrel Shotgun"
ITEM.Desc =  "A strong 2 round shotgun that eliminates anything up close to it."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_tfa_dbbl_classic_hd.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(74.5, -84.809997558594, -26)
ITEM.Weight = 5
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 12

ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_doublebarrel"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
