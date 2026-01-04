local ITEM = {}

ITEM.UniqueID = "card_cwu"
ITEM.Name = "CW Ration Credit Card"
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
    local taxcut = 1 - (OCAAB_CW_TAXRATE * 0.01)
	local amount = 0
    if ply:Team() == TEAM_CWU and ply:GetTeamRank() then
        amount = math.floor(taxcut * (150 + (ply:GetTeamRank() * 15)))
        ply:GiveBankMoney(amount)
        ply:Notify("You have redeemed this card for " .. amount .." credits. Pay varies based on current taxes and the politistabilization index.")
    else
        amount = math.floor(taxcut * 150)
        ply:GiveBankMoney(amount)
        ply:Notify("You have redeemed this card for " .. amount .." credits. Pay varies based on current taxes and the politistabilization index.")
    end
    local lvl = ply:GetTeamRank() or 1
    local taxedamount = amount 
    if RES_TAX == true then
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + (taxedamount * 2)
        net.Start("DeepAdjustFunds")
        net.WriteInt(OCAAB_CUR_FUNDS, 16)
        net.Broadcast()
    else
        OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + taxedamount
        net.Start("DeepAdjustFunds")
        net.WriteInt(OCAAB_CUR_FUNDS, 16)
        net.Broadcast()
    end
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)
