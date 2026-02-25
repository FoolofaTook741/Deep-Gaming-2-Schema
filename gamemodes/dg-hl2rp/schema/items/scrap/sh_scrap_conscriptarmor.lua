local ITEM = {}

ITEM.UniqueID = "scrap_conscriptarmor"
ITEM.Name = "Damaged Conscript Armor"
ITEM.Desc =  "A damaged set of conscript armor that can be reparied or scrapped."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/willardnetworks/clothingitems_conscripts/torso_vest_3.mdl")
ITEM.FOV = 50
ITEM.Weight = 7

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.ConfiscateReward = 50
ITEM.CanStack = false

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.5


ITEM.UseName = "Dismantle"
ITEM.UseWorkBarTime = 9
ITEM.UseWorkBarName = "Dismantling..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_break2.wav"

function ITEM:OnUse(ply)
    local scrapSkill = ply:GetSkillLevel("scrapping") or 1
    local xpGain = math.random(2, 5) + math.floor(scrapSkill / 3)
    ply:AddSkillXP("scrapping", xpGain)
    local scrapTime = math.max(0.5, 2 - 0.05 * scrapSkill)
    ply:Lock()
    timer.Simple(scrapTime, function()
        if IsValid(ply) then
            ply:UnLock()
            ply:GiveInventoryItem("util_heavyceramicplate", 1, false)
            ply:Notify("You have dismantled the conscript armor for a steel plate.")
        end
    end)
    return true
end

impulse.RegisterItem(ITEM)
