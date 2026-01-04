util.AddNetworkString("WallhammerBreacher_Activated")
util.AddNetworkString("WallhammerBreacher_Deactivated")

local cooldown = 30
local duration = 3
local speedMultiplier = 1.35
local breachForce = 50000
local respawnDelay = 300

local playerCooldowns = {}
local playerActive = {}
local breachedDoors = {}

hook.Add("KeyPress", "WallhammerBreacher_DetectDoubleShift", function(ply, key)
	if ply:Team() == TEAM_CTA or ply:GetTeamClass() ~= CLASS_PAYBACK then return end
    if key ~= IN_SPEED then return end

    local lastTap = ply.lastShiftTap or 0
    local curTime = CurTime()

    if curTime - lastTap < 0.3 then
        if playerCooldowns[ply] and playerCooldowns[ply] > curTime then
            local remaining = math.ceil(playerCooldowns[ply] - curTime)
            ply:Notify("[Wallhammer Breacher] Not ready! Cooldown: " .. remaining .. "s remaining.")
            return
        end
        if playerActive[ply] then return end
		ply:Notify("[Wallhammer Breacher] Activated")
        ActivateWallhammerBreacher(ply)
    end

    ply.lastShiftTap = curTime
end)

function ActivateWallhammerBreacher(ply)
    local curTime = CurTime()
    playerActive[ply] = true
    playerCooldowns[ply] = curTime + cooldown

    ply.originalRunSpeed = ply:GetRunSpeed()
    ply:SetRunSpeed(ply.originalRunSpeed * speedMultiplier)

    net.Start("WallhammerBreacher_Activated")
    net.Send(ply)

    timer.Simple(duration, function()
        if not IsValid(ply) then return end

        ply:SetRunSpeed(ply.originalRunSpeed or 400)
        net.Start("WallhammerBreacher_Deactivated")
        net.Send(ply)

        playerActive[ply] = false

        local cooldownTime = playerCooldowns[ply] - CurTime()
        timer.Simple(cooldownTime, function()
            if IsValid(ply) then
                ply:Notify("[Wallhammer Breacher] Breach ready to use again!")
            end
        end)
    end)
end

hook.Add("Think", "WallhammerBreacher_DoorBreakLogic", function()
    for _, ply in ipairs(player.GetAll()) do
        if not playerActive[ply] then continue end
        if not ply:KeyDown(IN_SPEED) then continue end

        local tr = util.TraceHull({
            start = ply:GetPos(),
            endpos = ply:GetPos() + ply:GetForward() * 50,
            mins = Vector(-10, -10, 0),
            maxs = Vector(10, 10, 64),
            filter = ply
        })

        local ent = tr.Entity
        if not IsValid(ent) then continue end

        local class = ent:GetClass()
        if class ~= "prop_door_rotating" and class ~= "func_door_rotating" then continue end
        if ent._breached then continue end
		if ent:GetSyncVar(SYNC_DOOR_GROUP) and ent:GetSyncVar(SYNC_DOOR_GROUP) >= 2 then
			return
		end

        ent._breached = true

        ply:DoAnimationEvent(ACT_MELEE_ATTACK_SWING)

        local doorInfo = {
            model = ent:GetModel(),
            pos = ent:GetPos(),
            ang = ent:GetAngles(),
            class = class,
            skin = ent:GetSkin(),
            solid = ent:GetSolid(),
            name = ent:GetName(),
        }
        breachedDoors[ent] = doorInfo

        local doorPos = ent:GetPos()
        local doorAng = ent:GetAngles()
        local doorModel = ent:GetModel()

		-- Hide the original door temporarily
		ent:SetNotSolid(true)
		ent:SetNoDraw(true)
		ent:Fire("Unlock")
		ent:Fire("Open")

		-- Spawn physics prop for smash effect
		local physDoor = ents.Create("prop_physics")
		physDoor:SetModel(ent:GetModel())
		physDoor:SetPos(ent:GetPos())
		physDoor:SetAngles(ent:GetAngles())
		physDoor:Spawn()
		physDoor:SetSkin(ent:GetSkin() or 0)

		-- Direction for physics force
		local dir = (physDoor:GetPos() - ply:GetPos()):GetNormalized()
		local phys = physDoor:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceCenter(dir * breachForce)
			phys:EnableMotion(true)
		end

		-- Play smash sound
		physDoor:EmitSound("ambient/explosions/explode_8.wav", 90, 100)

		timer.Simple(respawnDelay, function()
			if IsValid(physDoor) then
				physDoor:Remove()
			end
			if IsValid(ent) then
				ent:SetNotSolid(false)
				ent:SetNoDraw(false)
				ent:Fire("Lock")
				ent:Fire("Close")
				ent._breached = nil
			end
		end)
    end
end)

local playerPropCount = {}

hook.Add("Think", "WallhammerBreacher_PropDestroyLogic", function()
    for _, ply in ipairs(player.GetAll()) do
        if playerActive[ply] then
            if not playerPropCount[ply] then
                playerPropCount[ply] = 0
            end
            if not ply:KeyDown(IN_SPEED) then continue end

            local tr = util.TraceHull({
                start = ply:GetPos(),
                endpos = ply:GetPos() + ply:GetForward() * 50,
                mins = Vector(-10, -10, 0),
                maxs = Vector(10, 10, 64),
                filter = ply
            })

            local ent = tr.Entity
            if not IsValid(ent) then continue end

            local class = ent:GetClass()
            if class == "prop_door_rotating" or class == "func_door_rotating" then continue end
            if class ~= "prop_physics" then continue end
            if ent._smashed then continue end
            if playerPropCount[ply] >= 4 then continue end

            ent._smashed = true

            ply:DoAnimationEvent(ACT_MELEE_ATTACK_SWING)

            local dir = (ent:GetPos() - ply:GetPos()):GetNormalized()
            local shatterForce = 20000

            ent:PrecacheGibs()
            ent:GibBreakServer(dir * shatterForce)

            ent:EmitSound("ambient/explosions/explode_8.wav", 90, 100)

            playerPropCount[ply] = playerPropCount[ply] + 1

            timer.Simple(0.1, function()
                if IsValid(ent) then
                    ent:Remove()
                end
            end)
        else
            playerPropCount[ply] = nil
        end
    end
end)
