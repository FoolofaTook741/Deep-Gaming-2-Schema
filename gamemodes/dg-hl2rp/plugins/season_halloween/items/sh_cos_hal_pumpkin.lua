local ITEM = {}

ITEM.UniqueID = "cos_hal_pumpkin"
ITEM.Name = "Spooky Pumpkin Mask"
ITEM.Desc =  "Trick or treat!"
ITEM.Category = "Clothing"
ITEM.Model = Model("models/pumpkin_3/pumpkin_3.mdl")
ITEM.Skin = 0
ITEM.Colour = Color(252, 70, 5)

ITEM.FOV = 15.618911174785
ITEM.CamPos = Vector(-121.94842529297, 30.257879257202, 15.128939628601)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/pumpkin_3/pumpkin_3.mdl"),
	pos = Vector(1, 1.8, 0),
	ang = Angle(0, 180, 270),
	scale = 0.95,
	skin = 0,
	teamCustomPos = {
		[TEAM_CP] = Vector(3, -3, 0),
		[TEAM_OTA] = Vector(1.33, -3, 0)
	},
	teamCustomScale = {
		[TEAM_CP] = 0.62,
		[TEAM_OTA] = 0.65
	}
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[12] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return true
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 12, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)