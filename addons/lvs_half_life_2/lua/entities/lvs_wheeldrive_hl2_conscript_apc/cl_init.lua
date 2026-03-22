include("shared.lua")

local interiorProps = {
    {
        pos = Vector(75, 20, 3),
        ang = Angle(0, 270, 0),
        scale = Vector(1, 1, 0.75),
        model = "models/nova/jalopy_seat.mdl",
    },
    {
        pos = Vector(75, -20, 3),
        ang = Angle(0, 270, 0),
        scale = Vector(1, 1, 0.75),
        model = "models/nova/jalopy_seat.mdl",
    },
    {
        pos = Vector(0, 45, -32),
        ang = Angle(0, 270, 0),
        scale = Vector(1, 0.7, 1),
        model = "models/props_trainstation/wrecked_train_seat.mdl",
    },
    {
        pos = Vector(0, -45, -32),
        ang = Angle(0, 90, 0),
        scale = Vector(1, 0.7, 1),
        model = "models/props_trainstation/wrecked_train_seat.mdl",
    }
}

function ENT:UpdatePoseParameters(steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter)
    self:SetPoseParameter("vehicle_steer", steer)
end

function ENT:Draw()
    self:DrawModel()

    if ( !self.interiorParts ) then
        self.interiorParts = {}
    end

    local client = LocalPlayer()
    local shouldDrawInterior = client:lvsGetVehicle() == self

    for k, v in ipairs(interiorProps) do
        local pos = self:LocalToWorld(v.pos)
        local ang = self:LocalToWorldAngles(v.ang)
        debugoverlay.Axis(pos, ang, 10, 0.01, Color(255, 0, 0), true)

        if ( !self.interiorParts[k] ) then
            local interior = ClientsideModel(v.model, RENDERGROUP_OPAQUE)
            interior:SetPos(pos)
            interior:SetAngles(ang)
            interior:SetParent(self)
            interior:Spawn()
            interior:Activate()
            self.interiorParts[k] = interior
        else
            local interior = self.interiorParts[k]
            interior:SetPos(pos)
            interior:SetAngles(ang)

            local mat = Matrix()
            mat:Scale(v.scale)
            interior:EnableMatrix("RenderMultiply", mat)

            interior:SetNoDraw(!shouldDrawInterior)
        end
    end
end

function ENT:OnRemove()
    if ( self.interiorParts ) then
        for k, v in ipairs(self.interiorParts) do
            if ( IsValid(v) ) then
                v:Remove()
            end
        end
    end
end
