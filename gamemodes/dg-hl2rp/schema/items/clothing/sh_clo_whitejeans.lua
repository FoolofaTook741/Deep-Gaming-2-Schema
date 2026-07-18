local ITEM = {}

ITEM.UniqueID = "clo_whitejeans"
ITEM.Name = "Suit Pants"
ITEM.Desc =  "Pants fitting for a suit."
ITEM.Category = "Pants"
ITEM.Model = Model("models/willardnetworks/clothingitems/legs_ca_suit_pants.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "pants"
ITEM.CanStack = false   

ITEM.DyeSlots = { "Pants" } 

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(3, 7)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(3, 0)
end

impulse.RegisterItem(ITEM)
