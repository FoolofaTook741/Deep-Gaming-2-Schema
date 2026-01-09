--server side code
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("potatoSignal")
util.AddNetworkString("potatoesPeeled")
util.AddNetworkString("DeepAdjustJailEndTime")

function ENT:Initialize()

    self:SetModel("models/props_junk/MetalBucket01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetColor(Color(120,255,120))

    local phys = self:GetPhysicsObject()

    if(phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(ply, caller)
    net.Start("potatoSignal")
    net.WriteBool(true)
    net.Send(ply)
end

local MAX_REDUCTION = 120
local COOLDOWN = 2
local MAX_DIST_SQR = (120 * 120)

net.Receive("potatoesPeeled", function(_, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    if (ply._potatoNext or 0) > CurTime() then return end
    ply._potatoNext = CurTime() + COOLDOWN

    local tname = ply:UserID() .. "impulsePrison"
    local timeLeft = timer.TimeLeft(tname)
    if not timeLeft then 
        impulse.debugPrint("Potato peeler: no timer found for player "..ply:SteamID())
        return 
    end

    local nearest
    local ppos = ply:GetPos()
    for _, ent in ipairs(ents.FindByClass("ninja_potatopeeler")) do
        if IsValid(ent) and ppos:DistToSqr(ent:GetPos()) <= MAX_DIST_SQR then
            nearest = ent
            break
        end
    end
    if not nearest then 
        impulse.debugPrint("Potato peeler: no peeler found near player "..ply:SteamID())
        return 
    end

    local reps = net.ReadInt(32)
    if not isnumber(reps) then return end
    reps = math.floor(reps)

    if reps < 0 then return end
    if reps > MAX_REDUCTION then 
        impulse.debugPrint("Potato peeler: High potato count. Count:"..reps, ply:SteamID())
        reps = MAX_REDUCTION 
    end
    if reps == 0 then return end

    local newTime = timeLeft - reps
    if newTime < 1 then newTime = 1 end

    timer.Adjust(tname, newTime)

    OCAAB_CUR_FUNDS = (tonumber(OCAAB_CUR_FUNDS) or 0) + (reps * 3)

    ply:Notify("You have reduced your sentence by " .. reps .. " seconds from peeling the potatoes.")

    net.Start("DeepAdjustJailEndTime")
    net.WriteUInt(reps, 20)
    net.Send(ply)
end)
