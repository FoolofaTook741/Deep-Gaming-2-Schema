AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local PIPE_COOLDOWN  = 5
local CONTAM_CHANCE  = 20
local BARREL_LITERS  = 200

function ENT:Initialize()
    self:SetModel("models/props_wasteland/prison_pipefaucet001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self.cooldowns = {}
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
        activator:Notify("You cannot interact with this.")
        return
    end

    local ws = impulse.OilWorkshift
    if not ws or not ws.active then
        activator:Notify("[OIL PIPE] No oil workshift is currently active.")
        return
    end

    local reservoir = ws.reservoirLiters or 0
    if reservoir < BARREL_LITERS then
        if reservoir <= 0 then
            activator:Notify("[OIL PIPE] The crude reservoir is empty. Workers must fill it at the outlands pump jacks first.")
        else
            activator:Notify("[OIL PIPE] Not enough crude in reservoir (" .. reservoir .. "L remaining, need " .. BARREL_LITERS .. "L per barrel).")
        end
        return
    end

    local sid = activator:SteamID()
    if self.cooldowns[sid] and CurTime() < self.cooldowns[sid] then
        activator:Notify("[OIL PIPE] Wait " .. math.ceil(self.cooldowns[sid] - CurTime()) .. " more seconds.")
        return
    end

    ws.reservoirLiters = ws.reservoirLiters - BARREL_LITERS
    for _, ent in ipairs(ents.FindByClass("impulse_hl2rp_crudereservoir")) do
        ent:SetNWInt("ReservoirLevel", ws.reservoirLiters)
    end

    local contaminated = math.random(1, 100) <= CONTAM_CHANCE

    local barrel = ents.Create("impulse_hl2rp_citybarrel")
    if not IsValid(barrel) then

        ws.reservoirLiters = ws.reservoirLiters + BARREL_LITERS
        activator:Notify("[OIL PIPE] Failed to dispense barrel. Contact an admin.")
        return
    end
    barrel:SetPos(self:GetPos() + Vector(0, 0, 70))
    barrel:SetNWBool("Contaminated", contaminated)
    barrel:SetNWString("OwnerSID", sid)
    barrel:Spawn()
    barrel:Activate()

    self:EmitSound("ambient/materials/bump1.wav")
    self.cooldowns[sid] = CurTime() + PIPE_COOLDOWN

    if impulse.OilPushUpdate then impulse.OilPushUpdate() end

    if contaminated then
        activator:Notify("[OIL PIPE] Dispensed a 200L barrel - WARNING: contaminated. Filter it at the boiler for a payout bonus!")
    else
        activator:Notify("[OIL PIPE] Dispensed a 200L crude barrel. Bring it to an oil refinery.")
    end
end