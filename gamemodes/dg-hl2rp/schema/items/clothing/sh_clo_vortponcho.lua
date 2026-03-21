local ITEM = {}

ITEM.UniqueID = "clo_vortponcho"
ITEM.Name = "Vort Poncho"
ITEM.Desc =  "Black Poncho Made For Vortigaunts."
ITEM.Category = "Clothing Accessories"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "torso"
ITEM.CanStack = false    

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_VORT 
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(1, 4)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(1, 0)
end

impulse.RegisterItem(ITEM)
