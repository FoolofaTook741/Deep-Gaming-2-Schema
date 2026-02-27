local ITEM = {}

ITEM.UniqueID = "util_refinedmetalplate"
ITEM.Name = "Refined Metal Plate"
ITEM.Desc = "A refined metal plate made of an alloy."
ITEM.Category = "Components"
ITEM.Model = Model("models/gibs/scanner_gib02.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.8

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
	local amount = math.random(1,4)
	if ply:GetSkillLevel("scrapping") >= 3 then
        amount = math.random(2,4)
    elseif ply:GetSkillLevel("scrapping") >= 7 then
        amount = math.random(3,4)
    end
    local meeman = 0
    while meeman < amount do
        ply:GiveInventoryItem("item_scraps", 1)
        meeman = meeman + 1
    end
    ply:AddSkillXP("scrapping", math.random(2,5))

    ply:Notify("You have scrapped the metal pipe and received " .. amount .. " metal scraps.")
	return true
end

impulse.RegisterItem(ITEM)

