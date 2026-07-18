local ITEM = {}

ITEM.UniqueID = "clo_suitjacket"
ITEM.Name = "Suit Jacket"
ITEM.Desc =  "A suit jacket for the fanciest of occasions."
ITEM.Category = "Shirts"
ITEM.Model = Model("models/willardnetworks/clothingitems/torso_ca_suit_jacket.mdl")
ITEM.FOV = 22.638968481375
ITEM.CamPos = Vector(3.6676218509674, 9.1690540313721, 76.103149414063)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "torso"
ITEM.CanStack = false   

ITEM.DyeSlots = { "Torso", "Shirt" }

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(2, 34)
	ply.HasJacket = true
end

function ITEM:UnEquip(ply)
	if ply:Team() == TEAM_CA then
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(2, 4)
		ply.HasJacket = false
	else
		ply:SetBodygroup(2, 0)
		ply.HasJacket = false
	end
end

impulse.RegisterItem(ITEM)
