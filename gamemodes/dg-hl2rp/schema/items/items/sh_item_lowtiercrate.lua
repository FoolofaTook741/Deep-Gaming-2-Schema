local ITEM = {}
ITEM.UniqueID = "item_lowtiercrate"
ITEM.Name = "Low Tier Supply Crate"
ITEM.Desc = "A supply crate containing basic equipment."
ITEM.Category = "Supplies"
ITEM.Model = Model("models/hls/alyxports/wood_crate004.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 2
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
    ply:GiveInventoryItem("cos_lightvest")
    ply:GiveInventoryItem("cos_m1helmet")
    for i = 1, 2 do
        ply:GiveInventoryItem("item_healthvial")
    end

    local pool = impulse.Config.LootCratePools["lowtiercrate"]
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