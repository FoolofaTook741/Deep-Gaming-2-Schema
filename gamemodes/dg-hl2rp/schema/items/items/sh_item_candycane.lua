local ITEM = {}

ITEM.UniqueID = "item_candycane"
ITEM.Name = "Candy Cane"
ITEM.Desc =  "A red and white curved rod, filled with sugar."
ITEM.Category = "Christmas"
ITEM.Model = Model("models/griim/foodpack/candycane.mdl")
ITEM.FOV = 25
ITEM.CamPos = Vector(100, 100, 0)
ITEM.Colour = Color(255, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

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
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:OnUse(ply, target)
	ply:SetHealth(math.Clamp(ply:Health() + math.random(5,10), 0, ply:GetMaxHealth()))
	
	if ply:HasBrokenLegs() then
		ply:FixLegs()
		ply:Notify("Your broken legs have healed.")
	else
		ply:Notify("You have eaten the candy.")
	end

	return true
end

impulse.RegisterItem(ITEM)
