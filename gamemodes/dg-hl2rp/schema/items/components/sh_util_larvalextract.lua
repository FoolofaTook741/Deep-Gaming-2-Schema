local ITEM = {}

ITEM.UniqueID = "util_extract"
ITEM.Name = "Larval Extract"
ITEM.Desc = "A jar full of Larval Extract. The Vorts say it was a commodity for them."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_lab/jar01b.mdl")
ITEM.FOV = 33
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 2

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "powder"

ITEM.UseName = "Convert to Xen Extract"

function ITEM:OnUse(ply)
	ply:GiveInventoryItem("util_xenextract", 1)
	return true
end


impulse.RegisterItem(ITEM)
