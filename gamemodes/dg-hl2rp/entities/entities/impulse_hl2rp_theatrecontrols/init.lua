AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function CreateStageLight(pos, ang, brightness)
    local light = ents.Create("env_projectedtexture")
    light:SetPos(pos)
    light:SetAngles(ang)
    light:SetKeyValue("lightfov", "80")
    light:SetKeyValue("linearbrighten", tostring(brightness or 800))
    light:SetKeyValue("lighthdr", "-1 -1 -1 -1")
    light:SetKeyValue("lightscalehdr", "1")
    light:SetKeyValue("colortransitiontime", "0.5")
    light:SetKeyValue("color", "255 240 200 1")
    light:SetKeyValue("nearz", "4")
    light:SetKeyValue("farz", "1500")
    light:SetKeyValue("enableshadows", "0")
    light:Spawn()
    light:Activate()
    light:Fire("TurnOff")
    return light
end

function ENT:Initialize()
    for _, path in pairs(impulse.Config.TheatreMusic) do
        util.PrecacheSound(path)
    end

    self:SetModel("models/props_silo/desk_console3.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.cooldown = 0

    self.ELightProps = {}
    self.ELightSpots = {}
    self.ELights = {}

    for v,k in pairs(ents.GetAll()) do
        if not k.GetName then
            continue
        end

        local name = k:GetName()

        if name == "Theatre_Curtain" then
            self.ECurtain = k --1468
        elseif name == "Theatre_Lights_Prop" then
            table.insert(self.ELightProps, k)
        elseif name == "Theatre_Lights_Spot" then
            table.insert(self.ELightSpots, k)
        elseif name == "Theatre_Lights" then
            table.insert(self.ELights, k)
        end
    end

    for _, spot in pairs(self.ELightSpots) do
        if IsValid(spot) then spot:Fire("LightOff") end
    end
    for _, prop in pairs(self.ELightProps) do
        if IsValid(prop) then prop:SetSkin(1) end
    end

    self.EStageLights = self.EStageLights or {}
    local stageLightPositions = {
        {pos = Vector(2936.3444824219, 860.25323486328, 294.58212280273), ang = Angle(90, 0, 0)},
        {pos = Vector(2746.8503417969, 845.28289794922, 294.13272094727), ang = Angle(89, -178.89782714844, 0)},
        {pos = Vector(2499.0395507813, 848.06561279297, 279.97177124023), ang = Angle(80.590087890625, -1.7314985990524, 0)},
    }
    for _, data in pairs(stageLightPositions) do
        table.insert(self.EStageLights, CreateStageLight(data.pos, data.ang))
    end
    
    self.SpeakerPositions = {
        Vector(2598.0974121094, 1186.7159423828, 459.88357543945),
        Vector(2836.1684570313, 1184.7120361328, 463.7219543457),
    }
    self.SpeakerEnts = {}
    for _, pos in pairs(self.SpeakerPositions) do
        local speaker = ents.Create("info_target")
        speaker:SetPos(pos)
        speaker:Spawn()
        table.insert(self.SpeakerEnts, speaker)
    end
end

function ENT:Use(caller, activator)
    if self.cooldown > CurTime() then return end
    self.cooldown = CurTime() + 1
    self.CurrentUser = activator
    activator.TheatreConsole = self

    net.Start("impulseHL2RPTheatreControls")
    net.Send(activator)
end

function ENT:Think()
    if IsValid(self.ECurtain) then
        if self.ECurtain:GetInternalVariable("m_toggle_state") == 1 then
            self:SetSkin(1)
        else
            self:SetSkin(2)
        end
    end


    self:NextThink(CurTime() + 0.5)
    return true
end


function ENT:OnRemove()
    for _, light in pairs(self.EStageLights or {}) do
        if IsValid(light) then light:Remove() end
    end
    for _, speaker in pairs(self.SpeakerEnts or {}) do
        if IsValid(speaker) then speaker:Remove() end
    end
end