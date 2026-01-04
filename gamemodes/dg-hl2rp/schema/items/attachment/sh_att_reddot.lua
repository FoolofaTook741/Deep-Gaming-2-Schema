local ITEM = {}

ITEM.UniqueID = "att_reddot"
ITEM.Name = "Barska Red Dot Sight"
ITEM.Desc =  "This red dot sight is sleak and easy to use and is useful on a variety of Sub Machine Guns."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_optic"
ITEM.CanStack = true

ITEM.AttachmentClass = "barska_rds"

impulse.RegisterItem(ITEM)
