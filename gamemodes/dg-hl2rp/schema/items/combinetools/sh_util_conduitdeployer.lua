local ITEM = {}

ITEM.UniqueID = "util_conduit"
ITEM.Name = "Conduit Deployer"
ITEM.Desc = "A compact, lightweight conduit deployer designed for quick deployment of a light source."
ITEM.Category = "Utilities"
ITEM.Model = Model("models/props_combine/combine_light001a.mdl")
ITEM.FOV = 8.09
ITEM.CamPos = Vector(-454.221130, 455.023346, 147.986343)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "tool"
ITEM.CanStack = true


function ITEM:CanEquip(ply)
	return ply:IsCP()
end

function ITEM:OnEquip(ply)
	
end

function ITEM:UnEquip(ply)

end

ITEM.WeaponClass = "weapon_conduit_deployer"

impulse.RegisterItem(ITEM)