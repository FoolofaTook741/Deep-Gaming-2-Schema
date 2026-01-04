local ITEM = {}

ITEM.UniqueID = "wep_cz75"
ITEM.Name = "CZ-75 Auto"
ITEM.Desc =  "A Cold War era machine pistol."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_ins2/w_cz75a.mdl")
ITEM.FOV = 24.190544412607
ITEM.CamPos = Vector(-16.045845031738, 17.191976547241, 3.4383955001831)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_cz75"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_cz75"

function ITEM:OnEquip(ply)
    ply:Say("/me equips a " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips a " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
