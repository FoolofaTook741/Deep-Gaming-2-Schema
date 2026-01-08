local ITEM = {}

ITEM.UniqueID = "resin_pistol"
ITEM.Name = "USP-9 (Modified)"
ITEM.Desc =  "A lightweight semi-automatic pistol that fires 9mm rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_pistol.mdl")
ITEM.FOV = 24.190544412607
ITEM.CamPos = Vector(-16.045845031738, 17.191976547241, 3.4383955001831)
ITEM.NoCenter = true
ITEM.Weight = 0.8

ITEM.Colour = Color(180, 180, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_pistol"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_resin_usp"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
