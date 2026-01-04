local ITEM = {}

ITEM.UniqueID = "grenade_flashbang"
ITEM.Name = "Flashbang"
ITEM.Desc =  "Flashbangs emit a large light and loud sound to disorient an opponent."
ITEM.Category = "Grenades"
ITEM.Model = Model("models/shenesis/w_flashbang.mdl")
ITEM.Mass = 1
ITEM.FOV = 38.75787965616
ITEM.CamPos = Vector(45.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = false

ITEM.WeaponClass = "weapon_sh_flashbang"
ITEM.WeaponOverrideClip = 1

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)