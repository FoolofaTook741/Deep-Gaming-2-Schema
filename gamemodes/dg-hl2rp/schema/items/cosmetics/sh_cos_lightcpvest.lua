local ITEM = {}

ITEM.UniqueID = "cos_cpvest1"
ITEM.Name = "Tier I Ballistic Vest"
ITEM.Desc =  "A light plate placed inside of the Metro Police Force uniform, offering 10% protection."
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
	ply.HasCPVest1 = true
end

function ITEM:UnEquip(ply)
	ply.HasCPVest1 = false
end

impulse.RegisterItem(ITEM)
