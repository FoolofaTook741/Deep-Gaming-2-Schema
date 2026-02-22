local ITEM = {}

ITEM.UniqueID = "ing_grapes"
ITEM.Name = "Grapes"
ITEM.Desc = "A healthy fruit that can also be used for wine."
ITEM.Category = "Components"
ITEM.Model = Model("models/mosi/fallout4/props/food/tarberry.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true 

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.2

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eating.wav"

ITEM.Food = 4

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
