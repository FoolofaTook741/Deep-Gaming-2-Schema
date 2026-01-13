local ITEM = {}

ITEM.UniqueID = "food_cheese"
ITEM.Name = "Can of Ham"
ITEM.Desc =  "This shit is probably rotten.."
ITEM.Category = "Food"
ITEM.Model = Model("models/hlvr/food/spam_3.mdl")
ITEM.FOV = 33
ITEM.Weight = 2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = truefalse

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 10
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 50

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
