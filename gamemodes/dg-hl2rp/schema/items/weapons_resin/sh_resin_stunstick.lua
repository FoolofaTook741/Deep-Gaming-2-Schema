local ITEM = {}

ITEM.UniqueID = "resin_stunstick"
ITEM.Name = "Stun Baton (Modified) [Deprecated]"
ITEM.Desc =  "An electrified baton that can be used to stun disobedient citizens."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 25
ITEM.Weight = 0
ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.ScrapClass = "scrap_stunstick"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.UseName = "Convert to Stunstick"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_stunstick", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
