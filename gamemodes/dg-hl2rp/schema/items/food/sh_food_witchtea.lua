local ITEM = {}

ITEM.UniqueID = "food_witchtea"
ITEM.Name = "Tea [Halloween]"
ITEM.Desc =  "A distinctive cup of tea you probably won't forget, witches don't usually invite people to their tea parties."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_coffeemug001a.mdl")
ITEM.Material = "models/shiny"
ITEM.Weight = 0.5

ITEM.Colour = Color(255, 0, 97)

ITEM.FOV = 13.65329512894
ITEM.CamPos = Vector(-15.587392807007, 22.005731582642, 11.346704483032)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Sipping..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.CraftTime = 0.2
ITEM.Food = 5

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    ply:Notify("As you finish drinking your tea, you feel as if you could die and do it all over again.")
    return true
end

impulse.RegisterItem(ITEM)
