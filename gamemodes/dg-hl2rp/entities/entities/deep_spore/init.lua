AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/hlvr/distillery_gunk/distillerygunk_gunk.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(3)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
    self.phase = 1
    self:NextThink(CurTime() + 2)
end

function ENT:Think()
    if not self.phase then
        self:NextThink(CurTime() + 1)
        return true
    end
    local basetime = 600
    local basemult = 30
    local spawntime = 120
    local spawnmult = 5
	local spore = self
    local id = spore:EntIndex()
    local pos = spore:GetPos()
    local phase = spore.phase

    if not timer.Exists("HeadCrabCleanup") then
        timer.Create("HeadCrabCleanup", 3600, 0, function()
            for k, v in pairs(ents.FindByClass("npc_headcrab")) do
                if not IsValid(v:GetNWEntity("ParentSpore")) then
                    v:Remove()
                end
            end
            for k, v in pairs(ents.FindByClass("npc_headcrab_black")) do
                if not IsValid(v:GetNWEntity("ParentSpore")) then
                    v:Remove()
                end
            end
            for k, v in pairs(ents.FindByClass("npc_headcrab_fast")) do
                if not IsValid(v:GetNWEntity("ParentSpore")) then
                    v:Remove()
                end
            end
        end)
    end

    if not timer.Exists(id .. "sporephasethink") then
        timer.Create(id .. "sporephasethink", spawntime - (spawnmult * spore.phase), 1, function()
            if not IsValid(spore) or not spore.phase then return end
            local pos = spore:GetPos() + Vector(0, 0, 50)
            local crabtype
            local crabrandom = math.random(1, 10)
            if crabrandom < 7 then
                crabtype = "npc_headcrab"
            elseif crabrandom <= 9 then
                crabtype = "npc_headcrab_fast"
            else
                crabtype = "npc_headcrab_black"
            end
            local crabby = ents.Create(crabtype)
            if not IsValid(crabby) then
                return
            end
            crabby:SetPos(pos)
            crabby:SetNWEntity("ParentSpore", spore)
            crabby:Spawn()
            timer.Simple(30, function()
                if IsValid(crabby) then
                    crabby:Remove()
                end
            end)
        end)
    end

    if not timer.Exists(id .. "sporephasechanges") and phase <= 5 then
        timer.Create(id .. "sporephasechanges", basetime - (basemult * spore.phase), 1, function()
            if not IsValid(spore) or not spore.phase then return end
            local phase = spore.phase
            if phase + 1 <= 5 then
                spore.phase = phase + 1
            end
        end)
    end

    spore:NextThink(CurTime() + 2)
    return true
end

function ENT:Use(activator)
    local id = self:GetCreationID()
    activator:Notify("This is an infectious spore. Call I.C.T. members to clean it up before it grows further...")
end

function ENT:OnRemove()
    local id = self:GetCreationID()
    timer.Remove(id .. "sporephasethink")
    timer.Remove(id .. "sporephasechanges")
    for k, v in pairs(ents.FindByClass("npc_headcrab")) do
        if v:GetNWEntity("ParentSpore") == self then
            v:Remove()
        end
    end
    for k, v in pairs(ents.FindByClass("npc_headcrab_black")) do
        if v:GetNWEntity("ParentSpore") == self then
            v:Remove()
        end
    end
    for k, v in pairs(ents.FindByClass("npc_headcrab_fast")) do
        if v:GetNWEntity("ParentSpore") == self then
            v:Remove()
        end
    end
end