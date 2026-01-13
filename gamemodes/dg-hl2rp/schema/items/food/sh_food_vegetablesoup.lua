local ITEM = {}

ITEM.UniqueID = "food_vegetablesoup"
ITEM.Name = "Vegetable Soup"
ITEM.Desc =  "A bunch of vegetables turned into soup."
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/vegetablesoup.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.6
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 22

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
