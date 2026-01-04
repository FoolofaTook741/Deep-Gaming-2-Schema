local ITEM = {}

ITEM.UniqueID = "wep_scarl"
ITEM.Name = "Steyr AUG A3 [Deprecated]"
ITEM.Desc =  "The AUG A3 is an Austrian assault rifle. This rifle shoots 5.56x45mm ammo."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_ins2/w_aug.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7
ITEM.Colour = Color(75,0,0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 25

ITEM.UseName = "Convert to M4A1"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_m4a1", 1)
	return true
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
