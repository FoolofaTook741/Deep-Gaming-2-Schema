local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_famas"
ITEM.Name = "FN FAMAS"
ITEM.Desc =  "The FN FAMAS is a Belgian automatic rifle chambered in 5.56x45."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/arccw_go/v_rif_famas.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 6
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

ITEM.WeaponClass = "rw_sw_dlt19s"

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
