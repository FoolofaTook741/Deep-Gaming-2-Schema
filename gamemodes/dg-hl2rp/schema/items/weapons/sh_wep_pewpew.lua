local ITEM = {}

ITEM.UniqueID = "wep_pewpew"
ITEM.Name = "Golden USP-9"
ITEM.Desc =  "A USP-9 covered in pure gold."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_pistol.mdl")
ITEM.Material = "gold_tool/australium"
ITEM.Colour = Color(255, 255, 0)
ITEM.FOV = 24.190544412607
ITEM.CamPos = Vector(-16.045845031738, 17.191976547241, 3.4383955001831)
ITEM.NoCenter = true
ITEM.Weight = 0.8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = true
ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_pewpew"

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
