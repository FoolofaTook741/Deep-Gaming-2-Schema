local ITEM = {}
ITEM.UniqueID = "item_mediumtiercrate"
ITEM.Name = "Medium Tier Supply Crate"
ITEM.Desc = "A supply crate containing intermediate equipment."
ITEM.Category = "Supplies"
ITEM.Model = Model("models/hls/alyxports/wood_crate004.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 0
ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.Illegal = true
ITEM.CanStack = false
ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.UseName = "Unpack"
ITEM.UseWorkBarTime = 4
ITEM.UseWorkBarName = "Unpacking Crate..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
    ply:GiveInventoryItem("cos_otavest")
    ply:GiveInventoryItem("cos_parahelmet")
    ply:GiveInventoryItem("cos_combatgasmask")
    for i = 1, 3 do
        ply:GiveInventoryItem("item_healthvial")
    end
    ply:GiveInventoryItem("item_enhancedvial")

    local pool = impulse.Config.LootCratePools["mediumtiercrate"]
    local bundle = pool[math.random(1, #pool)]

    for _, entry in ipairs(bundle) do
        for i = 1, entry.count do
            ply:GiveInventoryItem(entry.class)
        end
    end

    ply:Notify("You have unpacked the supply crate.")
    return true
end

impulse.RegisterItem(ITEM)