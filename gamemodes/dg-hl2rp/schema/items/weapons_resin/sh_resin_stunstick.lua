local ITEM = {}

ITEM.UniqueID = "resin_stunstick"
ITEM.Name = "Stun Baton (Modified)"
ITEM.Desc =  "An electrified baton that can be used to stun disobedient citizens."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
ITEM.FOV = 25
ITEM.Weight = 1.2
ITEM.Colour = Color(180, 180, 0)

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

ITEM.WeaponClass = "plutonic_resin_stunbaton"

function ITEM:OnEquip(ply)
    ply:Say("/me equips a " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips a " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
