AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

include("entities/lvs_base_fighterplane/sv_wheels.lua")

-- override function, because hooks dont work for some reason
function ENT:SetPassenger(client)
	if not IsValid(client) then return end
	if client:GetMoveType() != MOVETYPE_NOCLIP and not self:GetDoor() and not client:InVehicle() then
		self:EmitSound("doors/default_locked.wav")
		client:PrintMessage(HUD_PRINTCENTER, "The door is closed, you must be noclipped or the door must be open to enter!")
		return
	end

	local AI = self:GetAI()
	local DriverSeat = self:GetDriverSeat()
	local AllowedToBeDriver = hook.Run("LVS.CanPlayerDrive", client, self) != false
	if IsValid(DriverSeat) and not IsValid(DriverSeat:GetDriver()) and not client:KeyDown(IN_WALK) and not AI and AllowedToBeDriver then
		client:EnterVehicle(DriverSeat)
	else
		local Seat = NULL
		local Dist = 500000
		for _, v in pairs(self:GetPassengerSeats()) do
			if not IsValid(v) or IsValid(v:GetDriver()) then continue end
			if v:GetNWInt("pPodIndex") == -1 then continue end
			local cDist = (v:GetPos() - client:GetPos()):Length()
			if cDist < Dist then
				Seat = v
				Dist = cDist
			end
		end

		if IsValid(Seat) then
			client:EnterVehicle(Seat)
		else
			if IsValid(DriverSeat) then
				if not IsValid(self:GetDriver()) and not AI then
					if AllowedToBeDriver then
						client:EnterVehicle(DriverSeat)
					else
						hook.Run("LVS.OnPlayerCannotDrive", client, self)
					end
				end
			else
				self:EmitSound("doors/default_locked.wav")
				client:PrintMessage(HUD_PRINTCENTER, "No available seats!")
			end
		end
	end
end

local passengerSeats = {{Vector(-30, -20, 0), Angle(0, 0, 0)}, {Vector(0, -20, 0), Angle(0, 0, 0)}, {Vector(30, -20, 0), Angle(0, 0, 0)}, {Vector(60, -20, 0), Angle(0, 0, 0)}, {Vector(-30, 20, 0), Angle(0, 180, 0)}, {Vector(0, 20, 0), Angle(0, 180, 0)}, {Vector(30, 20, 0), Angle(0, 180, 0)}, {Vector(60, 20, 0), Angle(0, 180, 0)}}
function ENT:OnSpawn(PObj)
	local DriverSeat = self:AddDriverSeat(Vector(100, 50, 0), Angle(0, -90, 0))
	DriverSeat:SetCameraDistance(0.5)
	DriverSeat.HidePlayer = true
	DriverSeat.ExitPos = Vector(125, 0, 0)
	for k, v in pairs(passengerSeats) do
		local PassengerSeat = self:AddPassengerSeat(v[1], v[2])
		PassengerSeat.ExitPos = Vector(125, 0, 0)
	end

	self:AddWheel(Vector(-200, 0, -40), 16, 50)
	self:AddWheel(Vector(75, 50, -40), 16, 50)
	self:AddWheel(Vector(75, -50, -40), 16, 50)
	self:AddEngineSound(Vector(0, 0, 50))
	self:DrawShadow(false)
	local Body = ents.Create("lvs_dropship_body")
	Body:SetPos(self:GetPos())
	Body:SetAngles(self:GetAngles())
	Body:Spawn()
	Body:Activate()
	Body:SetParent(self)
	Body:SetSkin(1)
	Body:PlayAnimation("cargo_idle")
	self:DeleteOnRemove(Body)
	self:TransferCPPI(Body)
	self:SetBody(Body)
	local Rotor = self:AddRotor(Vector(-133, 0, 55), Angle(0, 0, 0), 0, 4000)
	Rotor:SetRotorEffects(true)
	local ID = self:LookupAttachment("Muzzle")
	local Muzzle = self:GetAttachment(ID)
	self.weaponSND = self:AddSoundEmitter(self:WorldToLocal(Muzzle.Pos), "npc/combine_gunship/gunship_fire_loop1.wav")
	self.weaponSND:SetSoundLevel(110)
	self.weaponSND:SetParent(self, ID)
end

function ENT:OnRemoved()
	if self.deploySound then
		self.deploySound:Stop()
		self.deploySound = nil
	end
end

function ENT:OnTick()
	self:AnimBody()
end

function ENT:AnimBody()
	local PhysObj = self:GetPhysicsObject()
	if not IsValid(PhysObj) then return end
	local Body = self:GetBody()
	if not IsValid(Body) then return end
	local FT = FrameTime()
	local LocalAngles = self:WorldToLocalAngles(self:GetAimVector():Angle())
	local VelL = self:WorldToLocal(self:GetPos() + self:GetVelocity())
	local AngVel = PhysObj:GetAngleVelocity()
	local Steer = self:GetSteer()
	self._smLocalAngles = self._smLocalAngles and self._smLocalAngles + (LocalAngles - self._smLocalAngles) * FT * 4 or LocalAngles
	self._smVelL = self._smVelL and self._smVelL + (VelL - self._smVelL) * FT * 10 or VelL
	self._smAngVel = self._smAngVel and self._smAngVel + (AngVel - self._smAngVel) * FT * 10 or AngVel
	self._smSteer = self._smSteer and self._smSteer + (Steer - self._smSteer) * FT * 0.2 or Steer
	Body:SetPoseParameter("flex_vert", self._smSteer.y * 10 + self._smLocalAngles.p * 0.5)
	Body:SetPoseParameter("flex_horz", self._smAngVel.z * 0.25 - self._smSteer.x * 10 + self._smLocalAngles.y * 0.5)
	Body:SetPoseParameter("fin_accel", self._smVelL.x * 0.0015 + self._smSteer.y * 2 + self._smVelL.z * 0.008)
	Body:SetPoseParameter("fin_sway", -self._smVelL.y * 0.007 - self._smSteer.x * 5)
	if not self.cargo_body_accel then self.cargo_body_accel = 0 end
	if self:GetDeploying() then
		self.cargo_body_accel = math.Approach(self.cargo_body_accel, -1, FT)
	else
		self.cargo_body_accel = math.Approach(self.cargo_body_accel, self._smVelL.x * 0.0015, FT)
	end

	Body:SetPoseParameter("cargo_body_accel", self.cargo_body_accel)
	Body:SetPoseParameter("cargo_body_sway", -self._smVelL.y * 0.0025)
	--Body:SetPoseParameter("cargo_body_accel", self:GetDeploying() and 0 or accel)
	--Body:SetPoseParameter("cargo_body_sway", sway)
end
