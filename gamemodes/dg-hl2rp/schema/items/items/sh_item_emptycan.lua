local ITEM = {}

ITEM.UniqueID = "item_can"
ITEM.Name = "Empty Can"
ITEM.Desc =  "An empty water can, perhaps can be broken down into something else?"
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/PopCan01a.mdl")
ITEM.FOV = 18
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Dismantle"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Scrapping..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(1,4)
	if amount == 1 then
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_metalplate", 1)
	elseif amount == 2 then
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
	elseif amount == 3 then
		ply:GiveInventoryItem("util_plastic", 1)
	else
		ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
	end

    local chance = math.random(0,150) + (10* ply:GetSkillLevel("scrapping"))
    if chance > 100 then
        ply:GiveInventoryItem("util_plastic", 1)
    elseif chance > 150 then
        ply:GiveInventoryItem("util_plastic", 1)
    elseif chance > 200 then
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
    elseif chance > 250 then
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
    end

    ply:AddSkillXP("scrapping", 3)
--[[  	if ply.CurrentQuest == QUEST_START_SOMEWHERE then
		ply:CompleteQuest(QUEST_START_SOMEWHERE)
	end ]]
    ply:Notify("You have dismantled the empty can.")
	return true
end

impulse.RegisterItem(ITEM)
