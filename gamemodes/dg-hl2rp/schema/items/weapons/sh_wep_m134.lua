local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_m134"
ITEM.Name = "Compact M134"
ITEM.Desc =  "The M134 is a 6 barreled minigun that fires a significant amount of rounds at a high firerate."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/minigun_model/weapons/w_minigun.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 11
ITEM.Colour = Color(0, 150, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 100

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 5
ITEM.UnEquipTime = 5


ITEM.WeaponClass = "plutonic_minigun"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
