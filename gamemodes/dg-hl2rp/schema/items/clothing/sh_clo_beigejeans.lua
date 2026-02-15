local ITEM = {}

ITEM.UniqueID = "clo_beigejeans"
ITEM.Name = "Beige Jeans"
ITEM.Desc =  "Jeans with a beige hue."
ITEM.Category = "Pants"
ITEM.Model = Model("models/willardnetworks/clothingitems/legs_citizen5.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "pants"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(3, 2)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(3, 0)
end

impulse.RegisterItem(ITEM)
