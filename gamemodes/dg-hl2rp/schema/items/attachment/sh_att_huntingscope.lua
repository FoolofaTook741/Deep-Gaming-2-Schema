local ITEM = {}

ITEM.UniqueID = "att_huntingscope"
ITEM.Name = "Hunting Scope [Deprecated]"
ITEM.Desc =  "This item is out of service."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.01

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true

ITEM.CanStack = true

ITEM.UseName = "Convert to New Scope"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Converting..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
    ply:GiveInventoryItem("att_optic", 1)
    return true
end

impulse.RegisterItem(ITEM)
