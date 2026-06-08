local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local type		= type
local math      = math
local engine    = engine
local table     = table
local player    = player
local util      = util
local isangle   = isangle
local isnumber  = isnumber
local istable   = istable
local IsValid   = IsValid
local Angle     = Angle
local unpack    = unpack
local SysTime   = SysTime
local CurTime   = CurTime
local bit       = bit

local IN_ATTACK 	= IN_ATTACK
local IN_ATTACK2 	= IN_ATTACK2
local IN_JUMP 		= IN_JUMP
local IN_DUCK 		= IN_DUCK
local IN_FORWARD 	= IN_FORWARD
local IN_BACK 		= IN_BACK
local IN_LEFT 		= IN_LEFT
local IN_RIGHT 		= IN_RIGHT
local IN_MOVELEFT 	= IN_MOVELEFT
local IN_MOVERIGHT 	= IN_MOVERIGHT
local IN_SPEED 		= IN_SPEED
local IN_WALK 		= IN_WALK
local IN_ZOOM 		= IN_ZOOM
local IN_RELOAD 	= IN_RELOAD
local IN_USE 		= IN_USE
local IN_RUN 		= IN_RUN
local IN_SCORE 		= IN_SCORE
local IN_CANCEL 	= IN_CANCEL
local IN_ALT1 		= IN_ALT1
local IN_ALT2 		= IN_ALT2
local IN_WEAPON1 	= IN_WEAPON1
local IN_WEAPON2 	= IN_WEAPON2
local IN_BULLRUSH 	= IN_BULLRUSH
local IN_GRENADE1 	= IN_GRENADE1
local IN_GRENADE2 	= IN_GRENADE2
local MASK_SHOT 	= MASK_SHOT

local bor = bit.bor
local band = bit.band

function self:InternalId ()
    return "ChrononLabs:InputProcessor"
end

local function IsButtonDown (buttonMask, keyCode)
	return band (buttonMask, keyCode) ~= 0
end

function self:InitializeModules ()
	self.Operations = ChrononLabs ["ChrononLabs:Operations"]
    self.Vector    	= ChrononLabs ["ChrononLabs:VectorDisruptor"]
    self.Tick      	= ChrononLabs ["ChrononLabs:TickAnalytics"]
	self.Constants 	= ChrononLabs ["ChrononLabs:Constants"]
end

function self:Constructor ()
	self:InitializeModules ()

	self.TARGET_TICKRATE = self.Constants.Config.TargetTickRate or 22
	self.TICK_INTERVAL = self.Constants.Config.TargetTickInterval or (1.0 / self.TARGET_TICKRATE)
	self.INPUT_REFERENCE_CMD_RATE = self.TARGET_TICKRATE
	self.playerSampleState = {}

	local engineTickRate = self.Constants.Config.EngineTickRate or self.TARGET_TICKRATE
	local inputScale = 1
	if self.INPUT_REFERENCE_CMD_RATE > 0 then
		inputScale = engineTickRate / self.INPUT_REFERENCE_CMD_RATE
	end
	self.INPUT_CMD_RATE_SCALE = math.max (0.25, math.min (inputScale, 8))
	self.CMD_SCALE = self.TARGET_TICKRATE / engineTickRate

	self.GetPlayerSampleTick = function (plyOrSteamId)
		local steamId = nil

		if type (plyOrSteamId) == "string" then
			steamId = plyOrSteamId
		elseif IsValid (plyOrSteamId) and plyOrSteamId.SteamID then
			steamId = plyOrSteamId:SteamID ()
		end

		if not steamId then return 0 end

		local state = self.playerSampleState [steamId]
		return (state and state.sampleTick) or 0
	end

    self.ProcessCommand = function (ply, cmd)
        if ply:IsBot () or cmd:IsForced () then return end
        if not IsValid (ply) or not ply:IsPlayer () or type (ply) ~= "Player" or ply:InVehicle () then
			return
		end

		local steamId = ply:SteamID ()
		local currentTime = SysTime ()
		local state = self.playerSampleState [steamId]

		if not state then
			state = {
				nextSampleTime 	= currentTime,
				sampleTick 		= 0,
				cmdTickBase 	= nil,
				cmdNumberBase 	= nil,
				windowMouseX 	= 0,
				windowMouseY 	= 0,
				windowSamples 	= 0,
				windowButtons 	= 0,
				traceFilter 	= { false, false }
			}

			self.playerSampleState [steamId] = state
		end

		local currentButtons = cmd:GetButtons () or 0
		state.windowMouseX = state.windowMouseX + (cmd:GetMouseX () or 0)
		state.windowMouseY = state.windowMouseY + (cmd:GetMouseY () or 0)
		state.windowSamples = state.windowSamples + 1
		state.windowButtons = bor (state.windowButtons, currentButtons)

		if currentTime < state.nextSampleTime then
			return
		end

		state.sampleTick = state.sampleTick + 1
		local sampleTick = state.sampleTick

		state.nextSampleTime = state.nextSampleTime + self.TICK_INTERVAL
		if state.nextSampleTime <= currentTime - self.TICK_INTERVAL then
			state.nextSampleTime = currentTime + self.TICK_INTERVAL
		end

		if state.cmdTickBase == nil then
			state.cmdTickBase = cmd:TickCount ()
		end

		if state.cmdNumberBase == nil then
			state.cmdNumberBase = cmd:CommandNumber ()
		end

		local normalizedCmdTick = math.max (0, math.Round ((cmd:TickCount () - state.cmdTickBase) * self.CMD_SCALE))
		local normalizedCmdNumber = math.max (0, math.Round ((cmd:CommandNumber () - state.cmdNumberBase) * self.CMD_SCALE))
		local windowSamples = state.windowSamples > 0 and state.windowSamples or 1
		local normalizedMouseX = (state.windowMouseX / windowSamples) * self.INPUT_CMD_RATE_SCALE
		local normalizedMouseY = (state.windowMouseY / windowSamples) * self.INPUT_CMD_RATE_SCALE
		local windowButtons = state.windowButtons

		state.windowMouseX = 0
		state.windowMouseY = 0
		state.windowSamples = 0
		state.windowButtons = 0

		local plyTable = ply:GetTable ()
		local Operations = self.Operations
		local GaussianNoise = Operations.GaussianNoise
		local CloneTickData = Operations.CloneTickData

        plyTable.currentEyeAngles = ply:EyeAngles ()
        plyTable.currentMouseX = normalizedMouseX
        plyTable.currentMouseY = normalizedMouseY

        local isFlick, angleDelta = false, 0
        local microSmoothingDetectedP1 = 0
        local microSmoothingDetectedR1 = 0
        local microSmoothingDetectedR2 = 0

        if isangle (plyTable.lastEyeAngles) then
            isFlick, angleDelta = self.Vector.DetectFlick (ply, plyTable.currentEyeAngles, plyTable.lastEyeAngles)

            local pitchDiff = math.NormalizeAngle (plyTable.currentEyeAngles.p - plyTable.lastEyeAngles.p)
            local yawDiff 	= math.NormalizeAngle (plyTable.currentEyeAngles.y - plyTable.lastEyeAngles.y)
            local rollDiff 	= math.NormalizeAngle (plyTable.currentEyeAngles.r - plyTable.lastEyeAngles.r)

            plyTable.eyeDifference = Angle (pitchDiff, yawDiff, rollDiff)

            plyTable.snapAmount = GaussianNoise (Operations, math.abs (pitchDiff) + math.abs (yawDiff) + math.abs (rollDiff), 2)


            local pitchDiffMax 	= math.abs (pitchDiff)
            local yawDiffMax 	= math.abs (yawDiff)

            if pitchDiffMax > 0 and pitchDiffMax < 0.004 then
                microSmoothingDetectedP1 = 1
                if istable (plyTable.activeSequence) then
                    plyTable.activeSequence.sequence_stats.micro_smoothing_counts_p1 =
                        plyTable.activeSequence.sequence_stats.micro_smoothing_counts_p1 + 1
                end
            end

            if yawDiffMax > 0 and yawDiffMax < 0.004 then
                microSmoothingDetectedR1 = 1
                if istable (plyTable.activeSequence) then
                    plyTable.activeSequence.sequence_stats.micro_smoothing_counts_r1 =
                        plyTable.activeSequence.sequence_stats.micro_smoothing_counts_r1 + 1
                end
            end

            if yawDiffMax > 0 and yawDiffMax < 0.02 then
                microSmoothingDetectedR2 = 1
                if istable (plyTable.activeSequence) then
                    plyTable.activeSequence.sequence_stats.micro_smoothing_counts_r2 =
                        plyTable.activeSequence.sequence_stats.micro_smoothing_counts_r2 + 1
                end
            end


            local currentPunch = ply:GetViewPunchAngles ()
            if isangle (currentPunch) and isangle (plyTable.lastPunchAngles) then
                local recoilCompX = pitchDiff + (currentPunch.p - plyTable.lastPunchAngles.p)
                local recoilCompY = yawDiff + (currentPunch.y - plyTable.lastPunchAngles.y)

                plyTable.recoilCompensation = {
                    x = GaussianNoise (Operations, recoilCompX, 2),
                    y = GaussianNoise (Operations, recoilCompY, 2)
                }
            else
                plyTable.recoilCompensation = { x = 0, y = 0 }
            end
            plyTable.lastPunchAngles = currentPunch
        else
            plyTable.snapAmount = 0
            plyTable.recoilCompensation = { x = 0, y = 0 }
        end


        if isnumber (plyTable.lastMouseX) and isnumber (plyTable.lastMouseY) then
            local mouseDX = plyTable.currentMouseX - plyTable.lastMouseX
            local mouseDY = plyTable.currentMouseY - plyTable.lastMouseY
            plyTable.mouseSpeed = math.sqrt (mouseDX * mouseDX + mouseDY * mouseDY)
        end

        local playerVelocity = ply:GetVelocity ()
		local playerPosition = ply:GetPos ()
		local viewOffset = ply:GetViewOffset ()
		local aimVector = ply:GetAimVector ()

        local tickData = {
            tick = sampleTick,
            eye_angles_variance = {
                x = GaussianNoise (Operations, plyTable.eyeDifference and plyTable.eyeDifference.p or 0),
                y = GaussianNoise (Operations, plyTable.eyeDifference and plyTable.eyeDifference.y or 0)
            },
            mouse_speed 			= GaussianNoise (Operations, plyTable.mouseSpeed or 0),
            player_speed 			= GaussianNoise (Operations, playerVelocity:Length (), 0),

            -- Playback reconstruction: player position and velocity vectors
            player_pos_x 			= GaussianNoise (Operations, playerPosition.x, 2),
            player_pos_y 			= GaussianNoise (Operations, playerPosition.y, 2),
            player_pos_z 			= GaussianNoise (Operations, playerPosition.z, 2),
            player_vel_x 			= GaussianNoise (Operations, playerVelocity.x, 2),
            player_vel_y 			= GaussianNoise (Operations, playerVelocity.y, 2),
            player_vel_z 			= GaussianNoise (Operations, playerVelocity.z, 2),
            target_speed 			= 0,
            target_distance 		= 0,
            shot_fired 				= 0,
            shot_hit 				= 0,
            shot_headshot 			= 0,
            is_target_in_sight 		= 0,
            ticks_between_hits 		= 0,
            is_flick 				= isFlick,
            flick_angle 			= GaussianNoise (Operations, angleDelta, 2),
            snap_amount 			= plyTable.snapAmount,
            target_distance_class 	= 0,

            recoil_compensation_x = plyTable.recoilCompensation.x,
            recoil_compensation_y = plyTable.recoilCompensation.y,

            micro_smoothing_detected_p1 = microSmoothingDetectedP1,
            micro_smoothing_detected_r1 = microSmoothingDetectedR1,
            micro_smoothing_detected_r2 = microSmoothingDetectedR2,

			------------------
            cmd_tick 			= normalizedCmdTick,
            cmd_number 			= normalizedCmdNumber,
            player_ping 		= ply:Ping (),
            cmd_buttons 		= windowButtons,
            cmd_side_move 		= cmd:GetSideMove (),
            cmd_forward_move 	= cmd:GetForwardMove (),
			cmd_mouse_x 		= normalizedMouseX,
            cmd_mouse_y 		= normalizedMouseY,
            cmd_up_move 		= cmd:GetUpMove (),

			------------------
            key_attack 		= IsButtonDown		(windowButtons, IN_ATTACK) 		and 1 or 0,
            key_attack2 	= IsButtonDown		(windowButtons, IN_ATTACK2) 	and 1 or 0,
            key_jump 		= IsButtonDown		(windowButtons, IN_JUMP) 		and 1 or 0,
            key_duck 		= IsButtonDown		(windowButtons, IN_DUCK) 		and 1 or 0,
            key_forward 	= IsButtonDown		(windowButtons, IN_FORWARD) 	and 1 or 0,
            key_back 		= IsButtonDown		(windowButtons, IN_BACK) 		and 1 or 0,
            key_left 		= IsButtonDown		(windowButtons, IN_LEFT) 		and 1 or 0,
            key_right 		= IsButtonDown		(windowButtons, IN_RIGHT) 		and 1 or 0,
            key_moveleft 	= IsButtonDown		(windowButtons, IN_MOVELEFT) 	and 1 or 0,
            key_moveright 	= IsButtonDown		(windowButtons, IN_MOVERIGHT) 	and 1 or 0,
            key_speed 		= IsButtonDown		(windowButtons, IN_SPEED) 		and 1 or 0,
            key_walk 		= IsButtonDown		(windowButtons, IN_WALK) 		and 1 or 0,
            key_zoom 		= IsButtonDown		(windowButtons, IN_ZOOM) 		and 1 or 0,
            key_reload 		= IsButtonDown		(windowButtons, IN_RELOAD) 		and 1 or 0,
            key_use 		= IsButtonDown		(windowButtons, IN_USE) 		and 1 or 0,
            key_run 		= IsButtonDown		(windowButtons, IN_RUN) 		and 1 or 0,
            key_score 		= IsButtonDown		(windowButtons, IN_SCORE) 		and 1 or 0,
            key_cancel 		= IsButtonDown		(windowButtons, IN_CANCEL) 		and 1 or 0,
            key_alt1 		= IsButtonDown		(windowButtons, IN_ALT1) 		and 1 or 0,
            key_alt2 		= IsButtonDown		(windowButtons, IN_ALT2) 		and 1 or 0,
            key_weapon1 	= IsButtonDown		(windowButtons, IN_WEAPON1) 	and 1 or 0,
            key_weapon2 	= IsButtonDown		(windowButtons, IN_WEAPON2) 	and 1 or 0,
            key_bullrush 	= IsButtonDown		(windowButtons, IN_BULLRUSH) 	and 1 or 0,
            key_grenade1 	= IsButtonDown		(windowButtons, IN_GRENADE1) 	and 1 or 0,
            key_grenade2 	= IsButtonDown		(windowButtons, IN_GRENADE2) 	and 1 or 0,


			------------------

            eye_pitch 	= GaussianNoise (Operations, plyTable.currentEyeAngles.p, 2),
            eye_yaw 	= GaussianNoise (Operations, plyTable.currentEyeAngles.y, 2),
            eye_roll 	= GaussianNoise (Operations, plyTable.currentEyeAngles.r, 2),

            ------------------
            player_fov 		= GaussianNoise (Operations, ply:GetFOV (), 2),
            view_offset_x 	= GaussianNoise (Operations, viewOffset.x, 3),
            view_offset_y 	= GaussianNoise (Operations, viewOffset.y, 3),
            view_offset_z 	= GaussianNoise (Operations, viewOffset.z, 3),
            is_on_ground 	= ply:OnGround () and 1 or 0,
            player_crouching = ply:Crouching () and 1 or 0,
            player_health 	= ply:Health (),

            ------------------
            aim_vector_x 	= GaussianNoise (Operations, aimVector.x, 3),
            aim_vector_y 	= GaussianNoise (Operations, aimVector.y, 3),
            aim_vector_z 	= GaussianNoise (Operations, aimVector.z, 3),
        }

		local activeWeapon = ply:GetActiveWeapon ()
		local weaponNextFire = 0

		if IsValid (activeWeapon) then
			weaponNextFire = math.max (activeWeapon:GetNextPrimaryFire () - CurTime (), 0)
		end

		local viewAngles = cmd:GetViewAngles ()
		local currentEyeAngles = plyTable.currentEyeAngles

		tickData.weapon_next_fire = weaponNextFire
		tickData.angle_variance = math.sqrt (
			(viewAngles.p - currentEyeAngles.p) ^ 2 +
			(viewAngles.y - currentEyeAngles.y) ^ 2 +
			(viewAngles.r - currentEyeAngles.r) ^ 2
		)


        self.Tick.UpdateTickHistory (ply, tickData)


		local activeSeq = plyTable.activeSequence
		if istable (activeSeq) then
			local shootPos = ply:EyePos ()
			local shootAim = aimVector
			local traceFilter = state.traceFilter

			for _, target in player.Iterator () do
				if target == ply or not target:Alive () then continue end

				local targetPos = target:EyePos ()
				local toTarget = targetPos - shootPos
				local distance = toTarget:Length ()

				if distance < 1500 then continue end

				local directionToTarget = toTarget:GetNormalized ()
				local aimDot = shootAim:Dot (directionToTarget)

				-- (0.1 degree tolerance)
				if aimDot < 0.99995 then continue end
				
				traceFilter [1] = ply
				traceFilter [2] = target

				local tr = util.TraceLine({
					start = shootPos,
					endpos = targetPos,
					filter = traceFilter,
					mask = MASK_SHOT
				})

				if tr.Entity ~= target then
					if distance > 4000 then
						activeSeq.sequence_stats.esp_long_range_hits =
							activeSeq.sequence_stats.esp_long_range_hits + 1
					elseif distance > 1500 then
						activeSeq.sequence_stats.esp_medium_range_hits =
							activeSeq.sequence_stats.esp_medium_range_hits + 1
					end
				end
			end
		end

        if istable (activeSeq) then
            local sequence = activeSeq
            local temp = sequence.temp_data


            temp.total_ticks = (temp.total_ticks or 0) + 1


            temp.mouse_movements.x = temp.mouse_movements.x + normalizedMouseX
            temp.mouse_movements.y = temp.mouse_movements.y + normalizedMouseY
            temp.mouse_movements.samples = temp.mouse_movements.samples + 1


            if temp.mouse_movements.samples > 0 then
                sequence.sequence_stats.avg_mouse_speed = {
                    x = GaussianNoise (Operations, temp.mouse_movements.x / temp.mouse_movements.samples),
                    y = GaussianNoise (Operations, temp.mouse_movements.y / temp.mouse_movements.samples)
                }
            end


            local tickNow = sampleTick - (sequence.temp_data.tick_start or 0)
			if tickNow < 0 then
				tickNow = 0
			end

            sequence.tick_data[tickNow] = CloneTickData (tickData)


            if plyTable.recoilCompensation then
                table.insert (temp.recoil_compensation.x, plyTable.recoilCompensation.x)
                table.insert (temp.recoil_compensation.y, plyTable.recoilCompensation.y)
            end
        end

        plyTable.lastEyeAngles = plyTable.currentEyeAngles
        plyTable.lastMouseX = plyTable.currentMouseX
        plyTable.lastMouseY = plyTable.currentMouseY
    end
end


function self:Destructor ()
	hook.Remove ("StartCommand", "ChrononLabs:CmdPipeLineHandler")

	self.playerSampleState = {}

	self.ProcessCommand = function ()
	end

	self.GetPlayerSampleTick = function ()
		return 0
	end

	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
