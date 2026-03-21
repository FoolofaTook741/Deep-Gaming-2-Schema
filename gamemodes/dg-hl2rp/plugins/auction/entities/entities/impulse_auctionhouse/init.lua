AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_auctionhouse.lua")
AddCSLuaFile("cl_auctions.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/gman_high.mdl")

    self:PhysicsInitBox(Vector(-16, -16, 0), Vector(16, 16, 72))
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))

    self.PendingNotifications = {}
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    local t = activator:Team()
    if t ~= TEAM_CWU and t ~= TEAM_CITIZEN and t ~= TEAM_VORT then
        activator:Notify("You cannot use this as your current team.")
        return
    end

    local sid = activator:SteamID()
    for _, ent in ipairs(ents.FindByClass("impulse_auctionhouse")) do
        if IsValid(ent) then
            ent.PendingNotifications[sid] = nil
        end
    end
    net.Start("AuctionHouse_ClearNotification")
    net.Send(activator)

    net.Start("AuctionHouse_Open")
    net.WriteEntity(self)
    net.WriteBool(activator:IsCollaborator())
    net.Send(activator)

    if impulse.Auctions then
        impulse.Auctions.ProcessPickups(activator)
    end
end

util.AddNetworkString("AuctionHouse_Open")
util.AddNetworkString("AuctionHouse_ShowNotification")
util.AddNetworkString("AuctionHouse_ClearNotification")