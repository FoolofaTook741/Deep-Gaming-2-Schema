local ITEM = {}

ITEM.UniqueID = "item_armorrepairkit_r"
ITEM.Name = "Armor Repair Kit (Rebel)"
ITEM.Desc =  "Can be used to fully repair your armor one time, this takes a significant amount of time and locks you in place."
ITEM.Category = "Medical"
ITEM.Model = Model("models/Items/battery.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
