local ITEM = {}

ITEM.UniqueID = "food_pineapple"
ITEM.Name = "Zucchini"
ITEM.Desc =  "A nice green vegetable, it has multiple purposes if you're a woman."
ITEM.Category = "Food"
ITEM.Model = Model("models/hlvr/food/zucchini01a.mdl")
ITEM.FOV = 42
ITEM.Weight = 2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 10

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
