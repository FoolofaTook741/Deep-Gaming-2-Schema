local ITEM = {}

ITEM.UniqueID = "loyalistoutfit_2"
ITEM.Name = "Tier 2 Loyalist Outfit"
ITEM.Desc =  "An outfit given to loyalists when they arrive in the city to display their loyalty status."
ITEM.Category = "Clothing Items - Accessories"
ITEM.Model = Model("models/willardnetworks/clothingitems/shoes_black.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Droppable = false
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "torso"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN and not ply:IsRebel()
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(2, 23)
    ply:SetBodygroup(3, 1)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(2, 0)
    ply:SetBodygroup(3, 0)
end

impulse.RegisterItem(ITEM)
