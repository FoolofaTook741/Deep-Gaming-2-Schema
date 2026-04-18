AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local OIL_GOAL    = 2000
local ITEM_LITERS = 20

function ENT:Initialize()
    self:SetModel("models/props_vehicles/mining_car.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
        activator:Notify("You cannot interact with this.")
        return
    end

    local ws = impulse.OilWorkshift
    if not ws or not ws.active then
        activator:Notify("[COLLECTION] No oil workshift is active.")
        return
    end

    if ws.paid then
        activator:Notify("[COLLECTION] This workshift has already been paid out.")
        return
    end

    if not activator:HasInventoryItem("item_oilcan") then
        activator:Notify("[COLLECTION] You have no Refined Oil to deposit. Refine crude barrels at an oil refinery first.")
        return
    end

    local count = 0
    local safety = 0
    while activator:HasInventoryItem("item_oilcan") and safety < 500 do
        activator:TakeInventoryItemClass("item_oilcan")
        count  = count + 1
        safety = safety + 1
    end

    if count == 0 then
        activator:Notify("[COLLECTION] Failed to take items. Contact an admin.")
        return
    end

    local oilGoal     = ws.scaledGoal or OIL_GOAL
    local litersAdded = count * ITEM_LITERS
    ws.oilDeposited   = (ws.oilDeposited or 0) + litersAdded

    self:EmitSound("ambient/materials/bump1.wav")
    activator:Notify("[COLLECTION] Deposited " .. count .. "x Refined Oil (" .. litersAdded .. "L). Total: " .. ws.oilDeposited .. "L / " .. oilGoal .. "L")

    for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
        if ply ~= activator then
            ply:ChatPrint("[OIL WS] " .. activator:Nick() .. " deposited " .. litersAdded .. "L refined oil. Progress: " .. ws.oilDeposited .. "L / " .. oilGoal .. "L")
        end
    end

    if impulse.OilPushUpdate then
        impulse.OilPushUpdate()
    end

    if ws.oilDeposited >= oilGoal and not ws.goalMet then
        ws.goalMet = true
        for _, ply in ipairs(player.GetAll()) do
            ply:ChatPrint("[OIL WS] WORKSHIFT GOAL MET! " .. oilGoal .. "L of refined oil collected!")
        end
        net.Start("OilWorkshift_GoalMet")
        net.Broadcast()
    end
end