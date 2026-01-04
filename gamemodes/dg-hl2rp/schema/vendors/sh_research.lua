local VENDOR = {}

VENDOR.UniqueID = "research"
VENDOR.Name = "Research Supply Depot Operator"
VENDOR.Desc = "Gives special equipment to researchers."
VENDOR.Model = "models/Humans/Group02/male_08.mdl"
VENDOR.Skin = 0
VENDOR.Bodygroups = "0"
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Buy = {}

VENDOR.Sell = {
	["research_solution"] = {
		Cost = 100,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_RESEARCH then
				return true
			else return false end
		end
	},
	["research_samplekit"] = {
		Cost = 200,
		BuyMax = 1,
		TempCooldown = 600,
        Restricted = true,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_RESEARCH then
				return true
			else return false end
		end
	}
}

VENDOR.Buy = {
	["research_xensample"] = {
		Cost = 95
	},
	["research_antlionsample"] = {
		Cost = 210
	},
	["research_xencreaturesample"] = {
		Cost = 230
	},
}

function VENDOR:CanUse(ply)
	if (ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT) then
		return true
	end
end

impulse.RegisterVendor(VENDOR)
