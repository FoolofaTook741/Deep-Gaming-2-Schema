local ITEM = {}

ITEM.UniqueID = "att_holosight"
ITEM.Name = "Holographic Sight"
ITEM.Desc =  "Compatible with: G3A1, M4A1, PTRS-41, and HK MP5A2."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.2

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

ITEM.AttachmentClass = "holographic_sight"

impulse.RegisterItem(ITEM)
