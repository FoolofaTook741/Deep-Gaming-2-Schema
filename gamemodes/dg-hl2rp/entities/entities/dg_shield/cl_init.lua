include("shared.lua")

local SHIELD_MODEL = "models/hunter/tubes/circle4x4.mdl"
local SHIELD_MAT   = "effects/bluelaser2"
local SHIELD_SCALE = 0.55

local POS_LERP_RATE = 22
local ANG_LERP_RATE = 22

function ENT:Initialize()
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetColor(Color(255, 255, 255, 0))
    self:DrawShadow(false)

    self._vis = ClientsideModel(SHIELD_MODEL, RENDERGROUP_TRANSLUCENT)
    if IsValid(self._vis) then
        self._vis:SetNoDraw(true)
        self._vis:SetMaterial(SHIELD_MAT)
        self._vis:SetModelScale(SHIELD_SCALE, 0)
    end

    local p = self:GetPos()
    local a = self:GetAngles()
    self._smoothPos = p
    self._smoothAng = a
    self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))

end

function ENT:OnRemove()
    if IsValid(self._vis) then self._vis:Remove() end
end

function ENT:Think()
    if not IsValid(self._vis) then return true end

    local owner = self:GetNWEntity("dg_shield_owner")
    if not IsValid(owner) then return true end

    local ang = owner:EyeAngles()
    ang.p = 0
    local forward = ang:Forward()

    local z = owner:Crouching() and 25 or 40
    local targetPos = owner:GetPos() + forward * 52 + Vector(0, 0, z)
    local targetAng = Angle(90, ang.y, 0)

    local ft = FrameTime()
    local aP = math.Clamp(ft * POS_LERP_RATE, 0, 1)
    local aA = math.Clamp(ft * ANG_LERP_RATE, 0, 1)

    self._smoothPos = LerpVector(aP, self._smoothPos or targetPos, targetPos)
    self._smoothAng = LerpAngle(aA, self._smoothAng or targetAng, targetAng)
    self:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
    return true
end

function ENT:Draw()
    self:DrawTranslucent()
end

function ENT:DrawTranslucent()
    if not IsValid(self._vis) then return end

    self._vis:SetRenderOrigin(self._smoothPos)
    self._vis:SetRenderAngles(self._smoothAng)
    self._vis:SetupBones()
    self._vis:DrawModel()

    self._vis:SetRenderOrigin()
    self._vis:SetRenderAngles()
end
