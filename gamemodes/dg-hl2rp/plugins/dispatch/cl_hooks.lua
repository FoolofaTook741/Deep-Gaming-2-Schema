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
local squadVars
local RebuildOutlineCache

function PLUGIN:OnSyncUpdate(var, targ, val)
	if not squadVars then
		squadVars = {
			[SYNC_SQUAD_ID] = true,
			[SYNC_SQUAD_LEADER] = true
		}
	end

	if not squadVars[var] then
		return
	end

	if RebuildOutlineCache then
		RebuildOutlineCache()
	end

	if not IsValid(PDA_MENU) then
		return
	end

	if updateWaiting then
		return
	end

	updateWaiting = true
	timer.Simple(0.1, function()
		updateWaiting = false

		if IsValid(PDA_MENU) then
			PDA_MENU:BuildSquadTab()
		end
	end)
end

-- Colors, cached once
local squadGreen = Color(75, 155, 45, 255)
local ocaPurple = Color(138, 43, 226)
local cpBlue = Color(  0, 191, 255 )
local stalkerRed = Color(255,0,0)

local teamBlue = Color(0, 131, 255, 255)
local groupOrange = Color(255, 204, 0, 255)

local SCANNER_DISGUISE_MODEL = "models/wn7new/metropolice_rebel_c24/male_01.mdl"

-- Cache is rebuilt on a throttle (+ on squad sync updates), read every frame
local outlineCache = {
	squad = {}, ca = {}, cp = {}, ota = {}, stalker = {}, team = {}, group = {}
}

RebuildOutlineCache = function()
	local lp = LocalPlayer()
	if not IsValid(lp) then return end

	local perfOutline = impulse.GetSetting("SqDOutline")
	local teamVis = impulse.GetSetting("team_ESP")
	local combineVis = impulse.GetSetting("faction_ESP")
	local groupVis = impulse.GetSetting("group_ESP")

	local squadId = lp:GetSyncVar(SYNC_SQUAD_ID, 0)

	local squadComp = {}
	local tp = {}
	local gp = {}
	local caPlayers, cpPlayers, otaPlayers, stalkerPlayers = {}, {}, {}, {}

	if lp:IsCP() == true and lp:GetModel() != SCANNER_DISGUISE_MODEL and (perfOutline or teamVis or combineVis) then
		for _, k in ipairs(team.GetPlayers(lp:Team())) do
			if k == lp then continue end
			if not k:Alive() then continue end
			if k:GetMoveType() == MOVETYPE_NOCLIP then continue end
			if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId then
				squadComp[#squadComp+1] = k
			end
		end

		if combineVis != false then
			for _, k in ipairs(player.GetAll()) do
				if not k:IsCP() then continue end
				if k == lp then continue end
				if not k:Alive() then continue end
				if squadId != 0 and k:Team() == lp:Team() and k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId and perfOutline then continue end
				if k.IsRogue or k:GetModel() == SCANNER_DISGUISE_MODEL then continue end
				if k:GetMoveType() == MOVETYPE_NOCLIP then continue end

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
		elseif teamVis != false then
			for _, k in ipairs(team.GetPlayers(lp:Team())) do
				if k == lp then continue end
				if not k:Alive() then continue end
				if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId and perfOutline then continue end
				if k.IsRogue or k:GetModel() == SCANNER_DISGUISE_MODEL then continue end
				if k:GetMoveType() == MOVETYPE_NOCLIP then continue end
				tp[#tp+1] = k
			end
		end
	elseif groupVis != false and lp:IsCP() != true and lp:Team() != TEAM_ZOMBIE then
		local myGroup = lp:GetSyncVar(SYNC_GROUP_NAME, nil)
		if myGroup and myGroup != "" then
			for _, k in ipairs(player.GetAll()) do
				if k == lp then continue end
				if not k:Alive() then continue end
				if k:IsCP() then continue end
				if k:Team() == TEAM_ZOMBIE then continue end
				if k:GetMoveType() == MOVETYPE_NOCLIP then continue end
				if myGroup != k:GetSyncVar(SYNC_GROUP_NAME, nil) then continue end
				gp[#gp+1] = k
			end
		end
	end

	outlineCache.squad = squadComp
	outlineCache.ca = caPlayers
	outlineCache.cp = cpPlayers
	outlineCache.ota = otaPlayers
	outlineCache.stalker = stalkerPlayers
	outlineCache.team = tp
	outlineCache.group = gp
end

timer.Create("dg2_outline_cache_rebuild", 0.15, 0, RebuildOutlineCache)

hook.Add("PostDrawEffects", "combineOutlines", function()
	if #outlineCache.squad > 0 then
		outline.Add(outlineCache.squad, squadGreen, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.ca > 0 then
		outline.Add(outlineCache.ca, ocaPurple, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.cp > 0 then
		outline.Add(outlineCache.cp, cpBlue, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.ota > 0 then
		outline.Add(outlineCache.ota, color_white, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.stalker > 0 then
		outline.Add(outlineCache.stalker, stalkerRed, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.team > 0 then
		outline.Add(outlineCache.team, teamBlue, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
	if #outlineCache.group > 0 then
		outline.Add(outlineCache.group, groupOrange, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
end)