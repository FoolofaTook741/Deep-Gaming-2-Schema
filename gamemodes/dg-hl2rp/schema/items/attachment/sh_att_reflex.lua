local ITEM = {}

ITEM.UniqueID = "att_reflex"
ITEM.Name = "T1 Reflex Sight"
ITEM.Desc =  "This reflex sight is small and can be applied to various handguns and SMGs and has a delta reticle."
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

ITEM.AttachmentClass = "t1_reflex"

impulse.RegisterItem(ITEM)
