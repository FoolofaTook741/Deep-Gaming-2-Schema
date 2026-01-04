local ITEM = {}

ITEM.UniqueID = "cos_hal_skull"
ITEM.Name = "Spooky Skull Mask"
ITEM.Desc =  "Trick or treat!"
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/skull.mdl")
ITEM.Skin = 1
ITEM.Colour = Color(252, 70, 5)

ITEM.FOV = 15.618911174785
ITEM.CamPos = Vector(0, 48.595989227295, 0)
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/sal/halloween/skull.mdl"),
	pos = Vector(1, 3, 0),
	ang = Angle(0, -90, 270),
	scale = 0.95,
	femalePos = Vector(1, 2, 0),
	femaleScale = 0.9,
	skin = 1
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[9] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 9, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)