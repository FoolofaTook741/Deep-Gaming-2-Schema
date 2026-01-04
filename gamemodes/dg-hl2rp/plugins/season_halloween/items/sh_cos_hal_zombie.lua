local ITEM = {}

ITEM.UniqueID = "cos_hal_zombie"
ITEM.Name = "Spooky Zombie Mask"
ITEM.Desc =  "Trick or treat!"
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sal/halloween/zombie.mdl")
ITEM.Skin = 0
ITEM.Colour = Color(252, 70, 5)

ITEM.FOV = 3.2636103151862
ITEM.CamPos = Vector(-159.54154968262, 160, -7.5644698143005)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/sal/halloween/zombie.mdl"),
	pos = Vector(1, 1.8, 0),
	ang = Angle(0, -90, 270),
	scale = 0.95,
	femalePos = Vector(1, 0.7, 0),
	femaleScale = 0.9,
	skin = 0
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[10] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 10, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)