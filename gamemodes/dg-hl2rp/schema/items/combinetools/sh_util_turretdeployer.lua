local ITEM = {}

ITEM.UniqueID = "util_turret"
ITEM.Name = "Turret Deployer"
ITEM.Desc =  "A automated turret equipped with a high-precision targeting system and rapid-fire cannon, designed to detect and eliminate all non-combine personnel without hesitation."
ITEM.Category = "Utilities"
ITEM.Model = Model("models/combine_turrets/floor_turret.mdl")
ITEM.FOV = 92.03
ITEM.CamPos = Vector(68.672188, -1.870998, 52.942432)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "tool1"
ITEM.CanStack = true


function ITEM:CanEquip(ply)
	return ply:IsCP()
end

function ITEM:OnEquip(ply)
	
end

function ITEM:UnEquip(ply)

end

ITEM.WeaponClass = "weapon_turret_deployer"

impulse.RegisterItem(ITEM)