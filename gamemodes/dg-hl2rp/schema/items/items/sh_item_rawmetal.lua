local ITEM = {}

ITEM.UniqueID = "item_rawmetal"
ITEM.Name = "Raw Metal"
ITEM.Desc =  "Metal that has not yet been refined, using a refinery it can be turned into other metals."
ITEM.Category = "Items"
ITEM.Model = Model("models/props_debris/metal_panelshard01c.mdl")
ITEM.FOV = 3
ITEM.Material = "models/player/shared/ice_player"
ITEM.CamPos = Vector(0, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.ConfiscateReward = 0

impulse.RegisterItem(ITEM)
