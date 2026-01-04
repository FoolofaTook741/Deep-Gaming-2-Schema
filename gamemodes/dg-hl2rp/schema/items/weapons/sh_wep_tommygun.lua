local ITEM = {}

ITEM.UniqueID = "wep_tommygun"
ITEM.Name = "M1918 Thompson Submachine Gun [Deprecated]"
ITEM.Desc =  "A powerful American SMG commonly associated with the mafia. Retired on 2/8/24."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/cardboard_box004a_gib01.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3.5
ITEM.Colour = Color(75,0,0)


ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.CanStack = true
ITEM.UseName = "Convert to MP7A8"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_mp7a8", 1)
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
