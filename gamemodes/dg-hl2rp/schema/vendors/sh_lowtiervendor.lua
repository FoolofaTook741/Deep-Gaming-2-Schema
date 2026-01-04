local VENDOR = {}

VENDOR.UniqueID = "lowrebelvendor"
VENDOR.Name = "Broke Rebel Vendor [Event Only]"
VENDOR.Desc = "Can supply Rebels, Vortigaunts, and Rebel Medics with low tier equipment."

VENDOR.Model = "models/Humans/Group03/male_09.mdl"
VENDOR.Skin = 3
VENDOR.Bodygroups = "01" -- manhack
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["wep_pistol"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["wep_mp7"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["item_splint"] = {
		Desc = "CWU Only",
		Restricted = true,
		Max = 3,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["wep_shotgun"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["wep_mp7"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["item_stimshot"] = {
		Desc = "CWU Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["item_healthkit"] = {
		Desc = "CWU Only",
		Restricted = true,
		Max = 5,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
    ["cos_constructionhelmet"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
    ["cos_lightvest"] = {
		Desc = "CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
    ["item_lockpick"] = {
		Desc = "Vort/CWU/Citizen Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
				return true
			end

			return false
		end
	},
	["wep_molotov"] = {
		Desc = "Citizen/CWU Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
    ["item_vortessence"] = {
		Desc = "Vort Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_VORT then
				return true
			end

			return false
		end
	},
    ["cos_vortarmor"] = {
		Desc = "Vort Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_VORT then
				return true
			end

			return false
		end
	},
	["food_tomato"] = {
		Desc = "CLEARS YOUR INVENTORY",
		Restricted = true,
		Max = 1,
	},
	["food_bread"] = {
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

	if class == "wep_shotgun" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_usp") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
	end

	if class == "wep_usp" and (ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
	end

	if class == "wep_mp7" and (ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_usp") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
	end


	if class == "food_tomato" then
		ply:ClearInventory(1)
	end
end

impulse.RegisterVendor(VENDOR)