local ITEM = {}

ITEM.UniqueID = "meal_pancakes"
ITEM.Name = "Pancakes [MEAL]"
ITEM.Desc =  "A nice tall stack of fluffy pancakes. This is a meal item, consuming it will block hunger loss for 10 minutes. Meal items can be purchased from C.W. members."
ITEM.Category = "Meals"
ITEM.Model = Model("models/foodnhouseholditems/pancakes.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

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
