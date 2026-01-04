local ITEM = {}

ITEM.UniqueID = "cos_hal_bag"
ITEM.Name = "Spooky..ish? Bag Mask"
ITEM.Desc =  "Trick or treat! - On a budget."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/bag.mdl")
ITEM.Skin = 5
ITEM.Colour = Color(252, 70, 5)

ITEM.FOV = 24.604584527221
ITEM.CamPos = Vector(-13.753582000732, 36.676216125488, 9)
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/sal/halloween/bag.mdl"),
	pos = Vector(1.1, 1.8, 0),
	ang = Angle(0, -90, 270),
	scale = 0.95,
	femalePos = Vector(1, 1.1, 0),
	femaleScale = 0.9,
	skin = 5
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[8] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 8, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)