local VENDOR = {}

VENDOR.UniqueID = "halloweendealer"
VENDOR.Name = "Numbskull"
VENDOR.Desc = "A trader from the grave who sells spooky goods."

VENDOR.Model = "models/player/skeleton.mdl"
VENDOR.Skin = 1
VENDOR.Gender = "zombie" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["cos_hal_zombie"] = {
		Desc = "Seasonal",
		Cost = 500
	},
	["cos_hal_skull"] = {
		Desc = "Seasonal",
		Cost = 500
	},
	["cos_hal_monkey"] = {
		Desc = "Seasonal",
		Cost = 500
	},
	["cos_hal_bag"] = {
		Desc = "Seasonal",
		Cost = 500
	}
}

VENDOR.Buy = {
	["cos_hal_zombie"] = {
		Cost = 400
	},
	["cos_hal_skull"] = {
		Cost = 400
	},
	["cos_hal_monkey"] = {
		Cost = 400
	},
	["cos_hal_bag"] = {
		Cost = 400
	}
}

function VENDOR:OnItemPurchased(class, ply)
end

impulse.RegisterVendor(VENDOR)
