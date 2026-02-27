local ITEM = {}

ITEM.UniqueID = "util_gear"
ITEM.Name = "Metal Gear"
ITEM.Desc = "A small metal gear."
ITEM.Model = Model("models/props_wasteland/gear02.mdl")
ITEM.FOV = 8.4025787965616
ITEM.CamPos = Vector(100, -26.934097290039, 2.8653295040131)
ITEM.Weight = 0.6

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.5

ITEM.UseName = "Scrap"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Scrapping..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(1,3)
	if ply:GetSkillLevel("scrapping") >= 7 then
        amount = math.random(2,6)
    elseif ply:GetSkillLevel("scrapping") >= 3 then
        amount = math.random(2,4)
    end
    local meeman = 0
    while meeman < amount do
        ply:GiveInventoryItem("item_scraps", 1)
        meeman = meeman + 1
    end
    ply:AddSkillXP("scrapping", math.random(2,5))

    ply:Notify("You have scrapped the metal gear and received " .. amount .. " metal scraps.")
	return true
end

impulse.RegisterItem(ITEM)
