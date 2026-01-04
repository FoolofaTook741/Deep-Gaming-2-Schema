AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local notice = false
local researching = false

function ENT:Initialize()
    self:SetModel("models/props/de_nuke/crate_large.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
    local ply = activator
	local has, count = ply:HasInventoryItem("util_resin")
    if has then
        ply:TakeInventoryItemClass("util_resin", nil, count)
        ply:GiveMoney(15*count)   
        CWU_RESIN = CWU_RESIN + 0.1*count
        ply:Notify("You have deposited "..0.1*count.." kg of Resin into storage.")
        return
    end
end

function ENT:RaidStorage(ply)
    if CWU_RESIN <= 0 then
        ply:Notify("There was no Resin in storage.")
        return
    end
    local weight = math.random(1, math.Clamp(CWU_RESIN * 10, 1, 100))
    local aaa = 0
    while aaa <= weight do
        ply:GiveInventoryItem("util_resin")
    end
    ply:Notify("You have stolen " .. weight/10 .. " KG of Resin.")
end