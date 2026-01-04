net.Receive("impulseHalloweenStrike", function()
    local pos = net.ReadVector()

    local strike = ClientsideModel("models/lightning/lightning"..math.random(1, 3)..".mdl")
    strike:SetPos(pos)
    strike:SetModelScale(3, 0)
    strike:Spawn()

    timer.Simple(math.random(0.3, 0.8), function()
        if IsValid(strike) then
            strike:Remove()
        end
    end)

    local tr = util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = LocalPlayer():EyePos() + Vector(0, 0, 10000),
        filter = function(ent)
            if ent:IsPlayer() then 
                return false 
            end

            return true
        end
    })

    local inside = true

    if tr.HitSky then
        inside = false
    end

    LocalPlayer():EmitSound("impulse/halloween/lightning_0"..math.random(1, 3)..".wav", nil, math.random(95, 100), inside and math.random(0.43, 0.6) or math.random(0.45, 0.69), nil, nil, inside and 31 or nil)

	timer.Simple(math.random(4, 30), function()
		LocalPlayer():EmitSound("ambient/atmosphere/thunder"..math.random(1, 4)..".wav", nil, nil, inside and math.random(0.43, 0.6) or math.random(0.45, 0.69), nil, nil, inside and 31 or nil)
	end)
end)