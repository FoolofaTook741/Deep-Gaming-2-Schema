local ITEM = {}

ITEM.UniqueID = "wep_osiprmk1"
ITEM.Name = "O.S.I.P.R. MK. I"
ITEM.Desc =  "The O.S.I.P.R. MK. I or 'Overwatch Standard Issue Pulse Rifle Mark I' is a Combine issued pulse rifle issued specifically to Ordinal grade units. At the current moment it is pending replacement from the O.C.I.P.R. MK. II."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/ocipr/w_ocipr.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 6.5
ITEM.Colour = Color(255, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_osiprmk1"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 100

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_ar1"
ITEM.CombineWeapon = true





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
