local ITEM = {}

ITEM.UniqueID = "item_scraps"
ITEM.Name = "Metal Scrap"
ITEM.Desc =  "A broken down piece of metal. Can be reforged into metal plates."
ITEM.Category = "Items"
ITEM.Model = Model("models/props_debris/metal_panelchunk02d.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.ConfiscateReward = 0

ITEM.CraftTime = 0.25

impulse.RegisterItem(ITEM)
