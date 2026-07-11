local ITEM = {}

ITEM.UniqueID = "wep_p90"
ITEM.Name = "FN P90"
ITEM.Desc =  "A special Belgian SMG that fires 5.7x28 rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_smg_p90.mdl")
ITEM.FOV = 4.1060171919771
ITEM.CamPos = Vector(-46.762176513672, 142.12034606934, 44.928367614746)
ITEM.NoCenter = true
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





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
