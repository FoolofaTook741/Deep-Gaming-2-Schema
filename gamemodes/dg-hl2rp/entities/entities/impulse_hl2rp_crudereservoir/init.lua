AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local RESERVOIR_MAX    = 20000
local DRUM_LITERS      = 200
local DRUM_LITERS_CONT = 50

function ENT:Initialize()
    self:SetModel("models/props_mining/oiltank01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self:SetNWInt("ReservoirLevel", 0)
end

local function SyncReservoir(level)
    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_crudereservoir")) do
        ent:SetNWInt("ReservoirLevel", level)
    end
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
        activator:Notify("You cannot interact with this.")
        return
    end

    local ws = impulse.OilWorkshift
    if not ws or not ws.active then
        activator:Notify("[RESERVOIR] No oil workshift is active.")
        return
    end

    local currentLevel = ws.reservoirLiters or 0
    if currentLevel >= RESERVOIR_MAX then
        activator:Notify("[RESERVOIR] The reservoir is full (20,000L). Wait for the city pipe to drain it.")
        return
    end

    local closestDrum, closestDist = nil, 180
    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_oildrum")) do
        local d = ent:GetPos():Distance(activator:GetPos())
        if d < closestDist then
            closestDist = d
            closestDrum = ent
        end
    end

    if not IsValid(closestDrum) then
        activator:Notify("[RESERVOIR] No crude drum nearby. Carry a drum from the pump jack to the reservoir first.")
        return
    end

    local contaminated = closestDrum:GetNWBool("Contaminated", false)
    local addLiters    = contaminated and DRUM_LITERS_CONT or DRUM_LITERS

    ws.reservoirLiters = math.min(RESERVOIR_MAX, currentLevel + addLiters)
    closestDrum:Remove()
    SyncReservoir(ws.reservoirLiters)

    self:EmitSound("physics/liquid/water_impact_hard1.wav")

    if impulse.OilPushUpdate then impulse.OilPushUpdate() end

    if contaminated then
        activator:Notify("[RESERVOIR] Deposited contaminated drum: +" .. addLiters .. "L crude. (Tip: filter drums first for full credit.) Total: " .. ws.reservoirLiters .. "L")
    else
        activator:Notify("[RESERVOIR] Deposited drum: +" .. addLiters .. "L crude. Total: " .. ws.reservoirLiters .. "L / " .. RESERVOIR_MAX .. "L")
    end

    local barrelsNeeded = math.ceil((ws.scaledGoal or 2000) / 40)
    local crudeNeeded   = barrelsNeeded * 200
    local crudeLeft     = math.max(0, crudeNeeded - ws.reservoirLiters)
    local barrelsLeft   = math.ceil(crudeLeft / 200)

    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID64() == tostring(ws.supervisorID) then
            ply:Notify("[OIL WS] Reservoir: " .. ws.reservoirLiters .. "L | Still needed: " .. barrelsLeft .. " barrels (" .. crudeLeft .. "L)")
            break
        end
    end
end
