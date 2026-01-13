include("shared.lua")

local SHIELD_MODEL = "models/hunter/tubes/circle4x4.mdl"
local SHIELD_SCALE = 0.55

local MAT_CORE   = Material("effects/bluelaser2")
local MAT_RIM    = Material("effects/combinemuzzle1")
local MAT_SHIM   = Material("sprites/heatwave")
local MAT_HIT    = Material("effects/rollerglow")

local POS_LERP_RATE = 22
local ANG_LERP_RATE = 22

local HIT_FLASH_TIME   = 0.25
local HIT_SPRITE_LIFE   = 0.45
local MAX_HITS_STORED   = 10

local function easeOutQuad(x) return 1 - (1 - x) * (1 - x) end
local function clamp01(x) return math.Clamp(x, 0, 1) end

net.Receive("dg_shield_hitfx", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    local localPos = net.ReadVector()

    ent._hits = ent._hits or {}
    ent._hits[#ent._hits + 1] = {
        t = CurTime(),
        lp = localPos
    }

    if #ent._hits > MAX_HITS_STORED then
        table.remove(ent._hits, 1)
    end
end)

function ENT:Initialize()
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetColor(Color(255, 255, 255, 0))
    self:DrawShadow(false)

    self._vis = ClientsideModel(SHIELD_MODEL, RENDERGROUP_TRANSLUCENT)
    if IsValid(self._vis) then
        self._vis:SetNoDraw(true)
        self._vis:SetModelScale(SHIELD_SCALE, 0)
    end

    self._smoothPos = self:GetPos()
    self._smoothAng = self:GetAngles()

    self._hits = {}

    self:SetRenderBounds(Vector(-160, -160, -160), Vector(160, 160, 160))
end

function ENT:OnRemove()
    if IsValid(self._vis) then self._vis:Remove() end
end

function ENT:Think()
    if not IsValid(self._vis) then return true end

    local owner = self:GetParent()
    if not IsValid(owner) then owner = self:GetNWEntity("dg_shield_owner") end
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

    if self._hits then
        local now = CurTime()
        for i = #self._hits, 1, -1 do
            if (now - self._hits[i].t) > HIT_SPRITE_LIFE then
                table.remove(self._hits, i)
            end
        end
    end

    return true
end

function ENT:Draw()
    self:DrawTranslucent()
end

function ENT:DrawTranslucent()
    if not IsValid(self._vis) then return end

    local t = CurTime()

    local pulse = (math.sin(t * 2.2) * 0.5 + 0.5)
    local baseAlpha = 120 + pulse * 70

    local hit = 0
    if self._hits then
        for i = 1, #self._hits do
            local age = t - self._hits[i].t
            if age >= 0 and age <= HIT_FLASH_TIME then
                local x = 1 - (age / HIT_FLASH_TIME)
                hit = hit + easeOutQuad(clamp01(x))
            end
        end
    end
    hit = math.Clamp(hit, 0, 1.2)

    local scale = SHIELD_SCALE * (1 + pulse * 0.03 + hit * 0.06)
    self._vis:SetModelScale(scale, 0)

    self._vis:SetRenderOrigin(self._smoothPos)
    self._vis:SetRenderAngles(self._smoothAng)
    self._vis:SetupBones()

    render.SetBlend((baseAlpha + hit * 80) / 255)
    render.MaterialOverride(MAT_CORE)
    self._vis:DrawModel()

    render.SetBlend((70 + pulse * 60 + hit * 120) / 255)
    render.MaterialOverride(MAT_RIM)
    self._vis:DrawModel()

    render.SetBlend((20 + pulse * 25 + hit * 40) / 255)
    render.MaterialOverride(MAT_SHIM)
    self._vis:DrawModel()

    render.MaterialOverride(nil)
    render.SetBlend(1)

    if self._hits and #self._hits > 0 then
        for i = 1, #self._hits do
            local h = self._hits[i]
            local age = t - h.t

            local life = 1 - (age / HIT_SPRITE_LIFE)
            if life > 0 then
                life = easeOutQuad(clamp01(life))

                local wpos = self:LocalToWorld(h.lp)
                local size = 18 + (1 - life) * 48

                render.SetMaterial(MAT_HIT)
                render.DrawSprite(wpos, size, size, Color(120, 200, 255, 255 * life))
            end
        end
    end

    self._vis:SetRenderOrigin()
    self._vis:SetRenderAngles()
end
