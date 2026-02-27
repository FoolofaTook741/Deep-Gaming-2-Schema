local ITEM = {}

ITEM.UniqueID = "util_energycore"
ITEM.Name = "Energy Core"
ITEM.Desc = "A powerful core that can be used to repair Combine weapons or create and charge the powerful Tau Cannon."
ITEM.Category = "Components"
ITEM.Model = Model("models/Items/combine_rifle_ammo01.mdl")
ITEM.FOV = 8.4025787965616
ITEM.CamPos = Vector(100, -26.934097290039, 2.8653295040131)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 15

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)

function ITEM:OnUse(ply)
	ply:GiveAmmo(150, "energyammo")
	return true
end
