local ITEM = {}

ITEM.UniqueID = "card_christmas"
ITEM.Name = "Reward Ration Bonus"
ITEM.Desc = "This bonus card gives additional bonuses to Combine operatives. They are distributed if the O.C.A.A.B. activate them."
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
    ply:GiveBankMoney(75)
    ply:Notify("You have redeemed a 75 credit bonus from Combine Command, keep up the good work.")
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_atm" or ent:GetClass() == "civic_terminal" then
        return true
    end
end
impulse.RegisterItem(ITEM)
