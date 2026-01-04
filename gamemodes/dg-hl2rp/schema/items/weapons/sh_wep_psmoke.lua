local ITEM = {}

ITEM.UniqueID = "wep_psmoke"
ITEM.Name = "Air Support Marker"
ITEM.Desc =  "A small canister that will mark a location for aerial support."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_eq_smokegrenade.mdl")
ITEM.FOV = 13.574498567335
ITEM.CamPos = Vector(-33.810886383057, 28.080228805542, 20.057306289673)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = false

ITEM.WeaponClass = "plutonic_purplesmokegrenade"
ITEM.WeaponOverrideClip = 1

function ITEM:CanEquip(ply)
	return ply:Team() != TEAM_VORT and ply:Team() != TEAM_ZOMBIE
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)