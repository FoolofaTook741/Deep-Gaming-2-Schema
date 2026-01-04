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

net.Receive("potatoesPeeled", function(len, ply)
    local s = net.ReadInt(32)
    local reduction = s
	if not timer.TimeLeft(ply:UserID().."impulsePrison") then return end
    local timeleft = timer.TimeLeft(ply:UserID().."impulsePrison") - reduction
    if timeleft < 1 then
        timeleft = 1
    end
    ply:Notify("You have reduced your sentence by " .. reduction .. " seconds from peeling the potatoes.")
    timer.Adjust(ply:UserID().."impulsePrison", timeleft)
    OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (s * 3)
    net.Start("DeepAdjustJailEndTime")
    net.WriteUInt(reduction, 20)
    net.Send(ply)
end)
