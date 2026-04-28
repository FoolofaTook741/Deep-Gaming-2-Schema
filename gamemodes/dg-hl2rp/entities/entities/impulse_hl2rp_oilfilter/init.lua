AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local FILTER_TIME   = 15
local FILTER_BONUS  = 150
local FILTER_RADIUS = 200

function ENT:Initialize()
    self:SetModel("models/props_forest/sawmill_boiler.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self:SetNWBool("Filtering", false)
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
        activator:Notify("You cannot interact with this.")
        return
    end

    local ws = impulse.OilWorkshift
    if not ws or not ws.active then
        activator:Notify("[FILTER] No oil workshift is active.")
        return
    end

    if self:GetNWBool("Filtering") then
        activator:Notify("[FILTER] Already processing a barrel. Wait for it to finish.")
        return
    end

    local filterPos   = self:GetPos()
    local target      = nil
    local targetCart  = nil
    local targetSlot  = nil
    local closestDist = FILTER_RADIUS

    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_oildrum")) do
        if ent:GetNWBool("Contaminated", false) then
            local d = ent:GetPos():Distance(filterPos)
            if d < closestDist then closestDist = d; target = ent end
        end
    end
    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_citybarrel")) do
        if ent:GetNWBool("Contaminated", false) and not ent.refining then
            local d = ent:GetPos():Distance(filterPos)
            if d < closestDist then closestDist = d; target = ent end
        end
    end

    if not target then
        for _, cart in ipairs(ents.FindByClass("impulse_hl2rp_oilcart")) do
            local d = cart:GetPos():Distance(filterPos)
            if d < closestDist then
                local slot = cart:TakeContaminatedBarrel()
                if slot then
                    targetCart = cart
                    targetSlot = slot
                    closestDist = d
                end
            end
        end
    end

    if not target and not targetCart then
        activator:Notify("[FILTER] No contaminated drum or barrel within range.")
        return
    end

    self:SetNWBool("Filtering", true)
    self:EmitSound("ambient/machines/lab_loop1.wav")
    activator:Notify("[FILTER] Filtering started. " .. FILTER_TIME .. " seconds...")

    local filter = self

    timer.Create("OilFilter_" .. self:EntIndex(), FILTER_TIME, 1, function()
        if not IsValid(filter) then
            if IsValid(targetCart) and targetSlot then
                targetCart:CancelFilteredBarrel(targetSlot)
            end
            return
        end

        filter:SetNWBool("Filtering", false)
        filter:StopSound("ambient/machines/lab_loop1.wav")
        filter:EmitSound("physics/metal/metal_grate_impact_soft3.wav")

        if IsValid(target) then
            target:SetNWBool("Contaminated", false)
        end

        if IsValid(targetCart) and targetSlot then
            targetCart:ReturnCleanBarrel(targetSlot)
        end

        local wsNow = impulse.OilWorkshift
        if wsNow and wsNow.active then
            wsNow.bonusCredits = (wsNow.bonusCredits or 0) + FILTER_BONUS
            if impulse.OilPushUpdate then impulse.OilPushUpdate() end
        end

        for _, ply in ipairs(ents.FindInSphere(filter:GetPos(), 350)) do
            if ply:IsPlayer() then
                ply:Notify("[FILTER] Filtering complete! +" .. FILTER_BONUS .. " cr bonus added to the workshift payout.")
            end
        end
    end)
end

function ENT:OnRemove()
    timer.Remove("OilFilter_" .. self:EntIndex())
    self:StopSound("ambient/machines/lab_loop1.wav")
end