local ITEM = {}

ITEM.UniqueID = "cos_combatgasmask"
ITEM.Name = "M35 Gas Mask"
ITEM.Desc =  "A full face gas mask used to protect the wearer from toxic gases."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/update_items/m40_item.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "face"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return not ply:IsCP() and ply:Team() ~= TEAM_VORT
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
