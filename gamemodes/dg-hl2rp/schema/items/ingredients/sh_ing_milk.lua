local ITEM = {}

ITEM.UniqueID = "ing_milk"
ITEM.Name = "Milk"
ITEM.Desc = "A carton of milk."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_junk/garbage_milkcarton002a.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true 

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.2

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.Food = 6

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
