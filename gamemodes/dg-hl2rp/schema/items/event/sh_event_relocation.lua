local ITEM = {}

ITEM.UniqueID = "event_relocation"
ITEM.Name = "Relocation Coupon"
ITEM.Desc = "A Relocation Coupon for a new city, this can be redeemd at a ration terminal for a basic meal."
ITEM.Model = Model("models/synapse/props/relocation_coupon.mdl")
ITEM.Category = "Event Items"
ITEM.FOV = 4.24
ITEM.CamPos = Vector(62.333755, 52.309349, 38.014194)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = true
ITEM.DropOnDeathIfRestricted = true

ITEM.Illegal = false
ITEM.CanStack = false

function ITEM:ShouldTraceUse(ply, ent)
    if ent:GetClass() == "impulse_hl2rp_rationmachine" then
        return true
    end
end

ITEM.UseName = "Redeem"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Validating..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply)
    ply:GiveInventoryItem("ration_civ",1)
    return true
end

impulse.RegisterItem(ITEM)
