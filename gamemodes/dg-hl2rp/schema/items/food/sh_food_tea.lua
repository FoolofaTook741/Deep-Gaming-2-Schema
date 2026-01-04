local ITEM = {}

ITEM.UniqueID = "food_tea"
ITEM.Name = "Tea"
ITEM.Desc =  "A warm, distinctly British drink."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_coffeemug001a.mdl")
ITEM.FOV = 70
ITEM.Weight = 0.5
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Sipping..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 5

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
