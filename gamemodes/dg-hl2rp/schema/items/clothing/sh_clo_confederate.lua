local ITEM = {}

ITEM.UniqueID = "clo_confederate"
ITEM.Name = "Confederate Cap"
ITEM.Desc =  "A cap worn by the opps in the Civil War."
ITEM.Category = "Clothing Items"
ITEM.Model = Model("models/willardnetworks/clothingitems/head_confederatehat.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "hat"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(1, 6)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(1, 0)
end

impulse.RegisterItem(ITEM)
