include("shared.lua")

local SHIELD_MODEL = "models/hunter/tubes/circle4x4.mdl"
local SHIELD_MAT   = "effects/bluelaser2"
local SHIELD_SCALE = 0.55

local POS_LERP_RATE = 22
local ANG_LERP_RATE = 22

function ENT:Initialize()
    -- Do NOT SetNoDraw(true) here, or Draw/DrawTranslucent may never run.

    -- Make the server model invisible locally instead:
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetColor(Color(255, 255, 255, 0))
    self:DrawShadow(false)

    self._vis = ClientsideModel(SHIELD_MODEL, RENDER_GROUP_TRANSLUCENT_ENTITY)
    if IsValid(self._vis) then
        self._vis:SetNoDraw(true)
        self._vis:SetMaterial(SHIELD_MAT)
        self._vis:SetModelScale(SHIELD_SCALE, 0)
    end

    self._smoothPos = self:GetPos()
    self._smoothAng = self:GetAngles()

    -- give it generous bounds so it doesn't cull weirdly
    self:SetRenderBounds(Vector(-120, -120, -120), Vector(120, 120, 120))
end

function ENT:OnRemove()
    if IsValid(self._vis) then
        self._vis:Remove()
    end
end

local function calcTarget(owner)
    if not IsValid(owner) then return end

    local forward = owner:GetForward()
    local z = owner:Crouching() and 25 or 40

    local pos = owner:GetPos() + (Vector(forward.x, forward.y, 0) * 40) + Vector(0, 0, z)
    local ang = owner:GetAngles() + Angle(90, 0, 0)

    return pos, ang
end

function ENT:Think()
    local owner = self:GetNWEntity("dg_shield_owner")
    if not IsValid(owner) then return end
    if not IsValid(self._vis) then return end

    local targetPos, targetAng = calcTarget(owner)
    if not targetPos then return end

    local ft = FrameTime()
    local aPos = math.Clamp(ft * POS_LERP_RATE, 0, 1)
    local aAng = math.Clamp(ft * ANG_LERP_RATE, 0, 1)

    self._smoothPos = LerpVector(aPos, self._smoothPos, targetPos)
    self._smoothAng = LerpAngle(aAng, self._smoothAng, targetAng)

    self:NextThink(CurTime())
    return true
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
