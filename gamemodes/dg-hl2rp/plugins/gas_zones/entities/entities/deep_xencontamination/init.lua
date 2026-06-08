AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local GAS_RADIUS = 150
local GAS_DAMAGE = 1     --per tick damage to non gas mask players
local GAS_TICK   = 1   --seconds between damage ticks

function ENT:Initialize()
    self:SetModel("models/error.mdl")
    self:SetSolid(SOLID_NONE)
    self:SetNoDraw(true)
    self:SetMoveType(MOVETYPE_NONE)
    self:NextThink(CurTime() + GAS_TICK)
end

function ENT:Think()
    local pos = self:GetPos()

    for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() then continue end
        if ply.GasSafe then continue end
        if ply:Team() == TEAM_CREMATOR or ply:GetTeamClass() == CLASS_ICT or ply:Team() == TEAM_ZOMBIE then continue end  --cremators, zombies and ict are immune to gas
        if pos:Distance(ply:GetPos()) > GAS_RADIUS then continue end

        ply:TakeDamage(GAS_DAMAGE, self, self)
    end

    self:NextThink(CurTime() + GAS_TICK)
    return true
end
