local ITEM = {}

ITEM.UniqueID = "clo_casualjacket"
ITEM.Name = "Casual Jacket"
ITEM.Desc =  "A casual jacket with an undershirt."
ITEM.Category = "Shirts"
ITEM.Model = Model("models/willardnetworks/clothingitems/torso_alyxcoat1.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "torso"
ITEM.CanStack = false   

ITEM.DyeSlots = { "Torso", "Shirt" }

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(2, 14)
	ply.HasJacket = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 0)
	ply.HasJacket = false
end

impulse.RegisterItem(ITEM)
