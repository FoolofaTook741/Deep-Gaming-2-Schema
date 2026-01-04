TEAM_VORT = impulse.Teams.Define({
    name = "Vortigaunt",
    color = Color(172, 156, 11, 255),
    model = "models/willardnetworks/vortigaunt.mdl",
    description = [[A mysterious alien race, enslaved by the Combine. They are a wise and mainly peaceful race, forced into servitude by other races for centuries. Most are treated poorly by the Combine, forced to clean the streets and Nexus. However, once freed they are able to harness a mysterious energy, known as the Vortessence, that connects them with each other.]],
    loadout = {"impulse_hands", "plutonic_broom"},
    salary = 80,
    handModel = "models/weapons/vortigaunt_junior_arms.mdl",
    donatorOnly = false,
    spawnLoc = false,
    xp = 1500,
    classes = {
        {
            name = "Research & Development",
            description = "Researchers work on Xen Fauna and creatures to harness their resources for the Combine.",
            model = "models/willardnetworks/vortigaunt.mdl",
            xp = 25,
            noMenu = true,
			whitelistUID = "CW_Research",
			whitelistLevel = 1,
            whitelistFailMessage = "You must be specially whitelisted for the Research Team."
        },
    },
    ranks = {
        {
            name = "Intern",
            description = "intern",
            doorGroup = {1},
            xp = 0,
            onBecome = function(ply, rank)
                if ply:GetTeamClass() ~= CLASS_RESEARCH then
                    --leaving this for vort model with labcoat
                    ply:SetRPName("Zenthyrl " .. ply:GetSavedRPName())
                end
            end
        },
        {
            name = "Employee",
            description = "ows",
            doorGroup = {1},
            xp = 5,
            whitelistLevel = 1,
            onBecome = function(ply, rank)
                if ply:GetTeamClass() ~= CLASS_RESEARCH then
                    --leaving this for vort model with labcoat
                    ply:SetRPName("Fluxbinder " .. ply:GetSavedRPName())
                end
            end
        },
        {
            name = "Supervisor",
            description = "eow",
            doorGroup = {1},
            xp = 5,
            whitelistLevel = 2,
            onBecome = function(ply, rank)
                if ply:GetTeamClass() ~= CLASS_RESEARCH then
                    --leaving this for vort model with labcoat
                    ply:SetRPName("Voidshaper " .. ply:GetSavedRPName())
                end
            end
        },
        {
            name = "Director",
            description = "captain",
            doorGroup = {1},
            xp = 5,
            whitelistLevel = 3,
            onBecome = function(ply, rank)
                if ply:GetTeamClass() ~= CLASS_RESEARCH then
                    --leaving this for vort model with labcoat
                    ply:SetRPName("Synthrex " .. ply:GetSavedRPName())
                end
            end
        },
        {
            name = "Minister",
            description = "ldr",
            doorGroup = {1, 2},
            xp = 5,
            whitelistLevel = 4,
            onBecome = function(ply, rank)
                if ply:GetTeamClass() ~= CLASS_RESEARCH then
                    --leaving this for vort model with labcoat
                    ply:SetRPName("Vortiprime " .. ply:GetSavedRPName())
                end
            end
        },
    }
})

hook.Add("OnPlayerChangedTeam", "vortset", function(ply, oldTeam, newTeam)
    if newTeam == TEAM_VORT then
        local chance = math.random(2, 60)
        ply:SetSkin(chance)
        ply:SetBodygroup(7, 1)
        ply:SetBodygroup(8, 1)
        local vortSkillData = ply:vortSkillCalculate()
        local speed = 200 * (vortSkillData.quickening or 1)
        ply:SetRunSpeed(speed)
    end
end)

CLASS_RESEARCH = 6

RANK_INTERN = 1
RANK_EMPLOYEE = 2
RANK_SUPERVISOR = 3
RANK_DIRECTOR = 4
RANK_MINISTER = 5