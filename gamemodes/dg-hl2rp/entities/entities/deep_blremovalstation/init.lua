AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()

	self:SetModel( "models/props_c17/TrapPropeller_Engine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox

        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end


function ENT:Use( activator, caller )
	local id = self:GetCreationID()
	local ammo
	local droppos = self:GetPos() + Vector(0, 0, 25)
	local players
	local selfpos = self:GetPos()
	local outlets = 0
	local generators = 0
    if activator:Team() == TEAM_CITIZEN then
		if timer.Exists(id .. "blstation") then
			activator:Notify("The Refinery is already working.")
		elseif !activator:HasInventoryItem("item_emp") then
			activator:Notify("You need an EMP device to use alongside the power outlet to use this device.")
		elseif !activator:HasInventoryItem("bl_apf") and !activator:HasInventoryItem("bl_osiprmk1") and !activator:HasInventoryItem("bl_omr") and !activator:HasInventoryItem("bl_ar2") and !activator:HasInventoryItem("bl_osr") and !activator:HasInventoryItem("bl_ar2e") then
			activator:Notify("You need a biolinked weapon to use this device.")
		elseif activator:HasInventoryItem("bl_apf") or activator:HasInventoryItem("bl_osiprmk1") or activator:HasInventoryItem("bl_omr") or activator:HasInventoryItem("bl_ar2") or activator:HasInventoryItem("bl_osr") or activator:HasInventoryItem("bl_ar2e") then
			if GetPlayerCount() < 1 then
				activator:Notify("There are not enough players to use this machine. (15 minimum).")
			else
				for k, v in pairs(ents.FindByClass("deep_outlet")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 then
						outlets = 1
					end
				end
				for k, v in pairs(ents.FindByClass("deep_generator")) do
					local dist = selfpos:Distance(v:GetPos())
					if dist < 300 && v.powered == true then
						generators = 1
					end
				end
				if (outlets >= 1 or generators >= 1) && !timer.Exists(id .. "blstation") then
					local empchance = math.random(1,20)
					activator:Notify("Unlinking weapon, return in 30 seconds.")
					self:EmitSound("physics/metal/metal_canister_impact_soft2.wav")
					timer.Simple(2, function() self:EmitSound("ambient/machines/combine_shield_touch_loop1.wav") end)
					if activator:HasInventoryItem("bl_apf") then
						if empchance >= 18 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_apf")
						ammo = "wep_apf"
						timer.Create(id .. "blstation", 30, 1, function()
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					elseif activator:HasInventoryItem("bl_osiprmk1") then
						if empchance >= 3 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_osiprmk1")
						ammo = "wep_osiprmk1"
						timer.Create(id .. "blstation", 30, 1, function()
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					elseif activator:HasInventoryItem("bl_omr") then
						if empchance >= 18 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_omr")
						timer.Create(id .. "blstation", 30, 1, function()
							ammo = "wep_omr"
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					elseif activator:HasInventoryItem("bl_osr") then
						if empchance >= 18 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_osr")
						timer.Create(id .. "blstation", 30, 1, function()
							ammo = "wep_osr"
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					elseif activator:HasInventoryItem("bl_ar2") then
						if empchance >= 18 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_ar2")
						timer.Create(id .. "blstation", 30, 1, function()
							ammo = "wep_ar2"
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					elseif activator:HasInventoryItem("bl_ar2e") then
						if empchance >= 8 then
							activator:TakeInventoryItemClass("item_emp")
							activator:Notify("The EMP Tool broke.")
						end
						activator:TakeInventoryItemClass("bl_ar2e")
						timer.Create(id .. "blstation", 30, 1, function()
							ammo = "wep_ar2e"
							impulse.Inventory.SpawnItem(ammo, droppos)
							impulse.Inventory.SpawnItem("util_combinescrap", droppos)
							activator:Notify("Biolink complete!")
							self:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
							timer.Remove(id .. "blstation")
						end)
					end
				end
			end
		end
	else
		activator:Notify("You cannot interact with this item.")
	end
    return
end