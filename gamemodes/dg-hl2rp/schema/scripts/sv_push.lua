hook.Add("PlayerSpawn", "PlayerKeyValues", function(ply)
    ply.NextPush = CurTime() + 3
    ply.NextPushIncrement = 0
    ply.NextPushIncrementWear = ply.NextPush + 2
end)

hook.Add("Think", "PushThink", function()
    for _, ply in pairs(player.GetAll()) do
        if ply.NextPushIncrementWear < CurTime() then
            ply.NextPushIncrement = ply.NextPushIncrement - 1
            ply.NextPushIncrementWear = CurTime() + 1
            if ply.NextPushIncrement < 0 then
                ply.NextPushIncrement = 0 
            end
        end
    end
end)

hook.Add("KeyPress", "PushMechanic", function(ply, key)
    if ( key == IN_USE ) then
        if ply:Alive() and ply.NextPush < CurTime() and !ply:GetSyncVar(SYNC_ARRESTED, false) and ply:Team() != TEAM_ZOMBIE and ply:Team() != TEAM_STALKER and !ply:IsScanner() then
        	local dir = ply:GetAimVector()
        	local t = ply:GetEyeTrace().Entity
            if (t and t:IsPlayer()) and (ply:GetPos():Distance( t:GetPos() ) <= 100) then
                if t:IsPlayer() and t:Team() == TEAM_CREMATOR then return end
                t:SetVelocity(Vector(dir.x, dir.y, 0) * 270)
                t:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")
                ply.NextPush = CurTime() + (3 * ply.NextPushIncrement)
                ply.NextPushIncrement = ply.NextPushIncrement + 1
                if ply.NextPushIncrement > 3 then
                    ply.NextPushIncrement = 3 
                end
                ply.NextPushIncrementWear = ply.NextPush + 2
            end
			return
        elseif ply.NextPush > CurTime() then
        	return
        end
    end
end)