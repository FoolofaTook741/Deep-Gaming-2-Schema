local ITEM = {}

ITEM.UniqueID = "item_ashes"
ITEM.Name = "Ashes"
ITEM.Desc =  "A pile of ashes, the only evidence remaining of a cremator's work."
ITEM.Category = "Items"
ITEM.Model = Model("models/mosi/fnv/props/junk/hide.mdl")
iconFOV = 10.283667621777
iconCamPos = Vector(13.753582000732, 112.77937316895, 79.770774841309)
ITEM.NoCenter = true
ITEM.Weight = .1
ITEM.ItemColour = Color(20, 20, 20, 255)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false

--[[
function ITEM:OnUse(ply)
	return true
end ]]--

impulse.RegisterItem(ITEM)

