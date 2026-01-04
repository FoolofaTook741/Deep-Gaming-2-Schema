util.AddNetworkString("impulseHL2RPCameraAlert")
util.AddNetworkString("impulseHL2RPCameraBroken")
util.AddNetworkString("impulseHL2RPCameraView")

local entMeta = FindMetaTable("Entity")

impulse.Dispatch = impulse.Dispatch or {}
impulse.Dispatch.Cameras = impulse.Dispatch.Cameras or {}
local CAM_ID = CAM_ID or 1

function entMeta:SetupCombineCamera()
	if not IsValid(DISPATCH_FINDER) then
		DISPATCH_FINDER = ents.Create("base_entity")
		DISPATCH_FINDER:SetName("__cctvhook")
		
		function DISPATCH_FINDER:AcceptInput(name, ply, camera, data)
			if data == "OnFoundPlayer" then
				if impulse.Dispatch.Cameras[camera] and ply.GetMoveType(ply) != MOVETYPE_NOCLIP then
					if not impulse.Dispatch.Cameras[camera][ply] then
						impulse.Dispatch.Cameras[camera][ply] = {}
					end
				end
			end
		end

		DISPATCH_FINDER:Spawn()
		DISPATCH_FINDER:Activate()
	end

	local values = self:GetKeyValues()
	self:SetKeyValue("innerradius", values.outerradius) -- remove the outer/inner radius thing cuz its kinda pointless
	self:Fire("addoutput", "OnFoundPlayer __cctvhook:cctv:OnFoundPlayer:0:-1")

	self:CallOnRemove("impulseCamSyncRemove", function(ent)
     	ent:SyncRemove()
    end)

	impulse.Dispatch.Cameras[self] = {}

	self.CamID = self.CamID or CAM_ID
	self:SetSyncVar(SYNC_CAM_CAMID, self.CamID, true)
	CAM_ID = CAM_ID + 1
end

function entMeta:RepairCombineCamera()
	if not impulse.Dispatch.Cameras[self] then
		return
	end

	impulse.Dispatch.Cameras[self] = nil

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local camid = self.CamID
	local values = self:GetKeyValues()
	local iSaveEnt = self.impulseSaveEnt
	local iSaveData = self.impulseSaveKeyValue

	self:Remove()

	local new = ents.Create("npc_combine_camera")
	new:SetPos(pos)
	new:SetAngles(ang)
	new.CamID = camid
	new:Spawn()
	new:Activate()

	new:CallOnRemove("impulseCamSyncRemove", function(ent)
     	ent:SyncRemove()
    end)

	new:SetSyncVar(SYNC_CAM_CAMID, camid, true)
	new:SetKeyValue("innerradius", values.outerradius)
	new:SetKeyValue("outerradius", values.outerradius)

	new:Fire("addoutput", "OnFoundPlayer __cctvhook:cctv:OnFoundPlayer:0:-1")

	impulse.Dispatch.Cameras[new] = {}

	new.impulseSaveEnt = iSaveEnt
	new.impulseSaveKeyValue = iSaveData

	return new
end

local IsValid = IsValid
local range = 450 ^ 2
local nextScan = 0
local ctime = CurTime
local function CameraTick()
	local c = ctime()

	if nextScan > c then
		return
	end

	for v,k in pairs(impulse.Dispatch.Cameras) do
		if not IsValid(v) then
			impulse.Dispatch.Cameras[v] = nil
			continue
		end

		if not v:IsCameraEnabled() then
			v.RespawnTime = v.RespawnTime or (c + impulse.Config.CameraRepairTime)

			if not v.IveBrokenDown then
				timer.Simple(60, function()
					if not IsValid(v) then
						return
					end

					local rf = RecipientFilter()
					
					for v,k in pairs(team.GetPlayers(TEAM_CP)) do
						if k:GetTeamClass() == CLASS_GRID then
							rf:AddPlayer(k)
						end
					end

					net.Start("impulseHL2RPCameraBroken")
					net.WriteEntity(v)
					net.WriteUInt(v.CamID, 8)
					net.Send(rf)
				end)

				v.IveBrokenDown = true
			end

			if c > v.RespawnTime then
				v.RespawnTime = nil
				v:RepairCombineCamera()
			end

			continue
		end 

		local pos = v.GetPos(v)

		for ply,info in pairs(k) do
			if not IsValid(ply) or not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then
				info[ply] = nil
				continue
			end

			if pos.DistToSqr(pos, ply.GetPos(ply)) > range or not v.IsLineOfSightClear(v, ply) then
				k[ply] = nil
			else
				local violations = {}
				local isCrime, idKnown, crimes, firstCrime = ply.IsRebelSmart(ply)

				if isCrime then
					if not info.Detected then
						v:SetTarget(ply)
						v:Fire("SetAngry")

						if c > (v.NextPing or 0) then
							timer.Simple(2, function()
								if not IsValid(v) then
									return
								end

								v:Fire("SetIdle")

								if not IsValid(ply) then
									v.HasPinged = nil
									return
								end

								if firstCrime == CRIME_BOL and ply:IsDispatchBOL() then
									ply:ChangeDispatchBOLTime(impulse.Config.DefaultBOLTime)
								end

								local rf = RecipientFilter()
								rf:AddRecipientsByTeam(TEAM_CP)
								-- rf:AddAllPlayers() -- REMOVE BEFORE UPDATING LIVE SERVER

								net.Start("impulseHL2RPCameraAlert")
								net.WriteVector(ply:GetPos())
								net.WriteUInt(v.CamID, 8)
								net.WriteUInt(firstCrime, 8)
								net.WriteEntity(ply)
								net.WriteEntity(v) -- write the camera for HITMAN 2 style caught in 4k (8k (16k))
								net.Send(rf)
							end)

							v.NextPing = c + 60
						end

						k[ply].Detected = true
					end

					if idKnown then
						local camid = v.CamID
						local changed = false
						ply.DetectedCrimes = ply.DetectedCrimes or {}

						for a,b in pairs(crimes) do
							if not ply.DetectedCrimes[a] then
								ply.DetectedCrimes[a] = camid
								changed = true
							end
						end

						if changed then
							-- network changes to what crimes have been done
						end
					end
				end
			end
		end		
	end

	nextScan = c + 1
end

hook.Add("Think", "impulseDispatchCameraScan", CameraTick)

local function loadCams()
	for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
		if not impulse.Dispatch.Cameras[k] then
			k:SetupCombineCamera()
		end
	end
end

hook.Add("PostInitPostEntity", "impulseDispatchLoadCameras", loadCams)
hook.Add("PostLoadSaveEnts", "impulseDispatchLoadCameras2", loadCams)

net.Receive("impulseHL2RPCameraView", function(len, ply)
	if (ply.nextCamView or 0) > CurTime() then return end
	ply.nextCamView = CurTime() + 1

	if not ply:Alive() then
		return
	end
	
	if not ply:IsCP() then
		return
	end

	if not IsValid(ply.Terminal) then
		return
	end

	local camera = net.ReadEntity()

	if not IsValid(camera) then
		return
	end

	if camera:GetClass() != "npc_combine_camera" then
		return
	end

	if not camera.CamID then
		return
	end

	ply.extraPVS = camera:GetAttachment(1).Pos
end)