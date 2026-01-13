local ITEM = {}

ITEM.UniqueID = "att_slugrounds"
ITEM.Name = "Slug Rounds"
ITEM.Desc =  "These special rounds will increase the range and power of your shotgun, but limit the amount of rounds fired from it."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 1.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_attachment"
ITEM.CanStack = true

ITEM.AttachmentClass = "slug_rounds"

impulse.RegisterItem(ITEM)
