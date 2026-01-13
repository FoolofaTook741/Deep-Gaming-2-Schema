local ITEM = {}

ITEM.UniqueID = "food_xenstew"
ITEM.Name = "Xen Stew"
ITEM.Desc =  "A stew made out of the rare Xen extract."
ITEM.Category = "Food"
ITEM.Model = Model("models/willardnetworks/food/xen_stew.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.5
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 40

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
