local ITEM = {}

ITEM.UniqueID = "wep_mp510"
ITEM.Name = "H&K MP5/10MM"
ITEM.Desc =  "Heckler & Koch's famous MP5 in a 10mm caliber."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_inss/w_tfamp5a2kpdw.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3.5

ITEM.ScrapClass = "scrap_osips"

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 7

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_mp510"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
