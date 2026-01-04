local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_m249"
ITEM.Name = "M249"
ITEM.Desc =  "A powerful machine gun weilded by the United States army.."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_mach_m249para.mdl")
ITEM.Mass = 1
ITEM.FOV = 20.75787965616
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Weight = 10
ITEM.Colour = Color(0, 150, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4


ITEM.WeaponClass = "plutonic_m249"

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
