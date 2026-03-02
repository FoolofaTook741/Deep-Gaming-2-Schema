impulse.RagdollContainer = impulse.RagdollContainer or {}
DISABLE_LOOT_DROPS = false

impulse.RagdollContainer.LootPools = {
    ["ctadrops"] = {
        Items = {
            ["util_heavyceramicplate"] = {Rarity = 90, Rep = 1, RequiredClass = {CLASS_PAYBACK, CLASS_APF, CLASS_FIST}},
            ["item_enhancedvial"] = {Rarity = 65, Rep = 4},
            ["item_healthvial"] = {Rarity = 30, Rep = 2},
            ["cos_otavest3"] = {Rarity = 40, Rep = 1},
            ["util_refinedmetalplate"] = {Rarity = 35, Rep = 3},
            ["util_steel"] = {Rarity = 55, Rep = 4},
            ["util_combinescrap"] = {Rarity = 0.1, Rep = 1},
            ["util_electronics"] = {Rarity = 15, Rep = 2},
            ["util_lens"] = {Rarity = 45, Rep = 1},
            ["item_grenade"] = {Rarity = 55, Rep = 1},
            ["item_rappel"] = {Rarity = 65, Rep = 1}
        },
        MaxItems = 10,
        MinItems = 2
    },
    ["mpfdrops"] = { 
        Items = {
            ["util_combinescrap"] = {Rarity = 0.5, Rep = 1},
            ["item_enhancedvial"] = {Rarity = 90, Rep = 2},
            ["item_healthvial"] = { 
                Rarity = 35,
                Rep = 3,
                PopScale = {
                    Rarity = {
                        Min = 80,
                        Max = 35
                    },
                    Rep = {
                        Min = 3,
                        Max = 1
                    }
                }
            },
            ["util_lvl2plate"] = {Rarity = 65, Rep = 1},
            ["item_rappel"] = {Rarity = 65, Rep = 1}
        },
        MaxItems = 5,
        MinItems = 1
    },
    ["zombiedrops"] = { 
        Items = {
            ["util_cloth"] = {Rarity = 0.5, Rep = 3},
            ["util_rawheadcrabmeat"] = {Rarity = 10, Rep = 1},
            ["util_plastic"] = {Rarity = 35, Rep = 3},
            ["clo_backpack"] = {Rarity = 95, Rep = 1},
            ["util_steel"] = {Rarity = 65, Rep = 1},
        },
        MaxItems = 6,
        MinItems = 3
    },
} 

local ArmorItems = {
    ["cos_elitevest"] = true,
    ["cos_otavest2"] = true,
    ["cos_otavest"] = true,
    ["cos_lightvest"] = true,
    ['cos_conscriptarmor'] = true
}

local ANTICRASH_ATTEMPTS = 0
local function GenerateLootFromPool(pool, ply)
    local lootPool = impulse.RagdollContainer.LootPools[pool]
    local loot = {}
    local count = 0
    local rarityCount = 0
    
    local playerCount = #player.GetAll()
    local maxPlayers = game.MaxPlayers()
    local popRatio = math.Clamp(playerCount / maxPlayers, 0, 1)

    for itemName, itemData in RandomPairs(lootPool.Items) do
        local rarity = itemData.Rarity
        local rep = itemData.Rep or 1
        
        if itemData.PopScale then
            if itemData.PopScale.Rarity then
                local minRarity = itemData.PopScale.Rarity.Min or rarity
                local maxRarity = itemData.PopScale.Rarity.Max or rarity
                rarity = minRarity + ((maxRarity - minRarity) * popRatio)
            end
            
            if itemData.PopScale.Rep then
                local minRep = itemData.PopScale.Rep.Min or rep
                local maxRep = itemData.PopScale.Rep.Max or rep
                rep = maxRep - ((maxRep - minRep) * popRatio)
                rep = math.ceil(rep)
                rep = math.max(rep, 1)
            end
        end
        
        for i = 1, rep do
            local randomChance = math.random(1, 100)

            if randomChance >= rarity then
                if itemData.RequiredClass then
                    local playerClass = ply:GetTeamClass()
                    if playerClass and table.HasValue(itemData.RequiredClass, playerClass) then
                        if lootPool.MaxItems and count >= lootPool.MaxItems then break end
                        count = count + 1
                        rarityCount = rarityCount + itemData.Rarity
                        loot[itemName] = (loot[itemName] and loot[itemName] + 1) or 1
                    end
                else
                    if lootPool.MaxItems and count >= lootPool.MaxItems then break end
                    count = count + 1
                    rarityCount = rarityCount + itemData.Rarity
                    loot[itemName] = (loot[itemName] and loot[itemName] + 1) or 1
                end
            end
        end
    end

    if count == 0 or (lootPool.MinItems and count < lootPool.MinItems) then
        ANTICRASH_ATTEMPTS = ANTICRASH_ATTEMPTS + 1
        if ANTICRASH_ATTEMPTS > 32 then
            impulse.debugPrint("[impulse] HIGH LOOT GENERATION ATTEMPTS WARNING! ("..pool..") ("..ANTICRASH_ATTEMPTS..")")
            impulse.debugPrint("Please make sure this lootpool is NOT impossible to compute!")    
        end
        return GenerateLootFromPool(pool, ply)
    else
        ANTICRASH_ATTEMPTS = 0
    end

    return loot, count
end

impulse.RagdollContainer.ScrapWeapons = {
    ["ctadrops"] = {
        Items = {
            ["scrap_ar2"] = {Rarity = 450},
            ["scrap_apf"] = {Rarity = 600},
            ["scrap_mp7"] = {Rarity = 600},
            ["scrap_shotgun"] = {Rarity = 800},
            ["scrap_ar2e"] = {Rarity = 650},
            ["scrap_rappel"] = {Rarity = 750},
            ["scrap_osips"] = {Rarity = 800},
            ["scrap_ar15"] = {Rarity = 800},
            ["scrap_xm1014"] = {Rarity = 800},
            ["scrap_omr"] = {Rarity = 800},
        }
    },
    ["mpfdrops"] = {
        Items = {
            ["scrap_357"] = {Rarity = 750},
            ["scrap_pistol"] = {Rarity = 400},
            ["scrap_cz75"] = {Rarity = 400},
            ["scrap_mp7"] = {Rarity = 850},
            ["scrap_mp7a8"] = {Rarity = 925}, 
            ["scrap_stunstick"] = {Rarity = 750},
            ["scrap_shotgun"] = {Rarity = 600},
            ["scrap_deagle"] = {Rarity = 750},
            ["scrap_sw500"] = {Rarity = 999},
            ["scrap_hb"] = {Rarity = 800},
            ["scrap_ar15"] = {Rarity = 800},
            ["scrap_p90"] = {Rarity = 500},
            ["scrap_xm1014"] = {Rarity = 800},
        }
    },
}

local function GenerateScrapLootForPlayer(ply, lootType)
    local loot = {}
    local count = 0

    local scrapWeaponsTable = impulse.RagdollContainer.ScrapWeapons[lootType]
    if not scrapWeaponsTable then
        impulse.debugPrint("Error: Scrap weapons table '" .. lootType .. "' not found.")
        return loot, count
    end

    for _, playerItem in pairs(ply:GetInventory() or {}) do
        local itemClass = impulse.Inventory.ClassToNetID(playerItem.class)
        local impulseItemData = impulse.Inventory.Items[itemClass]

        if impulseItemData.Category == "Weapons" and impulseItemData.ScrapClass then
            local scrapClass = impulseItemData.ScrapClass
            local scrapData = scrapWeaponsTable.Items[scrapClass]

            if scrapData then
                local dropChance = math.random(1, 1000)
                if dropChance <= scrapData.Rarity then
                    count = count + 1
                    loot[scrapClass] = (loot[scrapClass] and loot[scrapClass] + 1) or 1
                end
            else
                impulse.debugPrint("Warning: Scrap data not found for weapon '" .. playerItem.class .. "'.")
            end
        end
    end

    return loot, count
end

impulse.RagdollContainer.AmmoDrops = {
    ["ammo_smg"] = {
        Rarity = 800,
        AssociatedWeapons = {
            ["wep_mp7"] = true,
            ["wep_mp7a8"] = true,
            ["wep_p90"] = true,
            ["wep_ar15"] = true,
            ["wep_honeybadger"] = true,
        }
    },
    ["ammo_buckshot"] = {
        Rarity = 800,
        AssociatedWeapons = {
            ["wep_shotgun"] = true,
            ["wep_m500"] = true,
            ["wep_osihs"] = true,
            ["wep_osisg"] = true,
            ["wep_db"] = true
        }
    },
    ["ammo_54r"] = {
        Rarity = 900, 
        AssociatedWeapons = {
            ["wep_ar2r"] = true,
            ["wep_omr"] = true,
        }
    },
    ["ammo_pistol"] = {
        Rarity = 600,
        AssociatedWeapons = {
            ["wep_pistol"] = true,
            ["wep_pm63"] = true,
            ["wep_cz75"] = true,
        }
    },
    ["ammo_ar2"] = {
        Rarity = 900, 
        AssociatedWeapons = {
            ["wep_ar2"] = true,
            ["wep_ar2e"] = true,
            ["wep_osiprmk1c"] = true,
            ["wep_osiprmk1"] = true,
            ["wep_osips"] = true
        }
    },
    ["ammo_sniper"] = {
        Rarity = 900, 
        AssociatedWeapons = {
            ["wep_osr"] = true,
            ["wep_omr"] = true,
        }
    },
}

local function GenerateAmmoLootForPlayer(ply)
    if not ply:IsCP() then return {}, 0 end

    local allAmmoLoot = {}
    local totalCount = 0

    for ammoItem, ammoPool in pairs(impulse.RagdollContainer.AmmoDrops) do
        local loot = {}
        local count = 0

        for weapon, _ in pairs(ammoPool.AssociatedWeapons) do
            local found = false
            for _, playerItem in pairs(ply:GetInventory() or {}) do
                local itemClass = impulse.Inventory.ClassToNetID(playerItem.class)
                local impulseItemData = impulse.Inventory.Items[itemClass]
                if impulseItemData.Category == "Weapons" and playerItem.class == weapon then
                    found = true
                    break
                end
            end

            if found then
                local numBoxesToDrop = math.random(0, 3)
                for i = 1, numBoxesToDrop do
                    local dropChance = math.random(1, 1000)
                    if dropChance <= ammoPool.Rarity then
                        count = count + 1
                        loot[ammoItem] = (loot[ammoItem] and loot[ammoItem] + 1) or 1
                    end
                end
            end
        end

        for itemName, itemCount in pairs(loot) do
            allAmmoLoot[itemName] = (allAmmoLoot[itemName] and allAmmoLoot[itemName] + itemCount) or itemCount
            totalCount = totalCount + itemCount
        end
    end

    return allAmmoLoot, totalCount
end

function PLUGIN:PlayerRagdollPreSpawn(ragdoll, ply, attacker)
    if not IsValid(ragdoll) then return end

    ragdoll:PhysicsInit(SOLID_VPHYSICS)
    ragdoll:SetMoveType(SOLID_VPHYSICS)
    ragdoll:SetSolid(SOLID_VPHYSICS)
    ragdoll:SetUseType(SIMPLE_USE)
    ragdoll:DrawShadow(false)

    ragdoll.Users = {}
    ragdoll.Authorised = {}
    ragdoll.Inventory = {}

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
    
        net.Start("impulseInvContainerOpen")
        local inventoryCount = self.Inventory and table.Count(self.Inventory) or 0
        net.WriteUInt(inventoryCount, 8)
    
        if self.Inventory then
            for v, k in pairs(self.Inventory) do
                local netid = impulse.Inventory.ClassToNetID(v)
                local amount = k
    
                if not netid then
                    impulse.debugPrint("Error: ClassToNetID returned nil for item:", v)
                    continue
                end
    
                if not amount or type(amount) ~= "number" then
                    impulse.debugPrint("Error: Invalid amount for item:", v, "amount:", amount)
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
        local count = self.Inventory[itemclass] or 0
        self.Inventory[itemclass] = count + (amount or 1)
        if not noUpdate then self:UpdateUsers() end
    end

    function ragdoll:TakeItem(itemclass, amount, noUpdate)
        local itemCount = self.Inventory[itemclass]
        if itemCount then
            local newCount = itemCount - (amount or 1)
            if newCount < 1 then
                self.Inventory[itemclass] = nil
            else
                self.Inventory[itemclass] = newCount
            end
        end
        if not noUpdate then self:UpdateUsers() end
    end

    function ragdoll:CanHoldItem(itemclass)
        local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(itemclass)]
        local weight = item.Weight or 0
        return self:GetStorageWeight() + weight <= self:GetCapacity()
    end

    function ragdoll:UpdateUsers()
        local pos = self:GetPos()
        for v, k in pairs(self.Users) do
            if IsValid(v) and pos:DistToSqr(v:GetPos()) < (230 ^ 2) then
                net.Start("impulseInvContainerUpdate")
                local inventoryCount = self.Inventory and table.Count(self.Inventory) or 0
                net.WriteUInt(inventoryCount, 8)
                if self.Inventory then
                    for iv, ik in pairs(self.Inventory) do
                        net.WriteUInt(impulse.Inventory.ClassToNetID(iv), 10)
                        net.WriteUInt(ik, 8)
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
        if self.Inventory then
            for v, k in pairs(self.Inventory) do
                local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(v)]
                weight = weight + ((item.Weight or 0) * k)
            end
        end
        return weight
    end

    ragdoll.InventoryWeight = ragdoll:GetStorageWeight()

    -- Use local variable, not global
    local deadPlayer = ragdoll.DeadPlayer
    if not deadPlayer then return end

    ragdoll:SetLoot(false)
    ragdoll:SetCapacity(35)

    for _, itemClass in pairs(ragdoll.inventoryOnDeath or {}) do
        if ragdoll:CanHoldItem(itemClass) then
            if not ArmorItems[itemClass] then
                ragdoll:AddItem(itemClass, 1, false)
            elseif itemClass == "cos_conscriptarmor" then
                ragdoll:AddItem("scrap_conscriptarmor", 1, true)
            else
                break
            end
        end
    end
        

    if ragdoll.TeamOnDeath == TEAM_OTA then
        if ragdoll.FallDeath then return end
        if not attacker or not IsValid(attacker) or not attacker:GetTeamClass() then return end
        if DISABLE_LOOT_DROPS then return end

        local loot, count = GenerateLootFromPool("ctadrops", deadPlayer)
        local scrapLoot, scrapCount = GenerateScrapLootForPlayer(attacker, "ctadrops")

        for itemName, itemCount in pairs(scrapLoot) do
            loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
            count = count + itemCount
        end

        local ammoLoot, ammoCount = GenerateAmmoLootForPlayer(attacker)
        for itemName, itemCount in pairs(ammoLoot) do
            loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
            count = count + itemCount
        end

        if deadPlayer.ConfiscatedInv and #deadPlayer.ConfiscatedInv >= 1 then
            for k, v in pairs(deadPlayer.ConfiscatedInv) do
                ragdoll:AddItem(v, 1, true)
            end
        end
        deadPlayer.ConfiscatedInv = {}

        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end

    elseif ragdoll.TeamOnDeath == TEAM_CP then
        if ragdoll.FallDeath then return end
        if not attacker or not IsValid(attacker) or not attacker:GetTeamClass() then return end
        if DISABLE_LOOT_DROPS then return end

        local loot, count = GenerateLootFromPool("mpfdrops", deadPlayer)
        local scrapLoot, scrapCount = GenerateScrapLootForPlayer(attacker, "mpfdrops")

        if deadPlayer.ConfiscatedInv and #deadPlayer.ConfiscatedInv >= 1 then
            for k, v in pairs(deadPlayer.ConfiscatedInv) do
                ragdoll:AddItem(v, 1, true)
            end
        end
        deadPlayer.ConfiscatedInv = {}

        for itemName, itemCount in pairs(scrapLoot) do
            loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
            count = count + itemCount
        end

        local ammoLoot, ammoCount = GenerateAmmoLootForPlayer(attacker)
        for itemName, itemCount in pairs(ammoLoot) do
            loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
            count = count + itemCount
        end

        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end

    elseif ragdoll.TeamOnDeath == TEAM_CA then
        if ragdoll.FallDeath then return end
        if not attacker or not IsValid(attacker) or not attacker:GetTeamClass() then return end

        if deadPlayer.ConfiscatedInv and #deadPlayer.ConfiscatedInv >= 1 then
            for k, v in pairs(deadPlayer.ConfiscatedInv) do
                ragdoll:AddItem(v, 1, true)
            end
        end
        deadPlayer.ConfiscatedInv = {}

    elseif ragdoll.TeamOnDeath == TEAM_ZOMBIE then
        if ragdoll.FallDeath then return end

        local loot, count = GenerateLootFromPool("zombiedrops", deadPlayer)

        for itemName, itemCount in pairs(loot) do
            ragdoll:AddItem(itemName, itemCount, true)
        end
    end
end

hook.Add("KeyPress", "impulseRagdollContainerUse", function(ply, key)
    if key ~= IN_USE then return end

    local trace = ply:GetEyeTrace()
    local ent = trace.Entity

    if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" then return end

    local maxDist = 80
    if ent:NearestPoint(ply:GetShootPos()):DistToSqr(ply:GetShootPos()) > maxDist * maxDist then return end

    if not ent.DeadPlayer then return end
    if not ply:Alive() then return end

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