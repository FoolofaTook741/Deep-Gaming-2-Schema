local VENDOR = {}

VENDOR.UniqueID = "cwcomm"
VENDOR.Name = "Civic Workforce Commercial Vendor"
VENDOR.Desc = "Can purchase various supplies to run a shop."

VENDOR.Model = "models/Humans/Group02/male_08.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = false

VENDOR.Sell = {
	["food_apple"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_banana"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_orange"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_pineapple"] = {
		Cost = 25,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_cookingoil"] = {
		Cost = 15,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_meat"] = {
		Cost = 25,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_yeast"] = {
		Cost = 40,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["ing_sugar"] = {
		Cost = 15,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_chicken"] = {
		Cost = 30,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_salt"] = {
		Cost = 15,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["ing_grapes"] = {
		Cost = 15,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["util_coffeegrounds"] = {
		Cost = 20,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_carrot"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_tomato"] = {
		Cost = 15,
		BuyMax = 20,
		TempCooldown = 300
	},
	["ing_milk"] = {
		Cost = 20,
		BuyMax = 20,
		TempCooldown = 300
	},
    ["food_waterspecial"] = {
		Cost = 20,
		BuyMax = 20,
		TempCooldown = 300
	},
	["food_water"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
	["util_potato"] = {
		Cost = 10,
		BuyMax = 20,
		TempCooldown = 300
	},
	["item_homerefinerypermit"] = {
		Desc = "Minister Permits",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_constructionpermit"] = {
		Desc = "Minister Permits",
		Cost = 15,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_metalpermit"] = {
		Desc = "Minister Permits",
		Cost = 20,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_outdoorspermit"] = {
		Desc = "Minister Permits",
		Cost = 15,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
    ["item_workbenchpermit"] = {
		Desc = "Minister Permits",
		Cost = 45,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_miningpermit"] = {
		Desc = "Minister Permits",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_lumberjackpermit"] = {
		Desc = "Minister Permits",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_cleaverpermit"] = {
		Desc = "Minister Permits",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_alcoholpermit"] = {
		Desc = "Minister Permits",
		Cost = 20,
		BuyMax = 2,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["item_generatorpermit"] = {
		Desc = "Minister Permits",
		Cost = 40,
		BuyMax = 3,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["toolbox_axe"] = {
		Desc = "Minister Permits",
		Cost = 30,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["toolbox_pickaxe"] = {
		Desc = "Minister Permits",
		Cost = 30,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
	["book_german"] = {
		Desc = "Minister Permits",
		Cost = 3000,
		BuyMax = 1,
		TempCooldown = 3600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_MINISTER && ply:GetTeamClass() == CLASS_COMMERCE then
				return true
			else return false
			end
		end
	},
}

VENDOR.Buy = {
	["food_wine"] = {
		Cost = 100 -- half of the moonshine amount
	},
}

function VENDOR:CanUse(ply)
    return (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) and (ply:GetTeamClass() == CLASS_COMMERCE or ply:GetTeamClass() == CLASS_RESEARCH)
end

impulse.RegisterVendor(VENDOR)
