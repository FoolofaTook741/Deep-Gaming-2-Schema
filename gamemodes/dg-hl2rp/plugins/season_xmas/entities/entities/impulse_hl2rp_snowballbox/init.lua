AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/zerochain/props_christmas/snowballswep/zck_snowballcrate.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(caller, activator)
    if (caller.NextSnowballTake or 0) > CurTime() then return caller:Notify("Wait "..string.NiceTime(caller.NextSnowballTake - CurTime()).." before picking up more snowballs.") end

    if caller:HasWeapon("ls_snowball") then
        caller:Notify("You already have a snowball.")
        return
    else
        caller:Give("ls_snowball")
        caller.NextSnowballTake = CurTime() + 60
        caller:Notify("You have picked up 5 snowballs.")
    end
end
