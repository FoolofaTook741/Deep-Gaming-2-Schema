local ITEM = {}

ITEM.UniqueID = "meal_xenpie"
ITEM.Name = "Xen Pie [MEAL]"
ITEM.Desc =  "A pie made out of the rare Xen extract. This is a meal item, consuming it will block hunger loss for 10 minutes. Meal items can be purchased from C.W. members."
ITEM.Category = "Meals"
ITEM.Model = Model("models/willardnetworks/food/xen_pie.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.7

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply, target)
    local sid = ply:SteamID()
    ply:SetHunger(100)
    timer.Create(sid .. "wellfed", 600, 0, function() 
        timer.Remove(sid .. "wellfed")
    end)
    ply:Notify("You have consumed a meal, you are now well fed and no longer have to eat for 10 minutes.")

    return true
end

impulse.RegisterItem(ITEM)