local ITEM = {}

ITEM.UniqueID = "item_suemp"
ITEM.Name = "Flimsy EMP Device"
ITEM.Desc =  "A low charge EMP device, breaks after 1 failed attempt."
ITEM.Category = "Tools"
ITEM.Model = Model("models/weapons/w_emptool.mdl")
ITEM.FOV = 29.113180515759
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 0.6

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = false
ITEM.ConfiscateReward = 30

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Overloading..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "ambient/energy/weld1.wav"

function ITEM:OnUse(ply, door)
	local id = door:GetCreationID()
	local chance = math.random(1, 10)
	local pos = door:GetPos() + Vector(-20, 0, 0)
	local duration = 45
	local ent = door

	if chance < 3 then
		ply:EmitSound("ambient/energy/zap1.wav")
		ply:Notify("The EMP attempt failed.")
		return true
	end
	if door:IsDoor() then
		door:Fire("open")
		ply:EmitSound("buttons/combine_button1.wav")
		ply:Notify("You have successfully overloaded the door.")
	elseif door:GetClass() == "impulse_hl2rp_rationmachine" && !timer.Exists("rationhackcooldown") then
		if GetPlayerCount() >= 25 and GetCPCount() >= 6 and GetCombineCount() >= 8 then
			ply:AchievementGive("ach_rationraid")
			for v,k in pairs(team.GetPlayers(TEAM_CP)) do
				timer.Simple(0.5, function()
					k:EmitSound("npc/overwatch/radiovoice/attention.wav")
					k:SendCombineMessage("INCOMING TRANSMISSION FROM DISPATCH...", Color(255, 50, 0))
				end)
				timer.Simple(2, function()
					k:SendCombineMessage("ATTENTION: RATION DISTRIBUTION TERMINAL COMPROMISED AT LOCATION", Color(255, 50, 0))
					k:EmitSound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
					local pos = door:GetPos()
					net.Start("DeepEMPMessage")
					net.WriteVector(pos)
					net.WriteUInt(1, 8)
					net.Broadcast()
				end)
			end
			ply:Notify("You have begun hacking the ration terminal. It will complete in 45 seconds.")
			door:EmitSound("ambient/alarms/alarm_citizen_loop1.wav")
			timer.Create(id .. "rationhack", duration, 1, function()
				door:StopSound("ambient/alarms/alarm_citizen_loop1.wav")
				timer.Remove(id .. "rationhack")
			end)
			timer.Create("rhackspawn1", duration + 0.5, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn1")
			end)
			timer.Create("rhackspawn2", duration + 1, 1, function() 
				impulse.Inventory.SpawnItem("card_vort", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn2")
			end)
			timer.Create("rhackspawn3", duration + 1.5, 1, function()  
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn3")
			end)
			timer.Create("rhackspawn4", duration + 2, 1, function() 
				impulse.Inventory.SpawnItem("card_ca", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn4")
			end)
			timer.Create("rhackspawn5", duration + 2.5, 1, function() 
				impulse.Inventory.SpawnItem("food_applepie", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn5")
			end)
			timer.Create("rhackspawn6", duration + 3, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn6")
			end)
			timer.Create("rhackspawn7", duration + 3.5, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn7")
			end)
			timer.Create("rhackspawn8", duration + 4, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn8")
			end)
			timer.Create("rhackspawn9", duration + 4.5, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn9")
			end)
			timer.Create("rhackspawn10", duration + 5.0, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn10")
			end)
			timer.Create("rhackspawn11", duration + 6.0, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn11")
			end)
			timer.Create("rhackspawn12", duration + 6.5, 1, function() 
				impulse.Inventory.SpawnItem("card_civ", pos) 
				door:EmitSound("buttons/button14.wav")
				timer.Remove("rhackspawn12")
			end)
			timer.Create("rationhackcooldown", 1800, 1, function()
				timer.Remove("rationhackcooldown")
			end)
		else
			ply:EmitSound("ambient/energy/zap1.wav")
			ply:Notify("A ration raid requires at least 25 players online, including 6 MPF and a total of 8 Combine members (OCA, OTA, MPF).")
		end
	elseif door:GetClass() == "impulse_hl2rp_rationmachine" && timer.Exists("rationhackcooldown") then
		ply:Notify("A ration center has recently been raided. You can raid again in: " .. math.floor(timer.TimeLeft("rationhackcooldown")) .. " seconds.")
	elseif ent:GetClass() == "autoturret" and ent.Allegiance == "Combine" then
		if chance > 5 then
			ply:EmitSound("buttons/combine_button1.wav")
			ply:GiveInventoryItem("item_autoturret", 1)
			ply:Notify("You have successfully disabled and taken the Automatic Turret.")
			ent:Remove()
		else
			ply:EmitSound("ambient/energy/zap1.wav")
			ply:Notify("The EMP attempt failed.")
            return true
		end
	elseif ent:GetClass() == "impulse_hl2rp_terminal" then
		if chance > 5 then
			ply:EmitSound("buttons/combine_button1.wav")
			ply:Notify("You have successfully disabled the Combine Terminal.")
			ent.Emped = true
			timer.Simple(60, function()
				for k,v in pairs(team.GetPlayers(TEAM_CP)) do
					if v:GetTeamClass() == CLASS_GRID then
						v:SendCombineWaypoint(message,ent:GetPos(),60,6,8,ply)
					end
				end
			end)
			timer.Simple(900, function()
				if ent.Emped == true then
					ent.Emped = false
				end
			end)
		else
			ply:EmitSound("ambient/energy/zap1.wav")
			ply:Notify("The EMP attempt failed.")
            return true
		end
	elseif ent:GetClass() == "deep_forcefield" or ent:GetClass() == "deep_forcefield_small" then
	    ent.Active = false
	    ent.EMPd = true
	    ent.EMPdTime = CurTime()
	    ply:EmitSound("buttons/combine_button1.wav")
	    ply:Notify("You have successfully disabled the Combine Forcefield.")
	    ply:AddSkillXP("metabolism", math.random(10,30))
	else
		if impulse.CommsNetWorkOn == true && !timer.Exists("emphackcooldown") then
			if (GetPlayerCount() >= 20 and GetCPCount() >= 4 and GetCombineCount() >= 6 ) or ply:IsSuperAdmin() then
				ply:Notify("You have successfully disabled the Combine comms network.")
				impulse.CommsNetWorkOn = false
				for k, v in pairs(player.GetAll()) do
					if v:IsCP() then
						timer.Simple(0.5, function()
							v:EmitSound("npc/overwatch/radiovoice/attention.wav")
						end)
						timer.Simple(2, function()
							v:SendCombineMessage("COMBINE COMMS NETWORK ERROR, SEND REPAIR TEAM IMMEDIATELY", Color(150, 150, 0))
							v:EmitSound("npc/overwatch/radiovoice/reinforcementteamscode3.wav")
						end)
					end
				end
				timer.Simple(2, function()  
					local pos = door:GetPos()
					net.Start("DeepEMPMessage")
					net.WriteVector(pos)
					net.WriteUInt(2, 8)
					net.Broadcast()
				end)
				timer.Create("emphackcooldown", 900, 1, function()
					timer.Remove("emphackcooldown")
				end)
				ply:AchievementGive("ach_blackout")
			else
				ply:Notify("There must be 20 players, 4 CPs, and 6 Combine online.")
			end
		else
			ply:Notify("The comms network is already offline.")
		end
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return (ent:GetClass() == "func_door" and (ent:GetSyncVar(SYNC_DOOR_GROUP) >= 2)) or ent:GetClass() == "deep_commsuplink" or ent:GetClass() == "impulse_hl2rp_rationmachine" or ent:GetClass() == "autoturret" or ent:GetClass() == "impulse_hl2rp_terminal" or ent:GetClass() == "deep_forcefield" or ent:GetClass() == "deep_forcefield_small"
end

impulse.RegisterItem(ITEM)
