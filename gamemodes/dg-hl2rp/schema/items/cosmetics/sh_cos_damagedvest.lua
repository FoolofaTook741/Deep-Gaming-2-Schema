local ITEM = {}

ITEM.UniqueID = "cos_otavest3"
ITEM.Name = "Damaged Level 4 D.M.I. Ballistic Armor"
ITEM.Desc =  "This Level 4 ballistic armor has been damaged by unknown means, although it can still be worn and provide a protection of 7.5%, perhaps it can be repaired for more formidable use."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/combine_vests/zombineregularvest.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true

ITEM.CosmeticData = {
	model = Model("models/combine_vests/zombineregularvest.mdl"),
	pos = Vector(-3, -11, 0),
	ang = Angle(0, 90, 270),
	scale = 1,
	femalePos = Vector(-2, -9, 0),
	femaleScale = 0.8
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[2] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP() and ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_CHEST, 2, true)
	ply.HasTier0Vest = true
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_CHEST, nil, true)
	ply.HasTier0Vest = false
end

impulse.RegisterItem(ITEM)
