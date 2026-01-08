local ITEM = {}

ITEM.UniqueID = "wep_sw500"
ITEM.Name = "S&W 500"
ITEM.Desc =  "A very large revolver that fires .500 rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_ins2_revolver_sw500.mdl")
ITEM.FOV = 17.113180515759
ITEM.CamPos = Vector(-25.21489906311, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true
ITEM.Colour = Color(255, 0, 0)

ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.ScrapClass = "scrap_sw500"
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1


ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

ITEM.WeaponClass = "plutonic_sw500"

impulse.RegisterItem(ITEM)
