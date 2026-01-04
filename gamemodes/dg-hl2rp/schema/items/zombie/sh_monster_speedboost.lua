local ITEM = {}

ITEM.UniqueID = "monster_speedboost"
ITEM.Name = "Ability: Speed Boost"
ITEM.Desc =  "Speed is key in the land of the living!"
ITEM.Category = "Monsters"
ITEM.Model = Model("models/zombie/classic_legs.mdl")
ITEM.FOV = 7.8252148997135
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Colour = Color(75, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 30

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Speed Boost"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Boosting..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "impulse/eat.wav"
 
function ITEM:OnUse(ply)
	local sid = ply:SteamID()
	if !timer.Exists(sid .. "speedcooldown") then
		timer.Create(sid .. "speedcooldown", 180, 1, function() timer.Remove(sid .. "speedcooldown") end)
		ply:SetRunSpeed(290)
		ply:Notify("Your speed has increased for 90 seconds.")
		timer.Simple(90, function()
			if ply:Team() == TEAM_ZOMBIE && ply:GetModel() == "models/player/fast_zombie.mdl" then
				ply:SetRunSpeed(240)
				ply:Notify("Your speed boost has worn off.")
			end
		end)
	else
		ply:Notify("You must wait " .. math.floor(timer.TimeLeft(sid .. "speedcooldown")) .. " seconds before using this again.")
	end
	return false
end

impulse.RegisterItem(ITEM)
