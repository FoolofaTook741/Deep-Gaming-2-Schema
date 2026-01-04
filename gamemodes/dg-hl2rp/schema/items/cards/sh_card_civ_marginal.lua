local ITEM = {}
ITEM.UniqueID = "card_civ_marginal"
ITEM.Name = "Civilian Ration Credit Card [M]"
ITEM.Desc = "Redeem this card at your nearest ATM or Civic Terminal to claim the rewards."ITEM.Model = Model("models/dorado/tarjeta2.mdl")
ITEM.Category = "Ration Cards"
ITEM.FOV = 7.918338108883
ITEM.CamPos = Vector(-1.1461317539215, 25.21489906311, 63.037250518799)
ITEM.Weight = 0.5
ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.Illegal = false
ITEM.CanStack = true
ITEM.UseName = "Redeem"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Redeeming..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply)
--[[     if ply.CurrentQuest == QUEST_DEPOSIT then ply:CompleteQuest(QUEST_DEPOSIT) end ]]
    local taxcut = 1 - (OCAAB_CIV_TAXRATE * 0.01)
    local money = 25
    local amount = math.floor(taxcut * money)
    ply:GiveBankMoney(amount)
    ply:Notify("You have redeemed this card for " .. amount .. " credits. Pay varies based on current taxes and the politistabilization index.")
    local taxedamount = money - amount
    if RES_TAX == true then
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (taxedamount * 2)
    else
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + taxedamount
    end
    net.Start("DeepAdjustFunds")
    net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)

local ITEM = {}
ITEM.UniqueID = "card_1_marginal"
ITEM.Name = "Tier I Ration Credit Card [M]"
ITEM.Desc = "Redeem this card at your nearest ATM to claim the rewards."
ITEM.Model = Model("models/dorado/tarjeta2.mdl")
ITEM.Category = "Ration Cards"
ITEM.FOV = 7.918338108883
ITEM.CamPos = Vector(-1.1461317539215, 25.21489906311, 63.037250518799)
ITEM.Weight = 0.5
ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.Illegal = false
ITEM.CanStack = true
ITEM.UseName = "Redeem"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Redeeming..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply)
--[[     if ply.CurrentQuest == QUEST_DEPOSIT then ply:CompleteQuest(QUEST_DEPOSIT) end ]]
    local taxcut = 1 - (OCAAB_CIV_TAXRATE * 0.01)
    local money = 40 --
    local amount = math.floor(taxcut * money)
    ply:GiveBankMoney(amount)
    ply:Notify("You have redeemed this card for " .. amount .. " credits. Pay varies based on current taxes and the politistabilization index.")
    local taxedamount = money - amount
    if RES_TAX == true then
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (taxedamount * 2)
    else
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + taxedamount
    end
    net.Start("DeepAdjustFunds")
    net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)


local ITEM = {}
ITEM.UniqueID = "card_2_marginal"
ITEM.Name = "Tier II Ration Credit Card [M]"
ITEM.Desc = "Redeem this card at your nearest ATM to claim the rewards."
ITEM.Model = Model("models/dorado/tarjeta2.mdl")
ITEM.Category = "Ration Cards"
ITEM.FOV = 7.918338108883
ITEM.CamPos = Vector(-1.1461317539215, 25.21489906311, 63.037250518799)
ITEM.Weight = 0.5
ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.Illegal = false
ITEM.CanStack = true
ITEM.UseName = "Redeem"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Redeeming..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply)
--[[     if ply.CurrentQuest == QUEST_DEPOSIT then ply:CompleteQuest(QUEST_DEPOSIT) end ]]
    local taxcut = 1 - (OCAAB_CIV_TAXRATE * 0.01)
    local money = 60 
    local amount = math.floor(taxcut * money)
    ply:GiveBankMoney(amount)
    ply:Notify("You have redeemed this card for " .. amount .. " credits. Pay varies based on current taxes and the politistabilization index.")
    local taxedamount = money - amount
    if RES_TAX == true then
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (taxedamount * 2)
    else
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + taxedamount
    end
    net.Start("DeepAdjustFunds")
    net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)


local ITEM = {}
ITEM.UniqueID = "card_3_marginal"
ITEM.Name = "Tier III Ration Credit Card [M]"
ITEM.Desc = "Redeem this card at your nearest ATM to claim the rewards."
ITEM.Model = Model("models/dorado/tarjeta2.mdl")
ITEM.Category = "Ration Cards"
ITEM.FOV = 7.918338108883
ITEM.CamPos = Vector(-1.1461317539215, 25.21489906311, 63.037250518799)
ITEM.Weight = 0.5
ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.Illegal = false
ITEM.CanStack = true
ITEM.UseName = "Redeem"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Redeeming..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply)
--[[     if ply.CurrentQuest == QUEST_DEPOSIT then ply:CompleteQuest(QUEST_DEPOSIT) end ]]
    local taxcut = 1 - (OCAAB_CIV_TAXRATE * 0.01)
    local money = 80 -- 
    local amount = math.floor(taxcut * money)
    ply:GiveBankMoney(amount)
    ply:Notify("You have redeemed this card for " .. amount .. " credits. Pay varies based on current taxes and the politistabilization index.")
    local taxedamount = money - amount
    if RES_TAX == true then
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (taxedamount * 2)
    else
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + taxedamount
    end
    net.Start("DeepAdjustFunds")
    net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)
