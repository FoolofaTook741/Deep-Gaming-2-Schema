local ITEM = {}

ITEM.UniqueID = "cos_gasmaskfilter"
ITEM.Name = "I.C.T. Hazmat Gas Mask Filter"
ITEM.Desc =  "Offers coverage from all contaminant and gases."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/tnb/items/gasmask.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "face"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return not ply:IsCP() and not ply:Team() == TEAM_VORT
end

function ITEM:OnEquip(ply)
	ply.GasSafe = true
	ply:SetBodygroup(9, 3)
	ply:AddVoiceFX("Masked")
end

function ITEM:UnEquip(ply)
	ply.GasSafe = false
	ply:SetBodygroup(9, 0)
	ply:RemoveVoiceFX("Masked")
end

impulse.RegisterItem(ITEM)
