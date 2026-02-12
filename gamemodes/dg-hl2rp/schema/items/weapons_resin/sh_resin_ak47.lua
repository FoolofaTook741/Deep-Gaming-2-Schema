local ITEM = {}

ITEM.UniqueID = "resin_ak47"
ITEM.Name = "AK-47 (Modified) [Deprecated]"
ITEM.Desc =  "A cheap yet reliable high powered rifle for medium range combat. Kicks as hard as it hits."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 6.6332378223496
ITEM.CamPos = Vector(160, -160, -15.128939628601)
ITEM.NoCenter = true
ITEM.Weight = 0
ITEM.Colour = Color(75, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 20

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.UseName = "Convert to AK47"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_ak47", 1)
	ply:GiveInventoryItem("resin_machineready", 1)
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
