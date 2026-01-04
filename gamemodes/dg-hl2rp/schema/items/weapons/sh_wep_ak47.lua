local ITEM = {}

ITEM.UniqueID = "wep_ak47"
ITEM.Name = "AK-47"
ITEM.Desc =  "A cheap yet reliable high powered rifle for medium range combat. Kicks as hard as it hits."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_akm_inss.mdl")
ITEM.FOV = 6.6332378223496
ITEM.CamPos = Vector(160, -160, -15.128939628601)
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 20

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_ak47"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end

impulse.RegisterItem(ITEM)
