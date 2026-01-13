local ITEM = {}

ITEM.UniqueID = "item_augmentchip"
ITEM.Name = "Augmentation Chip"
ITEM.Desc = "Activates the Combine Augmentor one time during peacetime, usage on the incorrect team may result in destruction."
ITEM.Model = Model("models/props/cs_office/projector_p6.mdl")
ITEM.FOV = 6.4971346704871
ITEM.CamPos = Vector(81.948425292969, 100, 60.744987487793)
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = true
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.CanStack = false

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
