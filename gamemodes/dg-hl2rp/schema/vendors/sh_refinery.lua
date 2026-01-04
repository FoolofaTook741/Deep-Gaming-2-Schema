local VENDOR = {}

VENDOR.UniqueID = "refinery"
VENDOR.Name = "Metal Refinery Transport Overseer"
VENDOR.Desc = "Delivers raw materials and ships out refined metal."
VENDOR.Model = "models/Humans/Group02/male_02.mdl"
VENDOR.Skin = 0
VENDOR.Bodygroups = "0"
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Buy = {}

VENDOR.Sell = {
	["item_rawmetalbox"] = {
		Desc = "2/4 minutes",
		Cost = 60,
		BuyMax = 2,
		TempCooldown = 240,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_REFINERY then
				return true
			else return false end
		end
	},
	["item_crudeoil"] = {
		Desc = "2/4 minutes",
		Cost = 60,
		BuyMax = 2,
		TempCooldown = 240,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_INDUST then
				return true
			else return false end
		end
	}
}

VENDOR.Buy = {
	["util_refinedmetalplate"] = {
		Cost = 20
	},
	["util_metalplate"] = {
		Cost = 10
	},
	["util_pipe"] = {
		Cost = 15
	},
	["util_fuel"] = {
		Cost = 100
	}
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CWU
end

impulse.RegisterVendor(VENDOR)
