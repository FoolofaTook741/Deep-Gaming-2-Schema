local HANDS_ACTIVITY_TRANSLATOR = {
    [ACT_MP_STAND_IDLE] = ACT_IDLE_ANGRY,
    [ACT_MP_WALK] = ACT_WALK,
    [ACT_MP_RUN] = ACT_RUN,
    [ACT_MP_JUMP] = ACT_GLIDE,
    [ACT_MP_CROUCH_IDLE] = ACT_COVER_LOW,
    [ACT_MP_CROUCHWALK] = ACT_WALK_CROUCH
}

function SCHEMA:TranslateActivity(client, activity)
    local weapon = client:GetActiveWeapon()
    local subClass = "normal"
    if ( IsValid(weapon) and weapon:GetClass() == "impulse_hands" ) then
        local modelClass = client._cachedModelClass or impulse.Anim.GetModelClass(string.lower(client:GetModel()))
        if modelClass == "citizen_male" or modelClass == "citizen_female" then
            subClass = weapon.HoldType or weapon.GetHoldType(weapon)
            subClass = HOLDTYPE_TRANSLATOR[subClass] or subClass
            return HANDS_ACTIVITY_TRANSLATOR[activity]
        end
    end
end

local function CacheModelClass(ply)
    if IsValid(ply) then
        ply._cachedModelClass = impulse.Anim.GetModelClass(string.lower(ply:GetModel()))
    end
end

hook.Add("PlayerSpawn", "CacheModelClass", function(ply)
    CacheModelClass(ply)
end)

hook.Add("OnPlayerChangedTeam", "CacheModelClass", function(ply)
    CacheModelClass(ply)
end)
