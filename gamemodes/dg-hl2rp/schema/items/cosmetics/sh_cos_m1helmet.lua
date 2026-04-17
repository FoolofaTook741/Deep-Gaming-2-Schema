local ITEM = {}

ITEM.UniqueID = "cos_m1helmet"
ITEM.Name = "M1 Helmet"
ITEM.Desc =  "An old school steel American helmet from World War 2. Offers 25% protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/head_helmet.mdl")
ITEM.FOV = 17.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 15

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return not ply:IsCP() and ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(1, 3)
	ply.HasHelmet2 = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(1, 0)
	ply.HasHelmet2 = false
end

impulse.RegisterItem(ITEM)
