local ITEM = {}

ITEM.UniqueID = "wep_osisg"
ITEM.Name = "O.S.I.S."
ITEM.Desc =  "The O.S.I.S. or 'Overwatch Standard Issue Shotgun' is a small shotgun that fires miniscule pellets but allows for a lot of mobility. It fires relatively quick but is limited by weak munitions and low range."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/hla/shotgun/w_shotgun.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_osisg"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_osisg"

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
