local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_ak47u"
ITEM.Name = "AK-74u"
ITEM.Desc =  "A smaller and more lightweight variant of the AK-74 chambered in 5.45."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_ins2/w_aksz.mdl")
ITEM.FOV = 6.6332378223496
ITEM.CamPos = Vector(160, -160, -15.128939628601)
ITEM.NoCenter = true
ITEM.Weight = 4.25
ITEM.Colour = Color(0, 150, 0)

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

ITEM.WeaponClass = "plutonic_ak74u"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end





impulse.RegisterItem(ITEM)
