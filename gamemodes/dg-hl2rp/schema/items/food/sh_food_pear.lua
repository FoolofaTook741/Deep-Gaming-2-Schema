local ITEM = {}

ITEM.UniqueID = "food_watermelon"
ITEM.Name = "Watermelon"
ITEM.Desc =  "A nice juicy green fruit."
ITEM.Category = "Food"
ITEM.Model = Model("models/hlvr/food/watermelon01.mdl")
ITEM.FOV = 20
ITEM.Weight = 0.2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 5

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
