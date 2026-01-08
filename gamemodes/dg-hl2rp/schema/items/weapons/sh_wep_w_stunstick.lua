local ITEM = {}

ITEM.UniqueID = "wep_w_stunstick"
ITEM.Name = "Stun Baton Baton MK. II"
ITEM.Desc =  "An extremely overcharged baton weilded by members of the PAYBACK division."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
ITEM.FOV = 20
ITEM.Weight = 1.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_w_stunstick"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
