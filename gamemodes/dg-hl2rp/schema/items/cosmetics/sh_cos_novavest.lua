local ITEM = {}

ITEM.UniqueID = "cos_otavest2"
ITEM.Name = "Level 5 Kevlar"
ITEM.Desc =  "A heavy vest made out of powerful steel anti-ballistic elements, this formidable vest offers a protection value of 60%, far greater than any human made vests."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/armor03_item.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 8.5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 80

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true
ITEM.IsVest = true

local bg

function ITEM:CanEquip(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		if ply.IsARebel or ply:GetBodygroup(2) == 26 or ply:GetBodygroup(2) == 26 or (ply:GetBodygroup(2) >= 7 and ply:GetBodygroup(2) <= 12) then
			return true
		end
	end
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(2, 26)
	ply.HasTier3Vest = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 12)
	ply.HasTier3Vest = false
end

impulse.RegisterItem(ITEM)
