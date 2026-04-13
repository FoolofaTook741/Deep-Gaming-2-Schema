local ITEM = {}

ITEM.UniqueID = "item_steelbar"
ITEM.Name = "Refined Steel Bar"
ITEM.Desc =  "A bar of refined steel."
ITEM.Category = "Components"
ITEM.Model = Model("models/mosi/fallout4/props/junk/components/steel.mdl")
ITEM.FOV = 10.002865329513
ITEM.CamPos = Vector(39.426933288574, 84.35530090332, 55.931232452393)
ITEM.NoCenter = true
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false

--[[
function ITEM:OnUse(ply)
	return true
end ]]--

impulse.RegisterItem(ITEM)

