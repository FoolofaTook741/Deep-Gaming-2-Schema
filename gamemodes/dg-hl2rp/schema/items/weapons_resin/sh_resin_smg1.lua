local ITEM = {}

ITEM.UniqueID = "resin_mp7"
ITEM.Name = "H&K MP7 (Modified) [Deprecated]"
ITEM.Desc =  "A lightweight submachine gun often used by Civil Protection officers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 0
ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_mp7"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.UseName = "Convert to MP7"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_mp7", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
