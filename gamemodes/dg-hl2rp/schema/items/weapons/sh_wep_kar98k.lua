local ITEM = {}

ITEM.UniqueID = "wep_kar98k"
ITEM.Name = "Mosin-Nagant [Old/Deprecated]"
ITEM.Desc =  "The Mosin has been repurposed to an end game item, all existing copies can be converted to 2 DMRs. Retired on 5/9/2024."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a_gib01.mdl")
ITEM.FOV = 10
ITEM.CamPos = Vector(-82, 144, 90)
ITEM.Weight = 0
ITEM.Colour = Color(75,0,0)

ITEM.Droppable = true 
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 25

ITEM.UseName = "Convert to M4A1"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_mini14", 1)
    ply:GiveInventoryItem("wep_mini14", 1)
	return true
end


impulse.RegisterItem(ITEM)
