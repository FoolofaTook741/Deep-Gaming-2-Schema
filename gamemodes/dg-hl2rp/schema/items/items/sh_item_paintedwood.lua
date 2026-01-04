local ITEM = {}

ITEM.UniqueID = "item_paintedwood"
ITEM.Name = "Carpenter's Wood"
ITEM.Desc = "Painted and reinforced wood ready for construction purposes."
ITEM.Model = Model("models/items/item_item_crate_chunk02.mdl")
ITEM.FOV = 20.924068767908
ITEM.CamPos = Vector(-25.787965774536, -0.57306587696075, 94.555877685547)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "wood"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)