local ITEM = {}

ITEM.UniqueID = "att_optic"
ITEM.Name = "Variable Sniper Optic"
ITEM.Desc =  "A magnifying optic for many weapons. Compatible with various Overwatch Snipers and resistance snipers."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_optic"
ITEM.CanStack = true

ITEM.AttachmentClass = "zoom_optic"

impulse.RegisterItem(ITEM)