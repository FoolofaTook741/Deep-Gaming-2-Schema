local ITEM = {}

ITEM.UniqueID = "cos_constructionhelmet"
ITEM.Name = "Construction Helmet"
ITEM.Desc =  "A bright yellow helmet that protects you from falling objects, it can also (very poorly) protect you from light munitions. Offers 5% protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/update_items/workercap_item.mdl")
ITEM.FOV = 17.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 1

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = true


function ITEM:CanEqup(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		return true
	end
	return false
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(1, 9)
	ply.HasHelmet1 = true
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(1, 0)
	ply.HasHelmet1 = false
end

impulse.RegisterItem(ITEM)
