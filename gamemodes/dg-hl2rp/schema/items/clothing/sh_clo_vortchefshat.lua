local ITEM = {}

ITEM.UniqueID = "clo_vortchefshat"
ITEM.Name = "Vort Chef's Hat"
ITEM.Desc =  "The official badge of someone who can cook."
ITEM.Category = "Hats"
ITEM.Model = Model("models/willardnetworks/clothingitems/head_chefhat.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "hat"
ITEM.CanStack = false    

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_VORT 
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(6, 1)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(6, 0)
end

impulse.RegisterItem(ITEM)
