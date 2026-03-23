local ITEM = {}

ITEM.UniqueID = "wep_wallhammershield"
ITEM.Name = "Wallhammer Shield"
ITEM.Desc = "A large portable shield used by WALLHAMMER Assets, functioning similarly to a Combine forcefield in a compact form. Equipped with a built-in flashbang ability for close-range engagements."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/synapse/props/combine_hand_shield.mdl")
ITEM.FOV = 80
ITEM.CamPos = Vector(20, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true

ITEM.Weight = 1.5

ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.ConfiscateReward = 100

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_attachment"
ITEM.EquipTime = 3
ITEM.UnEquipTime = 1.5
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_PAYBACK
end





ITEM.WeaponClass = "weapon_wallhammershield"

impulse.RegisterItem(ITEM)
