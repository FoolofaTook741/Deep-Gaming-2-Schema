local ITEM = {}

ITEM.UniqueID = "wep_immolator"
ITEM.Name = "Immolator"
ITEM.Desc =  "A tool used by the cremator to incenerate matter."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_immolator_quality_beta.mdl")
ITEM.FOV = 45.103151862464
ITEM.CamPos = Vector(26.590257644653, 48.595989227295, 56.73352432251)

ITEM.Weight = 12

ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.ConfiscateReward = 10

--ITEM.ScrapClass = ""

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CREMATOR
end





ITEM.WeaponClass = "weapon_immolator"

impulse.RegisterItem(ITEM)
