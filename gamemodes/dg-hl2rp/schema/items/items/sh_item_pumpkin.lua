local ITEM = {}

ITEM.UniqueID = "item_pumpkin"
ITEM.Name = "Pumpkin"
ITEM.Desc =  "A large robust pumpkin, this can be used to make pie."
ITEM.Category = "Food"
ITEM.Model = Model("models/halloween2015/pumbkin_n_f00.mdl")
ITEM.Colour = Color(255, 150, 0)
ITEM.FOV = 18
ITEM.Weight = 3.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Cut"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Cutting into slices..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(1,4)
	if amount == 1 then
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
	elseif amount == 2 then
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
	elseif amount == 3 then
		ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
	else
		ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
	end

    local chance = math.random(0,150) + (10* ply:GetSkillLevel("scrapping"))
    if chance > 100 then
        ply:GiveInventoryItem("item_pumpkinslice", 1)
    elseif chance > 200 then
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
    elseif chance > 250 then
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
        ply:GiveInventoryItem("item_pumpkinslice", 1)
    end

    ply:AddSkillXP("scrapping", 10)

    ply:Notify("You have cut the pumpkin into slices.")
	return true
end

impulse.RegisterItem(ITEM)
