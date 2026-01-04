local ITEM = {}

ITEM.UniqueID = "wep_goldendeagle"
ITEM.Name = "Golden Desert Eagle"
ITEM.Desc =  "A Desert Eagle painted with a gold hue."
ITEM.Category = "Weapons"
ITEM.Material = "gold_tool/australium"
ITEM.Model = Model("models/tasty/w-d50.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 4
ITEM.Colour = Color(255, 255, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.EquipTime = 1
ITEM.UnEquipTime = 1
ITEM.WeaponClass = "plutonic_goldendeagle"

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
