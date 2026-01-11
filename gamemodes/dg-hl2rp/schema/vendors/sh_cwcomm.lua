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
		Restricted = true,
		TempCooldown = 300
	},
    ["food_banana"] = {
		Cost = 10,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["food_orange"] = {
		Cost = 10,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["food_pineapple"] = {
		Cost = 25,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_cookingoil"] = {
		Cost = 15,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_meat"] = {
		Cost = 25,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_yeast"] = {
		Cost = 40,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["ing_sugar"] = {
		Cost = 15,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_chicken"] = {
		Cost = 30,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_salt"] = {
		Cost = 15,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["ing_grapes"] = {
		Cost = 15,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["util_coffeegrounds"] = {
		Cost = 20,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["food_carrot"] = {
		Cost = 10,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["food_tomato"] = {
		Cost = 15,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
	["ing_milk"] = {
		Cost = 20,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
    ["food_waterspecial"] = {
		Cost = 20,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
	["food_water"] = {
		Cost = 10,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	},
	["util_potato"] = {
		Cost = 10,
		BuyMax = 20,
		Restricted = true,
		TempCooldown = 300
	}
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
