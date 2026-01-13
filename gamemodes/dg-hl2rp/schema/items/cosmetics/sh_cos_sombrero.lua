local ITEM = {}

ITEM.UniqueID = "cos_sombrero"
ITEM.Name = "Sombrero"
ITEM.Desc =  "Yo Quiero Taco Bell!"
ITEM.Colour = Color(235, 255, 0)
ITEM.Category = "Clothing"
ITEM.Model = Model("models/sombrero/sombrero.mdl")
ITEM.FOV = 6.769340974212
ITEM.CamPos = Vector(-100, -77.936965942383, 0.57306587696075)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Droppable = false
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/sombrero/sombrero.mdl"),
	pos = Vector(0, -11, 0),
	ang = Angle(-180, 0, 90),
	scale = 1,
	femalePos = Vector(0.4, -12.1, 0),
	femaleScale = 1.05,
	teamCustomPos = {
		[TEAM_CP] = Vector(0, -14, 0),
		[TEAM_OTA] = Vector(0, -14, 0)
	},
	teamCustomScale = {
		[TEAM_CP] = 1.2,
		[TEAM_OTA] = 1.2
	}
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
local cosId = table.insert(impulse.Cosmetics, ITEM.CosmeticData)

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, cosId, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)
