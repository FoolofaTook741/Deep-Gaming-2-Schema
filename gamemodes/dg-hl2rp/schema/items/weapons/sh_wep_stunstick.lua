local ITEM = {}

ITEM.UniqueID = "wep_stunstick"
ITEM.Name = "Stun Baton"
ITEM.Desc =  "An electrified baton that can be used to stun disobedient citizens."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
ITEM.FOV = 25
ITEM.Weight = 1.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.ScrapClass = "scrap_stunstick"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_stunstick"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end





impulse.RegisterItem(ITEM)
