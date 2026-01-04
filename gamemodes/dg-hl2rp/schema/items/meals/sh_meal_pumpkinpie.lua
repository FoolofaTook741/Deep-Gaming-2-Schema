local ITEM = {}

ITEM.UniqueID = "meal_pumpkinpie"
ITEM.Name = "Pumpkin Pie [MEAL]"
ITEM.Desc =  "A sugar filled pumpkin treat in commemoration of Halloween 2023."
ITEM.Category = "Meals"
ITEM.Model = Model("models/foodnhouseholditems/pie.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.Colour = Color(255, 150, 0)
ITEM.NoCenter = true
ITEM.Weight = 1.5

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

function ITEM:OnUse(ply, target)
	local sid = ply:SteamID()
	ply:SetHunger(100)
	timer.Create(sid .. "wellfed", 900, 0, function() 
		timer.Remove(sid .. "wellfed")
	end)
	ply:Notify("You have consumed a meal, you are now well fed and no longer have to eat for 15 minutes.")

	return true
end

impulse.RegisterItem(ITEM)
