local ITEM = {}

ITEM.UniqueID = "food_bread"
ITEM.Name = "Bread"
ITEM.Desc =  "A dried loaf of bread containing preservatives."
ITEM.Category = "Food"
ITEM.Model = Model("models/synapse/alyxports/bread03a.mdl")
ITEM.FOV = 35
ITEM.Weight = 1
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 11

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
