AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 


function ENT:Use( activator, caller )
	local sid = activator:SteamID()
    if activator:Team() == TEAM_EXPLORER && !timer.Exists(sid .. "dispenserycooldown") then
		self:EmitSound("buttons/button1.wav")
		activator:GiveInventoryItem("food_water")
		activator:GiveInventoryItem("food_tomato")
		activator:GiveMoney(75)
		activator:Notify("You have received some food and 75 coins from the M.E.G. dispensery.")
		timer.Create(sid .. "dispenserycooldown", 1800, 0, function() timer.Remove(sid .. "dispenserycooldown") end)
	elseif activator:Team() == TEAM_BCW && !timer.Exists(sid .. "dispenserycooldown") then
		local bcwmult = 1.0 + (activator:GetTeamRank() / 5)
		self:EmitSound("buttons/button1.wav")
		activator:GiveInventoryItem("food_cannedham")
		activator:GiveInventoryItem("food_sodapop")
		activator:GiveMoney(125 * bcwmult)
		activator:Notify("You have received some food and 75 coins from the M.E.G. dispensery.")
		timer.Create(sid .. "dispenserycooldown", 1800, 0, function() timer.Remove(sid .. "dispenserycooldown") end)
	elseif activator:Team() == TEAM_CP && !timer.Exists(sid .. "dispenserycooldown") then
		activator:GiveInventoryItem("food_mre")
		activator:GiveInventoryItem("food_sodapop")
		activator:Notify("You have received some food and 200 coins from the M.E.G. dispensery.")
		activator:GiveMoney(200)
		self:EmitSound("buttons/button1.wav")
		timer.Create(sid .. "dispenserycooldown", 1800, 0, function() timer.Remove(sid .. "dispenserycooldown") end)
	elseif activator:Team() == TEAM_RAIDER then
		activator:Notify("The M.E.G. does not feed terrorists.")
		self:EmitSound("buttons/button8.wav")
	elseif timer.Exists(sid .. "dispenserycooldown") && (activator:Team() == TEAM_EXPLORER or activator:Team() == TEAM_BCW or activator:Team() == TEAM_CP) then
		local durationleft = math.Round(timer.TimeLeft(sid .. "dispenserycooldown"), 0)
		activator:Notify("You must wait " .. durationleft .. " seconds until you can get more food.")
		self:EmitSound("buttons/button8.wav")
	else
		self:EmitSound("buttons/button8.wav")
		activator:Notify("Your team cannot interact with this object.")
	end
    return
end