local ITEM = {}

ITEM.UniqueID = "resin_mp7a8"
ITEM.Name = "H&K MP7A8"
ITEM.Desc =  "A modified MP7 distributed to the members of the SWORD division of the Metro Police Force."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_misc/w_combine_smg.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3
ITEM.Colour = Color(180, 180, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_mp7a8"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_resin_mp7a8"

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
