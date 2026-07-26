local KEY_BLACKLIST = IN_ATTACK + IN_ATTACK2
local isValid = IsValid
local mathAbs = math.abs

function GM:StartCommand(ply, cmd)
	if not ply:IsWeaponRaised() then
		cmd:RemoveKey(KEY_BLACKLIST)
	end

	if SERVER then
		local dragger = ply.ArrestedDragger

		if isValid(dragger) and ply == dragger.ArrestedDragging and ply:Alive() and dragger:Alive() then
			cmd:ClearMovement()
			cmd:ClearButtons()

			if ply:GetPos():DistToSqr(dragger:GetPos()) > (60 ^ 2) then
				cmd:SetForwardMove(200)
			end

			cmd:SetViewAngles((dragger:GetShootPos() - ply:GetShootPos()):GetNormalized():Angle())
		end
	else
		cmd:RemoveKey(IN_ZOOM)
	end
end

function GM:PlayerSwitchWeapon(ply, oldWep, newWep)
	if SERVER then
		if newWep.QuickDraw and newWep.QuickDraw == true then
			ply:SetWeaponRaised(true)
		else
			ply:SetWeaponRaised(false)
		end
	end
end

function GM:Move(ply, mvData)
	-- alt walk thing based on nutscripts
    if ply:GetMoveType() ~= MOVETYPE_WALK then
        return
    end

    local isWalking = mvData:KeyDown(IN_WALK)
    local broken = false
    local arrested = false

    if not isWalking then
        broken = ply:HasBrokenLegs()

        if not broken then
            return
        end

        arrested = ply:IsArrested()

        if arrested then
            return
        end
    end

    local speed = ply:GetWalkSpeed()
    local forwardRatio = 0
    local sideRatio = 0
    local ratio = impulse.Config.SlowWalkRatio

    if mvData:KeyDown(IN_FORWARD) then
        forwardRatio = ratio
    elseif mvData:KeyDown(IN_BACK) then
        forwardRatio = -ratio
    end

    if mvData:KeyDown(IN_MOVELEFT) then
        sideRatio = -ratio
    elseif mvData:KeyDown(IN_MOVERIGHT) then
        sideRatio = ratio
    end

    mvData:SetForwardSpeed(forwardRatio * speed)
    mvData:SetSideSpeed(sideRatio * speed)
end

hook.Add("ShouldCollide", "Impulse_KnockoutRagdollNoPlayerCollide", function(ent1, ent2)
    if (ent1:GetNWBool("IsKnockoutRagdoll", false) and ent2:IsPlayer())
    or (ent2:GetNWBool("IsKnockoutRagdoll", false) and ent1:IsPlayer()) then
        return false
    end
end)
