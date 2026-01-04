local ITEM = {}

ITEM.UniqueID = "food_coffee"
ITEM.Name = "Cup of Coffee"
ITEM.Desc =  "A cup of warm coffee."
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/coffee.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 6

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
