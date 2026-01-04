local ITEM = {}

ITEM.UniqueID = "item_rappel"
ITEM.Name = "Rappeling Equipment"
ITEM.Desc =  "Standard issue Combine rappel gear."
ITEM.Category = "Tools"
ITEM.Model = Model("models/props_c17/TrapPropeller_Lever.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "rappel"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT
end

function ITEM:OnEquip(ply)
    ply.HasRappelGear = true
end

function ITEM:UnEquip(ply)
	ply.HasRappelGear = false
end

impulse.RegisterItem(ITEM)
