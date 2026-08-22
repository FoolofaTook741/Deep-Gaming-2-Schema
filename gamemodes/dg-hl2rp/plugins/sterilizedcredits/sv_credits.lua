util.AddNetworkString("DeepSterilizedCreditsPurchase")
util.AddNetworkString("DeepAwardSCs")
util.AddNetworkString("DeepSynchronizeSCCount")

function meta:AdjustSC(amount, message)
    local ply = self
    amount = math.Clamp(tonumber(amount) or 0, -100000, 100000)
    local SterilizedCredits = math.Clamp(math.floor((ply.SC or 0) + amount), 0, 100000)
    local col = Color(255,100,100)
    local action = "DEDUCTED"
    if amount > 0 then
        col = Color(100,255,100)
        action = "AWARDED"
    end
    if message == true then
        ply:SendCombineMessage(math.abs(amount) .. " STERILIZED CREDITS HAVE BEEN " .. action .. ".", col)
    end
    local steamid = self:SteamID()
    local query = mysql:Update("impulse_players")
    query:Where("steamid", steamid)
    query:Update("sterilizedcredits", SterilizedCredits)
    query:Execute()
    ply.SC = SterilizedCredits
    net.Start("DeepSynchronizeSCCount")
    net.WriteUInt(SterilizedCredits, 20)
    net.Send(ply)
end

function meta:SetSCs(amount)
    if amount < 0 then
        amount = 0
    end
    if amount > 100000 then
        return
    end
    local ply = self
    local steamid = self:SteamID()
    ply.SC = math.floor(amount)
    local query = mysql:Update("impulse_players")
    query:Where("steamid", steamid)
    query:Update("sterilizedcredits", ply.SC)
    query:Execute()
    net.Start("DeepSynchronizeSCCount")
    net.WriteUInt(amount, 20)
    net.Send(ply)
end

function meta:CanAffordSCPurchase(cost)
    local ply = self
    if ply.SC >= cost then
        return true
    else
        return false
    end
end

function meta:CanPurchaseSCCombat()
    local ply = self
    if not ply.NextStorage then
        ply.NextStorage = 0
    end
    if not ply.NextPurchase then
        ply.NextPurchase = 0
    end
    if (ply.NextStorage > CurTime()) then
        ply:Notify("Because you were recently in combat you must wait "..string.NiceTime(ply.NextStorage - CurTime()).." before purchasing from the SC shop.")
        return false
    elseif (ply.NextPurchase > CurTime()) then
        ply:Notify("Because you recently made a purchase you must wait ".. math.floor(ply.NextPurchase - CurTime()).." seconds before purchasing from the SC shop.")
        return false
    else
        return true
    end
end

net.Receive("DeepSterilizedCreditsPurchase", function(len, ply)
    if not IsValid(ply) then return end
    if ply:Team() != TEAM_CP then
        ply:Notify("You must be a Civil Protection officer to make purchases.")
        return
    end
    if ply:GetTeamRank() < RANK_I2 then
        ply:Notify("You must be rank I2 or higher to make purchases.")
        return
    end
    if not ply:CanPurchaseSCCombat() then
        return
    end
    if ply.NextPurchase and ply.NextPurchase > CurTime() then
        ply:Notify("You must wait " .. math.floor(ply.NextPurchase - CurTime()) .. " seconds before making another purchase.")
        return
    end
    local purchasetype = net.ReadString()
    local info = net.ReadString()
    local cost = net.ReadInt(16)
    if cost < 15 then
        ply:Notify("Purchase cost is too low.")
        return
    end
    if not ply:CanAffordSCPurchase(cost) then
        ply:Notify("You cannot afford this purchase.")
        return
    end
    local validweapons = {
        ["wep_cz75"] = true, ["wep_pm63"] = true, ["wep_mp7"] = true,
        ["wep_mini14"] = true, ["wep_mp7a8"] = true, ["wep_m500"] = true,
        ["wep_shotgun"] = true, ["wep_357"] = true, ["grenade_flashbang"] = true,
        ["wep_teargas"] = true, ["item_enhancedvial"] = true, ["stimulant_regen"] = true
    }
    local validweaponscost = {
        ["wep_cz75"] = 40, ["wep_pm63"] = 80, ["wep_mp7"] = 130,
        ["wep_mini14"] = 160, ["wep_mp7a8"] = 550, ["wep_m500"] = 300,
        ["wep_shotgun"] = 350, ["wep_357"] = 425, ["grenade_flashbang"] = 50,
        ["wep_teargas"] = 60, ["item_enhancedvial"] = 30, ["stimulant_regen"] = 50
    }
    if purchasetype == "Item" then
        if info == "Credits" then
            local sc_to_deduct = 50
            local credits_to_add = 500
            if not ply:CanAffordSCPurchase(sc_to_deduct) then
                ply:Notify("You cannot afford to spend " .. sc_to_deduct .. " SC.")
                return
            end
            ply:AdjustSC(-sc_to_deduct, true)
            local currentMoney = ply:GetMoney() or 0
            ply:SetMoney(currentMoney + credits_to_add)
            ply.NextPurchase = CurTime() + 30
            ply:Notify("You spent " .. sc_to_deduct .. " SC and received " .. credits_to_add .. " credits.")
            ServerLog(string.format("[SC PURCHASE] Player %s purchased %d credits for %d SC\n", ply:Nick(), credits_to_add, sc_to_deduct))
        elseif validweapons[info] then
            if cost < validweaponscost[info] then
                ply:Notify("Invalid weapon cost.")
                return
            end
            if ply:CanHoldItem(info) then
                if info == "wep_mini14" then
                    ply:GiveInventoryItem("att_optic", 1, true)
                    ply:GiveInventoryItem(info, 1, true)
                else
                    ply:GiveInventoryItem(info, 1, true)
                end
                ply:AdjustSC(-cost, true)
                ply.NextPurchase = CurTime() + 30
                ServerLog(string.format("[SC PURCHASE] Player %s purchased weapon %s for %d SC\n", ply:Nick(), info, cost))
            else
                ply:Notify("You cannot hold this item. Your credits have not been deducted.")
            end
        else
            ply:Notify("Invalid item.")
            return
        end
    elseif purchasetype == "Armor" then
        local amount = tonumber(info)
        if amount ~= 10 or cost ~= 15 then
            ply:Notify("Invalid armor purchase.")
            return
        end
        if ply:Armor() + amount <= ply:GetMaxArmor() + 10 then
            ply:SetArmor(math.Clamp(ply:Armor() + amount, 0, ply:GetMaxArmor() + 10))
            ply:AdjustSC(-cost, true)
            ply.NextPurchase = CurTime() + 30
            ServerLog(string.format("[SC PURCHASE] Player %s purchased %d armor for %d SC\n", ply:Nick(), amount, cost))
        else
            ply:Notify("You have reached the limit for the amount of armor purchases you can have.")
        end
    else
        ply:Notify("An error has occurred.")
    end
end)

net.Receive("DeepAwardSCs", function(len, ply)
    if not ply:IsCPCommand() then
        return
    end

    local targ = net.ReadEntity()
    if not IsValid(targ) or not targ:IsPlayer() or targ:Team() != TEAM_CP then
        return
    end

    if targ == ply then
        return
    end

    if targ:IsCPCommand() or targ:GetTeamWhitelist("TEAM_CP") >= RANK_OFC then
        ply:Notify("You cannot distribute SCs to supervisors")
        return
    end

    local amount = net.ReadUInt(20)
    amount = math.floor(amount)
    if not ply.AwardBalance then
        ply.AwardBalance = 0
    end

    local balance = ply.AwardBalance
    if amount < 25 then
        ply:Notify("You cannot distribute less than 25 SCs.")
        return
    end

    if balance < amount then
        ply:Notify("You do not have enough award credits to do this action (Currently:" .. balance .. ").")
        return
    end

    ply.AwardBalance = ply.AwardBalance - amount
    for k,v in pairs(player.GetAll()) do
        if v:IsCP() then
            v:SendCombineMessage(string.upper(ply:Name()) .. " HAS AWARDED " .. string.upper(targ:Name()) .. " " .. amount .. " STERILIZED CREDITS.", Color(100,255,100))
        end
    end

    net.Start("deepupdateawardcredits")
    net.WriteUInt(ply.AwardBalance, 16)
    net.Send(ply)
    targ:AdjustSC(amount, false)
end)
