AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/suit_charger001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    self.chargeSequence = self:LookupSequence("Open")
    self.cooldown = 0
    self.Enhanced = false
end

function ENT:Use(caller, activator)
    if self.cooldown > CurTime() then return end

    local armor 

    if self.Enhanced then
        armor = math.Clamp(caller:Armor() + 30, 0, caller:GetMaxArmor())
    else
        armor = math.Clamp(caller:Armor() + 15, 0, caller:GetMaxArmor())
    end

    if caller:IsCP() then
        if caller:Team() == TEAM_CP then
            if caller:Armor() >= armor then
                self:EmitBudgetSound("items/suitchargeno1.wav")
                self.cooldown = CurTime() + 0.2
                return
            else
                self:ResetSequence(self.chargeSequence)
                self:EmitBudgetSound("items/suitchargeok1.wav")

                caller:SetArmor(armor)

                caller:SendCombineMessage("SUIT PROTECTION SYSTEM CHARGE INCREASED", Color(200, 125, 0))
                self.cooldown = CurTime() + 2
            end
        elseif caller:Team() == TEAM_OTA then
            if caller:Armor() >= armor then
                self:EmitBudgetSound("items/suitchargeno1.wav")
                self.cooldown = CurTime() + 2
                return
            else
                self:ResetSequence(self.chargeSequence)
                self:EmitBudgetSound("items/suitchargeok1.wav")

                caller:SetArmor(armor)

                caller:SendCombineMessage("SUIT PROTECTION SYSTEM CHARGE INCREASED", Color(200, 125, 0))
                self.cooldown = CurTime() + 2
            end
        else
            caller:Notify("You cannot use this on your current team.")
        end
    else
        caller:Notify("You cannot use this on your current team.")
        self.cooldown = CurTime() + 0.2
    end
end
