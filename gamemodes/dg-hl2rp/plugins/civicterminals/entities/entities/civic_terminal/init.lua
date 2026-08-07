AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua") 

include("shared.lua")

local LoyalistTier

function ENT:Initialize()
    self:SetModel("models/hls/alyxports/monitor_medium.mdl")

    self:SetBodyGroups(0)
    self.seqCloseIdle = self:LookupSequence("close_idle")
    self.seqOpen = self:LookupSequence("open")
    self.seqOpenIdle = self:LookupSequence("open_idle")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:ResetSequence(self.seqCloseIdle)

    self.IsOpen = false
    self.HasPlayedCloseSound = true

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:HasNearbyPlayer(rangeSqr)
    local pos = self:GetPos()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and pos:DistToSqr(ply:GetPos()) <= rangeSqr then
            return true
        end
    end
    return false
end

local RANGE_SQR = 95 * 95
function ENT:Think()
    local shouldAnimate = self:HasNearbyPlayer(RANGE_SQR)
    self.IsOpening = false

    if shouldAnimate then
        if self:GetSequence() == self.seqCloseIdle then
            self:SetPlaybackRate(0.05)
            self:ResetSequence(self.seqOpen)
            self:EmitSound("combine_tech/civic_station/station_slide_open.mp3")

            self.IsOpening = true
            self.HasPlayedCloseSound = false
            self.IsOpen = true
        end
    else
        if self.IsOpen then
            self:ResetSequence(self.seqCloseIdle)

            if not self.HasPlayedCloseSound then
                self.HasPlayedCloseSound = true
                self:EmitSound("combine_tech/civic_station/station_slide_closed.mp3")
            end

            self.IsOpen = false
        end
    end

    if self.IsOpening and self:GetSequence() == self.seqOpen then
        self:ResetSequence(self.seqOpenIdle)
    end

    self:NextThink(CurTime() + 0.5)
    return true
end

util.AddNetworkString("Monitor_Activate")

net.Receive("Monitor_Activate", function(len, ply)
    local ent = net.ReadEntity()
    if IsValid(ent) and ent:GetClass() == "your_entity_class" then
        print(ply:Nick() .. " pressed the terminal button!")

        -- Example: trigger a response
        ent:EmitSound("buttons/button3.wav")
    end
end)

util.AddNetworkString("impulseHL2RPCitizenTerminal")
util.AddNetworkString("impulseHL2RPAssignHousing")
util.AddNetworkString("impulseHL2RPRequestCPsTerminal")
util.AddNetworkString("impulseHL2RPGetLoyalistTier")
util.AddNetworkString("impulseHL2RPLoyalistTierReturn")
util.AddNetworkString("impulseHL2RPOCABUpdate")
util.AddNetworkString("impulseHL2RPOCABReturn")

local MAX_BULLETIN_LENGTH = 500
local OCAB_ExploitAttempts = {}

local function LogOCABExploit(ply, reason)
    if not IsValid(ply) then return end

    OCAB_ExploitAttempts[ply] = (OCAB_ExploitAttempts[ply] or 0) + 1

    print(string.format(
        "[OCAB BLOCKED] %s (%s | %s) | Reason: %s | Attempts: %d",
        ply:Nick(),
        ply:SteamID(),
        ply:SteamID64(),
        reason,
        OCAB_ExploitAttempts[ply]
    ))
end

net.Receive("impulseHL2RPOCABUpdate", function(_, ply)
    local text = net.ReadString()

    if ply:Team() ~= TEAM_CA then
        LogOCABExploit(ply, "Wrong team")
        return
    end

    if ply:GetTeamRank() == 0 and ply:Team() ~= TEAM_CA then
        LogOCABExploit(ply, "Insufficient rank")
        return
    end

    if not isstring(text) or text == "" then
        LogOCABExploit(ply, "Invalid or empty text")
        return
    end

    if #text > MAX_BULLETIN_LENGTH then
        LogOCABExploit(ply, "Text too long")
        return
    end

    text = string.Trim(text)

    -- reset exploit counter if there is no exploit xdxdxd
    OCAB_ExploitAttempts[ply] = nil

    impulse.debugPrint("[OCAB UPDATE] Bulletin updated by", ply:Nick(), ply:SteamID())

    net.Start("impulseHL2RPOCABReturn")
    net.WriteString(text)
    net.WriteEntity(ply)
    net.Broadcast()
end)

net.Receive("impulseHL2RPGetLoyalistTier", function(len, ply)
    local ent = net.ReadEntity()
    local activator = ply
    if not IsValid(ent) then return 0 end

    local steamid = activator:SteamID()
    local query = mysql:Select("impulse_whitelists")
    query:Select("level")
    query:Where("steamid", steamid)
    query:Where("team", "TEAM_CITIZEN")
    query:Callback(function(result)
        if not IsValid(activator) then return end
        local level = 0

        if type(result) == "table" and #result > 0 then
            level = tonumber(result[1].level) or 0
        end
        LoyalistTier = level
    end)
    query:Execute()

    if not LoyalistTier then LoyalistTier = 0 end

    net.Start("impulseHL2RPLoyalistTierReturn")
        net.WriteUInt(LoyalistTier, 8)
    net.Send(activator)
end)

net.Receive("impulseHL2RPRequestCPsTerminal", function(len, ply)

    if ((ply.lastTryRequest or 0) > CurTime()) then
        return
    end

    ply.lastTryRequest = CurTime() + 15

    local terminal = net.ReadEntity()

    if not IsValid(terminal) then
        return
    end

    if not (terminal:GetClass() == "impulse_hl2rp_citizen_terminal") then
        return
    end

    if terminal:GetPos():DistToSqr( ply:GetPos() ) > 200^2 then
        return
    end

    local recipFilter = RecipientFilter()

	for v,k in pairs(player.GetAll()) do
		if k:Team() == TEAM_CP then
			recipFilter:AddPlayer(k)
		end
	end

	net.Start("impulseHL2RPRequest")
	net.WriteUInt(ply:EntIndex(), 8)
	net.WriteString("REQUEST FROM CIVIC TEMRINAL")
	net.Send(recipFilter)

    terminal:SetState(1)

    timer.Simple(30, function()
        terminal:SetState(0)
    end)
end)
