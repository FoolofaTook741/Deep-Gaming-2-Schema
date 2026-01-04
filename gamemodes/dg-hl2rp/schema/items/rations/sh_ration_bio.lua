local ITEM = {}

ITEM.UniqueID = "ration_vort"
ITEM.Name = "Biotic Ration"
ITEM.Desc =  "A Biotic's Ration."
ITEM.Category = "Rations"
ITEM.Model = Model("models/weapons/w_packatc.mdl")
ITEM.FOV = 47.068767908309
ITEM.CamPos = Vector(-12.836676597595, -7.3352437019348, 11.346704483032)
ITEM.NoCenter = false
ITEM.Weight = 1

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.NotSpawnable = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 0

ITEM.Illegal = false

ITEM.UseName = "Open"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Opening..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "impulse/craft/fabric/1.wav"

function ITEM:OnUse(ply)
    ply:GiveInventoryItem("food_water",1)
    return true
end

impulse.RegisterItem(ITEM)
