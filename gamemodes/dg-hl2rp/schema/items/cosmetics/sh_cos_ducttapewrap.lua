local ITEM = {}

ITEM.UniqueID = "cos_ducttapewrap"
ITEM.Name = "Duct Tape Face Wrap"
ITEM.Desc =  "A grey face wrap made out of duct tape. Can be used to hide your identity."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/headwrap2.mdl")
ITEM.FOV = 34
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "face"
ITEM.CanStack = true

ITEM.CosmeticData = {
	model = Model("models/sal/halloween/headwrap2.mdl"),
	pos = Vector(0.5, 2, -0.2),
	ang = Angle(0, -90, 270),
	scale = 1,
	femalePos = Vector(0.5, 0.8, -0.2)
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[3] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP() and ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, 3, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, nil, true)
end

impulse.RegisterItem(ITEM)
