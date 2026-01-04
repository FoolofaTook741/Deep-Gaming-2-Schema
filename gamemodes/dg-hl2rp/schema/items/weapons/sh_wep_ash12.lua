local ITEM = {}

ITEM.UniqueID = "wep_ash12"
ITEM.Name = "ShAK-12.7 [Deprecated]"
ITEM.Desc =  "A powerful Russian battle rifle that utilizes the menacing 12.7mm round. Item retired, 2/8/24."
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
ITEM.CanStack = true

ITEM.UseName = "Convert to AK-47"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_ak47", 1)
	return true
end


impulse.RegisterItem(ITEM)
