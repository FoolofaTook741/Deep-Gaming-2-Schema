local ITEM = {}

ITEM.UniqueID = "cos_yellowfacewrap"
ITEM.Name = "Police Tape Face Wrap"
ITEM.Desc =  "A yellow face wrap made out of old police tape. Can be used to hide your identity."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/headwrap1.mdl")
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
	model = Model("models/sal/halloween/headwrap1.mdl"),
	pos = Vector(0.5, 2, -0.2),
	ang = Angle(0, -90, 270),
	scale = 1,
	femalePos = Vector(0.5, 0.8, -0.2)
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[7] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, 7, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, nil, true)
end

impulse.RegisterItem(ITEM)
