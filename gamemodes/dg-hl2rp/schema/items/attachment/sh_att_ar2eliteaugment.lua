local ITEM = {}

ITEM.UniqueID = "att_ar2eliteaugment"
ITEM.Name = "AR2 Elite Augmentation"
ITEM.Desc =  "An upgrade to the Mark 2 Pulse Rifle given to units that have attained an elite grade augmentation."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/Items/combine_rifle_ammo01.mdl")
ITEM.FOV = 7.1948424068768
ITEM.CamPos = Vector(-99.942695617676, -18.338108062744, 64.297996520996)
ITEM.NoCenter = true
ITEM.Weight = 0.4

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_optic"
ITEM.CanStack = true

ITEM.AttachmentClass = "ar2eliteaugment"

impulse.RegisterItem(ITEM)