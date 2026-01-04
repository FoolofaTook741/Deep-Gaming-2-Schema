local ITEM = {}

ITEM.UniqueID = "util_pipe"
ITEM.Name = "Metal Pipe"
ITEM.Desc = "A metal pipe."
ITEM.Model = Model("models/props_lab/pipesystem03a.mdl")
ITEM.FOV = 43
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.ConfiscateReward = 0

ITEM.CraftSound = "gunmetal"
ITEM.CraftTime = 0.2

ITEM.UseName = "Scrap"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Scrapping..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(1,3)
	if ply:GetSkillLevel("scrapping") >= 3 then
        amount = math.random(2,3)
    elseif ply:GetSkillLevel("scrapping") >= 7 then
        amount = math.random(2,4)
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
