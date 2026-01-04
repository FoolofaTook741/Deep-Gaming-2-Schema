local ITEM = {}

ITEM.UniqueID = "wep_stiletto"
ITEM.Name = "Stiletto Dagger"
ITEM.Desc = "A small but sharp knife. This weapon has extremely small range and damage, but if it hits anyone below 50 HP it will kill them instantly. This item allows you to take an assassin playstyle. i love league"
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/knife_stiletto/w_stiletto.mdl")
ITEM.FOV = 10.462750716332
ITEM.CamPos = Vector(-12.607449531555, 15.472779273987, 61.318050384521)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_eknife"

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end
function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
