local VENDOR = {}

VENDOR.UniqueID = "rebelvendormelee"
VENDOR.Name = "Rebel Vendor Melee [Event Only]"
VENDOR.Desc = "Can supply people with melee weapons."

VENDOR.Model = "models/Humans/Group03/male_09.mdl"
VENDOR.Skin = 3
VENDOR.Bodygroups = "01" -- manhack
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["wep_stiletto"] = {
		Desc = "A small, easily concealed blade.",
		Restricted = true,
		Max = 1,
	},
	["wep_molotov"] = {
		Desc = "A crude incendiary device.",
		Restricted = true,
		Cooldown = 300,
		Max = 1,
	},
	["wep_axe"] = {
		Desc = "A heavy-duty cutting tool.",
		Restricted = true,
		Max = 1,
	},
	["wep_pickaxe"] = {
		Desc = "A tool for breaking rocks and heads.",
		Restricted = true,
		Max = 1,
	},
	["wep_stunstick"] = {
		Desc = "A baton that delivers an electric shock on impact to enemies.",
		Restricted = true,
		Max = 1,
	},
	["wep_rock"] = {
		Desc = "A throwable rock.",
		Restricted = true,
		Max = 1,
	},
	["food_tomato"] = {
		Desc = "CLEARS YOUR INVENTORY",
		Restricted = true,
		Max = 1,
	},
	["meal_pizza"] = {
		Cooldown = 3600,
		Restricted = true,
		Max = 1,
	},
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT
end

function VENDOR:OnItemPurchased(class, ply)
	if class == "food_tomato" then
		ply:ClearInventory(1)
	end
end

impulse.RegisterVendor(VENDOR)