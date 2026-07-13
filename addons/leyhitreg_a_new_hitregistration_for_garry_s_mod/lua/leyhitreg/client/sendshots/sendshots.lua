
local IsValid = IsValid
local inputIsMouseDown = input.IsMouseDown
local vector_origin = vector_origin
local isnumber = isnumber
local mathceil = math.ceil
local mathfloor = math.floor
local mathmax = math.max
local mathmin = math.min
local mathsqrt = math.sqrt

IN_LEYHITREG1 = bit.lshift(1, 27)

function LeyHitreg:ShouldPrimaryAttack()
    return inputIsMouseDown(MOUSE_LEFT) or inputIsMouseDown(MOUSE_RIGHT)
end

local lastPrim = nil
function LeyHitreg:CanShoot(cmd, wep, primary)
    local canShoot = true

    local nextPrim = wep:GetNextPrimaryFire()

    if (primary) then
        if (nextPrim == lastPrim or wep:Clip1() == 0) then
            canShoot = false
        else
            lastPrim = nextPrim
        end
    end

    return canShoot
end

local bitbor = bit.bor
local trace = {}
local traceres = {}
trace.filter = LocalPlayer()
trace.mask = MASK_SHOT
trace.output = traceres

local lply = nil

timer.Create("LeyHitreg.LocalPlayerGet", 0.1, 0, function()
    if (not lply and IsValid(LocalPlayer())) then
        lply = LocalPlayer()
        trace.filter = lply
        timer.Remove("LeyHitreg.LocalPlayerGet")
    end
end)

LeyHitreg.WeaponSpreads = {}

function LeyHitreg:IsAutoWep(wep)
    if (wep.Primary) then
        return wep.Primary.Automatic
    end

    return true
end

function LeyHitreg:IsShotgun(wep)
    if (wep.Primary) then
        return wep.Primary.NumShots > 1
    end

    return false
end

local function GetShotgunGridCoordinate(index, pelletCount, columns)
    local row = mathfloor((index - 1) / columns)
    local col = (index - 1) % columns
    local rows = mathceil(pelletCount / columns)
    local pelletsInRow = mathmin(columns, pelletCount - row * columns)
    local centeredCol = col + (columns - pelletsInRow) * 0.5

    local x = columns == 1 and 0 or (centeredCol / (columns - 1) - 0.5) * 2
    local y = rows == 1 and 0 or (row / (rows - 1) - 0.5) * 2
    local length = mathsqrt(x * x + y * y)

    if (length > 1) then
        x = x / length
        y = y / length
    end

    return x / 2, y / 2
end

function LeyHitreg:TraceShotgun(wep, dir)
    if !wep.Primary then return end -- pretty much programmed with reliance on plutonic guns

    local hitboxes = {}
    local hitgroups = {}
    local target
    local targetHitGroup = { group = nil, index = -1 } 
    local targetHitBox = { box = nil, index = -1 }
    local hits = 0
    
    local ang = dir:Angle() + Angle(wep.Primary.Recoil, 0, 0)-- calculate w/o recoil
    local spread = self:GetWeaponSpread(lply, wep)
    spread = Vector(spread, spread, spread)

    --dir = ang:Forward()

    for i = 1, wep.Primary.NumShots do 
        local start = lply:GetShootPos()
        local gridX, gridY = GetShotgunGridCoordinate(i, wep.Primary.NumShots, mathceil(mathsqrt(wep.Primary.NumShots)))
        local pelletDir = dir + (ang:Right() * gridX * spread.x) + (ang:Up() * gridY * spread.y)
        local endpos = start + (pelletDir * 8000)

        local trace = {}
        trace.start = start
        trace.endpos = endpos
        trace.filter = lply
        trace.mask = MASK_SHOT

        local result = util.TraceLine(trace) 
        local entity = result.Entity
        if !result or !result.HitBox or !result.HitGroup then 
            continue 
        end 
        if !entity or (!entity:IsPlayer() and !entity:IsNPC()) then 
            debugoverlay.Axis(result.HitPos, angle_zero, 5, 5, true)
            
            continue  
        end 

        -- i really don't like this...
        hitboxes[result.HitBox] = hitboxes[result.HitBox] or { box = result.HitBox, index = 0 }
        hitgroups[result.HitGroup] = hitgroups[result.HitGroup] or { group = result.HitGroup, index = 0 }

        local hb = hitboxes[result.HitBox]
        hb.index = hb.index + 1

        local hg = hitgroups[result.HitGroup]
        hg.index = hg.index + 1

        hits = hits + 1
        target = entity
    end 

    for i, v in pairs(hitboxes) do 
        if v.index > targetHitBox.index then
            targetHitBox = v
        end
    end 

    for i, v in pairs(hitgroups) do 
        if v.index > targetHitGroup.index then
            targetHitGroup = v
        end
    end 

    return { -- pseudo traceres. not good, but integrates well into current flow
        HitBox = targetHitBox.box,
        HitGroup = targetHitGroup.group,
        Hits = hits,
        Entity = target
    }
end 

local NeedsPrimReset = false

function LeyHitreg:CreateMove(cmd)
    if (not lply or LeyHitreg.Disabled or LeyHitreg.DisabledOnlyOnClient) then
        return
    end

    local spreadWep = lply.LeyHitreg_NeedsSpreadForce

    if (spreadWep and IsValid(spreadWep)) then
        LeyHitreg:SetFittingValidClip(spreadWep)
    end

    if (cmd:CommandNumber() == 0) then
        return
    end

    local cmdAttack1 = cmd:KeyDown(IN_ATTACK)

    if (not cmdAttack1) then
        NeedsPrimReset = false
        return
    elseif (NeedsPrimReset and not cmdAttack1) then
        NeedsPrimReset = false
    end

    local shouldPrimary = self:ShouldPrimaryAttack()

    if (not shouldPrimary) then
        return
    end

    local wep = lply:GetActiveWeapon()

    if (not IsValid(wep)) then
        return
    end

    if (self:IsIgnoreWep(wep)) then
        return
    end

    if (not self:CanShoot(cmd, wep, shouldPrimary)) then
        return
    end

    local primAuto = self:IsAutoWep(wep)
    local shotgun = self:IsShotgun(wep)

    if (NeedsPrimReset and shouldPrimary) then
        return
    end

    if ((not primAuto or shotgun) and shouldPrimary) then
        NeedsPrimReset = true
    end

    if (shouldPrimary) then
        cmd:SetButtons(bitbor(cmd:GetButtons(), IN_LEYHITREG1))
    end

    local viewang = cmd:GetViewAngles()
    local dir = viewang:Forward()

    local weaponSpread = self:GetWeaponSpread(lply, wep)

    if (weaponSpread) then
        local applied, newDir = self:ApplyBulletSpread(lply, wep, dir, weaponSpread)
 
        if (applied) then
            dir = newDir
        end
    else
        -- LocalPlayer():ChatPrint("NO WEAPONSPREAD")
    end

    local traceres = {}

    if wep.Primary and wep.Primary.NumShots and wep.Primary.NumShots > 1 then 
        traceres = self:TraceShotgun(wep, dir)
    else 
        trace.start = lply:GetShootPos()
        trace.endpos = trace.start + (dir * (56756 * 8))
        traceres.Entity = nil
        traceres.HitGroup = nil
        traceres.HitBox = nil

        traceres = util.TraceLine(trace)
    end 

    local target = traceres.Entity 

    if (not IsValid(target) or not (target:IsNPC() or target:IsPlayer())) then
        cmd:SetUpMove(-1)
        if (LeyHitreg.AnnounceClientHits) then
            LocalPlayer():Notify("It's a miss!")
            
            -- PrintTable(trace)
        end
        return
    end

    local hitgroup = traceres.HitGroup
    local hitbox = traceres.HitBox
    local hitbone = target:GetHitBoxBone(hitbox, 0)

    if (not hitbone or not hitgroup) then
        print("[/LeyHitreg/] Bone not found")
        return
    end

    cmd:SetUpMove(target:EntIndex())
    cmd:SetMouseWheel(hitbone)
    cmd:SetMouseX(traceres.Hits or 1)

    if (LeyHitreg.AnnounceClientHits) then
        LocalPlayer():Notify("It's a hit!")
        LocalPlayer():EmitSound("scramble/ui_mp_nukebomb_v1.mp3")
    end
end

hook.Add("CreateMove", "LeyHitreg:CreateMove", function(...)
    LeyHitreg:CreateMove(...)
end)

function LeyHitreg:EntityFireBullets(plyorwep, bullet)
    if (LeyHitreg.Disabled or LeyHitreg.DisabledOnlyOnClient) then
        return
    end

    local ply, wep = self:GetPlayerFromPlyOrBullet(plyorwep, bullet)

    if (not ply) then
        return
    end

    if (not wep or self:IsIgnoreWep(wep)) then
        return
    end

    if (not LeyHitreg.ShotDirForceDisabled) then
        bullet.Dir = ply:GetAimVector()
    end

    local forcedShot = LeyHitreg:FetchSpreadFireBullets(ply, wep, bullet)

    if (forcedShot != nil) then
        return forcedShot
    end

    local ret = LeyHitreg:SpreadedEntityFireBullets(ply, wep, bullet)

    if (ret != nil) then
        return ret
    end
end

hook.Add("EntityFireBullets", "LeyHitreg:EntityFireBullets", function(plyorwep, bullet)
    local ret = LeyHitreg:EntityFireBullets(plyorwep, bullet)

    if (ret != nil) then
        return ret
    end
end)
