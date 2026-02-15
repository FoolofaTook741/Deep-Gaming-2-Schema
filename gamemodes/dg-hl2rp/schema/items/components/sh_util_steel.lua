local ITEM = {}

ITEM.UniqueID = "util_steel"
ITEM.Name = "Piece of Steel"
ITEM.Desc = "A heavily refined piece of metal used in the construction of buildings."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_pipes/pipe02_connector01.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.ConfiscateReward = 0

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

ITEM.UseName = "Scrap"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Scrapping..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(3,6)
	if ply:GetSkillLevel("scrapping") >= 3 then
        amount = math.random(4,6)
    elseif ply:GetSkillLevel("scrapping") >= 7 then
        amount = math.random(5,7)
    end
    local meeman = 0
    while meeman < amount do
        ply:GiveInventoryItem("item_scraps", 1)
        meeman = meeman + 1
    end
    ply:AddSkillXP("scrapping", math.random(2,7))

    ply:Notify("You have scrapped the steel plate and received " .. amount .. " metal scraps.")
	return true
end

impulse.RegisterItem(ITEM)
