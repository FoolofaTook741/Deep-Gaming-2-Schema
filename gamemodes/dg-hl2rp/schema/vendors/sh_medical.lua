local VENDOR = {}

GL_MED_DISC = 1

VENDOR.UniqueID = "medical"
VENDOR.Name = "Medical Supplier"
VENDOR.Desc = "Can sell medical supplies to the members of the C.M.U."

VENDOR.Model = "models/Humans/Group03m/Female_02.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "female" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["item_healthkit"] = {
		Cost = math.floor(45 * GL_MED_DISC),
		BuyMax = 4,
		Restricted = true,
		TempCooldown = 300
	},
	["item_morphine"] = {
		Cost = math.floor(85 * GL_MED_DISC),
		BuyMax = 2,
		Restricted = true,
		TempCooldown = 300
	},
	["item_stimshot"] = {
		Cost = math.floor(60 * GL_MED_DISC),
		BuyMax = 2,
		Restricted = true,
		TempCooldown = 300
	},
	["item_splint"] = {
		Cost = math.floor(25 * GL_MED_DISC),
		BuyMax = 4,
		Restricted = true,
		TempCooldown = 300
	},
	["item_doxepin"] = {
		Cost = math.floor(35 * GL_MED_DISC),
		BuyMax = 2,
		Restricted = true,
		TempCooldown = 300
	},
	["util_medicalsupplies"] = {
		Cost = math.floor(80 * GL_MED_DISC),
		Restricted = false,
	},
}

VENDOR.Buy = {
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CWU && ply:GetTeamClass() == CLASS_MEDIC
end

impulse.RegisterVendor(VENDOR)
