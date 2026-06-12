local ITEM = {}

ITEM.UniqueID = "cos_cpvest2"
ITEM.Name = "Tier II Ballistic Vest"
ITEM.Desc =  "Medium vest, utilized during emergency situations and by special forces during downtime. This vest offers an additional 20% protection on the body."
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
	ply.HasCPVest2 = true
end

function ITEM:UnEquip(ply)
	ply.HasCPVest2 = false
end

impulse.RegisterItem(ITEM)
