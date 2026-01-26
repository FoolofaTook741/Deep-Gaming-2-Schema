local ITEM = {}

ITEM.UniqueID = "wep_ar3_eq"
ITEM.Name = "O.S.I.P.R. MK. III (Unlinked)"
ITEM.Desc =  "A heavy-weight, high-tech combine pulse heavy machine gun. Fires special combine pulse munitions."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_rifar3.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 11
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

ITEM.WeaponClass = "plutonic_ar3"
ITEM.CombineWeapon = false


ITEM.EquipTime = 3
ITEM.UnEquipTime = 3


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
