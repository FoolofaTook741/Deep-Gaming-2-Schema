local ITEM = {}

ITEM.UniqueID = "util_combinescrap"
ITEM.Name = "Ruined Biolink Device"
ITEM.Desc = "A small, ruined, combine device that can easily be scrapped."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/gibs/manhack_gib03.mdl")
ITEM.FOV = 13.84670487106
ITEM.CamPos = Vector(-5.7306590080261, 37.249282836914, 14.326647758484)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false
ITEM.ConfiscateReward = 2

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

ITEM.UseName = "Dismantle"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Dismantle..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_break2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(1,4)
	if amount == 1 then
		ply:GiveInventoryItem("util_metalplate", 1)
        ply:GiveInventoryItem("util_plastic", 1)
	elseif amount == 2 then
		ply:GiveInventoryItem("util_plastic", 1)
        ply:GiveInventoryItem("util_plastic", 1)
	elseif amount == 3 then
		ply:GiveInventoryItem("util_pipe", 1)
        ply:GiveInventoryItem("util_metalplate", 1)
	else
        ply:GiveInventoryItem("util_metalplate", 1)
	end
	ply:AddSkillXP("scrapping", math.random(1,6))
    ply:Notify("You have dismantled the Ruined Biolink Device")
	return true
end

impulse.RegisterItem(ITEM)
