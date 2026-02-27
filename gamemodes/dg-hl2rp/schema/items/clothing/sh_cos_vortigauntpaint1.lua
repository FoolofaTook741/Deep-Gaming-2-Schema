local ITEM = {}

ITEM.UniqueID = "cos_vortpaint1"
ITEM.Name = "Vortigaunt Body Paint (var. 1)"
ITEM.Desc =  "A tub of paint which can be used to draw markings on a Vortigaunt."
ITEM.Category = "Clothing Accessories"
ITEM.Model = Model("models/props_junk/metal_paintcan001b.mdl")
ITEM.FOV = 18.707736389685
ITEM.CamPos = Vector(-10, 25, 90.773635864258)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return (not ply:IsCP()) and ply:Team() == TEAM_VORT and not ply:IsRebel()
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(10, 10)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(10, 0)
end

impulse.RegisterItem(ITEM)