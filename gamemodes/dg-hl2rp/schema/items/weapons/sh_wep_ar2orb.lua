local ITEM = {}

ITEM.UniqueID = "wep_ar2orb"
ITEM.Name = "Experimental Pulse Orb Attachment"
ITEM.Desc =  "The experimental pulse orb attachment is an early combine device that fires an explosive pulse projectile that delivers signifcant damage to those around it, experimentation is still being done to make it ricochet."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/Items/combine_rifle_ammo01.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
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
