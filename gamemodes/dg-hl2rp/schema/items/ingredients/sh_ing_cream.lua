local ITEM = {}

ITEM.UniqueID = "ing_cream"
ITEM.Name = "Tray of Cream"
ITEM.Desc = "A sweet topping for many dishes"
ITEM.Category = "Components"
ITEM.Model = Model("models/mosi/fallout4/props/food/foodpaste.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true 

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.75

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eating.wav"

ITEM.Food = 5

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
