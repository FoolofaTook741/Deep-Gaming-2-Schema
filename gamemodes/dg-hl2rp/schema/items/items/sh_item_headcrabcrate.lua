local ITEM = {}

ITEM.UniqueID = "item_headcrabcrate"
ITEM.Name = "Specimen Crate [Headcrab]"
ITEM.Desc =  "A specimen crate with a live Headcrab inside. Turn it over to the supplier for reward so it can be studied or use it for research."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_crate.mdl")
ITEM.FOV = 80.929799426934
ITEM.CamPos = Vector(-5, -50, -5)
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
