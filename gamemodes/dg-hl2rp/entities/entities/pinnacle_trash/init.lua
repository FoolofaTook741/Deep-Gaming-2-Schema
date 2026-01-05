AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("impulseScavengeProgress")
util.AddNetworkString("impulseScavengeCancel")
util.AddNetworkString("ImpulseQuestScavWatcher")
local SCAVENGE_TIME = 5

function ENT:CancelScavenge()
    if IsValid(self.ScavengePlayer) then
        net.Start("impulseScavengeCancel")
            net.WriteEntity(self)
        net.Send(self.ScavengePlayer)
    end
    self.ScavengeInProgress = false
    self.ScavengePlayer = nil
    self.ScavengeStart = nil
    self.CWUScavengeRemove = nil
end

function ENT:Initialize()
    self:SetModel("models/props_junk/garbage128_composite001a.mdl")
    self.ScavengeItemsLeft = math.random(1, 4)
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
    self.ScavengeInProgress = false
    self.ScavengePlayer = nil
    self.ScavengeStart = nil
    self:NextThink(CurTime() + 0.1)
end

function ENT:Think()
    if self.ScavengeInProgress and IsValid(self.ScavengePlayer) then
        local ply = self.ScavengePlayer
        if not ply:KeyDown(IN_USE) or ply:GetEyeTrace().Entity ~= self then
            self:CancelScavenge()
        else
            if CurTime() - self.ScavengeStart >= SCAVENGE_TIME then
                self:FinishScavenge()
            end
        end
    end
    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:StartScavenge(ply)
    self.ScavengeInProgress = true
    self.ScavengePlayer = ply
    self.ScavengeStart = CurTime()

    net.Start("impulseScavengeProgress")
        net.WriteEntity(self)
        net.WriteFloat(SCAVENGE_TIME)
    net.Send(ply)
end


local loot = {"util_wood", "util_metalplate", "util_cloth", "util_glue", "util_plastic"}
local lootNiceName = {" a piece of Wood", " a Metal Plate", " a piece of Cloth", " a bottle of Glue", " a piece of Plastic"}

function ENT:FinishScavenge()
    local ply = self.ScavengePlayer
    --[[
    print(ply.CurrentQuest)
    if ply.CurrentQuest == QUEST_SCAV then
        loot = {"util_wood", "util_metalplate"}
        lootNiceName = {" a piece of Wood", " a Metal Plate"}
        ply:CompleteQuest(QUEST_SCAV)
    end--]]

    self.ScavengeInProgress = false
    self.ScavengePlayer = nil
    self.ScavengeStart = nil

    if not self.ScavengeItemsLeft or self.ScavengeItemsLeft <= 0 then
        if IsValid(ply) then
            ply:Notify("There's nothing left to scavenge here.", 1)
        end
        return
    end

    local pool = loot
    if pool and #pool > 0 and IsValid(ply) then
        local num = math.random(1, #pool)

        local lootItem = pool[num]

        ply:Notify("You found " .. lootNiceName[num] .. " in the trash.", 5)
        --impulse.debugPrint("Scavenged item: " .. lootNiceName[num])
        --print(lootItem)
        if lootItem then ply:GiveInventoryItem(lootItem) end
        self.ScavengeItemsLeft = self.ScavengeItemsLeft - 1
        if self.ScavengeItemsLeft <= 0 then
            self:SetColor(Color(120,120,120,255)) -- Optional: visually indicate empty
        end
    end
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    local t = activator:Team()
    
    if t ~= TEAM_CWU and t ~= TEAM_CITIZEN and t ~= TEAM_VORT then
        return
    end

    -- CWU Maintenance: remove entity instead of scavenge, but still show timer
    if (activator:Team() == TEAM_CWU and activator:GetTeamClass() == CLASS_INDUST ) or activator:Team() == TEAM_VORT then
        activator:EmitSound("foley/industrial/disassemble_crate"..math.random(1,3)..".mp3")
        net.Start("impulseScavengeProgress")
            net.WriteEntity(self)
            net.WriteFloat(SCAVENGE_TIME)
        net.Send(activator)

        self.ScavengeInProgress = true
        self.ScavengePlayer = activator
        self.ScavengeStart = CurTime()
        self.CWUScavengeRemove = true

        return
    end

    if self.ScavengeItemsLeft and self.ScavengeItemsLeft <= 0 then
        activator:Notify("There's nothing left to scavenge here.", 1)
        return
    end

    activator:EmitSound("foley/industrial/disassemble_crate"..math.random(1,3)..".mp3")
    if self.ScavengeInProgress then return end
    self:StartScavenge(activator)
end

-- In Think, handle CWU removal after timer
function ENT:Think()
    if self.ScavengeInProgress and IsValid(self.ScavengePlayer) then
        local ply = self.ScavengePlayer
        if not ply:KeyDown(IN_USE) or ply:GetEyeTrace().Entity ~= self then
            self:CancelScavenge()
        else
            if CurTime() - self.ScavengeStart >= SCAVENGE_TIME then
                if self.CWUScavengeRemove then
                    ply:GiveMoney(5)
                    ply:Notify("You have removed the trash and earned 5 Credits.", 5)
                    self:Remove()
                    return
                else
                    self:FinishScavenge()
                end
            end
        end
    end
    self:NextThink(CurTime() + 0.1)
    return true
end

