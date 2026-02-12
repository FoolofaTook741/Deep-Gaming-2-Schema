local ITEM = {}

ITEM.UniqueID = "resin_pistol"
ITEM.Name = "USP-9 (Modified) [Deprecated]"
ITEM.Desc =  "A lightweight semi-automatic pistol that fires 9mm rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 24.190544412607
ITEM.CamPos = Vector(-16.045845031738, 17.191976547241, 3.4383955001831)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_pistol"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.UseName = "Convert to USP-9"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_pistol", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
