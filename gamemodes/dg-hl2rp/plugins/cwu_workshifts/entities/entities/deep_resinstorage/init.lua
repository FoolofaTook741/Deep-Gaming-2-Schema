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
        --ply:GiveMoney(15*count)   
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

    local maxUnits = math.Clamp(math.floor(CWU_RESIN * 10), 1, 100)
    local units = math.random(1, maxUnits)

    for i = 1, units do
        ply:GiveInventoryItem("util_resin")
    end

    CWU_RESIN = math.max(CWU_RESIN - (units / 10), 0)

    ply:Notify(("You have stolen %.1f KG of Resin."):format(units / 10))
end