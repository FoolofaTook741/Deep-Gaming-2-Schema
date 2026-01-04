local ITEM = {}

ITEM.UniqueID = "wep_p90"
ITEM.Name = "FN P90"
ITEM.Desc =  "A special Belgian SMG that fires 5.7x28 rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_smg_p90.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_p90"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_p90"

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
