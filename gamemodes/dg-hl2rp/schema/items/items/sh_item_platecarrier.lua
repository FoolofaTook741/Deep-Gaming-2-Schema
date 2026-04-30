local ITEM = {}

ITEM.UniqueID = "util_platecarrier"
ITEM.Name = "Plate Carrier"
ITEM.Desc =  "A vest designed to hold ballistic plates. It has little use on its own."
ITEM.Category = "Components"
ITEM.Model = Model("models/willardnetworks/clothingitems_conscripts/torso_vest_2.mdl")
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

