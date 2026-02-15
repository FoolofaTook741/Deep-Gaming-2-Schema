local ITEM = {}

ITEM.UniqueID = "wep_ar1"
ITEM.Name = "O.S.I.P.R. MK. I"
ITEM.Desc =  "The O.S.I.P.R MK. 1 or 'Overwatch Standard Issue Pulse Rilfe Mark I' is a Combine pulse rifle issued specifically to Ordinal grade units."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/ocipr/w_ocipr.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7.25
ITEM.Colour = Color(255, 0, 0)

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

ITEM.WeaponClass = "plutonic_ar1"
ITEM.CombineWeapon = true
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
