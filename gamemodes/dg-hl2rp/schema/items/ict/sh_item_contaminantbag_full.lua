local ITEM = {}

ITEM.UniqueID = "item_fullbag"
ITEM.Name = "Full Contaminant Bag"
ITEM.Desc =  "A bag full with a source of contaminant, bring it back to HQ for disposal."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_trashbag.mdl")
ITEM.FOV = 60
ITEM.CamPos = Vector(40, 40, 40)
ITEM.NoCenter = true
ITEM.Weight = 0.25

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
