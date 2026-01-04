local ITEM = {}

ITEM.UniqueID = "wep_trenchgun"
ITEM.Name = "Winchester 1897 Trench Gun [Deprecated]"
ITEM.Desc =  "A powerful shotgun that was so powerful it was deemed a war crime. Now there is no Geneva convention to stop you. Retired on 2/8/24."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a_gib01.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(74.5, -84.809997558594, -26)
ITEM.Weight = 6
ITEM.NoCenter = true
ITEM.Colour = Color(75,0,0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.CanStack = true
ITEM.UseName = "Convert to XM1014"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_m500", 1)
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
