AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/jq/hlvr/props/xenpack/xen_antlion_cluster003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
    self.phase = 1
    self:NextThink(CurTime() + 2)
end

function ENT:Think()
    local basetime = 600
    local basemult = 30
    local id = self:GetCreationID()
    local pos = self:GetPos()
    local phase = self.phase

    if not timer.Exists("BarnacleCleanup_" .. id) then
        timer.Create("BarnacleCleanup_" .. id, 3600, 0, function()
            if not IsValid(self) then
                timer.Remove("BarnacleCleanup_" .. id)
                return
            end
            for _, barnacle in pairs(ents.FindByClass("npc_barnacle")) do
                if barnacle.SpawnedBySpore == id then
                    barnacle:Remove()
                end
            end
        end)
    end

    if not timer.Exists(id .. "sporephasechanges") and phase <= 5 then
        timer.Create(id .. "sporephasechanges", basetime - (basemult * self.phase), 1, function()
            if IsValid(self) then
                local phase = self.phase
                if phase + 1 <= 5 then
                    self.phase = phase + 1
                end
            end
        end)
    end


    if not timer.Exists(id .. "barnaclespawn") then
        timer.Create(id .. "barnaclespawn", 120, 0, function()
            if not IsValid(self) then
                timer.Remove(id .. "barnaclespawn")
                return
            end

            local barnacleCount = 0
            for _, barnacle in pairs(ents.FindByClass("npc_barnacle")) do
                if barnacle.SpawnedBySpore == id then
                    barnacleCount = barnacleCount + 1
                end
            end
            if barnacleCount >= 5 then return end

            local spawnPos = self:GetRandomCeilingPos(pos, 2000)
            if not spawnPos then
                spawnPos = pos + Vector(0, 0, 100)
            end

            local barnacle = ents.Create("npc_barnacle")
            if IsValid(barnacle) then
                barnacle:SetPos(spawnPos)
                barnacle:Spawn()
                barnacle:Activate()
                barnacle.SpawnedBySpore = id
                impulse.debugPrint("Teleport: setpos " .. spawnPos.x .. " " .. spawnPos.y .. " " .. spawnPos.z)
                barnacle:SetRenderMode(RENDERMODE_GLOW)
                barnacle:SetColor(Color(255, 255, 0, 255))
                timer.Simple(30, function()
                    if IsValid(barnacle) then
                        barnacle:SetRenderMode(RENDERMODE_NORMAL)
                        barnacle:SetColor(Color(255, 255, 255, 255))
                    end
                end)
            end
        end)
    end

    self:NextThink(CurTime() + 2)
    return true
end

function ENT:GetRandomCeilingPos(centerPos, radius)
    for i = 1, 50 do
        local x = math.random(-radius, radius)
        local y = math.random(-radius, radius)
        local z = math.random(50, 300)
        local pos = centerPos + Vector(x, y, z)

        local trUp = util.TraceLine({
            start = pos,
            endpos = pos + Vector(0, 0, 200),
            filter = self
        })

        local trDown = util.TraceLine({
            start = pos,
            endpos = pos - Vector(0, 0, 100),
            filter = self
        })

        if trUp.Hit and not trUp.HitSky and not trDown.Hit then
            local ceilingPos = trUp.HitPos - Vector(0, 0, 10)
            return ceilingPos
        end
    end
    return nil
end

function ENT:Use(activator)
    if IsValid(activator) and activator:IsPlayer() then
        activator:Notify("This is a barnacle spawner. Call I.C.T. members to clean it up before it grows further...")
    end
end

function ENT:OnRemove()
    local id = self:GetCreationID()
    timer.Remove(id .. "sporephasechanges")
    timer.Remove(id .. "barnaclespawn")
    timer.Remove("BarnacleCleanup_" .. id)
end