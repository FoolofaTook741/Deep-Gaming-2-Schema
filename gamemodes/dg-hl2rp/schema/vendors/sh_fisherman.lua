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

VENDOR.MaxBuys = 3000

VENDOR.RandomTrades = {
	Sell = {
		["ammo_357"] = {Rarity = 850, Cost = {90, 200}, BuyMax = 1},
		["ammo_smg"] = {Rarity = 800, Cost = {50, 180}, BuyMax = 2},
		["cos_combatgasmask"] = {Rarity = 890, Cost = {100, 150}, BuyMax = 1},
		["wep_pistol"] = {Rarity = 780, Cost = {70, 250}, BuyMax = 1},
		-- ["wep_cz75"] = {Rarity = 660, Cost = {130, 330}, BuyMax = 2},
		["util_rdxcompound"] = {Rarity = 430, Cost = {280, 440}, BuyMax = 4},
		-- ["wep_pickaxe"] = {Rarity = 500, Cost = {50, 101}, BuyMax = 2},
		["cos_otavest3"] = {Rarity = 890, Cost = {260, 699}, BuyMax = 1},
		-- ["wep_goldengun"] = {Rarity = 997, Cost = {6000, 9000}, BuyMax = 1},
		-- ["wep_goldenak47"] = {Rarity = 999, Cost = {15000, 20000}, BuyMax = 1},
		-- ["wep_goldendeagle"] = {Rarity = 998, Cost = {9000, 11000}, BuyMax = 1},
		["wep_bar"] = {Rarity = 795, Cost = {400, 900}, BuyMax = 1},
		["wep_molotov"] = {Rarity = 740, Cost = {100, 200}, BuyMax = 3},
		["wep_shotgun"] = {Rarity = 720, Cost = {400, 650}, BuyMax = 1},
		["wep_mg34"] = {Rarity = 890, Cost = {1020, 1470}, BuyMax = 1},
		["wep_mp7"] = {Rarity = 690, Cost = {320, 550}, BuyMax = 3},
		["util_yeast"] = {Rarity = 600, Cost = {6, 13}, BuyMax = 6},
		-- ["item_padlock"] = {Rarity = 580, Cost = {10, 20}, BuyMax = 2},
		["util_gear"] = {Rarity = 350, Cost = {19, 65}, BuyMax = 3},
		-- ["util_plastic"] = {Rarity = 360, Cost = {42, 62}, BuyMax = 3},
		["util_gunpowder"] = {Rarity = 690, Cost = {18, 30}, BuyMax = 10},
		["util_cloth"] = {Rarity = 400, Cost = {5, 20}, BuyMax = 6},
		["att_dragonsbreath"] = {Rarity = 900, Cost = {1015, 1520}, BuyMax = 1},
		["book_russian"] = {Rarity = 850, Cost = {2020, 3520}, BuyMax = 3},
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
	for v,k in RandomPairs(VENDOR.RandomTrades.Sell) do
		local r = math.random(0, 1000)

		if r >= k.Rarity then
			ent.Vendor.Sell[v] = {Cost = math.random(k.Cost[1], k.Cost[2]), BuyMax = k.BuyMax, TempCooldown = 600, OnPurchased = k.OnPurchased}
			amount = amount + 1
		end

		if amount > 5 then
			break
		end
	end
end

local function fishermanAppear(ent)
	if not IsValid(ent) then
		return
	end

	ent.BeenTriggered = true
	ent.Buys = 0
    
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

	self.TimerID = "TravelerSpawn_" .. self:EntIndex()

	timer.Create(self.TimerID, 1800, 0, function()
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
	if self.TimerID then
		timer.Remove(self.TimerID)
	end
end


impulse.RegisterVendor(VENDOR)