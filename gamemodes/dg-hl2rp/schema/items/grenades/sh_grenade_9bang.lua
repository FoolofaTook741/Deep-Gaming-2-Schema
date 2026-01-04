local ITEM = {}

ITEM.UniqueID = "grenade_9bang"
ITEM.Name = "9-Bang"
ITEM.Desc =  "This special flashbang will emit 9 flashes upon detonation, useful for prolonged suppression."
ITEM.Category = "Grenades"
ITEM.Model = Model("models/shenesis/w_flashbang.mdl")
ITEM.Mass = 1
ITEM.FOV = 38.75787965616
ITEM.CamPos = Vector(45.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = false

ITEM.WeaponClass = "weapon_sh_9bang"
ITEM.WeaponOverrideClip = 1

impulse.RegisterItem(ITEM)