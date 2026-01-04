local ITEM = {}

ITEM.UniqueID = "wep_sledgehammer"
ITEM.Name = "Sledgehammer"
ITEM.Desc = "A large hammer that can be used to break various structures or doors with ease."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_nmrih/w_me_sledge.mdl")
ITEM.FOV = 49.777936962751
ITEM.CamPos = Vector(44.126075744629, 22.349569320679, 14.326647758484)
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2


ITEM.WeaponClass = "plutonic_sledgehammer"

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
