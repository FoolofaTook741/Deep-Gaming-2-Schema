impulse.DefineSetting("misc_cameranotifyduration", {name="Camera notify duration", category="Misc", type="slider", default=45, minValue=20, maxValue=140})
impulse.DefineSetting("misc_cameranotifymax", {name="Camera notify max", category="Misc", type="slider", default=3, minValue=1, maxValue=6})

net.Receive("impulseHL2RPCivilUnrestStart", function()
	surface.PlaySound("npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav")
end)

CAM_NOTIFICAITONS = CAM_NOTIFICAITONS or 0

net.Receive("DeepEMPMessage", function() 
	if LocalPlayer():IsCP() then
		local pos = net.ReadVector()
		local emptype = net.ReadUInt(8)

		if emptype == 1 then
			impulse.AddCombineWaypoint("RATION TERMINAL COMPROMISED", pos, 120, 5, 9, 9)
		else
			impulse.AddCombineWaypoint("COMMS NETWORK OFFLINE", pos, 120, 4, 8, 8)
		end
	end
end)

net.Receive("Deep_AirSupport_Marker", function()
    local pos = net.ReadVector()
    impulse.AddCombineWaypoint("AIR SUPPORT REQUEST", pos, 180, 8, 12, 12)
end)

net.Receive("impulseHL2RPCameraAlert", function()
	local pos = net.ReadVector()
	local camid = net.ReadUInt(8)
	local crime = net.ReadUInt(8)
	local ply = net.ReadEntity()
	local duration = impulse.GetSetting("misc_cameranotifyduration")
	local max = impulse.GetSetting("misc_cameranotifymax")
	local col = nil

	if crime == CRIME_BOL then
		col = 3
		surface.PlaySound("npc/overwatch/radiovoice/allteamsrespondcode3.wav")
	elseif crime == CRIME_WEAPON then
		col = 4
	elseif CAM_NOTIFICAITONS >= max then
		return
	end

	local citizen = ply

	if crime == CRIME_EVASION then
		citizen = nil
	end

	impulse.AddCombineWaypoint("CAM-"..camid.." ("..CRIME_NICENAMES[crime]..")" .. " - " .. citizen:Name(), pos, duration, 7, col, 4)

	CAM_NOTIFICAITONS = CAM_NOTIFICAITONS + 1

	timer.Simple(duration, function()
		CAM_NOTIFICAITONS = CAM_NOTIFICAITONS - 1
	end)
end)

net.Receive("impulseHL2RPCameraBroken", function()
	local camera = net.ReadEntity()
	local camid = net.ReadUInt(8)

	if not IsValid(camera) then
		return
	end

	if camera:IsCameraEnabled() then
		return
	end

	surface.PlaySound("npc/overwatch/radiovoice/investigateandreport.wav")
	LocalPlayer():SendCombineMessage("CAM-"..camid.." REQUIRES IMMEDIATE SERVICE", Color(150, 154, 158))
	impulse.AddCombineWaypoint("CAM-"..camid.." REQUIRES SERVICE", camera:GetPos(), 100, 7, 5, 900)
end)

net.Receive("impulseHL2RPAmmoRaid", function()
	local box = net.ReadVector()
	local add = 0.1
	timer.Simple(add, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.8 + add, function()
		surface.PlaySound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
	end)
	timer.Simple(add, function()
		LocalPlayer():SendCombineMessage("HIGH PRIORITY TRANSMISSION INBOUND...", Color(139, 0, 0))
	end)
	timer.Simple(1 + add, function()
		LocalPlayer():SendCombineMessage("RESTRICTED INCURSION IN PROGRESS", Color(139, 0, 0))
		impulse.AddCombineWaypoint("PRIORITY INCURSION", box, impulse.Config.AmmoDrillTime, 6, 4, 4)
	end)
end)

net.Receive("DeepPWCRaid", function()
	local box = net.ReadVector()
	local add = 0.1
	timer.Simple(add, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.8 + add, function()
		surface.PlaySound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
	end)
	timer.Simple(add, function()
		LocalPlayer():SendCombineMessage("HIGH PRIORITY TRANSMISSION INBOUND...", Color(200, 0, 0))
	end)
	timer.Simple(1 + add, function()
		LocalPlayer():SendCombineMessage("PROXIMITY SENSOR TRIGGERED NEAR CONFISCATION STOCKPILE", Color(200, 0, 0))
		impulse.AddCombineWaypoint("STOCKPILE ALARM TRIGGERED", box, impulse.Config.PreWarCacheTime, 6, 4, 4)
	end)
end)

net.Receive("DeepMPFCRaid", function()
	local box = net.ReadVector()
	local add = 0.1
	timer.Simple(add, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.8 + add, function()
		surface.PlaySound("npc/overwatch/radiovoice/restrictedincursioninprogress.wav")
	end)
	timer.Simple(add, function()
		LocalPlayer():SendCombineMessage("HIGH PRIORITY TRANSMISSION INBOUND...", Color(200, 0, 0))
	end)
	timer.Simple(1 + add, function()
		LocalPlayer():SendCombineMessage("PROXIMITY SENSOR TRIGGERED NEAR CIVIL PROTECTION STOCKPILE", Color(200, 0, 0))
		impulse.AddCombineWaypoint("STOCKPILE ALARM TRIGGERED", box, impulse.Config.MPFCacheTime, 6, 4, 4)
	end)
end)

local squadWaypointCol = Color(75, 155, 45, 100)
net.Receive("impulseSquadDoReinforce", function()
	local squad = net.ReadUInt(8)
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/reinforcementteamscode3.wav")

	local n = LocalPlayer():Team() == TEAM_CP and "PT" or "SQUAD"
	LocalPlayer():SendCombineMessage(n.." "..squad.." REQUESTING REINFORCEMENT", squadWaypointCol)
	impulse.AddCombineWaypoint(n.." "..squad.." REINFORCEMENT", pos, 60, 5, 2, 2)
end)

net.Receive("impulseSquadDoOrder", function()
	local text = net.ReadString()

	LocalPlayer():SendCombineMessage("NEW SQUAD OBJECTIVE:", squadWaypointCol)
	LocalPlayer():SendCombineMessage(text, squadWaypointCol)
end)

net.Receive("impulseSquadDoBlockInspection", function()
	local blockName = net.ReadString()
	local pos = net.ReadVector()

	surface.PlaySound("npc/overwatch/radiovoice/attention.wav")

	timer.Simple(0.7, function()
		surface.PlaySound("npc/overwatch/radiovoice/search.wav")

		timer.Simple(0.7, function()
			surface.PlaySound("npc/overwatch/radiovoice/block.wav")
		end)
	end)

	LocalPlayer():SendCombineMessage("SEARCH PROPERTY - "..string.upper(blockName), squadWaypointCol)
	impulse.AddCombineWaypoint("SEARCH PROPERTY ("..string.upper(blockName)..")", pos, 120, 4, 2, 2)
end)

net.Receive("impulseHL2RPMedicCallRec", function()
	local caller = net.ReadEntity()

	if not IsValid(caller) then
		return
	end

	impulse.AddCombineMessage("MEDICAL ATTENTION REQUESTED FROM "..caller:Nick(), Color(168, 50, 76))
	impulse.AddCombineWaypoint("MEDICAL ATTENTION REQUESTED", caller:GetPos(), 65, 3, 5, 5, caller)
end)

net.Receive("impulseHL2RPObjectiveSend", function()
	local sender = net.ReadEntity()
	local order = net.ReadString():upper()
	
	if not IsValid(sender) then
		return
	end

	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM "..sender:Nick(), Color(255, 100, 0))
	impulse.AddCombineMessage(order, Color(255, 100, 0))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick()
	}
end)

net.Receive("deepGamingOTAObjSend", function()
	local sender = net.ReadEntity()
	local order = net.ReadString():upper()
	
	if not IsValid(sender) then
		return
	end

	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM "..sender:Nick(), Color(255, 0, 0))
	impulse.AddCombineMessage(order, Color(255, 0, 0))

	CP_OBJECTIVE = {
		message = order,
		localteamobj = true,
		endTime = CurTime() + 20,
		sender = sender:Nick()
	}
end)

net.Receive("impulseHL2RPObjectiveSendEvent", function()
	local order = net.ReadString():upper()
	local length = net.ReadUInt(8)
	
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)

	impulse.AddCombineMessage("INCOMING OBJECTIVE FROM DISPATCH", Color(0, 107, 149))
	impulse.AddCombineMessage(order, Color(0, 107, 149))

	CP_OBJECTIVE = {
		message = order,
		endTime = CurTime() + length
	}
end)

net.Receive("impulseHL2RPCityCodeChange", function()
	local citycode = net.ReadUInt(4)

	if citycode < 2 then
		return
	end

	CP_OBJECTIVE = nil

	timer.Simple(1.5, function()
		CP_OBJECTIVE = {
			citycode = citycode,
			endTime = CurTime() + 30
		}
	end)
end)

net.Receive("deepgamingSacrificeCode", function()
	local sender = net.ReadEntity()
	local length = 12
	
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.5, function()
		surface.PlaySound("npc/overwatch/radiovoice/lockdownlocationsacrificecode.wav")
	end)
	timer.Simple(6.7, function()
		surface.PlaySound("npc/overwatch/radiovoice/serve.wav")
	end)
	local order = "SELF PRESERVATION IS NOW PROHIBITED. STORM - PROSECUTE - SERVE."
	impulse.AddCombineMessage("SACRIFICE CODE ACTIVATED BY ORDER OF "..sender:Nick(), Color(0, 147, 255))

	CP_OBJECTIVE = {
		saccode = true,
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick(),
	}
end)

net.Receive("DeepSquadOrderClient", function()
	local sender = net.ReadEntity()
	local order = net.ReadString()
	local length = 12
	local senderName = sender:Nick()
	local isDispatch = net.ReadBool()

	if isDispatch == true then
		senderName = "DISPATCH"
	end

	
	
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.5, function()
		surface.PlaySound("npc/overwatch/radiovoice/preparetoinnoculate.wav")
	end)
	impulse.AddCombineMessage("INCOMING ORDER FROM "..senderName .. ": " .. order, Color(10, 70, 0))

	CP_OBJECTIVE = {
		saccode = false,
		squadorder = true,
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick(),
	}
end)

net.Receive("deepPriorityOneBroadcast", function()
	local name = string.upper(net.ReadString())
	local sender = net.ReadEntity()
	local length = 15
	local order = name .. " HAS BEEN DESIGNATED ANTI-CITIZEN ONE. LOCATE AND CAPTURE IMMEDIATELY."
	surface.PlaySound("npc/metropolice/vo/off1.wav")
	timer.Simple(0.8, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(1.5, function()
		surface.PlaySound("npc/overwatch/radiovoice/suspectmalignantverdictcodeis.wav")
	end)
	timer.Simple(4.5, function()
		surface.PlaySound("npc/overwatch/radiovoice/terminalprosecution.wav")
	end)
	CP_OBJECTIVE = {
		saccode = false,
		squadorder = false,
		pos = true,
		message = order,
		endTime = CurTime() + 20,
		sender = sender:Nick(),
	}
end)


-- im too lazy to fix this fucking disaster

net.Receive("impulseHL2RPBioDeath", function(len, ply)
	if not IsValid(LocalPlayer()) then return end
	local unit = net.ReadUInt(8)
	local zone = net.ReadUInt(8)
	local rank = net.ReadUInt(8) or 0
	local team = net.ReadUInt(8) or 0
	local jammer = net.ReadBool()
	zone = impulse.Config.Zones[zone]
	unit = Entity(unit)
	if not IsValid(unit) then return end
	local zonename = string.upper(zone.name) or "404 ZONE"

	if zone == 255 then
		zonename = "404 ZONE"
	end

	if zone and unit and IsValid(unit) and unit:IsPlayer() and unit:IsCP() then
		if not zonename then
			zonename = "404 ZONE"
		end
		if jammer == true then
			zonename = "SIGNAL DISRUPTED"
		end
		
		if rank == RANK_CMD and team == TEAM_CP then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR MPF COMMANDER: "..unit:Name().. " | LOCATION: "..zonename, Color(50, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("COMMANDER GRADE UNIT KILLED", unit:GetPos(), 120, 3, 6, 6, unit)
			end
			timer.Simple(4, function() globalsound("ambient/alyx_alert.wav") end)
			timer.Simple(8, function() globalsound("ambient/alyx_alert.wav") end)
		elseif rank >= RANK_DVL and team == TEAM_CP then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR MPF COMMAND UNIT: "..unit:Name().. " | LOCATION: "..zonename, Color(150, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("HIGH COMMAND UNIT KILLED", unit:GetPos(), 120, 3, 4, 4, unit)
			end
		elseif rank == RANK_OSC and team == TEAM_OTA then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR TRANSHUMAN COMMANDER: "..unit:Name().. " | LOCATION: "..zonename, Color(50, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("COMMANDER GRADE UNIT KILLED", unit:GetPos(), 120, 3, 6, 6, unit)
			end
			timer.Simple(4, function() globalsound("ambient/alyx_alert.wav") end)
			timer.Simple(8, function() globalsound("ambient/alyx_alert.wav") end)
		elseif rank == RANK_EA and team == TEAM_CA then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR CITY ADMINISTRATOR: "..unit:Name().. " | LOCATION: "..zonename, Color(50, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("COMMANDER GRADE UNIT KILLED", unit:GetPos(), 120, 3, 6, 6, unit)
			end
			timer.Simple(4, function() globalsound("ambient/alyx_alert.wav") end)
			timer.Simple(8, function() globalsound("ambient/alyx_alert.wav") end)
		elseif rank >= RANK_EA and team == TEAM_CA then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR DEPUTY CITY ADMINISTRATOR: "..unit:Name().. " | LOCATION: "..zonename, Color(150, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("HIGH COMMAND UNIT KILLED", unit:GetPos(), 120, 3, 4, 4, unit)
			end
		elseif rank == RANK_ORD and team == TEAM_OTA then
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR ORDINAL GRADE UNIT: "..unit:Name().. " | LOCATION: "..zonename, Color(150, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("HIGH COMMAND UNIT KILLED", unit:GetPos(), 120, 3, 4, 4, unit)
			end
		else
			LocalPlayer():SendCombineMessage("LOST BIOSIGNAL FOR UNIT: "..unit:Name().. " | LOCATION: "..zonename, Color(255, 0, 0))
			if jammer != true then
				impulse.AddCombineWaypoint("BIOSIGNAL LOSS", unit:GetPos(), 120, 3, 4, 4, unit)
			end
		end

		--local digits = unit:GetDigits()
		local readTime = 0

		local dispatch = {}
		if zone and zone.dispatch then
		    dispatch = zone.dispatch
		end
		local DISPATCH_DURATION_OVERRIDES = {
		    ["npc/overwatch/radiovoice/stabilizationjurisdiction.wav"] = 2.4,
		    ["npc/overwatch/radiovoice/highpriorityregion.wav"] = 1.9,
		    ["npc/overwatch/radiovoice/controlsection.wav"] = 2.1,
		    
		}

		local function getDispatchDuration(snd)
		    return DISPATCH_DURATION_OVERRIDES[snd] or SoundDuration(snd)
		end
		
		surface.PlaySound("npc/overwatch/radiovoice/lostbiosignalforunit.wav")

		timer.Simple(2, function()
		    timer.Simple(0.1, function()
		        surface.PlaySound("npc/overwatch/radiovoice/unitdownat.wav")
		    end)
		    timer.Simple(1, function()
			    local lastDispatchDuration = 0

			    if #dispatch > 1 then
				    local d1 = math.max(getDispatchDuration(dispatch[1]), 1.5)
				    local d2 = math.max(SoundDuration(dispatch[2]), 1.5)

				    surface.PlaySound(dispatch[1])
				    timer.Simple(d1 - .5, function()
				        surface.PlaySound(dispatch[2])
				        timer.Simple(d2 - .8, function()
				            surface.PlaySound("npc/overwatch/radiovoice/remainingunitscontain.wav")
				        end)
				    end)
				else
				    local d1 = math.max(SoundDuration("npc/overwatch/radiovoice/404zone.wav"), 1.5)
				    surface.PlaySound("npc/overwatch/radiovoice/404zone.wav")
				    timer.Simple(d1 + 0.3, function()
				        surface.PlaySound("npc/overwatch/radiovoice/remainingunitscontain.wav")
				    end)
				end
			end)
		end)
	end
end)