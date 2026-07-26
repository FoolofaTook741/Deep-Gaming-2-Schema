AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/health_charger001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    self.cooldown = 0
end

function ENT:Use(caller, activator)
    if self.cooldown > CurTime() then return end

    if caller:Team() == TEAM_CP or caller:Team() == TEAM_OTA or caller:Team() == TEAM_CA or caller:Team() == TEAM_CREMATOR then
        if caller:Team() == TEAM_OTA and caller:GetTeamClass() == CLASS_PAYBACK then
            if caller:Health() < caller:GetMaxHealth() then
                self:EmitBudgetSound("items/medshot4.wav")

                caller:SetHealth(caller:GetMaxHealth() * (1 - (caller.Antiheal or 0)))
    
                if caller:HasBrokenLegs() then
                    caller:FixLegs()
                end
                if caller:GetSyncVar(SYNC_BLEEDING,false) then
                    caller:SetSyncVar(SYNC_BLEEDING,false,true) -- remove bleeding and insta sync it :)
                end
    
                caller:SendCombineMessage("BIO-GEL INJECTION SYSTEM ACTIVATED", Color(0, 255, 0))
                self.cooldown = CurTime() + 3
            else
                self:EmitBudgetSound("items/medshotno1.wav")
                self.cooldown = CurTime() + 1
                return
            end
        elseif caller:Health() >= caller:GetMaxHealth() then
            self:EmitBudgetSound("items/medshotno1.wav")
            self.cooldown = CurTime() + 1
            return
        else
            --self:ResetSequence(self.chargeSequence)
            self:EmitBudgetSound("items/medshot4.wav")

            caller:SetHealth(caller:GetMaxHealth() * (1 - (caller.Antiheal or 0)))

            if caller:HasBrokenLegs() then
                caller:FixLegs()
            end
            if caller:GetSyncVar(SYNC_BLEEDING,false) then
                caller:SetSyncVar(SYNC_BLEEDING,false,true) -- remove bleeding and insta sync it :)
            end

            caller:SendCombineMessage("BIO-GEL INJECTION SYSTEM ACTIVATED", Color(0, 255, 0))
            self.cooldown = CurTime() + 3
        end
    else
        caller:Notify("You must be a CP, OTA or OCA to use this.")
        self.cooldown = CurTime() + 1
    end
end
