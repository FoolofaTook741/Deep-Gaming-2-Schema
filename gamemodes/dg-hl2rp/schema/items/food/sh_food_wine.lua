local ITEM = {}

ITEM.UniqueID = "food_wine"
ITEM.Name = "Red Wine"
ITEM.Desc =  "A rich red wine to compliment any meal. Perhaps it is time to invite the friends over for a pasta dinner?"
ITEM.Category = "Food"
ITEM.Model = Model("models/foodnhouseholditems/wine_red3.mdl")
ITEM.FOV = 45
ITEM.Weight = 2
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 10
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.CraftTime = 0.2

ITEM.Food = 5

function ITEM:OnUse(ply)
    local id = ply:SteamID()
	local timerName = id.."winebuff"
	ply.winebuffed = true
	
	timer.Remove(timerName)
    timer.Create(timerName, 120, 1, function() 
		if IsValid(ply) then
			ply.winebuffed = false
			ply:Notify("Your slight buzz from wine has worn off.")
		end
    end)
    ply:Notify("The wine gives you a slight buzz, impacts feel less painful. [10% reduction of damage].")
    return true
end

impulse.RegisterItem(ITEM)
