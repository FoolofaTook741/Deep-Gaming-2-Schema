local ITEM = {}

ITEM.UniqueID = "item_vehiclerepairkit"
ITEM.Name = "Vehicle Repair Torch"
ITEM.Desc =  "A torch used to Repair Combine vehicles."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/weapons/w_repairlvs.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 6

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "tool"
ITEM.CanStack = true

ITEM.WeaponClass = "weapon_lvsrepair"

impulse.RegisterItem(ITEM)
