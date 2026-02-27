local ITEM = {}

ITEM.UniqueID = "clo_gloves"
ITEM.Name = "Gloves"
ITEM.Desc =  "Useful for work or cold weather."
ITEM.Category = "Clothing Accessories"
ITEM.Model = Model("models/willardnetworks/clothingitems/hands_glove.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "hands"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(5, 1)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(5, 0)
end

impulse.RegisterItem(ITEM)
