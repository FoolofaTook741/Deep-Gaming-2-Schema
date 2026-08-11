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
    ply.PotatoSession = {
        ent = self,
        startTime = CurTime()
    }

    net.Start("potatoSignal")
    net.WriteBool(true)
    net.Send(ply)
end

local MAX_REDUCTION = 120
local COOLDOWN = 2
local MAX_DIST_SQR = (120 * 120)
local MIN_TIME_PER_REP = 0.2 -- floor for how fast a single legit peel cycle can plausibly complete

local function LogPotatoExploit(ply, reason)
    local embeds = {{
        title = "Net Message Exploit Attempted",
        description = reason,
        url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
        color = 5763719,
        fields = {
            {
                name = "Name:",
                value = ply:SteamName()
            },
            {
                name = "SteamID:",
                value = ply:SteamID()
            }
        }
    }}
    ServerLog("Net Message Exploit Logged: " .. ply:SteamName() .. " (" .. ply:SteamID() .. ") - " .. reason)
    ReqwestLog(embeds, DG_NME)
end

local function FakeSuccessNotify(ply, reps)
    ply:Notify("You have reduced your sentence by " .. reps .. " seconds from peeling the potatoes.")
    net.Start("DeepAdjustJailEndTime")
    net.WriteUInt(reps, 20)
    net.Send(ply)
end

net.Receive("potatoesPeeled", function(_, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    if (ply._potatoNext or 0) > CurTime() then return end
    ply._potatoNext = CurTime() + COOLDOWN

    local reps = net.ReadInt(32)
    if not isnumber(reps) then return end
    reps = math.floor(reps)
    if reps < 0 then return end
    if reps > MAX_REDUCTION then reps = MAX_REDUCTION end

    local session = ply.PotatoSession
    if not session or not IsValid(session.ent) then
        LogPotatoExploit(ply, "potatoesPeeled received with no active session (never triggered ENT:Use).")
        if reps > 0 then FakeSuccessNotify(ply, reps) end
        return
    end

    ply.PotatoSession = nil

    local tname = ply:UserID() .. "impulsePrison"
    local timeLeft = timer.TimeLeft(tname)
    if not timeLeft then 
        impulse.debugPrint("Potato peeler: no timer found for player "..ply:SteamID())
        return 
    end

    if ply:GetPos():DistToSqr(session.ent:GetPos()) > MAX_DIST_SQR then
        impulse.debugPrint("Potato peeler: player too far from peeler. Player:"..ply:SteamID())
        return
    end

    local elapsed = CurTime() - session.startTime
    local maxRepsForTime = math.floor(elapsed / MIN_TIME_PER_REP)
    if reps > maxRepsForTime then
        LogPotatoExploit(ply, "Reported more potato reps than feasibly possible for their peeling session. Likely a net message exploiter, but not certain. Pay attention to this player.")
        reps = maxRepsForTime
    end

    if reps <= 0 then return end

    local newTime = timeLeft - reps
    if newTime < 1 then newTime = 1 end

    timer.Adjust(tname, newTime)

    OCAAB_CUR_FUNDS = (tonumber(OCAAB_CUR_FUNDS) or 0) + (reps * 3)

    ply:Notify("You have reduced your sentence by " .. reps .. " seconds from peeling the potatoes.")

    net.Start("DeepAdjustJailEndTime")
    net.WriteUInt(reps, 20)
    net.Send(ply)
end)
