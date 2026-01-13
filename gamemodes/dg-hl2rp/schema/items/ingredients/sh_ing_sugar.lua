local ITEM = {}

ITEM.UniqueID = "ing_sugar"
ITEM.Name = "Can of Sugar"
ITEM.Desc = "A sweet surprise."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_junk/garbage_metalcan002a.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true 

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.2

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eating.wav"

ITEM.Food = 2

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
