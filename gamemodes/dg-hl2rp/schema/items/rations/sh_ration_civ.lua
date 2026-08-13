local ITEM = {}

ITEM.UniqueID = "ration_civ"
ITEM.Name = "Minimal Ration"
ITEM.Desc =  "A Citizen Ration."
ITEM.Category = "Rations"
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
ITEM.FOV = 10.56446991404
ITEM.CamPos = Vector(0, 0.91690546274185, 144.87106323242)
ITEM.NoCenter = false
ITEM.Weight = 1

ITEM.Droppable = false
ITEM.DropOnDeath = true

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
    ply:GiveInventoryItem("food_bread",1)
    return true
end

impulse.RegisterItem(ITEM)

local ITEM = {}
ITEM.UniqueID = "ration_tier1"
ITEM.Name = "Standard Ration"
ITEM.Desc = "A ration package for Tier I Loyalists, offering improved provisions."
ITEM.Category = "Rations"
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
ITEM.FOV = 10.56446991404
ITEM.CamPos = Vector(0, 0.91690546274185, 144.87106323242)
ITEM.Weight = 1
ITEM.Droppable = false
ITEM.DropOnDeath = true
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
    ply:GiveInventoryItem("food_bread", 1)
    ply:GiveInventoryItem("food_water", 1)
    ply:GiveInventoryItem("meal_beefstew", 1)
    return true
end
impulse.RegisterItem(ITEM)

local ITEM = {}
ITEM.UniqueID = "ration_tier2"
ITEM.Name = "Loyalist Ration"
ITEM.Desc = "A ration package for Tier II Loyalists, offering improved provisions."
ITEM.Category = "Rations"
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
ITEM.FOV = 10.56446991404
ITEM.CamPos = Vector(0, 0.91690546274185, 144.87106323242)
ITEM.Weight = 1
ITEM.Droppable = false
ITEM.DropOnDeath = true
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
    ply:GiveInventoryItem("food_watermelon", 1)
    ply:GiveInventoryItem("food_waterspecial", 1)
    ply:GiveInventoryItem("food_coffee", 1)
    ply:GiveInventoryItem("meal_pizza", 1)
    return true
end
impulse.RegisterItem(ITEM)

local ITEM = {}
ITEM.UniqueID = "ration_tier3"
ITEM.Name = "Priority Ration"
ITEM.Desc = "A ration package for Tier III Loyalists, offering improved provisions."
ITEM.Category = "Rations"
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
ITEM.FOV = 10.56446991404
ITEM.CamPos = Vector(0, 0.91690546274185, 144.87106323242)
ITEM.Weight = 1
ITEM.Droppable = false
ITEM.DropOnDeath = true
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
    ply:GiveInventoryItem("food_applepie", 1)
    ply:GiveInventoryItem("food_waterspecial", 1)
    ply:GiveInventoryItem("food_wine", 1)
    ply:GiveInventoryItem("meal_cheesewheel", 1)
    return true
end
impulse.RegisterItem(ITEM)
