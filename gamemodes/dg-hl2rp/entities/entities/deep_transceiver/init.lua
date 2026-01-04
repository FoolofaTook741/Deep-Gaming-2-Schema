AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_lab/teleportframe.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Working = false
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local NPCTable = {
"Gonarch",
"Ichthyosaur",
"Gonome",
"Frostsquid",
"Devilsquid",
"Mr Friendly",
"Panthereye",
"Poisonsquid",
"Pit Drone",
"Pit Worm",
"Voltigore",
"Gargantua"
}

function ENT:Use( activator, caller )
	if self.Working == true then
		activator:Notify("The transceiver is already working, please wait.")
		return
	end
	local ply = activator
	if (activator:Team() == TEAM_CW or activator:Team() == TEAM_VORT) and activator:GetTeamClass() == CLASS_RESEARCH then
		if activator:HasInventoryItem("research_xencore") then
			local chance = math.random(1,100)
			self.Working = true
			activator:EmitSound("vehicles/crane/crane_startengine1.wav")
			activator:TakeInventoryItem("research_xencore")
			timer.Simple(30, function()
				activator:StopSound("vehicles/crane/crane_startengine1.wav")
				if chance < 60 then
					activator:EmitSound("vehicles/crane/crane_extend_stop.wav")
					activator:Notify("The transceiver failed to make a connection.")
					self.Working = false
				elseif chance < 70 then
					SpawnXeNPC("Baby Headcrab", self:GetPos())
					activator:Notify("The transceiver sucessfully made a connection!")
					self.Working = false
				elseif chance <	80 then
					SpawnXeNPC("Houndeye", self:GetPos())
					activator:Notify("The transceiver sucessfully made a connection!")
					self.Working = false
				elseif chance < 90 then
					SpawnXeNPC("Chumtoad", self:GetPos())
					activator:Notify("The transceiver sucessfully made a connection!")
					self.Working = false
				elseif chance < 99 then
					SpawnXeNPC("Bullsquid", self:GetPos())
					activator:Notify("The transceiver sucessfully made a connection!")
					self.Working = false
				elseif Curtime() > impulse.NextXenPocalypse then
					XenPocalypse(activator, transceiver)
					activator:Notify("Something has gone terribly wrong...")
					impulse.NextXenPocalypse = CurTime() + 9000
				else
					activator:EmitSound("vehicles/crane/crane_extend_stop.wav")
					activator:Notify("The transceiver failed to make a connection.")
				end
			end)
		end
	else
		activator:Notify("You cannot use this on your current team.")
	end
    return
end

function XenPocalypse(ply, transceiver)
	transceiver:EmitSound("hl1/ambience/alien_cycletone.wav")
	transceiver:EmitSound("hl1/ambience/labdrone2.wav")
	timer.Simple(6, function()
		transceiver:EmitSound("hl1/ambience/particle_suck2.wav")
	end)
	timer.Simple(130, function()
		transceiver:StopSound("hl1/ambience/alien_cycletone.wav")
		transceiver:StopSound("hl1/ambience/labdrone2.wav")
		ply:Notify("The transceiver powers down.")
	end)
	net.Start("DeepPlaySound")
    net.WriteString("music/hl1_song14.mp3")
    net.WriteUInt(15, 10)
    net.Broadcast()
	timer.Simple(20, function() 
		timer.Create("XenPocalypse", 15, 8, function()
			for k,v in pairs(impulse.Config.XenPocalypse) do 
				local class = table.Random(NPCTable)
				SpawnXeNPC(class, v)
			end
		end)
	end)
	timer.Simple(200, function()
		ply:Notify("The transceiver is now ready again.")
		transceiver.Working = false
	end)
end

function SpawnXeNPC(class, transpos)
	local pos = transpos + Vector(0, 0, 50)
	--local crabmodel
	local mob = ents.Create(class)   
	mob:SetPos(pos)
	mob:Spawn()
	mob:MoveStart()
	mob:EmitSound("ambient/energy/whiteflash.wav")
	for k,v in pairs(player.GetAll()) do
		mob:SetTarget( v )
		break
	end
end

