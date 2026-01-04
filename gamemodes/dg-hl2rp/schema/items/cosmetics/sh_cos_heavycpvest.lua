local ITEM = {}

ITEM.UniqueID = "cos_cpvest3"
ITEM.Name = "Tier III Ballistic Vest"
ITEM.Desc =  "Special forces grade vest. This vest offers an additional 25% protection on the body."
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
	ply.HasCPVest3 = true
end

function ITEM:UnEquip(ply)
	ply.HasCPVest3 = false
end

impulse.RegisterItem(ITEM)
