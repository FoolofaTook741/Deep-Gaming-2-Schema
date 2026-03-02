impulse.RagdollContainer = impulse.RagdollContainer or {}
DISABLE_LOOT_DROPS = false


-- If ever modified the way the rarity system and the droprates work is that if the random number generated in the function is HIGHER or equal to the rarity the item will be added to the table/dropped
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

    -- ADDED: made it so mpf drops, specifically the health vial, are scaled based on server population; this can be used as an example if you want to add pop scale to other items as well.
    ["mpfdrops"] = { 
        Items = {
            ["util_combinescrap"] = {Rarity = 0.5, Rep = 1},
            ["item_enhancedvial"] = {Rarity = 90, Rep = 2},
            ["item_healthvial"] = { 
                Rarity = 35,
                Rep = 3,
                PopScale = {
                    Rarity = {
                        Min = 80,    -- 21% chance per attempt
                        Max = 35     -- 66% chance per attempt
                    },
                    Rep = {
                        Min = 3,     -- Attempts on FULL server - MORE
                        Max = 1      -- Attempts on EMPTY server - FEWER
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
    ["cos_conscriptarmor"] = true
}

local ANTICRASH_ATTEMPTS = 0
local function GenerateLootFromPool(pool, ply)
    local lootPool = impulse.RagdollContainer.LootPools[pool]
    local loot = {}
    local count = 0
    local rarityCount = 0
    
    local playerCount = #player.GetAll()
    local maxPlayers = game.MaxPlayers()
    local popRatio = math.Clamp(playerCount / maxPlayers, 0, 1)  -- 0 = empty, 1 = full

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
                        if lootPool.MaxItems and count >= lootPool.MaxItems then
                            break
                        end

                        count = count + 1
                        rarityCount = rarityCount + itemData.Rarity
                        loot[itemName] = (loot[itemName] and loot[itemName] + 1) or 1
                    end
                else
                    if lootPool.MaxItems and count >= lootPool.MaxItems then
                        break
                    end

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

-- If ever modified the way the rarity system and the droprates work is that if the random number generated in the function is LOWER or equal to the rarity the item will be added to the table/dropped
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
			["scrap_mini14"] = {Rarity = 800},
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
            ["scrap_mini14"] = {Rarity = 800},
            ["scrap_p90"] = {Rarity = 500},
            ["scrap_xm1014"] = {Rarity = 800},
		}
	},
}

local ANTICRASH_ATTEMPTS = 0
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
            ["wep_mini14"] = true,
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
    if !ply:IsCP() then
        return
    end



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

                -- Check if the player has the weapon in their inventory
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

    -- Debug prints
    if totalCount > 0 then
       -- impulse.debugPrint("Generated ammo loot for player:")
        for itemName, itemCount in pairs(allAmmoLoot) do
          --  impulse.debugPrint("Generated", itemCount, "of", itemName)
        end
    else
      --  impulse.debugPrint("No ammo loot generated for player.")
    end

    return allAmmoLoot, totalCount
end

function PLUGIN:PlayerRagdollPreSpawn(ragdoll, ply, attacker)
    if IsValid(ragdoll) then
        ragdoll:PhysicsInit(SOLID_VPHYSICS)
        ragdoll:SetMoveType(SOLID_VPHYSICS)
        ragdoll:SetSolid(SOLID_VPHYSICS)
        ragdoll:SetUseType(SIMPLE_USE)
        ragdoll:DrawShadow(false)

        ragdoll.Users = {}
        ragdoll.Authorised = {}
        ragdoll.Inventory = {}    

        if timer.Exists(ply:SteamID() .. "ragdelay") then
            return
        end
        timer.Create(ply:SteamID() .. "ragdelay", 10, 1, function() 
            timer.Remove(ply:SteamID() .. "ragdelay") -- idk it just looks scuffed leaving it empty
        end)
    
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
            
            -- ADDED NIL CHECK
            local inventoryCount = 0
            if self.Inventory then
                inventoryCount = table.Count(self.Inventory)
            end
            net.WriteUInt(inventoryCount, 8)
        
            -- ADDED NIL CHECK
            if self.Inventory then
                for v, k in pairs(self.Inventory) do
                    local netid = impulse.Inventory.ClassToNetID(v)
                    local amount = k
        
                    if not netid then
                        impulse.debugPrint("Error: ClassToNetID returned nil for item:", v)
                    end
        
                    if not amount or type(amount) ~= "number" then
                        impulse.debugPrint("Error: Invalid amount for item:", v, "amount:", amount)
                    end
        
                    net.WriteUInt(netid, 10)
                    net.WriteUInt(amount, 8)
                end
            end
        
            net.Send(ply)
        
            ply.currentContainer = self
        end                    

        function ragdoll:RemoveUser(ply)
            ragdoll.Users[ply] = nil
            ply.currentContainer = nil
        end

        function ragdoll:AddItem(itemclass, amount, noUpdate)
            local count = 0
        
            if self.Inventory[itemclass] then
                count = self.Inventory[itemclass]
            end
        
            self.Inventory[itemclass] = count + (amount or 1)
        
            if not noUpdate then
                self:UpdateUsers()
            end
        end

        function ragdoll:CheckEmpty()
            if not IsValid(self) then return end

            local hasLoot = false
            if self.Inventory then
                for _, v in pairs(self.Inventory) do
                    if v > 0 then
                        hasLoot = true
                        break
                    end
                end
            end

            if not hasLoot then
                self:Remove()
            end
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
        
            if not noUpdate then
                self:UpdateUsers()
            end
            self:CheckEmpty()
        end

        function ragdoll:CanHoldItem(itemclass)
            local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(itemclass)]
            local weight = (item.Weight or 0) * (amount or 1)
        
            return self:GetStorageWeight() + weight <= self:GetCapacity()
        end

        function ragdoll:UpdateUsers()
            local pos = self:GetPos()
        
            for v,k in pairs(self.Users) do
                if IsValid(v) and pos:DistToSqr(v:GetPos()) < (230 ^ 2) then
                    net.Start("impulseInvContainerUpdate")
                    
                    -- ADDED NIL CHECK
                    local inventoryCount = 0
                    if self.Inventory then
                        inventoryCount = table.Count(self.Inventory)
                    end
                    net.WriteUInt(inventoryCount, 8)
        
                    -- ADDED NIL CHECK
                    if self.Inventory then
                        for v,k in pairs(self.Inventory) do
                            local netid = impulse.Inventory.ClassToNetID(v)
                            local amount = k
        
                            net.WriteUInt(netid, 10)
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
        
            -- ADDED NIL CHECK
            if self.Inventory then
                for v,k in pairs(self.Inventory) do
                    local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(v)]
                    weight = weight + ((item.Weight or 0) * k)
                end
            end
        
            return weight
        end

        --ragdoll:SetNWInt("InventoryWeight", ragdoll:GetStorageWeight())
        ragdoll.InventoryWeight = ragdoll:GetStorageWeight()

        deadPlayerRagdoll = ragdoll.DeadPlayer 
        if deadPlayerRagdoll then
            ragdoll:SetLoot(false)
            ragdoll:SetCapacity(35)
        
            for _, itemClass in pairs(ragdoll.inventoryOnDeath) do
                if ragdoll:CanHoldItem(itemClass) then
                    if not ArmorItems[itemClass] then
                        ragdoll:AddItem(itemClass, 1, false)
                    elseif itemClass == "cos_conscriptarmor" then
                        ragdoll:AddItem("scrap_conscriptarmor", 1, false)
                    end
                else
                    break
                end
            end
        
            if ragdoll.TeamOnDeath == TEAM_OTA then
                if ragdoll.FallDeath == true then
                    return
                end

                if !ply:GetTeamClass() then
                    return
                end

                if DISABLE_LOOT_DROPS then
                    return
                end
        
                local lootPoolName = "ctadrops"
            
                local loot, count = GenerateLootFromPool(lootPoolName, deadPlayerRagdoll)
            
                local scrapLoot, scrapCount = GenerateScrapLootForPlayer(ply, "ctadrops")
            
                for itemName, itemCount in pairs(scrapLoot) do
                    loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
                    count = count + itemCount
                end
            
                local ammoLoot, ammoCount = GenerateAmmoLootForPlayer(ply)
                for itemName, itemCount in pairs(ammoLoot) do
                    loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
                    count = count + itemCount
                end
                
                if deadPlayerRagdoll.ConfiscatedInv and #deadPlayerRagdoll.ConfiscatedInv >= 1 then
                    for k,v in pairs(deadPlayerRagdoll.ConfiscatedInv) do
                        ragdoll:AddItem(v, 1, false)
                    end
                end

                deadPlayerRagdoll.ConfiscatedInv = {}
            
                if count > 0 then
                    for itemName, itemCount in pairs(loot) do
                        ragdoll:AddItem(itemName, itemCount, false)
                    end
                end
            elseif ragdoll.TeamOnDeath == TEAM_CP then

                if ragdoll.FallDeath == true then
                    return
                end

                if !ply:GetTeamClass() then
                    return
                end

                if DISABLE_LOOT_DROPS then
                    return
                end

                local lootPoolName = "mpfdrops"
            
                local loot, count = GenerateLootFromPool(lootPoolName, deadPlayerRagdoll)
            
                local scrapLoot, scrapCount = GenerateScrapLootForPlayer(ply, "mpfdrops")

                if deadPlayerRagdoll.ConfiscatedInv and #deadPlayerRagdoll.ConfiscatedInv >= 1 then
                    for k,v in pairs(ragdoll.DeadPlayer.ConfiscatedInv) do
                        ragdoll:AddItem(v, 1, false)
                    end
                end
                deadPlayerRagdoll.ConfiscatedInv = {}
            
                for itemName, itemCount in pairs(scrapLoot) do
                    loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
                    count = count + itemCount
                end
            
                local ammoLoot, ammoCount = GenerateAmmoLootForPlayer(ply)
                for itemName, itemCount in pairs(ammoLoot) do
                    loot[itemName] = (loot[itemName] and loot[itemName] + itemCount) or itemCount
                    count = count + itemCount
                end
            
                if count > 0 then
                    for itemName, itemCount in pairs(loot) do
                        ragdoll:AddItem(itemName, itemCount, false)
                    end


                end
            elseif ragdoll.TeamOnDeath == TEAM_CA then

                if ragdoll.FallDeath == true then
                    return
                end

                if !ply:GetTeamClass() then
                    return
                end

                if deadPlayerRagdoll.ConfiscatedInv and #deadPlayerRagdoll.ConfiscatedInv >= 1 then
                    for k,v in pairs(ragdoll.DeadPlayer.ConfiscatedInv) do
                        ragdoll:AddItem(v, 1, false)
                    end
                end
                deadPlayerRagdoll.ConfiscatedInv = {}

            elseif ragdoll.TeamOnDeath == TEAM_ZOMBIE then

                if ragdoll.FallDeath == true then
                    return
                end

                local lootPoolName = "zombiedrops"
            
                local loot, count = GenerateLootFromPool(lootPoolName, deadPlayerRagdoll)
            
                local scrapLoot, scrapCount = GenerateScrapLootForPlayer(ply, "zombiedrops")
            
                if count > 0 then
                    for itemName, itemCount in pairs(loot) do
                        ragdoll:AddItem(itemName, itemCount, false)
                    end
                end
            end                            
        end        
    end
end
--[[
function PLUGIN:KeyPress(ply, key)
    if key ~= IN_USE then return end

    local trace = ply:GetEyeTrace()
    local ent = trace.Entity

    if IsValid(ent) and ent:GetClass() == "prop_ragdoll" then
        local maxDist = 80
        local maxDistSqr = maxDist * maxDist

        local src = ply:GetShootPos()
        local near = ent:NearestPoint(src)
        if near:DistToSqr(src) > maxDistSqr then
            return
        end

        if deadPlayerRagdoll then
            if ply:IsPlayer() and ply:Alive() then
                if ply:GetSyncVar(SYNC_ARRESTED, false) then
                    return ply:Notify("You cannot access a container when detained.")
                end

                if ply:IsCP() and ent:GetLoot() then
                    return ply:Notify("You cannot access this container as this team.")
                end

                if ply:IsCP() and ply:IsScanner() then
                    return ply:Notify("You cannot access containers as a scanner.")
                end

                ent.Users = ent.Users or {}
                if not ent.Users[ply] then
                    ent:AddUser(ply)
                end
            end
        end
    end
end
--]]