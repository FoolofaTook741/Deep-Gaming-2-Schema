local ITEM = {}

ITEM.UniqueID = "cos_lightvest"
ITEM.Name = "Level 2 Kevlar Vest"
ITEM.Desc =  "A light vest made to protect the wearer against light munitions, not a strong piece of armor but not very expensive either. Offers 25% resistance to the chest."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/torso_rebel_torso_1.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true
ITEM.IsVest = true

local bg

function ITEM:CanEquip(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		if ply.IsARebel or ply:GetBodygroup(2) == 7 or ply:GetBodygroup(2) == 7 or (ply:GetBodygroup(2) >= 7 and ply:GetBodygroup(2) <= 12) then
			return true
		end
	end
end

function ITEM:OnEquip(ply)
	bg = ply:GetBodygroup(2)
	if ply:GetBodygroup(2) == 11 then
		ply:SetBodygroup(2, 7)
	elseif ply:GetBodygroup(2) == 11 then
		ply:SetBodygroup(2, 8)
	elseif ply:GetBodygroup(2) == 10 then
		ply:SetBodygroup(2, 9)
	else
		ply:SetBodygroup(2, 8)
	end
	ply.HasTier1Vest = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 12)
	ply.HasTier1Vest = false
end

impulse.RegisterItem(ITEM)
