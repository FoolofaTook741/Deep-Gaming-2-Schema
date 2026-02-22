local ITEM = {}

ITEM.UniqueID = "food_tomato"
ITEM.Name = "Tomato"
ITEM.Desc =  "A not-so freshly grown tomato."
ITEM.Category = "Food"
ITEM.Model = Model("models/mosi/skyrim/fooddrink/tomato.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.4
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

ITEM.Food = 9

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
