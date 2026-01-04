AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_lab/plotter.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.finished = false
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end


function ENT:Use( activator, caller )
	local chance = math.random(1, 100)
	local id = self:GetCreationID()
	local ammo
	local droppos = self:GetPos() + Vector(0, 0, 50)
	local players
	local selfpos = self:GetPos()
	local outlets = 0
	local generators = 0
    if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if self.finished == true then
			local amount = math.random(2,4)
			local beeb = 0
			while beeb < amount do
				activator:GiveInventoryItem("util_resin", 1)
				activator:Notify("You have received " .. amount .." containers of resin.")
				beeb = beeb + 1
			end
			self.finished = false
		elseif timer.Exists(id .. "recycler") then
			activator:Notify("The recycler is already working.")
		elseif not activator:HasInventoryItem("util_plastic") then
			activator:Notify("You need to input 1 plastic.")
		elseif activator:HasInventoryItem("util_plastic") then
			if not timer.Exists(id .. "recycler") then
				for k, v in pairs(ents.FindByClass("deep_outlet")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 then
						outlets = 1
					end
				end
				for k, v in pairs(ents.FindByClass("deep_generator")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 and v.powered then
						generators = 1
					end
				end
				if outlets >= 1 or generators >= 1 then
					activator:Notify("Recycling process underway, return in 45 seconds.")
					self:EmitSound("ambient/machines/spinup.wav")
					timer.Simple(2, function() self:EmitSound("ambient/machines/spin_loop.wav") end)
					activator:TakeInventoryItemClass("util_plastic")
					timer.Create(id .. "recycler", 45, 1, function()
						self:EmitSound("ambient/machines/spindown.wav")
						self:StopSound("ambient/machines/spin_loop.wav")
						activator:Notify("Recycling complete, press E on the machine to collect!")
						timer.Remove(id .. "recycler")
						self.finished = true
					end)
				else
					activator:Notify("The recycler requires electricity.")
				end
			else
				activator:Notify("The recycler is already active.")
			end
		end	
	else
		activator:Notify("You cannot interact with this item.")
	end
    return
end

function ENT:OnRemove()
	RECYCLER_COUNT = math.max((RECYCLER_COUNT or 0) - 1, 0)
	if self:GetOwner() then
		self:GetOwner().RecyclerCount = self:GetOwner().RecyclerCount - 1
	end
end 