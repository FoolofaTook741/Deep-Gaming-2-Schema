local ITEM = {}

ITEM.UniqueID = "wep_mk18s"
ITEM.Name = "MK-18S [Deprecated]"
ITEM.Desc =  "A silenced assault rifle, useful for operations where you don't want your cover blown, but you need to be up close. Retired on 2/8/2024."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 16.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 6.5
ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true
 
ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.UseName = "Convert to M4A1"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_m4a1", 1)
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
