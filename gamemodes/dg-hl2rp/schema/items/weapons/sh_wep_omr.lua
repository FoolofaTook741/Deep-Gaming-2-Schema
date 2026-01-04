local ITEM = {}

ITEM.UniqueID = "wep_omr"
ITEM.Name = "O.S.I.M.R."
ITEM.Desc =  "The O.S.I.M.R. is an experimental Combine marksman rifle. This weapon was designed as powerful medium and long range weapon as an alternative to the O.S.R."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_models/w_combine_sniper.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_omr"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 40
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_omr"
ITEM.CombineWeapon = true

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
