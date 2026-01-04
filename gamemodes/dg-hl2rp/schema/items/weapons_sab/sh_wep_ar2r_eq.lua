local ITEM = {}

ITEM.UniqueID = "wep_ar2r_eq"
ITEM.Name = "O.S.I.P.R. MK. II-R (Unlinked)"
ITEM.Desc =  "A special variant of the AR2 given to members of the Ranger Regiment. This burst rifle fires more powerful rounds, has a higher magnification optic, and also increased stability."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_irifle.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 8
ITEM.Colour = Color(0, 98, 255)

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 30

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_ar2r"
ITEM.CombineWeapon = false

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
