local ITEM = {}

ITEM.UniqueID = "wep_mini14"
ITEM.Name = "G3A3"
ITEM.Desc =  "The G3A3 is a German select fire battle rifle developed in the 1950s by Heckler and Koch."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_rif_g3.mdl")
ITEM.FOV = 11.396848137536
ITEM.CamPos = Vector(52.722061157227, -100, 1.1461317539215)
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
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_svt40"

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
