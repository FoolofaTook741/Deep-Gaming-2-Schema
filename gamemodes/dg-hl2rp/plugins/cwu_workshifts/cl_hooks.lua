function PLUGIN:CheckMenuInput()
	if input.IsKeyDown(KEY_F9) and not IsValid(impulse.cwPanel) and ((LocalPlayer():Team() == TEAM_CWU and LocalPlayer():GetTeamRank() >= RANK_INTERN) or (LocalPlayer():Team() == TEAM_CREMATOR)) then
		impulse.cwPanel = vgui.Create("DeepCWPDAMenu")
	end
end

local updateWaiting = false
function PLUGIN:OnSyncUpdate(var, targ, val)
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
    
    updateWaiting = true
    timer.Simple(0.1, function()
        updateWaiting = false

        if IsValid(PDA_MENU) then
            PDA_MENU:BuildSquadTab()
        end
    end)
end

hook.Add("PostDrawEffects", "CWUSquadOutlinesViewmodel", function()
    local lp = LocalPlayer()
    if lp:Team() ~= TEAM_CWU then return end
    if not impulse.GetSetting("cwu_group_ESP") then return end

    local squadId = lp:GetSyncVar(SYNC_CWU_SQUAD, 0)
    local squadComp = {}

    local lpGroup = lp:GetSyncVar(SYNC_GROUP_NAME, "")
    for _, k in pairs(team.GetPlayers(lp:Team())) do
        if k == lp then continue end
        if k:GetMoveType() == MOVETYPE_NOCLIP then continue end

        local targetGroup = k:GetSyncVar(SYNC_GROUP_NAME, "")
        if lpGroup ~= "" and targetGroup ~= "" and lpGroup == targetGroup then continue end

        if k:GetSyncVar(SYNC_CWU_SQUAD, -1) == squadId then
            squadComp[#squadComp + 1] = k
        end
    end

    if #squadComp > 0 then
        -- OUTLINE_RENDERTYPE_BEFORE_VM is for viewmodels
        outline.Add(squadComp, Color(0,0,255,255), OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
    end
end)