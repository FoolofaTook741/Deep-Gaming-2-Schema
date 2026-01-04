local ITEM = {}

ITEM.UniqueID = "att_extendedmag"
ITEM.Name = "Extended Rifle Mags"
ITEM.Desc =  "This box of magazines contains 45 round mags for the M4A1 and the AK-47."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.75

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

ITEM.AttachmentClass = "fortyrndmag"

impulse.RegisterItem(ITEM)
