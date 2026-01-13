local ITEM = {}

ITEM.UniqueID = "food_chickensoup"
ITEM.Name = "Chicken Soup"
ITEM.Desc =  "A cold can of chicken soup."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_metalcan001a.mdl")
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

ITEM.Food = 30

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
