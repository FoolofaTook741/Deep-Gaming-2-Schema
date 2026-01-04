AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Items/item_item_crate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 


function ENT:Use( activator, caller )
    if activator:Team() == TEAM_EXPLORER then
		local cid = self:GetCreationID()
		local cops = 0
		for k,v in pairs(player.GetAll()) do
			if v:Team() == TEAM_CP then
				cops = cops + 1
			end
		end
		if cops > 2 && activator:Team() == TEAM_EXPLORER && activator:HasInventoryItem("item_lockpick") && !timer.Exists(cid .. "lockboxcd") then
			local breakchance = math.random(1,13)
			if breakchance + activator:GetSkillLevel("lockpick") < 10 then
				local chancea = math.random(1,100)
				local chanceb = 0
				local SpawnPos = self:GetPos() + Vector(0,0,25)
				if chancea < 20 then
					chanceb = 1
				elseif chancea >= 20 and chancea <= 35 then
					chanceb = 2
				elseif chancea >= 36 and chancea <= 45 then
					chanceb = 3
				elseif chancea >= 46 && chancea <= 52 then
					chanceb = 4
				elseif chancea >= 53 && chancea <= 60 then
					chanceb = 5
				elseif chancea >= 61 && chancea <= 69 then
					chanceb = 6
				elseif chancea >= 70 && chancea <= 75 then
					chanceb = 7
				elseif chancea >= 76 && chancea <= 82 then
					chanceb = 8
				elseif chancea >= 83 && chancea <= 90 then
					chanceb = 9
				elseif chancea >= 91 && chancea <= 94 then
					chanceb = 10
				else
					chanceb = 11
				end
				local drops = {"ammo_pistol", "ammo_smg", "drop_p250", "wep_stunstick", "wep_m9", "ammo_rifle", "drop_mp5", "item_heavyvest", "item_cleaver", "wep_mp5k", "wep_handgun"}
				impulse.Inventory.SpawnItem(drops[chanceb], SpawnPos, 120)
				timer.Create(cid .. "lockboxcd", 900, 0, function() timer.Remove(cid .. "lockboxcd") end)
				activator:Notify("You break open the lockbox, an item pops out.")
				activator:Say("/me breaks open a lockbox.")
			else
				activator:TakeInventoryItem("item_lockpick")
				activator:Notify("The lockpick broke.")
			end
			for k, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP then
					v:EmitSound("buttons/button14.wav")
					v:SendCombineMessage("LOCKBOX TAMPERING DETECTED - TARGET: " .. activator:Name(), Color(255, 0, 0))
				end
				impulse.AddCombineWaypoint("ILLEGAL ACTIVITY", self:GetPos(), 90, 2, 9, 9, "LOCKBOX")
			end
		elseif cops <= 2 && activator:Team() == TEAM_EXPLORER && activator:HasInventoryItem("item_lockpick") && !timer.Exists(cid .. "lockboxcd") then
			activator:Notify("There must be at least 3 BIF Operatives active to steal from the lockboxes.")
		elseif cops > 2 && activator:Team() == TEAM_EXPLORER && !activator:HasInventoryItem("item_lockpick") && !timer.Exists(cid .. "lockboxcd") then
			activator:Notify("You need a lockpick to steal from the lockboxes.")
		elseif activator:Team() == TEAM_EXPLORER && activator:HasInventoryItem("item_lockpick") && timer.Exists(cid .. "lockboxcd") then
			local timeleft = math.floor(timer.TimeLeft(cid .. "lockboxcd"))
			activator:Notify("This lockbox is on cooldown for " .. timeleft .. " seconds.")
		elseif activator:Team() != TEAM_EXPLORER then
			activator:Notify("You must be an explorer with a lockpick to steal from the lockboxes.")
		else
			activator:Notify("You cannot interact with this item.")
		end
    end
    return
end