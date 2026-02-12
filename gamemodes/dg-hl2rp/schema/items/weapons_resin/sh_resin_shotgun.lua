local ITEM = {}

ITEM.UniqueID = "resin_shotgun"
ITEM.Name = "Franchi SPAS-12 (Modified) [Deprecated]"
ITEM.Desc =  "A large shotgun that packs a punch. Fires 12G buckshot rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(74.5, -84.809997558594, -26)
ITEM.Weight = 0
ITEM.NoCenter = true

ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_shotgun"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15

ITEM.Illegal = true
ITEM.UseName = "Convert to SPAS-12"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_shotgun", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end



function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
