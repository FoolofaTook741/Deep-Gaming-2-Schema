hook.Add("EntityTakeDamage", "LVSPlayerCrushDamage", function(target, dmginfo)
    if not IsValid(target) or not target:IsPlayer() then return end

    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) then return end

    -- Only target LVS vehicles
    if not attacker:GetClass():StartWith("lvs_") then return end

    local phys = attacker:GetPhysicsObject()
    if not IsValid(phys) then return end

    local speed = phys:GetVelocity():Length()
    if speed < 400 then return end -- minimum speed to deal damage

    -- Apply crushing damage
    local dmg = DamageInfo()
    dmg:SetDamage(speed * 0.05)
    dmg:SetDamageType(DMG_CRUSH)
    dmg:SetAttacker(attacker:GetDriver() or attacker)
    dmg:SetInflictor(attacker)

    target:TakeDamageInfo(dmg)
end)