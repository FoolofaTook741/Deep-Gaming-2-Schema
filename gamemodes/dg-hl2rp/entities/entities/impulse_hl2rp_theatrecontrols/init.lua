AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
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
            self.ECurtain = k
        elseif name == "Theatre_Lights_Prop" then
            table.insert(self.ELightProps, k)
        elseif name == "Theatre_Lights_Spot" then
            table.insert(self.ELightSpots, k)
        elseif name == "Theatre_Lights" then
            table.insert(self.ELights, k)
        elseif name == "Theatre_Speaker1" then
            self.ESpeaker1 = k
        elseif name == "Theatre_Speaker2" then
            self.ESpeaker2 = k
        end
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
