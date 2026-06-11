function PLUGIN:CheckMenuInput()
	if input.IsKeyDown(KEY_F6) and not IsValid(PDA_MENU) and (LocalPlayer():GetTeamRank() or 0) != 0 and (LocalPlayer():Team() == TEAM_CP or LocalPlayer():Team() == TEAM_OTA or LocalPlayer():Team() == TEAM_CA) then
		if LocalPlayer():Team() == TEAM_CP and LocalPlayer():GetTeamRank() >= RANK_OFC and LocalPlayer():IsScanner() then
			PDA_MENU = vgui.Create("impulseScannerTerminalMenu")
		else
			PDA_MENU = vgui.Create("impulsePDAMenu")
		end
	end
end

local updateWaiting = false
function PLUGIN:OnSyncUpdate(var, targ, val) -- live update for pda menu
	local squadVars = squadVars or {
		[SYNC_SQUAD_ID] = true,
		[SYNC_SQUAD_LEADER] = true
	}

	if not squadVars[var] then
		return
	end

	if not IsValid(PDA_MENU) then
		return
	end

	if updateWaiting then
		return
	end
	
	updateWaiting = true -- hacky fix because data is sent rapidly
	timer.Simple(0.1, function()
		updateWaiting = false

		if IsValid(PDA_MENU) then
			PDA_MENU:SetupPDA()
		end
	end)
end


hook.Add("PostDrawEffects", "combineOutlines", function()
	
	local lp = LocalPlayer()

	local perfOutline = impulse.GetSetting("SqDOutline")
	local teamVis = impulse.GetSetting("team_ESP")
	local combineVis = impulse.GetSetting("faction_ESP")
	local groupVis = impulse.GetSetting("group_ESP")

	local squadId = lp:GetSyncVar(SYNC_SQUAD_ID, 0)
    local squadComp = {}
	local fp = {}
	local tp = {}
	local gp = {}
	if LocalPlayer():IsCP() == true and LocalPlayer():GetModel() != "models/wn7new/metropolice_rebel_c24/male_01.mdl" and (perfOutline or teamVis or combineVis) then
    	for v,k in pairs(team.GetPlayers(lp:Team())) do
			if k == lp then continue end
			if not k:Alive() then continue end
			if k:GetMoveType() == MOVETYPE_NOCLIP then
    	            continue
    	        end
    	    if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId then
    	        if k:GetSyncVar(SYNC_SQUAD_LEADER, false) then
    	            squadComp[#squadComp+1] = k
    	        else
    	            squadComp[#squadComp+1] = k
    	        end
    	    end
    	end
		if #squadComp > 0 then
			--halo.Add(squadComp,Color(75, 155, 45, 255), 0, 0, 1, true, true)
			outline.Add(squadComp, Color(75, 155, 45, 255), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
		end
		if combineVis != false then
			local caPlayers, cpPlayers, otaPlayers, stalkerPlayers = {}, {}, {}, {}
			for v,k in pairs(player.GetAll()) do
				if not k:IsCP() then continue end
				if k == lp then continue end
				if not k:Alive() then continue end
				if squadId != 0 and k:Team() == lp:Team() and k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId and perfOutline then continue end				
				if k.IsRogue or k:GetModel() == "models/wn7new/metropolice_rebel_c24/male_01.mdl" then continue end
				if k:GetMoveType() == MOVETYPE_NOCLIP then
					continue
				end
				local t = k:Team()
				if t == TEAM_CA then
					table.insert(caPlayers, k)
				elseif t == TEAM_CP then
					table.insert(cpPlayers, k)
				elseif t == TEAM_OTA then
					table.insert(otaPlayers, k)
				elseif t == TEAM_STALKER then
					table.insert(stalkerPlayers, k)
				end
			end
			if #caPlayers > 0 then
				--halo.Add(caPlayers, Color(138, 43, 226), 0, 0, 1, true, true)
				outline.Add(caPlayers, Color(138, 43, 226), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
			end
			if #cpPlayers > 0 then
				--halo.Add(cpPlayers, Color(  0, 191, 255 ), 0, 0, 1, true, true)
				outline.Add(cpPlayers, Color(  0, 191, 255 ), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
			end
			if #otaPlayers > 0 then
				--halo.Add(otaPlayers, Color(255,255,255), 0, 0, 1, true, true)
				outline.Add(otaPlayers, Color(255,255,255), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
			end
			if #stalkerPlayers > 0 then
				--halo.Add(stalkerPlayers, Color(255,0,0), 0, 0, 1, true, true)
				outline.Add(stalkerPlayers, Color(255,0,0), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
			end
		elseif teamVis != false then
			for v,k in pairs(team.GetPlayers(lp:Team())) do
				if k == lp then continue end
				if not k:Alive() then continue end
				if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId && perfOutline then continue end
				if k.IsRogue or k:GetModel() == "models/wn7new/metropolice_rebel_c24/male_01.mdl" then continue end
				if k:GetMoveType() == MOVETYPE_NOCLIP then
					continue
				end
				tp[#tp+1] = k
			end
			if #tp > 0 then
				--halo.Add(tp,Color(0, 131, 255, 255), 0, 0, 1, true, true)
				outline.Add(tp, Color(0, 131, 255, 255), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
			end
		end
	elseif groupVis != false and LocalPlayer():IsCP() != true and (LocalPlayer():Team() != TEAM_ZOMBIE) and LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil) and LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil) != "" then
		for v,k in pairs(player.GetAll()) do
			if k == lp then continue end
			if not k:Alive() then continue end
			if k:IsCP() then continue end
			if k:Team() == TEAM_ZOMBIE then continue end
			if not lp:GetSyncVar(SYNC_GROUP_NAME, nil) then continue end
			if lp:GetSyncVar(SYNC_GROUP_NAME, nil) == "" then continue end
			if lp:GetSyncVar(SYNC_GROUP_NAME, nil) != k:GetSyncVar(SYNC_GROUP_NAME, nil) then continue end
			if k:GetMoveType() == MOVETYPE_NOCLIP then
				continue
			end
			gp[#gp+1] = k
		end
		if #gp > 0 then
			--halo.Add(gp,Color(255, 204, 0, 255), 0, 0, 1, true, true)
			outline.Add(gp, Color(255, 204, 0, 255), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
		end
	end
end)
