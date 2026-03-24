local ITEM = {}

ITEM.UniqueID = "wep_honeybadger"
ITEM.Name = "Honeybadger"
ITEM.Desc =  "A lightweight compact PDW chambered in .300 blackout."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/private_arsenals/w_honeybadger.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 6

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_hb"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "rw_sw_dc15a_purge"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
