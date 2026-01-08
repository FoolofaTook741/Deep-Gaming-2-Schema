local ITEM = {}

ITEM.UniqueID = "wep_goldengun"
ITEM.Name = "Golden .357 Revolver"
ITEM.Desc =  "A large revolver coated in 24 carrat gold. What it loses in camouflage it makes up for in style."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_357.mdl")
ITEM.Material = "gold_tool/australium"
ITEM.FOV = 17.113180515759
ITEM.Colour = Color(255, 255, 0)
ITEM.CamPos = Vector(-25.21489906311, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true

ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 80

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true

ITEM.EquipTime = 1
ITEM.UnEquipTime = 1
ITEM.WeaponClass = "plutonic_goldengun"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
