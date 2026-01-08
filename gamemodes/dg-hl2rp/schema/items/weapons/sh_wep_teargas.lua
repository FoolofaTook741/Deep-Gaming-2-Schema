local ITEM = {}

ITEM.UniqueID = "wep_teargas"
ITEM.Name = "Tear Gas"
ITEM.Desc =  "A small canister containing a chemical agent that can be used to distrupt public gatherings."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_eq_smokegrenade.mdl")
ITEM.FOV = 13.574498567335
ITEM.CamPos = Vector(-33.810886383057, 28.080228805542, 20.057306289673)
ITEM.NoCenter = true
ITEM.Weight = 0.25

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_teargas"
ITEM.WeaponOverrideClip = 1





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
