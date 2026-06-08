local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local IsValid   = IsValid
local CurTime   = CurTime
local engine    = engine
local table     = table
local math      = math
local pairs     = pairs

function self:InternalId ()
    return "ChrononLabs:BallisticsProcessor"
end

function self:InitializeModules ()
    self.Operations = ChrononLabs ["ChrononLabs:Operations"]
    self.Plugin 	= ChrononLabs ["ChrononLabs:PluginLoader"]
    self.Management = ChrononLabs ["ChrononLabs:Management"]

    self.Recoil 	= ChrononLabs ["ChrononLabs:RecoilDetector"]
    self.Constants 	= ChrononLabs ["ChrononLabs:Constants"]
    self.Classifier = ChrononLabs ["ChrononLabs:Classifier"]

    self.Vector 	= ChrononLabs ["ChrononLabs:VectorDisruptor"]
end

function self:Constructor ()
	self:InitializeModules ()

	local function GetCurrentSampleTick (ply)
		local inputProcessor = ChrononLabs ["ChrononLabs:InputProcessor"]
		if inputProcessor and inputProcessor.GetPlayerSampleTick then
			return inputProcessor.GetPlayerSampleTick (ply) or 0
		end

		return 0
	end

	local function BuildPlayerSnapshot (ply, tickTime, sequence)
		local eyeAngles = ply:EyeAngles ()
		local viewOffset = ply:GetViewOffset ()
		local aimVector = ply:GetAimVector ()
		local velocity = ply:GetVelocity ()
		local pos = ply:GetPos ()
		local weapon = ply:GetActiveWeapon ()

		local snapshot = {
			tick = (sequence and sequence.temp_data and sequence.temp_data.tick_start or 0) + (tickTime or 0),
			eye_angles_variance = { x = 0, y = 0 },
			mouse_speed = 0,
			player_speed = self.Operations:GaussianNoise (velocity:Length (), 0),
			player_pos_x = self.Operations:GaussianNoise (pos.x, 2),
			player_pos_y = self.Operations:GaussianNoise (pos.y, 2),
			player_pos_z = self.Operations:GaussianNoise (pos.z, 2),
			player_vel_x = self.Operations:GaussianNoise (velocity.x, 2),
			player_vel_y = self.Operations:GaussianNoise (velocity.y, 2),
			player_vel_z = self.Operations:GaussianNoise (velocity.z, 2),
			target_speed = 0,
			target_distance = 0,
			shot_fired = 0,
			shot_hit = 0,
			shot_headshot = 0,
			is_target_in_sight = 0,
			ticks_between_hits = 0,
			is_flick = 0,
			flick_angle = 0,
			snap_amount = ply.snapAmount or 0,
			target_distance_class = 0,
			recoil_compensation_x = 0,
			recoil_compensation_y = 0,
			micro_smoothing_detected_p1 = 0,
			micro_smoothing_detected_r1 = 0,
			micro_smoothing_detected_r2 = 0,
			cmd_tick = 0,
			cmd_number = 0,
			player_ping = ply:Ping (),
			cmd_buttons = 0,
			cmd_side_move = 0,
			cmd_forward_move = 0,
			cmd_mouse_x = 0,
			cmd_mouse_y = 0,
			cmd_up_move = 0,
			key_attack = ply:KeyDown (IN_ATTACK) and 1 or 0,
			key_attack2 = ply:KeyDown (IN_ATTACK2) and 1 or 0,
			key_jump = ply:KeyDown (IN_JUMP) and 1 or 0,
			key_duck = ply:KeyDown (IN_DUCK) and 1 or 0,
			key_forward = ply:KeyDown (IN_FORWARD) and 1 or 0,
			key_back = ply:KeyDown (IN_BACK) and 1 or 0,
			key_left = ply:KeyDown (IN_LEFT) and 1 or 0,
			key_right = ply:KeyDown (IN_RIGHT) and 1 or 0,
			key_moveleft = ply:KeyDown (IN_MOVELEFT) and 1 or 0,
			key_moveright = ply:KeyDown (IN_MOVERIGHT) and 1 or 0,
			key_speed = ply:KeyDown (IN_SPEED) and 1 or 0,
			key_walk = ply:KeyDown (IN_WALK) and 1 or 0,
			key_zoom = ply:KeyDown (IN_ZOOM) and 1 or 0,
			key_reload = ply:KeyDown (IN_RELOAD) and 1 or 0,
			key_use = ply:KeyDown (IN_USE) and 1 or 0,
			key_run = ply:KeyDown (IN_RUN) and 1 or 0,
			key_score = ply:KeyDown (IN_SCORE) and 1 or 0,
			key_cancel = ply:KeyDown (IN_CANCEL) and 1 or 0,
			key_alt1 = ply:KeyDown (IN_ALT1) and 1 or 0,
			key_alt2 = ply:KeyDown (IN_ALT2) and 1 or 0,
			key_weapon1 = ply:KeyDown (IN_WEAPON1) and 1 or 0,
			key_weapon2 = ply:KeyDown (IN_WEAPON2) and 1 or 0,
			key_bullrush = ply:KeyDown (IN_BULLRUSH) and 1 or 0,
			key_grenade1 = ply:KeyDown (IN_GRENADE1) and 1 or 0,
			key_grenade2 = ply:KeyDown (IN_GRENADE2) and 1 or 0,
			eye_pitch = self.Operations:GaussianNoise (eyeAngles.p, 2),
			eye_yaw = self.Operations:GaussianNoise (eyeAngles.y, 2),
			eye_roll = self.Operations:GaussianNoise (eyeAngles.r, 2),
			player_fov = self.Operations:GaussianNoise (ply:GetFOV (), 2),
			view_offset_x = self.Operations:GaussianNoise (viewOffset.x, 3),
			view_offset_y = self.Operations:GaussianNoise (viewOffset.y, 3),
			view_offset_z = self.Operations:GaussianNoise (viewOffset.z, 3),
			is_on_ground = ply:OnGround () and 1 or 0,
			player_crouching = ply:Crouching () and 1 or 0,
			player_health = ply:Health (),
			aim_vector_x = self.Operations:GaussianNoise (aimVector.x, 3),
			aim_vector_y = self.Operations:GaussianNoise (aimVector.y, 3),
			aim_vector_z = self.Operations:GaussianNoise (aimVector.z, 3),
			weapon_next_fire = (function ()
				local next_fire_delta = (IsValid (weapon) and (weapon:GetNextPrimaryFire () - CurTime ())) or 0
				return math.max (next_fire_delta, 0)
			end)(),
			angle_variance = 0,
		}

		return snapshot
	end

	local function EnsureTickData (sequence, weaponOwner, tickTime)
		if sequence.tick_data [tickTime] then
			return sequence.tick_data [tickTime]
		end

		local nearestTick = nil
		for key in pairs (sequence.tick_data) do
			if key <= tickTime and (not nearestTick or key > nearestTick) then
				nearestTick = key
			end
		end

		if nearestTick then
			sequence.tick_data [tickTime] = self.Operations.CloneTickData (sequence.tick_data [nearestTick])
			sequence.tick_data [tickTime].tick = (sequence.temp_data.tick_start or 0) + tickTime
		else
			local history = self.Constants.TickHistory [weaponOwner:SteamID ()]
			if history and history [#history] then
				sequence.tick_data [tickTime] = self.Operations.CloneTickData (history [#history])
				sequence.tick_data [tickTime].tick = (sequence.temp_data.tick_start or 0) + tickTime
			else
				sequence.tick_data [tickTime] = BuildPlayerSnapshot (weaponOwner, tickTime, sequence)
			end
		end

		local tickNow = sequence.tick_data [tickTime]
		tickNow.shot_fired 		= tickNow.shot_fired 	 or 0
		tickNow.shot_hit 		= tickNow.shot_hit 	 or 0
		tickNow.shot_headshot 	= tickNow.shot_headshot or 0

		return tickNow
	end

    self.ProcessBulletFired = function (weaponOwner, bullet)
        if not IsValid (weaponOwner) or not weaponOwner:IsPlayer () or type (weaponOwner) ~= "Player" then
			return
		end

		local Operations = self.Operations
		local GaussianNoise = Operations.GaussianNoise
		local Plugin = self.Plugin
		local Management = self.Management
		local Recoil = self.Recoil
		local Constants = self.Constants
		local Classifier = self.Classifier
		local Vector = self.Vector

        if weaponOwner:HasGodMode () then return end
        if weaponOwner:InVehicle  () then return end
		if weaponOwner:SteamID () == "BOT" then return end

        local weapon = weaponOwner:GetActiveWeapon ()
        if not IsValid (weapon) then return end

        local classification = Plugin:GetWeaponClassifications () [weapon:GetClass ()]

        if classification then
			if Constants.Config.DebugMode then
				weaponOwner:ChatPrint ("This weapon is within the classification.")
			end

            return
        end

        local isHit, trace = Recoil.IsValidHit (weaponOwner, bullet)

        local sequence = Management.ChrononSequence (weaponOwner)
        if not sequence then return end

		local stats = sequence.sequence_stats
		local temp = sequence.temp_data

        stats.total_shots = stats.total_shots + 1
        stats.snap_hit_count = stats.snap_hit_count or 0

        if isHit and IsValid (trace.Entity) and trace.Entity:IsPlayer () then
            local target = trace.Entity

			if not IsValid (target) or type (target) ~= "Player" then
				return
			end

			local timeNow = CurTime ()
			local targetEntIndex = target:EntIndex ()
			local weaponOwnerPos = weaponOwner:GetPos ()
			local targetPos = target:GetPos ()
            local rawDistance = GaussianNoise (Operations, weaponOwnerPos:Distance (targetPos), 2)
            local distanceClass, _ = Classifier.DistanceClassification (rawDistance)

            local distanceR2 = isHit and weaponOwner:GetShootPos ():Distance (bullet.Trace.HitPos) or 0

            local wasVisible = (Recoil.IsTargetInSight(weaponOwner, target) and 1.0 or 0.0)

            local hitInfo = {
                headshot 		= trace.HitGroup == HITGROUP_HEAD,
                distance 		= rawDistance,
                distance_class 	= distanceClass,
                time 			= timeNow,
                target_visible 	= wasVisible,
            }

            local tickTime = math.max (0, GetCurrentSampleTick (weaponOwner) - (sequence.temp_data.tick_start or 0))
            local currentTick = EnsureTickData (sequence, weaponOwner, tickTime)
            if currentTick and currentTick.is_flick then
                stats.flick_hits = (stats.flick_hits or 0) + 1
            end

            if weaponOwner.snapAmount > 2 and distanceR2 > 100 then
                stats.snap_hit_count = stats.snap_hit_count + 1
            end

            stats.hits = stats.hits + 1
            if hitInfo.headshot then
                stats.headshots = stats.headshots + 1
            else
                stats.bodyshots = stats.bodyshots + 1
            end

            local isTrackingHit = false
            if temp.last_target and
               temp.last_target.ent == targetEntIndex and
               (timeNow - temp.last_target.time) < 1.0 then
                isTrackingHit = true
                stats.tracking_hits = stats.tracking_hits + 1
            end

            Operations.UpdateTargetStats (sequence, target, hitInfo)

            temp.distance_class_counts[distanceClass] =
                (temp.distance_class_counts[distanceClass] or 0) + 1

            table.insert (stats.hit_distance_classes, distanceClass)

            local totalClassValue = 0
            local totalHits = 0
            for class, count in pairs (temp.distance_class_counts) do
                totalClassValue = totalClassValue + (class * count)
                totalHits = totalHits + count
            end
            stats.avg_distance_class = totalHits > 0
                and GaussianNoise (Operations, totalClassValue / totalHits, 2)
                or 0

            temp.combat_targets[targetEntIndex] = true
            stats.unique_targets = table.Count (temp.combat_targets)


            if temp.last_target then
                if temp.last_target.ent ~= targetEntIndex then
                    local switchTime = timeNow - temp.last_target.time
                    temp.total_switch_time = (temp.total_switch_time or 0) + switchTime
                    temp.switch_count = (temp.switch_count or 0) + 1


                    if temp.switch_count > 0 then
                        stats.target_switch_speed = GaussianNoise (Operations,
                            temp.total_switch_time / temp.switch_count, 2
                        )
                    end
                end
            end

			if Vector.GetSpeedRatio (target) >= 0.5 then
                temp.continuous_shots = temp.continuous_shots + 1
                if temp.continuous_shots >= Constants.RCSConfig.MaxContinuousShots then
                    stats.continuous_shots_ratio =
                        GaussianNoise (Operations, temp.continuous_shots / stats.total_shots, 3)
                end
            end


            local shooterToTarget = weaponOwnerPos:Distance (targetPos)
            local bulletToTarget = trace.HitPos:Distance (targetPos)
            if math.abs (shooterToTarget - bulletToTarget) > Constants.RCSConfig.ProAimTeleportThreshold then
                temp.teleport_shots = temp.teleport_shots + 1
                stats.teleport_shots_ratio =
                    GaussianNoise (Operations, temp.teleport_shots / stats.total_shots, 3)
            end


            local dist = shooterToTarget
            if dist > Constants.RCSConfig.MinDistForAimChecks then
                if not Recoil.IsCameraVectorAligned (weaponOwner, target) then
                    temp.random_aim_shots = temp.random_aim_shots + 1
                    stats.random_aim_hits_ratio =
                        GaussianNoise (Operations, temp.random_aim_shots / stats.total_shots, 3)
                end
            end

            temp.last_target = {
                ent = targetEntIndex,
                time = timeNow
            }

            local tickNow = currentTick
			local targetVelocity = target:GetVelocity ()
			local targetEyeAngles = target:EyeAngles ()
            tickNow.shot_fired = 1
            tickNow.shot_hit = 1
            tickNow.shot_headshot = hitInfo.headshot and 1 or 0
            tickNow.is_target_in_sight = wasVisible
            tickNow.target_speed = GaussianNoise (Operations, targetVelocity:Length (), 0)
			tickNow.target_distance = rawDistance
            tickNow.target_distance_class = distanceClass
            tickNow.ticks_between_hits = weaponOwner.lastHitTick
                and (tickTime - weaponOwner.lastHitTick)
                or 0

            -- Playback reconstruction: hit event data
            tickNow.hit_group = trace.HitGroup
            tickNow.hit_pos_x = GaussianNoise (Operations, trace.HitPos.x, 2)
            tickNow.hit_pos_y = GaussianNoise (Operations, trace.HitPos.y, 2)
            tickNow.hit_pos_z = GaussianNoise (Operations, trace.HitPos.z, 2)
            tickNow.target_pos_x = GaussianNoise (Operations, targetPos.x, 2)
            tickNow.target_pos_y = GaussianNoise (Operations, targetPos.y, 2)
            tickNow.target_pos_z = GaussianNoise (Operations, targetPos.z, 2)
            tickNow.target_vel_x = GaussianNoise (Operations, targetVelocity.x, 2)
            tickNow.target_vel_y = GaussianNoise (Operations, targetVelocity.y, 2)
            tickNow.target_vel_z = GaussianNoise (Operations, targetVelocity.z, 2)
            tickNow.target_eye_pitch = GaussianNoise (Operations, targetEyeAngles.p, 2)
            tickNow.target_eye_yaw = GaussianNoise (Operations, targetEyeAngles.y, 2)
            tickNow.target_eye_roll = GaussianNoise (Operations, targetEyeAngles.r, 2)
            tickNow.target_model = target:GetModel ()
            tickNow.target_steamid64 = target:SteamID64 ()
            tickNow.target_entindex = targetEntIndex
            tickNow.target_health = target:Health ()
            tickNow.target_crouching = target:Crouching () and 1 or 0
            tickNow.target_on_ground = target:OnGround () and 1 or 0

			-- Track last hit tick for this specific target (for death health update)
			temp.target_last_hit_ticks = temp.target_last_hit_ticks or {}
			temp.target_last_hit_ticks [targetEntIndex] = tickTime

            weaponOwner.lastHitTick = tickTime
        else
            stats.misses = stats.misses + 1

            local tickTime = math.max (0, GetCurrentSampleTick (weaponOwner) - (sequence.temp_data.tick_start or 0))
            local tickNow = EnsureTickData (sequence, weaponOwner, tickTime)
            tickNow.shot_fired = 1
            tickNow.shot_hit = 0
            tickNow.shot_headshot = 0
        end

        stats.accuracy = GaussianNoise (Operations,
            stats.hits / stats.total_shots, 2
        )
    end
end

function self:Destructor ()
	hook.Remove ("PostEntityFireBullets", "ChrononLabs:DriftSequencer")

	self.ProcessBulletFired = function ()
	end

	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
