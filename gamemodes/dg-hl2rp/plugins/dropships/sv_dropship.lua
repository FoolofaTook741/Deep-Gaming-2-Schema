DROPSHIP_TROOPS = DROPSHIP_TROOPS or {}
function MakeDropship(cName, startpos, startang, trackpos, endpos, god, s_smg, s_ar2, s_shotgun, s_elite)
	if DROPSHIP_TROOPS[cName] then
		local t = DROPSHIP_TROOPS[cName]

		for v,k in pairs(t) do
			if IsValid(k) then
				k:Remove()
			end
		end

		DROPSHIP_TROOPS[cName] = nil
	end

	DROPSHIP_TROOPS[cName] = {}

	local ship = ents.Create("npc_combinedropship")
	ship:SetPos(startpos)
	ship:SetAngles(startang)
	ship:SetKeyValue("squadname", "overwatch")
	ship:SetKeyValue("GunRange", "3000")
	ship:SetKeyValue("CrateType", "1")
	ship:Spawn()
	ship:Activate()

	ship:SetHealth(100)
	ship:SetMaxHealth(100)
	ship:CapabilitiesAdd(CAP_MOVE_FLY)
	ship:CapabilitiesAdd(CAP_SQUAD)

	local shipName = "Dropship"..ship:EntIndex()

	ship:SetName(shipName)

	local min, max = ship:GetCollisionBounds()
	local hull = ship:GetHullType()
	local id = ship:EntIndex()

	ship:SetSolid(SOLID_BBOX)
	ship:SetCollisionGroup(COLLISION_GROUP_NPC)
	ship:SetMoveType(MOVETYPE_FLY)

	if god then
		ship:SetKeyValue("Invunerable", "1")
	else
		ship:SetKeyValue("Invunerable", "0")
	end

	ship:SetKeyValue("spawnflags", "32768")
	ship.SquadDeploying = false

	for v,k in pairs(player.GetAll()) do
		if k.GetMoveType(k) == MOVETYPE_NOCLIP then
			ship:AddEntityRelationship(k, D_NU, 99)
		end
	end

	local flyTrackName = "DropshipTrackFly"..id

	local flyTrack3 = ents.Create("path_track")
	flyTrack3:SetName(flyTrackName.."3")
	flyTrack3:SetPos(startpos)

	flyTrack3:Fire("AddOutput", "OnPass "..shipName..",kill")

	local flyTrack2
	local flyTrack2r

	if trackpos then
		flyTrack2 = ents.Create("path_track")
		flyTrack2:SetName(flyTrackName.."2")
		flyTrack2:SetPos(trackpos)

		flyTrack2:Fire("AddOutput", "OnPass "..shipName..":flytospecifictrackviapath:"..flyTrackName..":0:1")

		flyTrack2r = ents.Create("path_track")
		flyTrack2r:SetName(flyTrackName.."2r")
		flyTrack2r:SetPos(trackpos)

		flyTrack2r:Fire("AddOutput", "OnPass "..shipName..",flytospecifictrackviapath,"..flyTrackName.."3,0,1")
	end

	local flyTrack = ents.Create("path_track")

	flyTrack:SetName(flyTrackName)
	flyTrack:SetPos(Vector(endpos.x, endpos.y, endpos.z + 450))

	if trackpos then
		ship:Fire("flytospecifictrackviapath", flyTrackName.."2")
	else
		ship:Fire("flytospecifictrackviapath", flyTrackName)
	end

	ship.FlyZoneReady = true
	ship.AtFlyZone = false

	local container

	for v,k in pairs(ship:GetChildren()) do
		if k:GetClass() == "prop_dropship_container" then
			ship.Container = k
			container = k
		end
	end

	local landTrack = ents.Create("scripted_target")
	local landTrackName = "DropshipTrackLand"..id
	landTrack:SetPos(endpos)
	landTrack:SetNotSolid(true)
	landTrack:SetNoDraw(true)
	landTrack:Spawn()
	landTrack:Activate()
	landTrack:SetName(landTrackName)

	local returnPath1 = flyTrackName.."3"
	if trackpos then
		returnPath1 = flyTrackName.."2r"
	end

	ship:Fire("AddOutput", "OnFinishedDropoff "..shipName..",flytospecifictrackviapath,"..returnPath1..",0,1")

	local timerName = "dropship"..id.."Think"

	local function Cleanup()
		if IsValid(ship) then
			ship:Remove()
		end

		if IsValid(flyTrack) then
			flyTrack:Remove()
		end

		if IsValid(flyTrack2) then
			flyTrack2:Remove()
		end

		if IsValid(flyTrack3) then
			flyTrack3:Remove()
		end

		if IsValid(flyTrack2r) then
			flyTrack2r:Remove()
		end

		if IsValid(landTrack) then
			landTrack:Remove()
		end

		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
	end

	ship:CallOnRemove("pathCleaner", function()
		Cleanup()
	end)

	local weps = {
		["shotgun"] = "weapon_shotgun",
		["smg"] = "weapon_smg1",
		["ar2"] = "weapon_ar2",
		["elite"] = "weapon_ar2"
	}

	local function SpawnTroops()
		local c = (s_shotgun or 0) + (s_smg or 0) + (s_ar2 or 0) + (s_elite or 0)

		local shot_spawned = 0
		local smg_spawned = 0
		local ar2_spawned = 0
		local elite_spawned = 0

		local time = 0
		local side = (c * .5) * -70

		ship.TroopsDeploying = true

		for i=1, c do
			local t = ""
			if shot_spawned < s_shotgun then
				t = "shotgun"
				shot_spawned = shot_spawned + 1
			elseif smg_spawned < s_smg then
				t = "smg"
				smg_spawned = smg_spawned + 1
			elseif ar2_spawned < s_ar2 then
				t = "ar2"
				ar2_spawned = ar2_spawned + 1
			elseif elite_spawned < s_elite then
				t = "elite"
				elite_spawned = elite_spawned + 1
			end

			if t == "" then
				break
			end

			timer.Simple(time, function()
				if IsValid(container) then
					local pos = container:GetPos() + container:GetForward() * -26 + container:GetUp() * -36
					local soldier = ents.Create("npc_combine_s")
					soldier:SetPos(pos)

					if t == "elite" then
						soldier:SetKeyValue("model", "models/combine_super_soldier.mdl")
					end

					soldier:SetKeyValue("spawnflags", "644")
					soldier:SetKeyValue("squadname", shipName.."Squad")
					soldier:SetKeyValue("spawnflags", soldier:GetSpawnFlags() + SF_NPC_NO_WEAPON_DROP)
					soldier:Give(weps[t])
					soldier:Spawn()
					soldier:Activate()

					table.insert(DROPSHIP_TROOPS[cName], soldier)

					local name = shipName.."Troop"..soldier:EntIndex()
					soldier:SetName(name)

					soldier.SequencePlayed = false

					local seq = ents.Create("scripted_sequence")
					seq:SetName(name.."_wake_seq")
					seq:SetKeyValue("spawnflags", "624")
					seq:SetKeyValue("m_iszEntity", name)
					seq:SetKeyValue("m_iszIdle", "idle1")
					seq:SetKeyValue("m_fMoveTo", "4")
					seq:SetKeyValue("m_iszPlay", "Dropship_Deploy")
					seq:SetPos(pos)
					seq:Spawn()
					seq:Activate()
					seq:SetParent(soldier)

					seq:Fire("BeginSequence", "", 0)

					soldier.SequencePlayed = true

					for v,k in pairs(player.GetAll()) do
						if k.GetMoveType(k) == MOVETYPE_NOCLIP then
							soldier:AddEntityRelationship(k, D_NU, 99)
						elseif k:IsCP() then
							soldier:AddEntityRelationship(k, D_LI, 99)
						end
					end

					timer.Simple(2.6666666666667, function()
						if IsValid(container) and IsValid(soldier) and not soldier:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
							side = side + math.random(60, 95)
							local pos = container:GetPos() + container:GetForward() * 350 + container:GetRight() * side

							soldier:ExitScriptedSequence()
							soldier:SetLastPosition(pos)
							soldier:SetSchedule(SCHED_FORCED_GO_RUN)
						end
					end)
				end
			end)

			time = time + 3
		end

		timer.Simple(time + 3, function()
			if IsValid(container) then
				for v,k in pairs(DROPSHIP_TROOPS[cName]) do
					if IsValid(k) then
						k:Fire("StartPatrolling")
					end
				end

				container:Remove()
			end
		end)
	end


	timer.Create(timerName, 1, 0, function()
		if IsValid(ship) and ship.GettingReadyToLand and ship:GetPos():DistToSqr(startpos) < (70 ^ 2) then
			Cleanup()
		end

		if IsValid(ship) and ship.GettingReadyToLand and IsValid(container) then
			if container:GetSequence() == container:LookupSequence("open_idle") and not ship.TroopsDeploying then
				SpawnTroops()
			end
		end

		if IsValid(ship) and IsValid(flyTrack) and ship:GetPos():DistToSqr(flyTrack:GetPos()) < (70 ^ 2) then
			ship.AtFlyZone = true

			if not ship.GettingReadyToLand and ship.AtFlyZone then
				ship.GettingReadyToLand = true

				ship:Fire("SetLandTarget", landTrackName)
				ship:Fire("StopWaitingForDropoff")

				if not ship.Landing then
					ship:Fire("LandLeaveCrate", 10)
					ship:SetCollisionGroup(COLLISION_GROUP_VEHICLE_CLIP)
				end
			end
		else
			ship.AtFlyZone = false

			if not IsValid(ship) then
				Cleanup()
			end
		end
	end)

	for v,k in pairs(player.GetAll()) do
		if k:IsCP() or k:GetMoveType() == MOVETYPE_NOCLIP then
			ship:AddEntityRelationship(k, D_LI, 99)
		end
	end

	return ship
end