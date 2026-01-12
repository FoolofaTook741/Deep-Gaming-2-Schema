local ITEM = {}

ITEM.UniqueID = "scrap_omr"
ITEM.Name = "Damaged O.S.I.M.R."
ITEM.Desc =  "The O.S.I.M.R. is an experimental Combine marksman rifle. This weapon was designed as powerful medium and long range weapon as an alternative to the O.S.R."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/weapons/w_models/w_combine_sniper.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.5


ITEM.UseName = "Dismantle"
ITEM.UseWorkBarTime = 9
ITEM.UseWorkBarName = "Dismantle..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_break2.wav"

function ITEM:OnUse(ply)
    local scrapSkill = ply:GetSkillLevel("scrapping") or 1
    local baseAmount = math.random(1, 4)
    local itemMultiplier = 1 + math.floor(scrapSkill / 5)
    local bonusChance = math.min(0.05 * scrapSkill, 0.5)
    local itemNames = {
        ["util_refinedmetalplate"] = "Refined Metal Plate",
        ["util_metalplate"] = "Metal Plate",
        ["util_gear"] = "Gear",
        ["util_electronics"] = "Electronics"
    }
    local itemsGiven = {}
    local function addItem(item, quantity)
        for i = 1, quantity do
            if ply:GiveInventoryItem(item, 1) then
                itemsGiven[#itemsGiven + 1] = itemNames[item] or item
            end
        end
    end
    if baseAmount == 1 then
        addItem("util_refinedmetalplate", itemMultiplier * 2)
        addItem("util_metalplate", itemMultiplier)
        addItem("util_electronics", itemMultiplier * 2)
    elseif baseAmount == 2 then
        addItem("util_refinedmetalplate", itemMultiplier)
        addItem("util_metalplate", itemMultiplier)
        addItem("util_electronics", itemMultiplier * 2)
        addItem("util_gear", itemMultiplier)
    elseif baseAmount == 3 then
        addItem("util_gear", itemMultiplier * 3)
        addItem("util_metalplate", itemMultiplier)
        addItem("util_refinedmetalplate", itemMultiplier * 2)
        addItem("util_electronics", itemMultiplier)
    else
        addItem("util_metalplate", itemMultiplier)
        addItem("util_refinedmetalplate", itemMultiplier * 2)
        addItem("util_gear", itemMultiplier)
        addItem("util_electronics", itemMultiplier * 2)
    end
    if math.random() < bonusChance then
        addItem("util_electronics", 1)
    end
    local xpGain = math.random(2, 5) + math.floor(scrapSkill / 3)
    ply:AddSkillXP("scrapping", xpGain)
    local scrapTime = math.max(0.5, 2 - 0.05 * scrapSkill)
    ply:Lock()
    timer.Simple(scrapTime, function()
        if IsValid(ply) then
            ply:UnLock()
            local itemCounts = {}
            for _, item in ipairs(itemsGiven) do
                itemCounts[item] = (itemCounts[item] or 0) + 1
            end
            local itemList = {}
            for item, count in pairs(itemCounts) do
                itemList[#itemList + 1] = string.format("%d %s", count, item)
            end
            local notifyText = #itemList > 0 and table.concat(itemList, ", ") or "nothing"
            ply:Notify("You have dismantled the O.S.I.M.R., yielding: " .. notifyText .. ".")
        end
    end)
    return true
end

impulse.RegisterItem(ITEM)
