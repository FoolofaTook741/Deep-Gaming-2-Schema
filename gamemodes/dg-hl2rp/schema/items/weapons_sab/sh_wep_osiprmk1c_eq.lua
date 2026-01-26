local ITEM = {}

ITEM.UniqueID = "wep_osiprmk1c_eq"
ITEM.Name = "O.S.I.P.R. MK. I-C (Unlinked)"
ITEM.Desc =  "The O.S.I.P.R. MK. I-C is a special variant of the O.S.I.P.R. MK. I built for close range combat and efficiency."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/ocipr/w_ocipr.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7
ITEM.Colour = Color(0, 98, 255)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 225

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_ar1c"
ITEM.CombineWeapon = false


ITEM.EquipTime = 2
ITEM.UnEquipTime = 2


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
