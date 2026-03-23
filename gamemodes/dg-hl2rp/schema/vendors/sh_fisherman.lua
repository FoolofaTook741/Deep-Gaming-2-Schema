local VENDOR = {}

VENDOR.UniqueID = "fisherman"
VENDOR.Name = "Traveler"
VENDOR.Desc = "Drops by with useful items."

VENDOR.Model = "models/Humans/Group01/Male_Cheaple.mdl"
VENDOR.Skin = 0
VENDOR.Sequence = "lineidle02"
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.DownloadTrades = true -- use for vendors that change what they buy/sell at runtime


VENDOR.RandomTrades = {
	Sell = {
		["ammo_357"] = {Rarity = 850, Cost = {90, 200}, BuyMax = 1},
		["ammo_smg"] = {Rarity = 800, Cost = {50, 180}, BuyMax = 2},
		["cos_combatgasmask"] = {Rarity = 890, Cost = {100, 150}, BuyMax = 1},
		["wep_pistol"] = {Rarity = 400, Cost = {70, 250}, BuyMax = 1},
		["wep_skeleton"] = {Rarity = 500, Cost = {67, 100}, BuyMax = 1},
		["wep_stiletto"] = {Rarity = 500, Cost = {130, 330}, BuyMax = 1},
		["util_rdxcompound"] = {Rarity = 750, Cost = {400, 650}, BuyMax = 2},
		["util_lvl2plate"] = {Rarity = 400, Cost = {120, 285}, BuyMax = 1},
		-- ["wep_pickaxe"] = {Rarity = 500, Cost = {50, 101}, BuyMax = 2},
		["cos_otavest3"] = {Rarity = 890, Cost = {260, 699}, BuyMax = 1},
		-- ["wep_goldengun"] = {Rarity = 997, Cost = {6000, 9000}, BuyMax = 1},
		-- ["wep_goldenak47"] = {Rarity = 999, Cost = {15000, 20000}, BuyMax = 1},
		-- ["wep_goldendeagle"] = {Rarity = 998, Cost = {9000, 11000}, BuyMax = 1},
		["util_refinedmetalplate"] = {Rarity = 680, Cost = {60, 100}, BuyMax = 5},
		["util_steel"] = {Rarity = 710, Cost = {140, 230}, BuyMax = 3},
		["wep_bar"] = {Rarity = 795, Cost = {400, 900}, BuyMax = 1},
		["wep_molotov"] = {Rarity = 740, Cost = {350, 550}, BuyMax = 1},
		["item_enhancedvial"] = {Rarity = 575, Cost = {150, 300}, BuyMax = 2},
		["item_healthvial"] = {Rarity = 550, Cost = {95, 200}, BuyMax = 3},
		["wep_shotgun"] = {Rarity = 720, Cost = {400, 650}, BuyMax = 1},
		["wep_mg34"] = {Rarity = 890, Cost = {1020, 1470}, BuyMax = 1},
		["wep_357"] = {Rarity = 890, Cost = {700, 900}, BuyMax = 1},
		["wep_mp7"] = {Rarity = 690, Cost = {320, 550}, BuyMax = 3},
		["util_yeast"] = {Rarity = 600, Cost = {6, 13}, BuyMax = 6},
		-- ["item_padlock"] = {Rarity = 580, Cost = {10, 20}, BuyMax = 2},
		["util_gear"] = {Rarity = 350, Cost = {19, 65}, BuyMax = 3},
		-- ["util_plastic"] = {Rarity = 360, Cost = {42, 62}, BuyMax = 3},
		["util_gunpowder"] = {Rarity = 690, Cost = {18, 30}, BuyMax = 10},
		["util_cloth"] = {Rarity = 400, Cost = {5, 20}, BuyMax = 6},
		["att_dragonsbreath"] = {Rarity = 900, Cost = {1015, 1520}, BuyMax = 1},
		["util_energycore"] = {Rarity = 970, Cost = {900, 1750}, BuyMax = 3},
		["scrap_ar2"] = {Rarity = 998, Cost = {3000, 4500}, BuyMax = 1},
		["wep_m60"] = {Rarity = 850, Cost = {1900, 2750}, BuyMax = 1},
	},
	Buy = {
		["util_moonshine"] = {Cost = {400, 500}},
		["util_resin"] = {Cost = {20, 35}},
		["resin_machineready"] = {Cost = {500, 875}},
	}
}

VENDOR.Sell = {}
VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT
end

local function fishermanDisappear(ent)
	ent:EmitSound("lostcoast/vo/fisherman/fish_grieve02.wav")

	timer.Simple(3, function()
		if not IsValid(ent) then
			return
		end

		ent.BeenTriggered = false
		ent:SetPos(Vector(-4061.1323242188, 14661.44140625, 10783.806640625)) -- ik its messy
		ent:SetNoDraw(true)
		ent:RemoveAllDecals()
	end)
end

local function fishermanRandomInv(ent)
	ent.Vendor.Sell = {}
	ent.Vendor.Buy = {}

	for v,k in pairs(VENDOR.RandomTrades.Buy) do
		ent.Vendor.Buy[v] = {Cost = math.random(k.Cost[1], k.Cost[2])}
	end

	local amount = 0
    local targetAmount = math.random(3, 5)
    local attempts = 0
    local maxAttempts = 100  -- Prevent infinite loop

    for v,k in RandomPairs(VENDOR.RandomTrades.Sell) do
        local r = math.random(0, 1000)

        if r >= k.Rarity then
            ent.Vendor.Sell[v] = {Cost = math.random(k.Cost[1], k.Cost[2]), BuyMax = k.BuyMax, TempCooldown = 600, OnPurchased = k.OnPurchased}
            amount = amount + 1
        end
        attempts = attempts + 1
        if amount >= targetAmount or attempts >= maxAttempts then
            break
        end
    end

    if amount < 3 then
        for v,k in RandomPairs(VENDOR.RandomTrades.Sell) do
            if not ent.Vendor.Sell[v] and k.Rarity < 700 then  
--Only solution I could think of to fill at least 3 items and maintain some semblance of rarity -FOOL
                ent.Vendor.Sell[v] = {Cost = math.random(k.Cost[1], k.Cost[2]), BuyMax = k.BuyMax, TempCooldown = 600, OnPurchased = k.OnPurchased}
                amount = amount + 1

                if amount >= 3 then
                    break
                end
            end
        end
    end
end

local function fishermanAppear(ent)
	if not IsValid(ent) then
		return
	end

	ent.BeenTriggered = true
	ent.Vendor.BuyBudget = 8000
	--print("[Fisherman] Spawned with budget: " .. ent.Vendor.BuyBudget)

	fishermanRandomInv(ent)

	ent:SetPos(ent.MainPos)
	ent:SetNoDraw(false)
    --ent:SetSolid(SOLID_BBOX)
    --ent:SetMoveType(MOVETYPE_NONE)
    --ent:SetUseType(SIMPLE_USE)
    --ent:SetCollisionGroup(COLLISION_GROUP_NONE)

	timer.Simple(360, function()
		if not IsValid(ent) then return end
		fishermanDisappear(ent)
	end)
end

function VENDOR:Initialize()
    self.MainPos = impulse.Config.FishermanPos
    self:SetAngles(impulse.Config.FishermanAng)
    self:SetNoDraw(true)
    self.BeenTriggered = false
    self.Vendor.BuyBudget = 8000

    hook.Add("PlayerVendorSell", "FishermanBudget_"..tostring(self), function(ply, vendor, itemclass, cost)
        if vendor ~= self then return end
        if isnumber(cost) then
            if self.Vendor.BuyBudget <= 0 then
                ply:Notify("This vendor can not afford to purchase this item.")
                return
            end
           -- print("[Fisherman] Budget before sale: " .. self.Vendor.BuyBudget)
            self.Vendor.BuyBudget = self.Vendor.BuyBudget - cost
            --print("[Fisherman] Budget after sale: " .. self.Vendor.BuyBudget)
            if self.Vendor.BuyBudget <= 0 then
                self.Vendor.Buy = {}
                ply:Notify("This vendor can not afford to purchase this item.")
            end
        end
    end)

    self.TimerID = "TravelerSpawn_" .. self:EntIndex()

    timer.Create(self.TimerID, 2160, 0, function()
        if not IsValid(self) then
            timer.Remove(self.TimerID)
            return
        end

        if not self.BeenTriggered then
            fishermanAppear(self)
        end
    end)
end

function VENDOR:OnRemove()
    hook.Remove("PlayerVendorSell", "FishermanBudget_"..tostring(self))
    if self.TimerID and timer.Exists(self.TimerID) then
        timer.Remove(self.TimerID)
    end
end


impulse.RegisterVendor(VENDOR)