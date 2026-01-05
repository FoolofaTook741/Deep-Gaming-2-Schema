-- CONFIG
local CROUCH_SPAM_WINDOW = 1.5        -- seconds
local CROUCH_MAX_STACKS = 2           -- how many rapid crouches before lock
local CROUCH_LOCK_TIME = 1.2          -- time crouch is disabled
local CROUCH_RECOVERY_RATE = 1.5      -- stacks per second
local CROUCH_MIN_SPEED = 0.15         -- minimum crouch speed multiplier

local crouchData = {}

local function GetData(ply)
    crouchData[ply] = crouchData[ply] or {
        lastCrouch = 0,
        stacks = 0,
        lockedUntil = 0
    }
    return crouchData[ply]
end

hook.Add("KeyPress", "DG_CrouchFatigue_KeyPress", function(ply, key)
    if key ~= IN_DUCK then return end

    local data = GetData(ply)
    local now = CurTime()

    if now < data.lockedUntil then return end

    if now - data.lastCrouch <= CROUCH_SPAM_WINDOW then
        data.stacks = math.min(data.stacks + 1, CROUCH_MAX_STACKS)
    else
        data.stacks = math.max(data.stacks - 1, 0)
    end

    data.lastCrouch = now

    if data.stacks >= CROUCH_MAX_STACKS then
        data.lockedUntil = now + CROUCH_LOCK_TIME
        data.stacks = CROUCH_MAX_STACKS
    end
end)

hook.Add("SetupMove", "DG_CrouchFatigue_Block", function(ply, mv)
    local data = crouchData[ply]
    if not data then return end

    if CurTime() < data.lockedUntil then
        mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_DUCK)))
    end
end)

hook.Add("Move", "DG_CrouchFatigue_Slow", function(ply, mv)
    local data = crouchData[ply]
    if not data or data.stacks <= 0 then return end

    local frac = data.stacks / CROUCH_MAX_STACKS
    local speedMul = math.max(1 - frac, CROUCH_MIN_SPEED)

    mv:SetMaxSpeed(mv:GetMaxSpeed() * speedMul)
    mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * speedMul)
end)

-- Recover over time
hook.Add("Think", "DG_CrouchFatigue_Recovery", function()
    for ply, data in pairs(crouchData) do
        if not IsValid(ply) then
            crouchData[ply] = nil
            continue
        end

        if CurTime() > data.lockedUntil and data.stacks > 0 then
            data.stacks = math.max(
                data.stacks - CROUCH_RECOVERY_RATE * FrameTime(),
                0
            )
        end
    end
end)
