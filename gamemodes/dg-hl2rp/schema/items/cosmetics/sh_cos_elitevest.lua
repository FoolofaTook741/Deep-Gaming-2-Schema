local ITEM = {}

ITEM.UniqueID = "cos_elitevest"
ITEM.Name = "Level 10 Quadruple Plated Dark Matter Ballistic Vest"
ITEM.Desc =  "A heavy vest, in ceremonial white. Provides additional ballistic protection. Salvaged from the body of an OTA Elite soldier, this poweful ballistic gear offers a whopping 80% protection, but only offers 40% arm protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/combine_vests/elitevest.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 9
ITEM.Colour = Color(255, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 150

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true 
ITEM.IsVest = true

ITEM.CosmeticData = { 
	model = Model("models/combine_vests/elitevest.mdl"),
	pos = Vector(-3, -11, 0),
	ang = Angle(0, 90, 270),
	scale = 1,
	femalePos = Vector(-2, -9, 0),
	femaleScale = 0.8
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[13] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP() and ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_CHEST, 13, true)
	ply.HasEliteOTAVest = true
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_CHEST, nil, true)
	ply.HasEliteOTAVest = false
end


impulse.RegisterItem(ITEM)
