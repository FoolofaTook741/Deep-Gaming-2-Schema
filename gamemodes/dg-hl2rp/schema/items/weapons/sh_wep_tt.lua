local ITEM = {}

ITEM.UniqueID = "wep_tt"
ITEM.Name = "IMI Desert Eagle"
ITEM.Desc =  "An Israeli handcannon that fires .50 AE rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/tasty/w-d50.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3

ITEM.ScrapClass = "scrap_deagle"

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 6
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_tt"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
