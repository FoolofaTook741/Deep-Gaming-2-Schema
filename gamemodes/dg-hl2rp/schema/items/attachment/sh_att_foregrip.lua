local ITEM = {}

ITEM.UniqueID = "att_foregrip"
ITEM.Name = "Heavy Rifle Stock"
ITEM.Desc =  "This stock reduces the overall recoil of the AK-47 and M4A1 when equipped."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 1.2

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

ITEM.AttachmentClass = "rifle_foregrip"

impulse.RegisterItem(ITEM)
