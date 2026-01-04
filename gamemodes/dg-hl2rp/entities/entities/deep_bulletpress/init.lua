AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end


function ENT:Use( activator, caller )
	local chance = math.random(1, 100)
	local id = self:GetCreationID()
	local ammo
	local droppos = self:GetPos() + Vector(0, 0, 25)
	local players
	local pos = self:GetPos()
	local outlets = 0
	local generators = 0
    if activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU then
		if timer.Exists(id .. "ammopress") then
			activator:Notify("The Bullet Press is already working.")
		elseif GetPlayerCount() < 10 then
			activator:Notify("There are not enough players to use this machine. (10 minimum)")
		elseif !activator:HasInventoryItem("util_bulletcasing") or !activator:HasInventoryItem("util_gunpowder") then
			activator:Notify("You need 1 bullet casing and 1 gunpowder to use the machine.")
		elseif activator:HasInventoryItem("util_bulletcasing") and activator:HasInventoryItem("util_gunpowder") then
			activator:AchievementGive("ach_ammosmith")
			for k, v in pairs(ents.FindByClass("deep_outlet")) do
				local dist = pos:Distance(v:GetPos())
				if dist < 300 then
					outlets = 1
				end
			end
			for k, v in pairs(ents.FindByClass("deep_generator")) do
				local dist = pos:Distance(v:GetPos())
				if dist < 300 && v.powered == true then
					generators = 1
				end
			end
			if (generators == 1 or outlets == 1) && !timer.Exists(id .. "ammopress") then
				activator:TakeInventoryItemClass("util_bulletcasing")
				activator:TakeInventoryItemClass("util_gunpowder")
				activator:Notify("The bullet press has started production.")
				self:EmitSound("ambient/machines/spinup.wav")
				timer.Create(id .. "ammopress", 90, 1, function()
					activator:Notify("Your bullet press has completed production!")
					if chance < 33 then
						ammo = "ammo_pistol"
					elseif chance < 45 then
						ammo = "ammo_deagle"
					elseif chance < 60 then
						ammo = "ammo_smg"
					elseif chance < 70 then
						ammo = "ammo_buckshot"
					elseif chance < 80 then
						ammo = "ammo_357"
					elseif chance < 90 then
						ammo = "ammo_rifle"
					else
						ammo = "ammo_54r"
					end
					impulse.Inventory.SpawnItem(ammo, droppos)
					timer.Remove(id .. "ammopress")
					self:EmitSound("buttons/button17.wav")
				end)
			end
		else
			activator:Notify("A nearby power outlet is required. Power is readily available in some buildings in the city or the outlands.")
		end
	else
		activator:Notify("You cannot interact with this item.")
	end
    return
end

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end

    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end

    owner.BPCount = math.max((owner.BPCount or 1) - 1, 0)
end