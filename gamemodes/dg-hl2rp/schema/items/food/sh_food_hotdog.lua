local ITEM = {}

ITEM.UniqueID = "food_hotdog"
ITEM.Name = "Hotdog"
ITEM.Desc =  "Piece of meat between some bread."
ITEM.Category = "Food"
ITEM.Model = Model("models/mosi/fnv/props/food/wastelandhotdog.mdl")
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

ITEM.Food = 15

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
