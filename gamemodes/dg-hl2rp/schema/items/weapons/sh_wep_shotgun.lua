local ITEM = {}

ITEM.UniqueID = "wep_shotgun"
ITEM.Name = "Franchi SPAS-12"
ITEM.Desc =  "A large shotgun that packs a punch. Fires 12G buckshot rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_spas122.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(74.5, -84.809997558594, -26)
ITEM.Weight = 6
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_shotgun"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3


ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "tfa_sw_repshot"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
