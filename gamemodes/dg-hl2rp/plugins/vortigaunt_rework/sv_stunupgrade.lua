local function EnsureVortStateTimer(target)
    if target._dgVortStateTimer then return end
    target._dgVortStateTimer = true

    local id = "dg_vortstate_" .. target:EntIndex()
    timer.Create(id, 0.1, 0, function()
        if not IsValid(target) then
            timer.Remove(id)
            return
        end

        local ct = CurTime()

        if target._dgStunUntil and ct >= target._dgStunUntil then
            target._dgStunUntil = nil
            target:SetSyncVar(SYNC_STUNNED, false, true)
            target:Freeze(false)
        end

        if target._dgAntiHealUntil and ct >= target._dgAntiHealUntil then
            target._dgAntiHealUntil = nil
            target.Antiheal = 0
        end

        if not target._dgStunUntil and not target._dgAntiHealUntil then
            target._dgVortStateTimer = nil
            timer.Remove(id)
        end
    end)
end

hook.Add("EntityTakeDamage", "vortCrits", function(target, dmginfo)
    if not (IsValid(target) and target:IsPlayer()) then return end

    local inf = dmginfo:GetInflictor()
    if not (IsValid(inf) and inf:GetClass() == "plutonic_vort") then return end

    local attacker = dmginfo:GetAttacker()
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end

    local vortSkillData = attacker.vortComputedSkills
    if not istable(vortSkillData) then return end

    local ct = CurTime()
    local dmg = dmginfo:GetDamage()

    target.NextFrozen = target.NextFrozen or 0
    target.nextAntiHeal = target.nextAntiHeal or 0
    target.Antiheal = target.Antiheal or 0

    local vortWounds = vortSkillData.wounds or false
    local vortThreshold = vortSkillData.threshold or 0

    local baseCritical = 23 - vortThreshold
    local essenceCritical = 28 - vortThreshold
    local enrichedCritical = 33 - vortThreshold

    local usedEssence = attacker.UsedVortessence
    local usedEnriched = attacker.UsedEnrichedVortessence
    local stunSkill = attacker:GetSyncVar(SYNC_VORT_STUN, 0)

    -- =================
    -- STUN SYSTEM
    -- =================
    if ct >= target.NextFrozen then
        if usedEssence and stunSkill == 2 and dmg >= essenceCritical then
            target:Freeze(true)
            target:SetSyncVar(SYNC_STUNNED, true, true)

            target.NextFrozen = ct + 5
            target._dgStunUntil = ct + 0.25
            EnsureVortStateTimer(target)

        elseif usedEnriched and stunSkill == 1 and dmg >= enrichedCritical then
            target:Freeze(true)
            target:SetSyncVar(SYNC_STUNNED, true, true)

            target.NextFrozen = ct + 3
            target._dgStunUntil = ct + 0.33
            EnsureVortStateTimer(target)
        end
    end

    -- =================
    -- ANTIHEAL SYSTEM
    -- =================
    if vortWounds and target.Antiheal == 0 and ct >= target.nextAntiHeal then

        if usedEssence and dmg >= essenceCritical then
            target.Antiheal = 0.33
            target.nextAntiHeal = ct + 8
            target._dgAntiHealUntil = ct + 8
            EnsureVortStateTimer(target)

        elseif (usedEnriched and dmg >= enrichedCritical) or (dmg >= baseCritical) then
            target.Antiheal = 0.50
            target.nextAntiHeal = ct + 25
            target._dgAntiHealUntil = ct + 15
            EnsureVortStateTimer(target)
        end
    end
end)


function meta:LearnStunSkill(level)
    --when databasing is done
end