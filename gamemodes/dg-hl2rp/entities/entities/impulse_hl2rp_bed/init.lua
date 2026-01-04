AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/hospital_bed01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    self.Occupier=ply
    if IsValid(self.Occupier) then
        self:StartSleep(ply)
        return
    end
end

function ENT:StartSleep(ply)
    if IsValid(self.Vehicle) then
        self.Vehicle:Remove()
    end

    local entPos = self:GetPos()
    local entAng = self:GetAngles()
    local pos = self:GetPos()
    local ang = self:GetAngles()

    pos = pos + (ang:Up() * 2.65)
    pos = pos + (ang:Forward() * -33)
    --pos = pos + (ang:Right() * 9.8)

    ang:RotateAroundAxis(entAng:Forward(), 180)
    ang:RotateAroundAxis(entAng:Right(), 101)

    local ent = ents.Create("prop_vehicle_prisoner_pod")
    ent:SetModel("models/vehicles/prisoner_pod_inner.mdl")
    ent:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetNotSolid(true)
    ent:SetNoDraw(true)

    ent.HandleAnimation = HandleRollercoasterAnimation
    ent:SetParent(self)
    ent:SetCameraDistance(800)
    ent:SetOwner(self)
    ent:Spawn()
    ent:Activate()

    local phys = ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    -- addoutput with PlayerOff

    ply:EnterVehicle(ent)

    ent.SeatData = {
        Ent = self,
        Pos = self:GetPos(),
        EntryPoint = ply:GetPos(),
        EntryAngles = ply:EyeAngles()
    }

    self.Occupier = ply
    self.Vehicle = ent
end

function ENT:Think()
    if IsValid(self.Vehicle) and not IsValid(self.Vehicle:GetPassenger(1)) then
        self.Vehicle:Remove()
        self.Occupier = nil
    end

    self:NextThink(CurTime() + 0.5)
    return true
end