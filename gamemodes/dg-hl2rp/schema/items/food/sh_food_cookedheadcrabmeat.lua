local ITEM = {}

ITEM.UniqueID = "food_cookedheadcrabmeat"
ITEM.Name = "Cooked Headcrab Meat"
ITEM.Desc =  "A cooked piece of headcrab meat."
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/meat6.mdl")
ITEM.FOV = 18
ITEM.Weight = 2.0
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 30

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
