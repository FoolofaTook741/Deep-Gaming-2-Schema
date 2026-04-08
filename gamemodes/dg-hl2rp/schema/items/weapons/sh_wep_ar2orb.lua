local ITEM = {}

ITEM.UniqueID = "wep_ar2orb"
ITEM.Name = "Pulse Orb Launcher"
ITEM.Desc =  "The pulse orb launcher fires a highly energized pulse projectile that delivers significant damage to those that come in contact with it."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/effects/combineball.mdl")
ITEM.FOV = 45
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "orb"
ITEM.CanStack = true
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_xar2_orb"

impulse.RegisterItem(ITEM)
