local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_scarh"
ITEM.Name = "FN SCAR-H"
ITEM.Desc =  "The FN SCAR-H is a Belgian battle rifle chambered in 7.62x51."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_rif_scar.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7
ITEM.Colour = Color(0, 150, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 25
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_scar"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
