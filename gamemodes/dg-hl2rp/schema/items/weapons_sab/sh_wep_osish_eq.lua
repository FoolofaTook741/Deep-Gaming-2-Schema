local ITEM = {}

ITEM.UniqueID = "wep_osihs_eq"
ITEM.Name = "O.S.I.H.S. (Unlinked)"
ITEM.Desc =  "The O.S.I.H.S. or 'Overwatch Standard Issue Heavy Shotgun' is a heavy weight shotgun utilized by members of the PAYBACK division."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/heavyshotgun/w_shotgun_heavy.mdl")
ITEM.FOV = 9.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 12
ITEM.Colour = Color(0, 98, 255)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_osish"
ITEM.CombineWeapon = false


ITEM.EquipTime = 4
ITEM.UnEquipTime = 4


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
