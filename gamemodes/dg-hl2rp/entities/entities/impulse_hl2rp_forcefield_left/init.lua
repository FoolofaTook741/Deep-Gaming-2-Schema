AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local IsCurfew = false 
local FFStatus = false 

function ENT:ChangeForcefieldStatus(status)
	status = tobool(status)
	self:SetFFStatus(status)
	FFStatus = status
	--print(status)
end

function ENT:SpawnFunction(client, trace)
	local angles = (client:GetPos() - trace.HitPos):Angle()
	angles.p = 0
	angles.r = 0
	angles:RotateAroundAxis(angles:Up(), 270)

	local entity = ents.Create("impulse_hl2rp_forcefield_left")
	entity:SetPos(trace.HitPos + Vector(0, 0, 40))
	entity:SetAngles(angles:SnapTo("y", 180))
	entity:Spawn()

	return entity
end

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_fence01b.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self.ForcefieldStatus = false 
	self:SetFFStatus(false)
	self:SetSkin(1)
	local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion(false)
    end

	local data = {}
		data.start = self:GetPos() + self:GetRight()*-16
		data.endpos = self:GetPos() + self:GetRight()*-480
		data.filter = self
	local trace = util.TraceLine(data)

	local angles = self:GetAngles()
	angles:RotateAroundAxis(angles:Up(), 180)
    if self.dummy then self.dummy:Remove() end
    timer.Simple(0.5, function()
        self.dummy = ents.Create("prop_physics")
        self.dummy:SetModel(self:GetModel())
        self.dummy:SetPos(trace.HitPos)
        self.dummy:SetAngles(angles)
        self.dummy:Spawn()
        --self:DeleteOnRemove(self.dummy)
		self.dummy:SetSkin(1)
		self.dummy.IsForcefieldEnd = self

        local verts = {
            {pos = Vector(0, 0, -25)},
            {pos = Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
            {pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)},
            {pos = Vector(0, 0, -25)},
        }

        self:PhysicsFromMesh(verts)
        self:SetCustomCollisionCheck(true)
        self:EnableCustomCollisions(true)
        self:SetStage(self.dummy:EntIndex())

        local physObj = self:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        physObj = self.dummy:GetPhysicsObject()

        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end

        self:SetMoveType(MOVETYPE_NOCLIP)
        self:SetMoveType(MOVETYPE_PUSH)
        self:MakePhysicsObjectAShadow()
    end)
end

function ENT:Use(activator)
	if activator:Team() == TEAM_CP and activator:GetTeamClass() == CLASS_GRID and activator:GetTeamRank() >= RANK_I3 and self.ForcefieldStatus == false then
		self:ChangeForcefieldStatus(true)
		self.ForcefieldStatus = true
	elseif activator:Team() == TEAM_CP and activator:GetTeamClass() == CLASS_GRID and activator:GetTeamRank() >= RANK_I3 and self.ForcefieldStatus == true then
		self:ChangeForcefieldStatus(false)
		self.ForcefieldStatus = false
	end
end

function ENT:OnRemove()
    if self.dummy then
        self.dummy:Remove()
    end
end

hook.Add("ShouldCollide", "impulse_hl2rp_forcefield_left", function(a, b)
	local client
	local entity

	if (a:IsPlayer()) then
		client = a
		entity = b
	elseif (b:IsPlayer()) then
		client = b
		entity = a
	elseif (a:GetClass() == "gmod_sent_vehicle_fphysics_wheel") then
		return false
	elseif (b:GetClass() == "gmod_sent_vehicle_fphysics_wheel") then
		return false
	elseif (a:GetClass() == "gmod_sent_vehicle_fphysics_base") then
		return false
	elseif (b:GetClass() == "gmod_sent_vehicle_fphysics_base") then
		return false
	else
		if (a:GetClass() == "impulse_hl2rp_forcefield_left") then
			return a:GetFFStatus() and not a:GetFFEMP() 
		else
			return true
		end
	end

	if (IsValid(entity) and entity:GetClass() == "impulse_hl2rp_forcefield_left") then
		if (IsValid(client)) then
			if (client:IsCP() or client.ArrestedDragger or (client:Team() == TEAM_CWU and client:GetTeamClass())) or client:IsVehicle() then
				return false
			end

			return entity:GetFFStatus() and not entity:GetFFEMP() 
		else
			return false
		end
	end
end)

impulse.Forcefields = impulse.Forcefields or {}
local cityCode = impulse.Dispatch.GetCityCode()

function ENT:KeyValue(key, value)
	if key ~= "identifier" then return end

	self:SetForcefieldName(value)
	impulse.Forcefields[value] = self
end

function ENT:GetFFName()
	return self.FFName
end

hook.Add("KeyPress", "ImpulseForcedUse", function(client, key)
end)