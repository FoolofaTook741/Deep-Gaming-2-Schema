local ITEM = {}

ITEM.UniqueID = "wep_bar"
ITEM.Name = "M1918 Browning Automatic Rifle"
ITEM.Desc = "The Browning Automatic Rifle is an American light machine gun manufactured in 1918. It fires powerful .30-06 rounds but has a significant kick compared to other rifles."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_dm1918_bar.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.WeaponClass = "plutonic_bar"

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
