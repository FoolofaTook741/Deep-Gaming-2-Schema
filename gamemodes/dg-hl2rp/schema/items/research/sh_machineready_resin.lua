local ITEM = {}

ITEM.UniqueID = "resin_machineready"
ITEM.Name = "Resin (Machine Ready)"
ITEM.Desc = "A tightly compacted cluster of Resin, ready for use in the Fabricator."
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 44.061604584527
ITEM.CamPos = Vector(-6.8767910003662, 4.0114612579346, 28.080228805542)
ITEM.NoCenter = true
ITEM.Weight = 2
ITEM.Colour = Color(180, 180, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "plastic"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
