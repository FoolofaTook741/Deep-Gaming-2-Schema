local ITEM = {}

ITEM.UniqueID = "wep_m500"
ITEM.Name = "XM1014"
ITEM.Desc =  "A semi automatic shotgun, fires reduced power loads at a fast rate."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_shot_xm1014.mdl")
--ITEM.Model = Model("models/weapons/arccw_go/v_shot_m1014.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_xm1014"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_xm1014"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
