AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_intmonitor003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    local id = self:GetCreationID()
    if impulse.Dispatch.GetCityCode() >= CODE_AJ or ply:HasInventoryItem("item_augmentchip") then
        if not ply:IsCP() then
            ply:Notify("You cannot use this machine.")
            return
        elseif ply:Team() == TEAM_CA then
            ply:Notify("You cannot use this machine.")
            return
        elseif not ply:GetTeamClass() then
            ply:Notify("You cannot use this machine.")
            return
        elseif ply:Team() == TEAM_OTA and (impulse.Dispatch.GetCityCode() >= CODE_AJ or ply:HasInventoryItem("item_augmentchip")) then
            if ply:Alive() then
                timer.Create(id .. "augmentor", 25, 1, function()
                    timer.Remove(id .. "augmentor")
                end)
                ply:Notify("Augmentation process underway, you will be unable to move for a moment.")
				if ply:HasInventoryItem("item_augmentchip") then
					ply:TakeInventoryItemClass("item_augmentchip",1,1)
				end
                self:EmitSound("ambient/machines/thumper_amb.wav")
                ply:Freeze(true)
                net.Start("impulseHL2RPCombineOverlayBoot")
                net.Send(ply)
                local sid = ply:SteamID()
                timer.Create(sid .. "augmentation", 25, 1, function()
                    if ply:GetTeamClass() == CLASS_ECHO or ply:GetTeamClass() == CLASS_MACE or ply:GetTeamClass() == CLASS_RANGER or ply:GetTeamClass() == CLASS_NOMAD then
                        if ply:GetTeamRank() < RANK_ORD and ply:GetTeamRank() > RANK_CGR then
                            ply:SetModel("models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl")
                            if ply:GetTeamClass() == CLASS_ECHO then
                                ply:SetSkin(0)
                                ply:SetArmor(180)
                                ply:SetRunSpeed(190)
                                ply.IsAugmented = true
                            elseif ply:GetTeamClass() == CLASS_MACE then
                                ply:SetSkin(1)
                                ply:SetArmor(200)
                                ply:SetRunSpeed(190)
                                ply.IsAugmented = true
                            elseif ply:GetTeamClass() == CLASS_RANGER then
                                ply:SetSkin(2)
                                ply:SetArmor(160)
                                ply:SetRunSpeed(190)
                                ply.IsAugmented = true
                            elseif ply:GetTeamClass() == CLASS_NOMAD then
                                ply:SetSkin(3)
                                ply:SetArmor(160)
                                ply:SetRunSpeed(190)
                                ply.IsAugmented = true
                            end
                        elseif ply:GetTeamRank() >= RANK_ORD then
                            ply:SetSkin(0)
                            ply:SetArmor(300)
                            ply:SetMaxArmor(300)
                            ply:SetHealth(130)
                            ply:SetMaxHealth(130)
                            ply:SetRunSpeed(200)
                            ply:SetModel("models/transition/soldiers/transition-ordinal/transition-ordinal.mdl")
                            ply.IsAugmented = true
                        else
                            ply:Notify("You cannot use this on your current rank.")
                        end
                    elseif ply:GetTeamClass() == CLASS_FIST and ply:GetTeamRank() < RANK_ORD then
                        ply:SetModel("models/wn/ota_elite_summit.mdl")
                        ply:SetArmor(250)
                        ply:SetRunSpeed(200)
                        ply.IsAugmented = true
                    elseif ply:GetTeamRank() >= RANK_ORD and ply:GetTeamClass() == CLASS_FIST then
                        ply:SetSkin(0)
                        ply:SetArmor(320)
                        ply:SetHealth(140)
                        ply:SetMaxHealth(140)
                        ply:SetRunSpeed(200)
                        ply:SetModel("models/transition/soldiers/transition-ordinal/transition-ordinal.mdl")
                        ply.IsAugmented = true
                    elseif ply:GetTeamClass() == CLASS_APF then
                        ply:SetSkin(0)
                        ply:SetArmor(400)
                        ply:SetHealth(175)
                        ply:SetMaxHealth(175)
                        ply:SetModel("models/transition/soldiers/suppressor-eow/suppressor-eow.mdl")
                        ply.IsAugmented = true
                    elseif ply:GetTeamClass() == CLASS_PAYBACK then
                        ply:SetSkin(0)
                        ply:SetArmor(575)
                        ply:SetHealth(300)
                        ply:SetMaxHealth(300)
                        ply:SetModel("models/transition/soldiers/wallhammer-eow/wallhammer-eow.mdl")
                        ply.IsAugmented = true
                    end
                    ply:Freeze(false)
                    self:StopSound("ambient/machines/thumper_amb.wav")
                    self:EmitSound("ambient/machines/teleport3.wav")
                end)
            else
                ply:Notify("You cannot use this on your current class.")
            end
        elseif ply.IsAugmented then
            ply:Notify("You are already an augmented unit.")
        elseif ply:Team() == TEAM_CP and ply:GetTeamRank() != nil then
            timer.Create(id .. "augmentor", 25, 1, function()
                timer.Remove(id .. "augmentor")
            end)
            ply:Notify("Augmentation process underway, you will be unable to move for a moment.")
				if ply:HasInventoryItem("item_augmentchip") then
					ply:TakeInventoryItemClass("item_augmentchip",1,1)
				end
            self:EmitSound("ambient/machines/thumper_amb.wav")
            ply:Freeze(true)
            net.Start("impulseHL2RPCombineOverlayBoot")
	    	net.Send(ply)
            local sid = ply:SteamID()
            timer.Create(sid .. "augmentation", 25, 1, function()
                if ply:Alive() and ply:Team() == TEAM_CP then
                    hook.Run("PlayerSetCombineRank", ply, ply:GetTeamRank(), ply:GetTeamClass())
                    ply:SetArmor(35)
                    ply:SetMaxArmor(35)
                    ply:SetWalkSpeed(120)
                    ply:SetRunSpeed(240)
                    ply:SetModel("models/earlbolat_customs/npc/vlk_male_1.mdl")
                    ply:SetBodygroup(8, 0)
                    if ply:GetTeamClass() == CLASS_UNION or ply:GetTeamClass() == CLASS_GRID then
                        ply:SetSkin(1)
                    elseif ply:GetTeamClass() == CLASS_HELIX then
                        ply:SetSkin(3)
                    elseif ply:GetTeamClass() == CLASS_SWORD then
                        ply:SetSkin(4)
                    elseif ply:GetTeamClass() == CLASS_GHOST then
                        ply:SetSkin(5)
                        ply:SetBodygroup(8, 1)
                    end
                    if ply:GetTeamRank() >= RANK_DVL then
                        ply:SetBodygroup(1, 6)
                    else
                        ply:SetBodygroup(1, 7)
                    end
                    if ply:GetTeamRank() == RANK_CMD then
                        ply:SetBodygroup(8, 1)
                    end
                    ply:SetBodygroup(2, 1)
                    ply:SetBodygroup(3, 1)
                    ply:SetBodygroup(4, 0)
                    ply:SetBodygroup(5, 1)
                    ply:SetBodygroup(6, 1)
                    ply:SetBodygroup(7, 0)
                    ply:Give("plutonic_mp7a8")
                    ply.IsAugmented = true
                    local ranktable = {"i4", "i3", "i2", "i1", "OfC", "SqL", "DvL", "DcO", "VCmD", "CmD"}
                    ply:SetRPName("MPF:" .. ranktable[ply:GetTeamRank()] .. ".SCAR-" ..math.random(1,999))
                    timer.Remove(sid.."augmentation")
                    ply:Notify("Augmentation process complete. Take no prisoners.")
                end
                ply:Freeze(false)
                self:StopSound("ambient/machines/thumper_amb.wav")
                self:EmitSound("ambient/machines/teleport3.wav")
            end)
        else
            ply:Notify("You cannot use this device.")
        end
    elseif ply:Team() == TEAM_OTA and impulse.Dispatch.GetCityCode() < CODE_AJ and ply.IsAugmented != true then
        local ranktable = {"CGR", "CSO", "ECS"}
        if ply:GetTeamClass() == CLASS_MACE or ply:GetTeamClass() == CLASS_ECHO or ply:GetTeamClass() == CLASS_FIST then
            if ply:GetTeamRank() == RANK_CGR and ply:GetTeamClass() != CLASS_FIST then
                if ply.NovaTrooper != true then
                    ply:SetSkin(2)
                    ply.NovaTrooper = true
                    self:EmitSound("items/suitchargeok1.wav")
                    ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".NOVA-"..math.random(1,99))
                elseif ply:GetTeamClass() == CLASS_MACE then
                    ply:SetSkin(1)
                    ply.NovaTrooper = false
                    self:EmitSound("items/suitchargeok1.wav")
                    ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".MACE-"..math.random(1,99))
                else
                    ply:SetSkin(0)
                    ply.NovaTrooper = false
                    self:EmitSound("items/suitchargeok1.wav")
                    ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".ECHO-"..math.random(1,99))
                end
            else
                if ply.NovaTrooper != true and ply:GetTeamClass() != CLASS_FIST then
                    if ply:GetTeamClass() == CLASS_MACE then
                        ply:SetSkin(1)
                        ply:SetModel("models/nemez/combine_soldiers/combine_soldier_nova_h.mdl")
                        ply.NovaTrooper = true
                        self:EmitSound("items/suitchargeok1.wav")
                    else
                        ply.NovaTrooper = true
                        ply:SetSkin(0)
                        ply:SetModel("models/nemez/combine_soldiers/combine_soldier_nova_h.mdl")
                        self:EmitSound("items/suitchargeok1.wav")
                    end
                    if ply:GetTeamRank() < RANK_CCP then
                        ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".NOVA-"..math.random(1,99))
                        self:EmitSound("items/suitchargeok1.wav")
                    end
                else
                    if ply:GetTeamClass() == CLASS_MACE then
                        if ply:GetTeamRank() < RANK_CCP then
                            ply:SetModel("models/nemez/combine_soldiers/combine_soldier_h.mdl")
                            ply:SetSkin(1)
                            ply.NovaTrooper = false
                            ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".MACE-"..math.random(1,99))
                            self:EmitSound("items/suitchargeok1.wav")
                        elseif ply:GetTeamRank() < RANK_ORD then
                            ply:SetModel("models/nemez/combine_soldiers/combine_soldier_urban_shotgunner_h.mdl")
                            ply:SetSkin(1)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        elseif ply:GetTeamRank() == RANK_ORD then
                            ply:SetModel("models/wn/ordinal.mdl")
                            ply:SetSkin(0)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        else
                            ply:SetModel("models/wn/dg/ordinal.mdl")
                            ply:SetSkin(0)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        end
                    elseif ply:GetTeamClass() == CLASS_ECHO then
                        if ply:GetTeamRank() < RANK_CCP then
                            local ranktable = {"CGR", "CSO", "ECS"}
                            ply:SetModel("models/nemez/combine_soldiers/combine_soldier_h.mdl")
                            ply:SetSkin(0)
                            ply.NovaTrooper = false
                            ply:SetRPName("CTA:"..ranktable[ply:GetTeamRank()]..".ECHO-"..math.random(1,99))
                            self:EmitSound("items/suitchargeok1.wav")
                        elseif ply:GetTeamRank() < RANK_ORD then
                            ply:SetModel("models/nemez/combine_soldiers/combine_soldier_coordinator_h.mdl")
                            ply:SetSkin(1)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        elseif ply:GetTeamRank() == RANK_ORD then
                            ply:SetModel("models/wn/ordinal.mdl")
                            ply:SetSkin(0)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        else
                            ply:SetModel("models/wn/dg/ordinal.mdl")
                            ply:SetSkin(0)
                            ply.NovaTrooper = false
                            self:EmitSound("items/suitchargeok1.wav")
                        end
                    elseif ply:GetTeamClass() == CLASS_FIST then
                        if ply.NovaTrooper == false then
                            if ply:GetTeamRank() < RANK_ORD then
                                ply:SetModel("models/nemez/combine_soldiers/combine_soldier_elite_wpu_h.mdl")
                                ply:SetSkin(0)
                                ply.NovaTrooper = true
                                self:EmitSound("items/suitchargeok1.wav")
                            else
                                ply:SetModel("models/transition/soldiers/ordinal-eow/ordinal-eow.mdl")
                                ply:SetSkin(0)
                                ply:SetBodygroup(1,0)
                                ply.NovaTrooper = true
                                self:EmitSound("items/suitchargeok1.wav")
                            end
                        else
                            if ply:GetTeamRank() < RANK_ORD then
                                ply:SetModel("models/nemez/combine_soldiers/combine_soldier_elite_h.mdl")
                                ply:SetSkin(0)
                                ply.NovaTrooper = false
                                self:EmitSound("items/suitchargeok1.wav")
                            else
                                ply:SetModel("models/wn/ota_elite_summit.mdl")
                                ply:SetSkin(0)
                                ply.NovaTrooper = false
                                self:EmitSound("items/suitchargeok1.wav")
                            end
                        end
                    end
                end
            end
        end
    else
        ply:Notify("This cannot be used unless the City Code is Judgement Waiver.")
    end
end