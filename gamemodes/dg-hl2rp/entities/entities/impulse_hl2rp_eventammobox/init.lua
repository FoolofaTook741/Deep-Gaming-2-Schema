AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self.openSequence = self:LookupSequence("Open")
    self.cooldown = 0
end

local ammoValues = {
    ["Pistol"] = 250,
    ["357"] = 24,
    ["SniperRound"] = 160,
    ["AirboatGun"] = 90,
    ["SMG1"] = 500,
    ["slam"] = 3,
    ["Grenade"] = 1,
    ["AR2"] = 300,
    ["Buckshot"] = 52,
    ["XBowBolt"] = 45,
    ["SniperPenetratedRound"] = 20,
    ["AlyxGun"] = 600,
    ["Rifle"] = 360,
    ["AR2AltFire"] = 1,
    ["SMG1_Grenade"] = 2,
}

function ENT:Use(caller, activator)
    if self.cooldown > CurTime() then return end
    self.cooldown = CurTime() + 1.2

    self:ResetSequence(self.openSequence)
    self:EmitBudgetSound("items/ammocrate_open.wav")

    timer.Simple(self:SequenceDuration(self.openSequence), function()
        if not IsValid(self) then return end
        self:ResetSequence(0)
        self:EmitBudgetSound("items/ammocrate_close.wav")
    end)

    timer.Simple(0.1, function()
        if not IsValid(self) or not IsValid(activator) then return end
        activator:EmitBudgetSound("items/ammo_pickup.wav")
    end)

    for v,k in pairs(activator:GetWeapons()) do
        local ammoName = game.GetAmmoName(k:GetPrimaryAmmoType())

        if ammoValues[ammoName] then
            local ammoCount = activator:GetAmmoCount(ammoName)
            
            if ammoCount and ammoCount < ammoValues[ammoName] then
                activator:SetAmmo(ammoValues[ammoName], k:GetPrimaryAmmoType())
            end
        end
    end

    activator:Notify("Your ammo has been restocked.")
end