-- source: https://github.com/Metastruct/simfphys_armed/blob/master/lua/effects/simfphys_gausstracer.lua
EFFECT.Mat = Material("effects/lvs_hl2/gauss_beam")
function EFFECT:Init(data)
    self.StartPos = data:GetStart()
    self.EndPos = data:GetOrigin()
    local ent = data:GetEntity()
    self.parentent = ent
    local att = data:GetAttachment()

    -- Validate attachment
    if IsValid(ent) and att > 0 then
        if ent.Owner == LocalPlayer() and IsValid(LocalPlayer():GetViewModel()) then
            ent = ent.Owner:GetViewModel()
        end
        local attachment = ent:GetAttachment(att)
        if attachment then
            self.StartPos = attachment.Pos
        end
    end

    self.Dir = self.EndPos - self.StartPos
    self:SetRenderBoundsWS(self.StartPos, self.EndPos)
    self.TracerTime = 0.1
    self.Length = math.Rand(0.15, 0.3)
    -- Die when it reaches its target
    self.DieTime = CurTime() + self.TracerTime
end

function EFFECT:Think()
    if CurTime() > self.DieTime then
        -- Improved End Sparks
        local effectdata = EffectData()
        effectdata:SetOrigin(self.EndPos + self.Dir:GetNormalized() * -5)
        effectdata:SetNormal(self.Dir:GetNormalized() * -1) -- Adjusted for better visuals
        effectdata:SetMagnitude(2) -- Increased magnitude
        effectdata:SetScale(1.5) -- Slightly larger scale
        effectdata:SetRadius(8) -- Increased radius
        util.Effect("Sparks", effectdata)
        return false
    end
    return true
end

function EFFECT:RenderGauss(dir, dist)
    if not IsValid(self.parentent) then return end
    local attachment = self.parentent:GetAttachment(1)
    if not attachment then return end -- Validate attachment

    local origin = attachment.Pos
    render.SetMaterial(self.Mat)
    render.DrawBeam(origin, origin + dir * dist, 2, 1, 1, Color(255, 145, 0, 255))
    self:GaussArc(origin, dir, dist)
    self:GaussArc(origin, dir, dist)
end

function EFFECT:GaussArc(origin, dir, dist)
    local amount = math.max(math.Round(dist / 100, 1), 1) -- Ensure at least 1 arc
    local positions = {}
    for i = 1, amount do
        local intensitivity = math.sin((i / amount) * math.pi) -- Simplified calculation
        local arc_offset = dir * i * (dist / amount) + self.side:Right() * intensitivity * dist * 0.02
        local noise = VectorRand() * intensitivity -- Simplified random noise
        table.insert(positions, origin + arc_offset + noise)
        render.DrawBeam(positions[i - 1] or origin, positions[i], 1, 1, 1, Color(255, 195, 50, 255))
    end
end

function EFFECT:Render()
    local dir = self.Dir
    dir:Normalize()
    self.side = dir:Angle()
    self.side:RotateAroundAxis(dir, math.random(-180, 180))
    self:RenderGauss(dir, (self.EndPos - self.StartPos):Length())
end
