local ITEM = {}

ITEM.UniqueID = "food_ration"
ITEM.Name = "Combine Grade Ration"
ITEM.Desc =  "A ration that will fill you up for the duration of your operations."
ITEM.Category = "Food"
ITEM.Model = Model("models/hlvr/food/ration_bar.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(0, 0, 90)
ITEM.Weight = 1
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 100

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
