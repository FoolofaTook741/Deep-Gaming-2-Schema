local ITEM = {}

ITEM.UniqueID = "food_rationbox"
ITEM.Name = "Box of Rations"
ITEM.Desc =  "A box filled with Combine Rations."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/cardboard_box002a.mdl")
ITEM.FOV = 40
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Unpack"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Opening..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:CanUse(ply)
    if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
        return true
    else
        return false
    end
end

function ITEM:OnUse(ply)
    local rations = math.random(4,8)
    local meem = 0
    while meem < rations do
        ply:GiveInventoryItem("food_ration", 1)
        meem = meem + 1
    end

    ply:Notify("You have opened the box of rations.")
	return true
end

impulse.RegisterItem(ITEM)
