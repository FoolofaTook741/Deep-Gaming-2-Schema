AddCSLuaFile("auctionhouse.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/gman_high.mdl")
    self:PhysicsInitBox(Vector(-16, -16, 0), Vector(16, 16, 72))
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 90))

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    self.PendingNotifications = {}
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    local sid = activator:SteamID()
    if self.PendingNotifications[sid] then
        self.PendingNotifications[sid] = nil
        net.Start("AuctionHouse_ClearNotification")
        net.WriteEntity(self)
        net.Send(activator)
    end

    net.Start("AuctionHouse_Open")
    net.WriteEntity(self)
    net.Send(activator)
end

function ENT:AddNotification(ply, message)
    if not IsValid(ply) then return end

    local sid = ply:SteamID()
    self.PendingNotifications[sid] = true

    if ply:IsConnected() then
        ply:Notify(message)
        net.Start("AuctionHouse_ShowNotification")
        net.WriteEntity(self)
        net.Send(ply)
    end
end

function ENT:SendNotificationState(ply)
    if not IsValid(ply) then return end
    local sid = ply:SteamID()
    if self.PendingNotifications[sid] then
        net.Start("AuctionHouse_ShowNotification")
        net.WriteEntity(self)
        net.Send(ply)
    end
end

util.AddNetworkString("AuctionHouse_Open")
util.AddNetworkString("AuctionHouse_ShowNotification")
util.AddNetworkString("AuctionHouse_ClearNotification")
