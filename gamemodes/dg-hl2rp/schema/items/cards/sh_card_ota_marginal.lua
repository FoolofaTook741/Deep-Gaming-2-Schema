local ITEM = {}

ITEM.UniqueID = "card_ota_marginal"
ITEM.Name = "CTA Ration Credit Card [M]"
ITEM.Desc = "Redeem this card at your nearest ATM or Civic Terminal to claim the rewards."ITEM.Model = Model("models/dorado/tarjetazero.mdl")
ITEM.Category = "Ration Cards"
ITEM.FOV = 6.918338108883
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
    if ply:Team() == TEAM_OTA then
        local amount = 200 + (ply:GetTeamRank() * 20) 
        ply:GiveBankMoney(amount-175)
        ply:Notify("You have redeemed this card for ".. amount .."  credits. You have received a reduced pay due to the current politistabilization index.")
        return true
    else
        local amount = 200
        ply:GiveBankMoney(amount - 175)
        ply:Notify("You have redeemed this card for ".. amount .."  credits. You have received a reduced pay due to the current politistabilization index.")
        return true
    end
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)
