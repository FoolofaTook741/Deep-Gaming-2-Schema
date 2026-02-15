local ITEM = {}

ITEM.UniqueID = "clo_runningshoes"
ITEM.Name = "Running shoes"
ITEM.Desc =  "A pair of brown running shoes."
ITEM.Category = "Shoes"
ITEM.Model = Model("models/willardnetworks/clothingitems/shoes_military.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "shoes"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(4, 3)
	ply.HasJacket = false
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(4, 0)
	ply.HasJacket = false
end

impulse.RegisterItem(ITEM)
