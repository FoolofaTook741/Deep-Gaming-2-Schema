local ITEM = {}

ITEM.UniqueID = "att_greasedbelt"
ITEM.Name = "Grease Kit"
ITEM.Desc =  "This special lubricant will allow for rounds cycling to occur more rapidly."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_attachment"
ITEM.CanStack = true

ITEM.AttachmentClass = "greased_belt"

impulse.RegisterItem(ITEM)
