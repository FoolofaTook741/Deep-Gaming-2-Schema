ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Combine Transporter (HL:A)"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combinetransport_hla.png"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.SpawnNormalOffset = 0

ENT.MDL = "models/ctvehicles/hla/prisoner_transport.mdl"
ENT.GibModels = {
    "models/combine_apc_destroyed_gib02.mdl",
    "models/combine_apc_destroyed_gib03.mdl",
    "models/combine_apc_destroyed_gib04.mdl",
    "models/combine_apc_destroyed_gib05.mdl",
    "models/combine_apc_destroyed_gib06.mdl",
}

ENT.DSArmorIgnoreForce = 0
ENT.CannonArmorPenetration = 9200

ENT.AITEAM = 1
ENT.MaxHealth = 1800
ENT.MaxVelocity = 2000
ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 1
ENT.TransGearsReverse = 1

ENT.EngineSounds = {}

ENT.Lights = {}

// taken from one of the armed vehicles
function ENT:OnSetupDataTables()
    self:AddDT("Float", "LeftDoor")
    self:AddDT("Float", "RightDoor")
end

function ENT:InitWeapons()
    local weapon = {}
    weapon.Icon = Material("lvs/engine.png")
    weapon.Ammo = -1
    weapon.Delay = 1
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.Attack = function(ent)
        self.bDoorsOpen = !self.bDoorsOpen
        self:EmitSound("doors/door_metal_rusty_move1.wav")
        timer.Simple((100 * FrameTime()) * 0.5, function() // gay
            if not ( IsValid(self) ) then
                return
            end

            self:EmitSound(self.bDoorsOpen and "doors/door_metal_large_open1.wav" or "doors/door_metal_large_close2.wav")
        end)
    end
    weapon.OnThink = function(ent, active)
        local Rate = 100 * FrameTime() 
        local Pitch = math.ApproachAngle(self:GetLeftDoor(), self.bDoorsOpen and -90 or 0, Rate)
        local Yaw = math.ApproachAngle(self:GetRightDoor(), self.bDoorsOpen and -90 or 0, Rate)

        self:SetLeftDoor(Pitch)
        self:SetRightDoor(Yaw)

        self:ManipulateBoneAngles(self:LookupBone("l_door"), Angle(0, self:GetLeftDoor(), 0))
        self:ManipulateBoneAngles(self:LookupBone("r_door"), Angle(0, self:GetRightDoor(), 0))
    end

    self:AddWeapon(weapon)
end