local ITEM = {}

ITEM.UniqueID = "food_cookedantlionmeat"
ITEM.Name = "Cooked Antlion Meat"
ITEM.Desc =  "A slightly cooked piece of alien meat."
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/cooked_alienmeat.mdl")
ITEM.FOV = 18
ITEM.Weight = 2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

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
