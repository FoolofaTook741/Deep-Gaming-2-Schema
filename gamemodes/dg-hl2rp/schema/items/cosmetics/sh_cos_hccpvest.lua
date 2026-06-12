local ITEM = {}

ITEM.UniqueID = "cos_cpvest4"
ITEM.Name = "Tier IV Ballistic Vest"
ITEM.Desc =  "High Command grade vest. This vest offers an additional 30% protection on the body."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_junk/cardboard_box002a.mdl")
ITEM.FOV = 150
ITEM.NoCenter = true
ITEM.Weight = 6

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 40

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	if ply:Team() == TEAM_CP then
		return true
	end
end

function ITEM:OnEquip(ply)
	ply.HasCPVest4 = true
end

function ITEM:UnEquip(ply)
	ply.HasCPVest4 = false
end

impulse.RegisterItem(ITEM)
