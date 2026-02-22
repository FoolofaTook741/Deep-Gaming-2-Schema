local ITEM = {}

ITEM.UniqueID = "cos_otavest"
ITEM.Name = "Level 4 Kevlar"
ITEM.Desc =  "A durable ballistic vest made up of ceramics and anti-ballistic materials. This vest protects against greater munitions and offers a 40% protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/armor01_item.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 40

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true
ITEM.IsVest = true

local bg

function ITEM:CanEquip(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		if ply.IsARebel or ply:GetBodygroup(2) == 25 or ply:GetBodygroup(2) == 25 or (ply:GetBodygroup(2) >= 7 and ply:GetBodygroup(2) <= 12) then
			return true
		end
	end
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(2, 25)
	ply.HasTier2Vest = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 12)
	ply.HasTier2Vest = false
end

impulse.RegisterItem(ITEM)
