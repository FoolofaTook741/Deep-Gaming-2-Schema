local OUTFITS = {
    "citizenoutfit",
    "loyalistoutfit_1",
    "loyalistoutfit_2",
    "loyalistoutfit_3",
}

local function GiveCitizenOutfit(ply)
    if not IsValid(ply) or ply:Team() ~= TEAM_CITIZEN then return end

    local lvl = ply:GetTeamWhitelist("TEAM_CITIZEN") or 0
    local desired
    if lvl == 1 then
        desired = "loyalistoutfit_1"
    elseif lvl == 2 then
        desired = "loyalistoutfit_2"
    elseif lvl == 3 then
        desired = "loyalistoutfit_3"
    else
        desired = "citizenoutfit"
    end

    for _, outfit in ipairs(OUTFITS) do
        if outfit ~= desired and ply:HasInventoryItem(outfit) then
            ply:TakeInventoryItemClass(outfit, 1, 1)
        end
    end
    if not ply:HasInventoryItem(desired) then
        ply:GiveInventoryItem(desired, 1, true)
    end
end

    --[[
hook.Add("PlayerChangedTeam", "civoutfit_change", function(ply, oldTeam, newTeam)
	
    if newTeam ~= TEAM_CITIZEN then return end

    timer.Simple(0.5, function()
        GiveCitizenOutfit(ply)
        ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
    end

end)
--[[
hook.Add("PostSetupPlayer", "civoutfit_change_initial", function(ply)
    if newTeam ~= TEAM_CITIZEN then return end
    timer.Simple(0.5, function()
        GiveCitizenOutfit(ply)
        ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
    end)
end)
--]]
