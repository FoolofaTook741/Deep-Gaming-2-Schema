AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/hls/combine_dispenser.mdl")
    self:PhysicsInitBox(
        Vector(-8, -8, 0),
        Vector(8, 8, 48)
    )

    self:SetCollisionBounds(
        Vector(-8, -8, 0),
        Vector(8, 8, 48)
    )
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetPlaybackRate(1)
    self:SetLight(3)
    self.rationsactive = true
    self.Enhanced = false

    self.dispenseAnim = self:LookupSequence("dispense_package")
end

local rationModels = {
    [TEAM_CITIZEN] = "models/weapons/w_package.mdl",
    [TEAM_CWU] = "models/weapons/w_package.mdl",
    [TEAM_CP] = "models/weapons/w_package.mdl",
    [TEAM_OTA] = "models/weapons/w_package.mdl",
    [TEAM_CA] = "models/weapons/w_package.mdl",
    [TEAM_VORT] = "models/weapons/w_package.mdl"
}

local rationItemsMarginal = {
    [TEAM_CITIZEN] = "card_civ_marginal",
    [TEAM_CITIZEN] = "card_1_marginal",
    [TEAM_CITIZEN] = "card_2_marginal",
    [TEAM_CITIZEN] = "card_3_marginal",
    [TEAM_CWU] = "card_cwu_marginal",
    [TEAM_CP] = "card_cp_marginal",
    [TEAM_OTA] = "card_ota_marginal",
    [TEAM_CA] = "card_ca",
    [TEAM_VORT] = "card_vort_marginal"
}

local rationFood = {
    [TEAM_CITIZEN] = "food_civilianration",
    [TEAM_CWU] = "food_civilianration",
    [TEAM_CP] = "food_ration",
    [TEAM_OTA] = "food_ration",
    [TEAM_CA] = "food_ration",
    [TEAM_VORT] = "food_civilianrationmarginal"
}

local rationItems = {
    [TEAM_CITIZEN] = "card_civ",
    [TEAM_CITIZEN] = "card_1",
    [TEAM_CITIZEN] = "card_2",
    [TEAM_CITIZEN] = "card_3",
    [TEAM_CWU] = "card_cwu",
    [TEAM_CP] = "card_cp",
    [TEAM_OTA] = "card_ota",
    [TEAM_CA] = "card_ca",
    [TEAM_VORT] = "card_vort"
}

local rationFoodMarginal = {
    [TEAM_CITIZEN] = "food_civilianrationmarginal",
    [TEAM_CWU] = "food_civilianrationmarginal",
    [TEAM_CP] = "food_ration",
    [TEAM_OTA] = "food_ration",
    [TEAM_CA] = "food_ration",
    [TEAM_VORT] = "food_sardines"
}
--[[
function ENT:Initialize()
    self:SetModel("models/props_combine/combine_dispenser.mdl")
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetPlaybackRate(1)
    self:SetLight(3)
    self.rationsactive = true
    self.Enhanced = false
    self.dispenseAnim = self:LookupSequence("dispense_package")
end ]]--

local rationModels = {
    [TEAM_CITIZEN] = "models/weapons/w_package.mdl",
    [TEAM_CWU] = "models/weapons/w_package.mdl",
    [TEAM_CP] = "models/weapons/w_package.mdl",
    [TEAM_OTA] = "models/weapons/w_package.mdl",
    [TEAM_CA] = "models/weapons/w_package.mdl",
    [TEAM_VORT] = "models/weapons/w_package.mdl"
}

local rationItemsMarginal = {
    [TEAM_CITIZEN] = "card_civ_marginal",
    [TEAM_CITIZEN] = "card_1_marginal",
    [TEAM_CITIZEN] = "card_2_marginal",
    [TEAM_CITIZEN] = "card_3_marginal",
    [TEAM_CWU] = "card_cwu_marginal",
    [TEAM_CP] = "card_cp_marginal",
    [TEAM_OTA] = "card_ota_marginal",
    [TEAM_CA] = "card_ca",
    [TEAM_VORT] = "card_vort_marginal"
}

local rationFood = {
    [TEAM_CITIZEN] = "food_civilianration",
    [TEAM_CWU] = "food_civilianration",
    [TEAM_CP] = "food_ration",
    [TEAM_OTA] = "food_ration",
    [TEAM_CA] = "food_ration",
    [TEAM_VORT] = "food_civilianrationmarginal"
}

local rationItems = {
    [TEAM_CITIZEN] = "card_civ",
    [TEAM_CITIZEN] = "card_1",
    [TEAM_CITIZEN] = "card_2",
    [TEAM_CITIZEN] = "card_3",
    [TEAM_CWU] = "card_cwu",
    [TEAM_CP] = "card_cp",
    [TEAM_OTA] = "card_ota",
    [TEAM_CA] = "card_ca",
    [TEAM_VORT] = "card_vort"
}

local rationFoodMarginal = {
    [TEAM_CITIZEN] = "food_civilianrationmarginal",
    [TEAM_CWU] = "food_civilianrationmarginal",
    [TEAM_CP] = "food_ration",
    [TEAM_OTA] = "food_ration",
    [TEAM_CA] = "food_ration",
    [TEAM_VORT] = "food_sardines"
}

function ENT:Use(activator, caller)
    if activator:Team() == TEAM_ZOMBIE then
        activator:Notify("yo headcrab is already eating yo bum ass what the fuck you need a ration for.")
        return
    elseif (activator:Team() == TEAM_CP or activator:Team() == TEAM_OTA) and timer.Exists(self:GetCreationID() .. "rationhack") then
        activator:Notify("You have successfully stopped a hack on the ration center. 500 credits awarded.")
        activator:GiveMoney(500)
        self:StopSound("ambient/alarms/alarm_citizen_loop1.wav")
        timer.Remove(self:GetCreationID() .. "rationhack")
        timer.Remove("rhackspawn1")
        timer.Remove("rhackspawn2")
        timer.Remove("rhackspawn3")
        timer.Remove("rhackspawn4")
        timer.Remove("rhackspawn5")
        timer.Remove("rhackspawn6")
        timer.Remove("rhackspawn7")
        timer.Remove("rhackspawn8")
        timer.Remove("rhackspawn9")
        timer.Remove("rhackspawn10")
        timer.Remove("rhackspawn11")
        timer.Remove("rhackspawn12")
        return
    elseif timer.Exists(self:GetCreationID() .. "rationhack") then
        activator:Notify("The ration center is being hacked. You cannot retrieve your ration at this time.")
        return
    elseif DG_RATIONS == false and (activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU or activator:Team() == TEAM_VORT) then
        activator:Notify("Civic rations are currently suspended. Please contact a Civil Protection officer for more information.")
        self:SetLight(1)
        self:EmitBudgetSound("buttons/button19.wav")
        timer.Simple(1, function()
            if not IsValid(self) then return end
            self:SetLight(3)
        end)
        self.NextDispenseTime = CurTime() + 2
        return
    elseif self.rationsactive == false and (activator:Team() == TEAM_CITIZEN or activator:Team() == TEAM_CWU or activator:Team() == TEAM_VORT) then
        activator:Notify("Civic rations are being restocked. You cannot retrieve your ration at this time.")
        self:SetLight(1)
        self:EmitBudgetSound("buttons/button19.wav")
        timer.Simple(1, function()
            if not IsValid(self) then return end
            self:SetLight(3)
        end)
        self.NextDispenseTime = CurTime() + 2
        return
    end

    if (self.NextDispenseTime or 0) >= CurTime() then return end

    self.NextDispenseTime = CurTime() + 3
    local pos = self:GetPos() + self:GetForward() * 15 + self:GetRight() * -6 + self:GetUp() * -6
    local ang = self:GetAngles()

  if caller.NextRation >= CurTime() and not caller.RewardRation then
        self:SetLight(1)
        self:EmitBudgetSound("buttons/button19.wav")
        caller:Notify("You must wait " .. string.NiceTime(caller.NextRation - CurTime()) .. " before getting your next ration.")
        timer.Simple(1, function()
            if not IsValid(self) then return end
            self:SetLight(3)
        end)
        self.NextDispenseTime = CurTime() + 2
        return
    end

    caller:Notify("Dispensing ration...")
    self:EmitBudgetSound("ambient/machines/combine_terminal_idle4.wav")
    self:ResetSequence(self.dispenseAnim)
    self:SetSequence(self.dispenseAnim)
    caller.RationNotified = false

--[[     if caller.CurrentQuest == 1 then
        caller:CompleteQuest()
    end ]]

    local reward, rationType
    if caller.RewardRation then
        reward = caller.RewardRation
        caller.RewardRation = nil
    else
        rationType = caller:Team()
        caller.NextRation = CurTime() + impulse.Config.RationTime
    end

    rationType = caller:Team()
    if (rationType == TEAM_CP or rationType == TEAM_OTA) and not caller:GetTeamClass() then
        rationType = TEAM_CITIZEN
    end

    local fake = ents.Create("prop_physics")
    if reward then
        fake:SetModel("models/weapons/w_packatp.mdl")
    elseif rationModels[rationType] then
        fake:SetModel(rationModels[rationType])
    else
        fake:SetModel("models/weapons/w_packatc.mdl")
    end

    fake:Spawn()
    fake:SetNotSolid(true)
    fake:SetParent(self)
    fake:Fire("SetParentAttachment", "package_attachment")

    self:SetLight(2)
    timer.Simple(1.8, function()
        if not IsValid(self) or not IsValid(fake) then return end
        local fPos = fake:GetPos()
        local fAng = fake:GetAngles()
        fake:Remove()

        if not IsValid(activator) then return end

        local isUnrest = impulse.Dispatch.GetCityCode() >= CODE_UNREST
        if isUnrest then
            activator:Notify("You have received your ration. Due to the current politstabilization level, you have received reduced money and food.")
        else
            activator:Notify("You have received your ration.")
        end

        if activator:Team() == TEAM_CITIZEN then
            local steamid = activator:SteamID()
            local query = mysql:Select("impulse_whitelists")
            query:Select("level")
            query:Where("steamid", steamid)
            query:Where("team", "TEAM_CITIZEN")
            query:Callback(function(result)
                if not IsValid(activator) then return end
                local level = 0
                if type(result) == "table" and #result > 0 then
                    level = tonumber(result[1].level) or 0
                end

                if level >= 3 then
                    activator:GiveInventoryItem("ration_tier3", 1)
                    activator:GiveInventoryItem(isUnrest and "card_3_marginal" or "card_3", 1)
                elseif level == 2 then
                    activator:GiveInventoryItem("ration_tier2", 1)
                    activator:GiveInventoryItem(isUnrest and "card_2_marginal" or "card_2", 1)
                elseif level == 1 then
                    activator:GiveInventoryItem("ration_tier1", 1)
                    activator:GiveInventoryItem(isUnrest and "card_1_marginal" or "card_1", 1)
                else
                    activator:GiveInventoryItem("ration_civ", 1)
                    activator:GiveInventoryItem(isUnrest and "card_civ_marginal" or "card_civ", 1)
                end
            end)
            query:Execute()
        else
            if isUnrest then
                activator:GiveInventoryItem(rationItemsMarginal[activator:Team()], 1, activator:IsCP())
                activator:GiveInventoryItem(rationFoodMarginal[activator:Team()], 1, activator:IsCP())
            else
                activator:GiveInventoryItem(rationItems[activator:Team()], 1, activator:IsCP())
                activator:GiveInventoryItem(rationFood[activator:Team()], 1, activator:IsCP())
            end

            if activator:IsCP() and self.Enhanced then
                activator:GiveInventoryItem("card_christmas", 1, activator:IsCP())
            end

            if activator:Team() == TEAM_OTA then
                if self.Enhanced then
                    activator:GiveInventoryItem("stimulant_dr", 1, activator:IsCP())
                    activator:GiveInventoryItem("stimulant_adrenaline", 1, activator:IsCP())
                    activator:GiveInventoryItem("stimulant_creatine", 1, activator:IsCP())
                else
                    local stims = {"stimulant_adrenaline", "stimulant_creatine", "stimulant_dr"}
                    activator:GiveInventoryItem(table.Random(stims), 1, activator:IsCP())
                end
            end

            if activator:IsCP() then
                activator:GiveInventoryItem("card_christmas", 1, activator:IsCP())
            end
        end
    end)

    timer.Simple(2, function()
        if not IsValid(self) then return end
        self:SetLight(3)
    end)
end



