local ITEM = {}

ITEM.UniqueID = "wep_crossbow"
ITEM.Name = "Crossbow [Event Exclusive]"
ITEM.Desc =  "A souvenir item obtainable from PD Raids during the 2024 April Fools event."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_crossbow.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(74.5, -84.809997558594, -26)
ITEM.Colour = Color(255, 150, 0)
ITEM.Weight = 6
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 12

ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "weapon_crossbow"
ITEM.WeaponOverrideClip = 0

impulse.RegisterItem(ITEM)
