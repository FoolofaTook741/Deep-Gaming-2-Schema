impulse.RagdollContainer = impulse.RagdollContainer or {}
DISABLE_LOOT_DROPS = false

impulse.RagdollContainer.LootPools = {
    ["ctadrops"] = {
        Items = {
            ["util_heavyceramicplate"] = {Rarity = 90, Rep = 1, RequiredClass = {CLASS_PAYBACK, CLASS_APF, CLASS_FIST}},
            ["item_enhancedvial"]      = {Rarity = 65, Rep = 4},
            ["item_healthvial"]        = {Rarity = 30, Rep = 2},
            ["cos_otavest3"]           = {Rarity = 40, Rep = 1},
            ["util_refinedmetalplate"] = {Rarity = 35, Rep = 3},
            ["util_steel"]             = {Rarity = 55, Rep = 4},
            ["util_combinescrap"]      = {Rarity = 0.1, Rep = 1},
            ["util_electronics"]       = {Rarity = 15, Rep = 2},
            ["util_lens"]              = {Rarity = 45, Rep = 1},
            ["item_grenade"]           = {Rarity = 55, Rep = 1},
            ["item_rappel"]            = {Rarity = 65, Rep = 1},
        },
        MaxItems = 10,
        MinItems = 2,
    },
    ["mpfdrops"] = {
        Items = {
            ["util_combinescrap"] = {Rarity = 0.5, Rep = 1},
            ["item_enhancedvial"] = {Rarity = 90,  Rep = 2},
            ["item_healthvial"]   = {
                Rarity = 35,
                Rep    = 3,
                PopScale = {
                    Rarity = {Min = 80, Max = 35},
                    Rep    = {Min = 3,  Max = 1},
                },
            },
            ["util_lvl2plate"] = {Rarity = 65, Rep = 1},
            ["item_rappel"]    = {Rarity = 65, Rep = 1},
        },
        MaxItems = 5,
        MinItems = 1,
    },
    ["zombiedrops"] = {
        Items = {
            ["util_cloth"]           = {Rarity = 0.5, Rep = 3},
            ["util_rawheadcrabmeat"] = {Rarity = 10,  Rep = 1},
            ["util_plastic"]         = {Rarity = 35,  Rep = 3},
            ["clo_backpack"]         = {Rarity = 95,  Rep = 1},
            ["util_steel"]           = {Rarity = 65,  Rep = 1},
        },
        MaxItems = 6,
        MinItems = 3,
    },
}

local ArmorItems = {
    ["cos_elitevest"]      = true,
    ["cos_otavest2"]       = true,
    ["cos_otavest"]        = true,
    ["cos_lightvest"]      = true,
    ["cos_conscriptarmor"] = true,
}

local mathRandom  = math.random
local mathClamp   = math.Clamp
local mathCeil    = math.ceil
local mathMax     = math.max
local tableHasVal = table.HasValue
local IsValid     = IsValid

local ANTICRASH_ATTEMPTS = 0
local function GenerateLootFromPool(pool, deadPlayer)
    local lootPool = impulse.RagdollContainer.LootPools[pool]
    local loot     = {}
    local count    = 0
    local popRatio = mathClamp(#player.GetAll() / game.MaxPlayers(), 0, 1)

    for itemName, itemData in RandomPairs(lootPool.Items) do
        if lootPool.MaxItems and count >= lootPool.MaxItems then break end

        local rarity = itemData.Rarity
        local rep    = itemData.Rep or 1

        if itemData.PopScale then
            local ps = itemData.PopScale
            if ps.Rarity then
                rarity = ps.Rarity.Min + ((ps.Rarity.Max - ps.Rarity.Min) * popRatio)
            end
            if ps.Rep then
                rep = mathCeil(mathMax(ps.Rep.Max - ((ps.Rep.Max - ps.Rep.Min) * popRatio), 1))
            end
        end

        local reqClass = itemData.RequiredClass
        for i = 1, rep do
            if lootPool.MaxItems and count >= lootPool.MaxItems then break end
            if mathRandom(1, 100) < rarity then continue end

            if reqClass then
                local playerClass = deadPlayer:GetTeamClass()
                if playerClass and tableHasVal(reqClass, playerClass) then
                    count = count + 1
                    loot[itemName] = (loot[itemName] or 0) + 1
                end
            else
                count = count + 1
                loot[itemName] = (loot[itemName] or 0) + 1
            end
        end
    end

    if count == 0 or (lootPool.MinItems and count < lootPool.MinItems) then
        ANTICRASH_ATTEMPTS = ANTICRASH_ATTEMPTS + 1
        if ANTICRASH_ATTEMPTS > 32 then
            impulse.debugPrint("[impulse] HIGH LOOT GENERATION ATTEMPTS WARNING! (" .. pool .. ") (" .. ANTICRASH_ATTEMPTS .. ")")
            impulse.debugPrint("Please make sure this lootpool is NOT impossible to compute!")
        end
        return GenerateLootFromPool(pool, deadPlayer)
    end

    ANTICRASH_ATTEMPTS = 0
    return loot, count
end

impulse.RagdollContainer.ScrapWeapons = {
    ["ctadrops"] = {
        Items = {
            ["scrap_ar2"]    = {Rarity = 450},
            ["scrap_apf"]    = {Rarity = 600},
            ["scrap_mp7"]    = {Rarity = 600},
            ["scrap_shotgun"]= {Rarity = 800},
            ["scrap_ar2e"]   = {Rarity = 650},
            ["scrap_rappel"] = {Rarity = 750},
            ["scrap_osips"]  = {Rarity = 800},
            ["scrap_ar15"]   = {Rarity = 800},
            ["scrap_xm1014"] = {Rarity = 800},
            ["scrap_omr"]    = {Rarity = 800},
        },
    },
    ["mpfdrops"] = {
        Items = {
            ["scrap_357"]       = {Rarity = 750},
            ["scrap_pistol"]    = {Rarity = 400},
            ["scrap_cz75"]      = {Rarity = 400},
            ["scrap_mp7"]       = {Rarity = 850},
            ["scrap_mp7a8"]     = {Rarity = 925},
            ["scrap_stunstick"] = {Rarity = 750},
            ["scrap_shotgun"]   = {Rarity = 600},
            ["scrap_deagle"]    = {Rarity = 750},
            ["scrap_sw500"]     = {Rarity = 999},
            ["scrap_hb"]        = {Rarity = 800},
            ["scrap_ar15"]      = {Rarity = 800},
            ["scrap_p90"]       = {Rarity = 500},
            ["scrap_xm1014"]    = {Rarity = 800},
        },
    },
}

local function GenerateScrapLootForPlayer(ply, lootType)
    local scrapWeaponsTable = impulse.RagdollContainer.ScrapWeapons[lootType]
    if not scrapWeaponsTable then
        impulse.debugPrint("Error: Scrap weapons table '" .. lootType .. "' not found.")
        return {}, 0
    end

    local loot  = {}
    local count = 0
    local items = impulse.Inventory.Items

    for _, playerItem in pairs(ply:GetInventory() or {}) do
        local netid   = impulse.Inventory.ClassToNetID(playerItem.class)
        local itemDef = items[netid]
        if not itemDef then continue end
        if itemDef.Category ~= "Weapons" or not itemDef.ScrapClass then continue end

        local scrapData = scrapWeaponsTable.Items[itemDef.ScrapClass]
        if not scrapData then continue end

        if mathRandom(1, 1000) <= scrapData.Rarity then
            count = count + 1
            loot[itemDef.ScrapClass] = (loot[itemDef.ScrapClass] or 0) + 1
        end
    end

    return loot, count
end

impulse.RagdollContainer.AmmoDrops = {
    ["ammo_smg"] = {
        Rarity = 800,
        AssociatedWeapons = {
            ["wep_mp7"]         = true,
            ["wep_mp7a8"]       = true,
            ["wep_p90"]         = true,
            ["wep_ar15"]        = true,
            ["wep_honeybadger"] = true,
        },
    },
    ["ammo_buckshot"] = {
        Rarity = 800,
        AssociatedWeapons = {
            ["wep_shotgun"] = true,
            ["wep_m500"]    = true,
            ["wep_osihs"]   = true,
            ["wep_osisg"]   = true,
            ["wep_db"]      = true,
        },
    },
    ["ammo_54r"] = {
        Rarity = 900,
        AssociatedWeapons = {
            ["wep_ar2r"] = true,
            ["wep_omr"]  = true,
        },
    },
    ["ammo_pistol"] = {
        Rarity = 600,
        AssociatedWeapons = {
            ["wep_pistol"] = true,
            ["wep_pm63"]   = true,
            ["wep_cz75"]   = true,
        },
    },
    ["ammo_ar2"] = {
        Rarity = 900,
        AssociatedWeapons = {
            ["wep_ar2"]       = true,
            ["wep_ar2e"]      = true,
            ["wep_osiprmk1c"] = true,
            ["wep_osiprmk1"]  = true,
            ["wep_osips"]     = true,
        },
    },
    ["ammo_sniper"] = {
        Rarity = 900,
        AssociatedWeapons = {
            ["wep_osr"] = true,
            ["wep_omr"] = true,
        },
    },
}

local function GenerateAmmoLootForPlayer(ply)
    if not ply:IsCP() then return {}, 0 end

    local allAmmoLoot = {}
    local totalCount  = 0
    local items       = impulse.Inventory.Items

    local playerWeapons = {}
    for _, playerItem in pairs(ply:GetInventory() or {}) do
        local netid   = impulse.Inventory.ClassToNetID(playerItem.class)
        local itemDef = items[netid]
        if itemDef and itemDef.Category == "Weapons" then
            playerWeapons[playerItem.class] = true
        end
    end

    for ammoItem, ammoPool in pairs(impulse.RagdollContainer.AmmoDrops) do
        for weapon in pairs(ammoPool.AssociatedWeapons) do
            if not playerWeapons[weapon] then continue end

            local numBoxes = mathRandom(0, 3)
            for i = 1, numBoxes do
                if mathRandom(1, 1000) <= ammoPool.Rarity then
                    allAmmoLoot[ammoItem] = (allAmmoLoot[ammoItem] or 0) + 1
                    totalCount = totalCount + 1
                end
            end
        end
    end

    return allAmmoLoot, totalCount
end

local function MergeLoot(dst, src)
    for itemName, itemCount in pairs(src) do
        dst[itemName] = (dst[itemName] or 0) + itemCount
    end
end

function PLUGIN:PlayerRagdollPreSpawn(ragdoll, ply, attacker)
    if not IsValid(ragdoll) then return end

    ragdoll:PhysicsInit(SOLID_VPHYSICS)
    ragdoll:SetMoveType(SOLID_VPHYSICS)
    ragdoll:SetSolid(SOLID_VPHYSICS)
    ragdoll:SetUseType(SIMPLE_USE)
    ragdoll:DrawShadow(false)

    ragdoll.Users      = {}
    ragdoll.Authorised = {}
    ragdoll.Inventory  = {}

    function ragdoll:SetLoot(bool)
        self:SetNWBool("Loot", bool)
    end

    function ragdoll:GetLoot()
        return self:GetNWBool("Loot", false)
    end

    function ragdoll:SetCapacity(cap)
        self:SetNWInt("Capacity", cap)
    end

    function ragdoll:GetCapacity()
        return self:GetNWInt("Capacity", 0)
    end

    function ragdoll:AddUser(ply)
        self.Users[ply] = true

        local inv   = self.Inventory
        local count = inv and table.Count(inv) or 0

        net.Start("impulseInvContainerOpen")
        net.WriteUInt(count, 8)

        if inv then
            for itemClass, amount in pairs(inv) do
                local netid = impulse.Inventory.ClassToNetID(itemClass)
                if not netid then
                    impulse.debugPrint("Error: ClassToNetID returned nil for item:", itemClass)
                    continue
                end
                if type(amount) ~= "number" then
                    impulse.debugPrint("Error: Invalid amount for item:", itemClass, "amount:", amount)
                    continue
                end
                net.WriteUInt(netid, 10)
                net.WriteUInt(amount, 8)
            end
        end

        net.Send(ply)
        ply.currentContainer = self
    end

    function ragdoll:RemoveUser(ply)
        self.Users[ply] = nil
        ply.currentContainer = nil
    end

    function ragdoll:AddItem(itemclass, amount, noUpdate)
        self.Inventory[itemclass] = (self.Inventory[itemclass] or 0) + (amount or 1)
        if not noUpdate then self:UpdateUsers() end
    end

    function ragdoll:TakeItem(itemclass, amount, noUpdate)
        local cur = self.Inventory[itemclass]
        if not cur then return end
        local newCount = cur - (amount or 1)
        self.Inventory[itemclass] = newCount > 0 and newCount or nil
        if not noUpdate then self:UpdateUsers() end
    end

    function ragdoll:CanHoldItem(itemclass)
        local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(itemclass)]
        if not item then return false end
        return self:GetStorageWeight() + (item.Weight or 0) <= self:GetCapacity()
    end

    function ragdoll:UpdateUsers()
        local pos   = self:GetPos()
        local inv   = self.Inventory
        local count = inv and table.Count(inv) or 0

        for v in pairs(self.Users) do
            if IsValid(v) and pos:DistToSqr(v:GetPos()) < 52900 then -- 230^2 pre-computed
                net.Start("impulseInvContainerUpdate")
                net.WriteUInt(count, 8)
                if inv then
                    for itemClass, amount in pairs(inv) do
                        net.WriteUInt(impulse.Inventory.ClassToNetID(itemClass), 10)
                        net.WriteUInt(amount, 8)
                    end
                end
                net.Send(v)
            else
                self.Users[v] = nil
            end
        end
    end

    function ragdoll:GetStorageWeight()
        local weight = 0
        local items  = impulse.Inventory.Items
        if self.Inventory then
            for itemClass, count in pairs(self.Inventory) do
                local item = items[impulse.Inventory.ClassToNetID(itemClass)]
                if item then weight = weight + (item.Weight or 0) * count end
            end
        end
        return weight
    end

    ragdoll.InventoryWeight = ragdoll:GetStorageWeight()

    local deadPlayer = ragdoll.DeadPlayer
    if not deadPlayer then return end

    ragdoll:SetLoot(false)
    ragdoll:SetCapacity(35)

    for _, itemClass in pairs(ragdoll.inventoryOnDeath or {}) do
        if ArmorItems[itemClass] then
            if itemClass == "cos_conscriptarmor" then
                ragdoll:AddItem("scrap_conscriptarmor", 1, true)
            end
        elseif ragdoll:CanHoldItem(itemClass) then
            ragdoll:AddItem(itemClass, 1, true)
        else
            break
        end
    end

    local function AddConfiscated()
        if deadPlayer.ConfiscatedInv and #deadPlayer.ConfiscatedInv >= 1 then
            for _, v in pairs(deadPlayer.ConfiscatedInv) do
                ragdoll:AddItem(v, 1, true)
            end
        end
        deadPlayer.ConfiscatedInv = {}
    end

    local team = ragdoll.TeamOnDeath

    if team == TEAM_OTA then
        if ragdoll.FallDeath then return end
        if not ply:GetTeamClass() then return end
        if DISABLE_LOOT_DROPS then return end

        local loot = GenerateLootFromPool("ctadrops", deadPlayer)
        MergeLoot(loot, GenerateScrapLootForPlayer(ply, "ctadrops"))
        MergeLoot(loot, GenerateAmmoLootForPlayer(ply))
        AddConfiscated()

        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end

    elseif team == TEAM_CP then
        if ragdoll.FallDeath then return end
        if not ply:GetTeamClass() then return end
        if DISABLE_LOOT_DROPS then return end

        local loot = GenerateLootFromPool("mpfdrops", deadPlayer)
        MergeLoot(loot, GenerateScrapLootForPlayer(ply, "mpfdrops"))
        MergeLoot(loot, GenerateAmmoLootForPlayer(ply))
        AddConfiscated()

        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end

    elseif team == TEAM_CA then
        if ragdoll.FallDeath then return end
        if not ply:GetTeamClass() then return end
        AddConfiscated()

    elseif team == TEAM_ZOMBIE then
        if ragdoll.FallDeath then return end

        local loot = GenerateLootFromPool("zombiedrops", deadPlayer)
        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end
    end
end

hook.Add("KeyPress", "impulseRagdollContainerUse", function(ply, key)
    if key ~= IN_USE then return end

    local trace = ply:GetEyeTrace()
    local ent   = trace.Entity

    if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" then return end
    if not ent.DeadPlayer then return end
    if not ply:Alive() then return end

    local src = ply:GetShootPos()
    if ent:NearestPoint(src):DistToSqr(src) > 6400 then return end -- 80^2 pre-computed

    if ply:GetSyncVar(SYNC_ARRESTED, false) then
        return ply:Notify("You cannot access a container when detained.")
    end

    if ply:IsCP() and ent:GetLoot() then
        return ply:Notify("You cannot access this container as this team.")
    end

    if ply:IsCP() and ply:IsScanner() then
        return ply:Notify("You cannot access containers as a scanner.")
    end

    if not ent.AddUser then
        impulse.debugPrint("Ragdoll has DeadPlayer but no AddUser - PlayerRagdollPreSpawn may not have fired")
        return
    end

    ent.Users = ent.Users or {}
    if not ent.Users[ply] then
        ent:AddUser(ply)
    end
end)