local ITEM = {}

ITEM.UniqueID = "wep_osips"
ITEM.Name = "O.S.I.P.S."
ITEM.Desc =  "The O.S.I.P.S. or 'Overwatch Standard Issue Pulse SMG' is a lightweight submachine gun that fires small anti-matter munitions. It is limited by range, a poor iron sights, and a large barrel flare."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/psmg/w_psmg.mdl")
ITEM.FOV = 9.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_osips"

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

ITEM.WeaponClass = "plutonic_psmg"

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
