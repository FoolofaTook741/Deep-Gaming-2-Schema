local ITEM = {}

ITEM.UniqueID = "cos_constructionhelmet"
ITEM.Name = "Construction Helmet"
ITEM.Desc =  "A helmet that protects you from falling objects, it can also (very poorly) protect you from light munitions. Offers 10% protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/workercap_item.mdl")
ITEM.FOV = 17.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = true

ITEM.DyeSlots = { "Head Gear" }

function ITEM:CanEquip(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA then
		return true
	end
	return false
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(1, 9)
	ply.HasHelmet1 = true
	if ply:IsCharacterFemale() then
    	ply:SetBodygroup(10, 16)
	else
	    ply:SetBodygroup(10, 14)
	end
end

function ITEM:UnEquip(ply)
	ply.HasHelmet1 = false
	ply:SetBodygroup(1, 0)
	ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
end

impulse.RegisterItem(ITEM)
