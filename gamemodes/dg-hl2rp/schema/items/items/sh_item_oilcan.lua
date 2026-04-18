local ITEM = {}

ITEM.UniqueID = "item_oilcan"
ITEM.Name = "Refined Oil Jar"
ITEM.Desc =  "A 20 liter jar of refined oil. Perfect for fuel or lubrication."
ITEM.Category = "Components"
ITEM.Model = Model("models/mosi/fallout4/props/junk/components/oil.mdl")
iconFOV = 3.5444126074499
iconCamPos = Vector(-52.263610839844, 139.36962890625, 66)
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

