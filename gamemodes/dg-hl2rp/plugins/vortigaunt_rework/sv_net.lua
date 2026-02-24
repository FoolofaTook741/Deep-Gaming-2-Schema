local function roundToTenth(num)
    return math.floor(num * 10 + 0.5) / 10
end

if SERVER then

	VORTMAXSKILLS = 15

    util.AddNetworkString("vortSpendSkill")
    util.AddNetworkString("vortUpdateSkills")
    util.AddNetworkString("vortSkillsTable")
	util.AddNetworkString("vortResetSkills")

    vortSkills = vortSkills or {}
    vortSkills.Skills = {
        ["vort_quickening"] = {
            niceName = "Quickening",
            maxLevel = 5,
            desc = "Each level, your movement speed increases by 2%."
        },
        ["vort_restorative_pulse"] = {
            niceName = "Restorative Pulse",
            maxLevel = 2,
            desc = "Each level boosts your healing energies by 1 HP."
        },
        ["vort_enduring_essence"] = {
            niceName = "Enduring Essence",
            maxLevel = 5,
            desc = "Each level, the duration of your vortessence is extended by 10%."
        },
        ["vort_power_overload"] = {
            niceName = "Power Overload",
            maxLevel = 5,
            desc = "Each level increases the damage output of your power by 2%."
        },
        ["vort_stun"] = {
            niceName = "Overcharge",
            maxLevel = 2,
            desc = "Your vortigaunt beams that do critical damage will stun the target for 0.33 seconds with Enriched Vortessence (3 second cooldown per target). At Level 2, this will stun for 0.25 seconds with Vortessence (5 second cooldown per target)."
        },
        ["vort_antlion"] = {
            niceName = "Bug Lord",
            maxLevel = 5,
            desc = "Each level, your antlion minions gain 20% more maximum health."
        },
        ["vort_wounds"] = {
            niceName = "Deep Penetration",
            maxLevel = 1,
            desc = "Hitting a target with a critical damage beam reduces healing by 50% for 15 seconds. 25 second cooldown per target."
        },
        ["vort_threshold"] = {
            niceName = "Critical Damage Threshold",
            maxLevel = 5,
            desc = "Reduces the critical damage threshold by 1 damage. Critical damage is used to determine wounding and stuns."
        },
    }
    --PrintTable(vortSkills.Skills)
    meta = FindMetaTable("Player")

    local function SendFullSkillData(ply)
        local vortData = ply:GetData().vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
        net.Start("vortUpdateSkills")
            net.WriteTable({
                availableSkillPoints = vortData.availableSkillPoints,
				lastReset = vortData.lastReset,
                skills = vortData.skills,
                skillsTable = vortSkills.Skills
            })
        net.Send(ply)
    end

    hook.Add("PostSetupPlayer", "InitializeVortSkillPoints", function(ply)
        ply.impulseData = ply.impulseData or {}
        
        if not ply.impulseData.vort_skills then
            ply.impulseData.vort_skills = {
                availableSkillPoints = 0,
				lastReset = 0,
                skills = {}
            }
        end

        local storedSkills = ply.impulseData.vort_skills.skills or {}

        for skillID, _ in pairs(vortSkills.Skills) do
            if storedSkills[skillID] == nil then
                storedSkills[skillID] = 0
            end
        end

        for storedSkillID, _ in pairs(storedSkills) do
            if not vortSkills.Skills[storedSkillID] then
                storedSkills[storedSkillID] = nil
            end
        end
        
        ply.impulseData.vort_skills.skills = storedSkills
        ply:SaveData()
        ply.vortComputedSkills = ply:vortSkillCalculate()
    end)

    net.Receive("vortSkillsTable", function(len, ply)
        if ply:Team() ~= TEAM_VORT then return end
        SendFullSkillData(ply)
    end)

    net.Receive("vortSpendSkill", function(len, ply)
        local skillID = net.ReadString()
        local skillDef = vortSkills.Skills[skillID]
        if not skillID or not skillDef then return end
        
        if ply:Team() ~= TEAM_VORT then return end

        local vortData = ply:GetData().vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
        local currentLevel = tonumber(vortData.skills[skillID]) or 0
        local maxLevel = skillDef.maxLevel or 10

        if currentLevel >= maxLevel then
            ply:Notify("You are max level for that skill.")
            return
        end

        local availablePoints = tonumber(vortData.availableSkillPoints) or 0
        if availablePoints >= 1 then
            vortData.availableSkillPoints = roundToTenth(availablePoints - 1)
            vortData.skills[skillID] = currentLevel + 1

            ply.impulseData.vort_skills = vortData
            ply:SaveData()

            SendFullSkillData(ply)
            ply:Notify("You leveled up " .. skillDef.niceName .. " to level " .. (currentLevel + 1) .. ".")
			ply.vortComputedSkills = ply:vortSkillCalculate()
        else
            ply:Notify("You don't have enough skill points.")
        end
    end)
	
net.Receive("vortResetSkills", function(len, ply)
        if ply:Team() ~= TEAM_VORT then return end

        local vortData = ply:GetData().vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
		local last = vortData.lastReset
		local cooldown = 6 * 3600

		if last > 0 and (os.time() - last) < cooldown then
			local remaining = cooldown - (os.time() - last)
			local hrs = math.floor(remaining / 3600)
			local mins = math.floor((remaining % 3600) / 60)
			local secs = math.ceil(remaining % 60)
			local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
			ply:Notify("You can reset again in " .. timeStr .. ".")
			return
		end

        local refund = 0
        for id, lvl in pairs(vortData.skills) do
            refund = refund + (tonumber(lvl) or 0)
            vortData.skills[id] = 0
        end

        if refund == 0 then
            ply:Notify("No skill levels to reset.")
            return
        end

        vortData.availableSkillPoints = roundToTenth((vortData.availableSkillPoints or 0) + refund)
        vortData.lastReset = os.time()

        ply.impulseData.vort_skills = vortData
        ply:SaveData()

        SendFullSkillData(ply)
        ply:Notify("Skills reset! Refunded " .. refund .. " skill point(s).")
		ply.vortComputedSkills = ply:vortSkillCalculate()
    end)
end

function meta:vortSkillPoints()
    local data = self:GetData().vort_skills or { availableSkillPoints = 0, skills = {} }
    local used = 0
    for _, lvl in pairs(data.skills or {}) do
        used = used + (tonumber(lvl) or 0)
    end
    local unused = tonumber(data.availableSkillPoints) or 0
    local total = used + unused
    return used, unused, total
end

function meta:vortAddSkillPoints(points)
    if not points or type(points) ~= "number" then return end
	if self:Team() ~= TEAM_VORT then return end
	
    self.impulseData = self.impulseData or {}
    self.impulseData.vort_skills = self.impulseData.vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
    
    local data = self.impulseData.vort_skills
	local used, unused, total = self:vortSkillPoints()
	
    if total >= VORTMAXSKILLS then
        self:Notify("You have reached the maximum achievable Vortigaunt skill points (" .. VORTMAXSKILLS .. ").")
        return
    end

    local pointsToAdd = math.min(points, VORTMAXSKILLS - total)
    data.availableSkillPoints = roundToTenth(data.availableSkillPoints + pointsToAdd)

    self:SaveData()
    self:Notify("You have received " .. pointsToAdd .. " Vortigaunt skill point(s).")
	
    local vortData = self:GetData().vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
    net.Start("vortUpdateSkills")
        net.WriteTable({
            availableSkillPoints = math.floor(vortData.availableSkillPoints * 10 + 0.5) / 10,
            lastReset = vortData.lastReset or 0,
            skills = vortData.skills,
            skillsTable = vortSkills.Skills
        })
    net.Send(self)
end

function meta:vortSkillLevel(skillID)
    local vortData = self:GetData().vort_skills or { availableSkillPoints = 0, lastReset = 0, skills = {} }
    local value = tonumber(vortData.skills[skillID]) or 0
    return value
end

function meta:vortSkillCalculate()
    local vortSkill = {}

    local quickeningLevel = self:vortSkillLevel("vort_quickening")
    vortSkill.quickening = 1 + (quickeningLevel * 0.02)

    local restorativeLevel = self:vortSkillLevel("vort_restorative_pulse")
    vortSkill.restorative_pulse = restorativeLevel

    local enduringLevel = self:vortSkillLevel("vort_enduring_essence")
    vortSkill.enduring_essence = 1 + (enduringLevel * 0.10)

    local powerLevel = self:vortSkillLevel("vort_power_overload")
    vortSkill.power_overload = 1 + (powerLevel * 0.02)

    local stunLevel = self:vortSkillLevel("vort_stun")
    if stunLevel == 1 then
        vortSkill.stunLevel = stunLevel
        vortSkill.stun = 0.33
    elseif stunLevel >= 2 then
        vortSkill.stunLevel = stunLevel
        vortSkill.stun = 0.25
    else
        vortSkill.stun = 0
    end

    local antlionLevel = self:vortSkillLevel("vort_antlion")
    vortSkill.antlion = 1 + (antlionLevel * 0.20)

    local woundsLevel = self:vortSkillLevel("vort_wounds")
    vortSkill.wounds = (woundsLevel > 0) and true or false

    local thresholdLevel = self:vortSkillLevel("vort_threshold")
    vortSkill.threshold = thresholdLevel


	-- Resync all skills
	self:SetSyncVar(SYNC_VORT_STUN, vortSkill.stunLevel, true)
	local speed = 200 * (vortSkill.quickening or 1)
	self:SetRunSpeed(speed)
	
    return vortSkill
end