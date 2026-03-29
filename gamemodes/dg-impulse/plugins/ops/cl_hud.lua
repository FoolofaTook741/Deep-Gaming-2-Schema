local red = Color(255, 0, 0, 255)
local green = Color(0, 240, 0, 255)
local col = Color(255,255,255,120)
local dotToggleTime = 0
local ocadeaths = 0
local otadeaths = 0
local cpdeaths = 0

net.Receive("staffcpmessage", function()
	cpdeaths = net.ReadUInt(6)
end)

net.Receive("staffotamessage", function()
	otadeaths = net.ReadUInt(6)
end)

net.Receive("staffocamessage", function()
	ocadeaths = net.ReadUInt(6)
end)

local hitgroups = {
	[HITGROUP_GENERIC] = "generic",
	[HITGROUP_HEAD] = "head",
	[HITGROUP_CHEST] = "chest",
	[HITGROUP_STOMACH] = "stomach",
	[HITGROUP_LEFTARM] = "leftarm",
	[HITGROUP_RIGHTARM] = "rightarm",
	[HITGROUP_LEFTLEG] = "leftleg",
	[HITGROUP_RIGHTLEG] = "rightleg",
	[HITGROUP_GEAR] = "belt"
}

hook.Add("HUDPaint", "impulseOpsHUD", function()
	if not impulse.hudEnabled then return end

	if (LocalPlayer():IsAdmin()or LocalPlayer():IsSeniorGameMaster()) and LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP and not LocalPlayer():InVehicle() then
		local onDuty = impulse.GetSetting("admin_onduty") or false

		if onDuty then
			draw.SimpleText("OBSERVER MODE", "Impulse-Elements19-Shadow", 20, 10, col)
		else
			draw.SimpleText("OBSERVER MODE (OFF DUTY! YOU WILL NOT VIEW INBOUND REPORTS!)", "Impulse-Elements19-Shadow", 20, 10, red)
		end

		local staffOn = 0

		for v,k in pairs(player.GetAll()) do
			if k:IsAdmin() then
				staffOn = staffOn + 1
			end
		end

		draw.SimpleText(staffOn.." STAFF ONLINE", "Impulse-Elements18-Shadow", ScrW() * .5, 10, col, TEXT_ALIGN_CENTER)

		if OPS_LIGHT then
			draw.SimpleText("LIGHT ON", "Impulse-Elements18-Shadow", ScrW() * .5, 30, col, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText("TOTAL REPORTS: " ..#impulse.Ops.Reports, "Impulse-Elements16-Shadow", 20, 30, col)

		local totalClaimed = 0
		for v,k in pairs(impulse.Ops.Reports) do
			if k[3] then
				totalClaimed = totalClaimed + 1

				if k[3] == LocalPlayer() then
					if IsValid(k[1]) then
						draw.SimpleText("REPORTEE: "..k[1]:SteamName().." ("..k[1]:Name()..")", "Impulse-Elements16-Shadow", 20, 80, green)
					else
						draw.SimpleText("REPORTEE IS INVALID! CLOSE THIS REPORT.", "Impulse-Elements16-Shadow", 20, 80, green)
					end
				end
			end
		end

		draw.SimpleText("CLAIMED REPORTS: " ..totalClaimed, "Impulse-Elements16-Shadow", 20, 50, col)

		if (LocalPlayer():IsAdmin() or LocalPlayer():IsGameMaster() or LocalPlayer():IsSeniorGameMaster()) and impulse.GetSetting("admin_esp") then
			draw.SimpleText("ENTCOUNT: "..#ents.GetAll(), "Impulse-Elements16-Shadow", 20, 100, col)
			draw.SimpleText("PLAYERCOUNT: "..#player.GetAll(), "Impulse-Elements16-Shadow", 20, 120, col)
			draw.SimpleText("O.C.A. DEATHS (15M): "..ocadeaths, "Impulse-Elements16-Shadow", 20, 160, Color(150,0,0))
			draw.SimpleText("C.T.A. DEATHS (15M): "..otadeaths, "Impulse-Elements16-Shadow", 20, 180, Color(100,100,100))
			draw.SimpleText("M.P.F. DEATHS (15M): "..cpdeaths, "Impulse-Elements16-Shadow", 20, 200, Color(0,100,175))

			if impulse.Dispatch then
				local ccode = impulse.Dispatch.CityCodes[impulse.Dispatch.GetCityCode()]
				draw.SimpleText("CITY CODE: "..ccode[1], "Impulse-Elements16-Shadow", 20, 240, ccode[2])
			end

			local y = 260

			for v,k in pairs(impulse.Teams.Data) do
				draw.SimpleText(team.GetName(v)..": "..#team.GetPlayers(v), "Impulse-Elements16-Shadow", 20, y, col)
				y = y + 20
			end

			for v,k in pairs(player.GetAll()) do
				if k ==  LocalPlayer() then continue end
				local currentSID = k:SteamID()
				local pos = (k:GetPos() + k:OBBCenter()):ToScreen()
				local col = team.GetColor(k:Team())
				local protectedSID = "STEAM_0:0:29204032" --Fool of a Took


				if (k:IsAdmin() or k:IsGameMaster()) and k:GetMoveType() == MOVETYPE_NOCLIP and k:GetNoDraw() then
					draw.SimpleText("** In Noclip Mode **", "Impulse-Elements18-Shadow", pos.x, pos.y, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				elseif currentSID == protectedSID then
					draw.SimpleText("<< Protected >>", "Impulse-Elements18-Shadow", pos.x, pos.y, Color(150,0,0), TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(k:Name(), "Impulse-Elements18-Shadow", pos.x, pos.y, col, TEXT_ALIGN_CENTER)
				end

				if currentSID == protectedSID then
					draw.SimpleText("<< Protected >>", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, Color(255,200,200), TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(k:SteamName(), "Impulse-Elements16-Shadow", pos.x, pos.y + 15, impulse.Config.InteractColour, TEXT_ALIGN_CENTER)
				end

				if k:GetPos():Distance(LocalPlayer():GetPos()) < 1500 and currentSID != protectedSID and k:GetMoveType() != MOVETYPE_NOCLIP then
					draw.SimpleText("HP: " .. k:Health() .. "/" .. k:GetMaxHealth(), "Impulse-Elements14-Shadow", pos.x, pos.y + 30, Color(200,255,200), TEXT_ALIGN_CENTER)
					draw.SimpleText("AP: " .. k:Armor() .. "/" .. k:GetMaxArmor(), "Impulse-Elements14-Shadow", pos.x, pos.y + 42, Color(200,200,255), TEXT_ALIGN_CENTER)
				elseif k:GetPos():Distance(LocalPlayer():GetPos()) < 1500 and currentSID == protectedSID and k:GetMoveType() != MOVETYPE_NOCLIP then
					draw.SimpleText("HP: ???", "Impulse-Elements14-Shadow", pos.x, pos.y + 30, Color(200,255,200), TEXT_ALIGN_CENTER)
					draw.SimpleText("AP: ???", "Impulse-Elements14-Shadow", pos.x, pos.y + 42, Color(200,200,255), TEXT_ALIGN_CENTER)
				end
			end
		end

		if CUR_SNAPSHOT then
			local snapData = impulse.Ops.Snapshots[CUR_SNAPSHOT]
			impulse.Ops.Snapshots[CUR_SNAPSHOT].VictimNeatName = impulse.Ops.Snapshots[CUR_SNAPSHOT].VictimNeatName or ((IsValid(snapData.Victim) and snapData.Victim:IsPlayer()) and (snapData.VictimNick.." ("..snapData.Victim:SteamName()..")") or snapData.VictimID)
			impulse.Ops.Snapshots[CUR_SNAPSHOT].InflictorNeatName = impulse.Ops.Snapshots[CUR_SNAPSHOT].InflictorNeatName or ((IsValid(snapData.Inflictor) and snapData.Inflictor:IsPlayer()) and (snapData.InflictorNick.." ("..snapData.Inflictor:SteamName()..")") or snapData.InflictorID)

			draw.SimpleText("VIEWING SNAPSHOT #"..CUR_SNAPSHOT.." (CLOSE WITH F2)", "Impulse-Elements16-Shadow", 250, 100, col)
			draw.SimpleText("VICTIM: "..snapData.VictimNeatName.." ["..snapData.VictimID.."]", "Impulse-Elements16-Shadow", 250, 120, Color(255, 0, 0))
			draw.SimpleText("ATTACKER: "..snapData.InflictorNeatName.." ["..snapData.InflictorID.."]", "Impulse-Elements16-Shadow", 250, 140, Color(0, 255, 0))

			for v,k in pairs(impulse.Ops.SnapshotEnts) do
				local pos = (k:GetPos() + k:OBBCenter()):ToScreen()
				local col = k:GetColor()

				draw.SimpleText(k.IsVictim and snapData.VictimNeatName or snapData.InflictorNeatName, "Impulse-Elements18-Shadow", pos.x, pos.y, col, TEXT_ALIGN_CENTER)

				if not k.IsVictim then
					draw.SimpleText("WEP: "..snapData.AttackerClass, "Impulse-Elements18-Shadow", pos.x, pos.y + 20, col, TEXT_ALIGN_CENTER)
					draw.SimpleText("HP: "..snapData.InflictorHealth, "Impulse-Elements18-Shadow", pos.x, pos.y + 40, col, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("HITGROUP: "..hitgroups[snapData.VictimHitGroup], "Impulse-Elements18-Shadow", pos.x, pos.y + 20, col, TEXT_ALIGN_CENTER)
				end
			end
		end

		if impulse.Ops.EventManager and impulse.Ops.EventManager.GetEventMode() and impulse.Ops.EventManager.GetSequence() then
			local symb = "•"

			if dotToggleTime < CurTime() then
				symb = ""

				if dotToggleTime + 1 < CurTime() then
					dotToggleTime = CurTime() + 1
				end
			end

			draw.SimpleText(symb.." LIVE (CURRENT SEQUENCE: "..impulse.Ops.EventManager.GetSequence()..")", "Impulse-Elements18-Shadow", ScrW() - 20, 20, red, TEXT_ALIGN_RIGHT)
		end
	end
end)
