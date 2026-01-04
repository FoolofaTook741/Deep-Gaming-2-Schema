local ITEM = {}

ITEM.UniqueID = "cos_hal_monkey"
ITEM.Name = "Spooky Monkey Mask"
ITEM.Desc =  "Trick or treat!"
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/monkey.mdl")
ITEM.Skin = 2
ITEM.Colour = Color(252, 70, 5)

ITEM.FOV = 6.352435530086
ITEM.CamPos = Vector(-26.590257644653, 107.27793884277, 79.426933288574)
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/sal/halloween/monkey.mdl"),
	pos = Vector(1, 1.8, 0),
	ang = Angle(0, -90, 270),
	scale = 0.95,
	femalePos = Vector(1, 0.7, 0),
	femaleScale = 0.9,
	skin = 2
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[11] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 11, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)