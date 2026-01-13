local ITEM = {}

ITEM.UniqueID = "food_waterspecial"
ITEM.Name = "Enhanced Water"
ITEM.Desc =  "'Don't drink the water, they put something in it, to make us forget.'"
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/breencan1.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 5

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
