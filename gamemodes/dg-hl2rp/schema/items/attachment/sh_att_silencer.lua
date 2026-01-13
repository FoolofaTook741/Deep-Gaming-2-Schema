local ITEM = {}

ITEM.UniqueID = "att_pistol_silencer"
ITEM.Name = "Pistol Suppressor"
ITEM.Desc =  "A small suppressor used for handguns."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary_attachment"
ITEM.CanStack = true

ITEM.AttachmentClass = "att_pistol_silencer"

impulse.RegisterItem(ITEM)
