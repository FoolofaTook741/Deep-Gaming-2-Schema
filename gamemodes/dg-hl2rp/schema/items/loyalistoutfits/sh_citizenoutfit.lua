local ITEM = {}

ITEM.UniqueID = "citizenoutfit"
ITEM.Name = "Standard Citizen Outfit"
ITEM.Desc =  "An outfit given to citizens when they arrive in the city."
ITEM.Category = "Clothing Items - Accessories"
ITEM.Model = Model("models/willardnetworks/clothingitems/torso_citizen1.mdl")

ITEM.FOV = 8.3180515759312
ITEM.CamPos = Vector(0, 1.8338109254837, 173.98280334473)
ITEM.Weight = 0

ITEM.Droppable = false
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "torso"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN and not ply:IsRebel()
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(2, 1)
    ply:SetBodygroup(3, 1)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 0)
    ply:SetBodygroup(3, 0)
end

impulse.RegisterItem(ITEM)
