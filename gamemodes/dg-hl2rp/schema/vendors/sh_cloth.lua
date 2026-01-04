local VENDOR = {}


VENDOR.UniqueID = "cloth"
VENDOR.Name = "Clothing Dispensary"
VENDOR.Desc = "Purchase cloth to make clothing."
VENDOR.DownloadTrades = true
VENDOR.Model = "models/Humans/Group02/Female_07.mdl"
VENDOR.Skin = 0
VENDOR.Bodygroups = "0"
VENDOR.Gender = "female" -- male, female, cp
VENDOR.Talk = true

VENDOR.Buy = {}

VENDOR.Sell = {
	["util_cloth"] = {
		Desc = "20/10 minutes!",
		BuyMax = 20,
		Cost = 50,
		TempCooldown = 600
	}
}

function VENDOR:CanUse(ply)
	return ((ply:Team() == TEAM_CWU) or (ply:Team() == TEAM_CITIZEN))
end

impulse.RegisterVendor(VENDOR)
