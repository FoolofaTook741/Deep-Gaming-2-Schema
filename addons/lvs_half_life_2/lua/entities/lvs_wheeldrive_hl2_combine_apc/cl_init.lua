include("shared.lua")

function ENT:UpdatePoseParameters(steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter)
    self:SetPoseParameter("vehicle_steer", steer)

    if ( throttle > 0.25 ) then
        if ( !self.bMoving ) then
            self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
            self:EmitSound("vehicles/apc/apc_firstgear_loop1.wav", 80, 100, LVS.EngineVolume)
            self.bMoving = true
        end
    else
        if ( self.bMoving ) then
            self:StopSound("vehicles/apc/apc_firstgear_loop1.wav")
            self:EmitSound("vehicles/apc/apc_slowdown_fast_loop5.wav", 80, 100, LVS.EngineVolume)

            timer.Simple(1.5, function()
                if ( IsValid(self) ) then
                    self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
                end
            end)

            self.bMoving = false
        end
    end
end

function ENT:OnEngineActiveChanged(bActive)
    if ( bActive ) then
        self:EmitSound("vehicles/apc/apc_start_loop3.wav", 80, 100, LVS.EngineVolume)
    else
        self:StopSound("vehicles/apc/apc_start_loop3.wav")
        self:EmitSound("vehicles/apc/apc_shutdown.wav", 80, 100, LVS.EngineVolume)
    end
end

function ENT:OnSpawn(PObj)
    self.interiorParts = {}

    local interiorPos = Vector(-130, 0, 70)
    local interiorModels = {"models/riggs9162/vehicles/combine_apc_interior_0.mdl", "models/riggs9162/vehicles/combine_apc_interior_1.mdl", "models/riggs9162/vehicles/combine_apc_interior_2.mdl", "models/riggs9162/vehicles/combine_apc_interior_3.mdl", "models/riggs9162/vehicles/combine_apc_interior_4.mdl", "models/riggs9162/vehicles/combine_apc_interior_5.mdl", "models/riggs9162/vehicles/combine_apc_interior_6.mdl", "models/riggs9162/vehicles/combine_apc_interior_7.mdl", "models/riggs9162/vehicles/combine_apc_interior_8.mdl"}
    for k, v in ipairs(interiorModels) do
        local interior = ClientsideModel(v, RENDERGROUP_OPAQUE)
        interior:SetPos(self:LocalToWorld(interiorPos))
        interior:SetAngles(self:GetAngles() + Angle(0, 270, 0))
        interior:SetParent(self)
        interior:Spawn()
        interior:Activate()

        interior:SetNoDraw(true)

        self.interiorParts[k] = interior
    end

    self.LightProp = ClientsideModel("models/props_combine/combine_light001a.mdl")
    self.LightProp:SetPos(self:LocalToWorld(Vector(95, 0, 34)))
    self.LightProp:SetAngles(self:GetAngles() + Angle(0, 180, 0))
    self.LightProp:SetParent(self)
    self.LightProp:Spawn()
    self.LightProp:Activate()

    self.LightProp:SetModelScale(0.75)
    self.LightProp:SetNoDraw(true)
end

function ENT:DrawInterior()
    local client = LocalPlayer()
    local vehicle = client:GetVehicle()
    local lvsVehicle = client:lvsGetVehicle()
    if ( !IsValid(vehicle) or !IsValid(lvsVehicle) ) then
        self:DrawModel()
        return
    end

    if ( lvsVehicle != self or lvsVehicle:GetDriver() == client ) then
        self:DrawModel()
        return
    end

    local bThirdperson = vehicle:GetThirdPersonMode()
    if ( bThirdperson ) then
        self:DrawModel()
    else
        for k, v in ipairs(self.interiorParts) do
            if ( !IsValid(v) ) then
                for k2, v2 in ipairs(self.interiorParts) do
                    if ( IsValid(v2) ) then
                        v2:Remove()
                    end
                end

                self.interiorParts = {}
                return
            end

            v:DrawModel()
        end

        if ( system.HasFocus() ) then
            local dynamicLighting = DynamicLight(self:EntIndex(), true)
            if ( dynamicLighting ) then
                local pos = self:LocalToWorld(Vector(0, -35, 85))
                dynamicLighting.pos = pos
                dynamicLighting.r = 140
                dynamicLighting.g = 200
                dynamicLighting.b = 50
                dynamicLighting.brightness = 10
                dynamicLighting.size = 64
                dynamicLighting.decay = 1000
                dynamicLighting.dietime = CurTime() + 1
            end
        end
    end
end

function ENT:DrawLightProp()
    if ( !IsValid(self.LightProp) ) then return end

    self.LightProp:DrawModel()
end

function ENT:Draw()
    if ( self:GetHornEnabled() ) then
        if ( !self.HornSound ) then
            self.HornSound = CreateSound(self, "ambient/alarms/apc_alarm_loop1.wav")
            self.HornSound:SetSoundLevel(80)
        elseif ( !self.HornSound:IsPlaying() ) then
            self.HornSound:Play()
        end
    else
        if ( self.HornSound ) then
            self.HornSound:FadeOut(1)
            self.HornSound = nil
        end
    end

    self:DrawInterior()
    self:DrawLightProp()
end

function ENT:OnRemoved()
    self:StopSound("vehicles/apc/apc_firstgear_loop1.wav")
    self:StopSound("vehicles/apc/apc_shutdown.wav")
    self:StopSound("vehicles/apc/apc_slowdown_fast_loop5.wav")
    self:StopSound("vehicles/apc/apc_start_loop3.wav")

    if ( self.LightProp ) then
        self.LightProp:Remove()
        self.LightProp = nil
    end

    for k, v in ipairs(self.interiorParts) do
        v:Remove()
    end
end
