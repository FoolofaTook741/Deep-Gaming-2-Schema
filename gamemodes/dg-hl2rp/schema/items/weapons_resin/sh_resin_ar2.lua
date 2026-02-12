local ITEM = {}

ITEM.UniqueID = "resin_ar2"
ITEM.Name = "O.S.I.P.R. MK. II (Modified) [Deprecated]"
ITEM.Desc =  "A heavy-weight, high-tech combine pulse rifle. Fires special combine pulse munitions."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 0
ITEM.Colour = Color(75, 0, 0)

ITEM.ScrapClass = "scrap_ar2"

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 30

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.UseName = "Convert to AR2"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_ar2", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end


function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
