local VENDOR = {}

VENDOR.UniqueID = "heavyrebelvendor"
VENDOR.Name = "High Grade Rebel Vendor [Event Only]"
VENDOR.Desc = "Can supply Rebels, Vortigaunts, and Rebel Medics with high grade equipment."

VENDOR.Model = "models/Humans/Group03/male_07.mdl"
VENDOR.Skin = 3
VENDOR.Bodygroups = "01" -- manhack
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["att_optic"] = {
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
	["wep_357"] = {
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
	["wep_ak47"] = {
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
	["wep_bar"] = {
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
	["wep_db"] = {
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
	["wep_ptrs41"] = {
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
	["wep_m4a1"] = {
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
	["wep_m60"] = {
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
	["wep_pm63"] = {
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
	["wep_mini14"] = {
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
	["wep_ppsh41"] = {
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
	["wep_scarh"] = {
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
	["wep_rsass"] = {
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
	["wep_famas"] = {
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
	["wep_ar2"] = {
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
	["wep_ar2e_eq"] = {
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
	["wep_apf_eq"] = {
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
	["wep_osiprmk1_eq"] = {
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
	["wep_ar3_eq"] = {
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
	["wep_mosin"] = {
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
	["wep_mp7a8"] = {
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
	["wep_tt"] = {
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
	["item_morphine"] = {
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
	["item_stimshot"] = {
		Desc = "CWU Only",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CWU then
				return true
			end

			return false
		end
	},
	["item_grenade"] = {
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
    ["cos_otavest"] = {
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
	["cos_otavest2"] = {
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
	["item_emp"] = {
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
    ["cos_parahelmet"] = {
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
    ["cos_combatgasmask"] = {
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
    ["item_enrichedvortessence"] = {
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
	["att_foregrip"] = {
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
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
	if class == "wep_357" and (ply:HasInventoryItem("wep_tt")) then
		ply:TakeInventoryItemClass("wep_tt")
	end
	if class == "wep_tt" and (ply:HasInventoryItem("wep_357")) then
		ply:TakeInventoryItemClass("wep_357")
	end
	if class == "wep_mp7" and (ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
        ply:TakeInventoryItemClass("wep_kar98k")
		ply:TakeInventoryItemClass("wep_m4a1")
		ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_ak47" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_kar98k")
		ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_bar" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
		ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_kar98k")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_db" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_kar98k")
		ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_m4a1" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_kar98k")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_shotgun" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_kar98k")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_m60" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_kar98k")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_pm63" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_kar98k")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
    if class == "wep_ppsh41" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
        ply:TakeInventoryItemClass("wep_kar98k")
	end
    if class == "wep_scarl" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_trenchgun") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_trenchgun")
        ply:TakeInventoryItemClass("wep_kar98k")
	end
    if class == "wep_trenchgun" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_kar98k") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_kar98k")
	end
    if class == "wep_kar98k" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_ak47") or ply:HasInventoryItem("wep_bar") or ply:HasInventoryItem("wep_db") or ply:HasInventoryItem("wep_m4a1") or ply:HasInventoryItem("wep_m60") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_ppsh41") or ply:HasInventoryItem("wep_scarl") or ply:HasInventoryItem("wep_trenchgun") ) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ak47")
		ply:TakeInventoryItemClass("wep_bar")
		ply:TakeInventoryItemClass("wep_db")
		ply:TakeInventoryItemClass("wep_m4a1")
        ply:TakeInventoryItemClass("wep_shotgun")
        ply:TakeInventoryItemClass("wep_m60")
        ply:TakeInventoryItemClass("wep_pm63")
        ply:TakeInventoryItemClass("wep_ppsh41")
        ply:TakeInventoryItemClass("wep_scarl")
        ply:TakeInventoryItemClass("wep_trenchgun")
	end
	if class == "cos_otavest3" and (ply:HasInventoryItem("cos_lightvest") or ply:HasInventoryItem("cos_otavest3") or ply:HasInventoryItem("cos_otavest2")) then
		ply:TakeInventoryItemClass("cos_lightvest")
		ply:TakeInventoryItemClass("cos_otavest2")
		ply:TakeInventoryItemClass("cos_otavest")
	end
	if class == "cos_lightvest" and (ply:HasInventoryItem("cos_otavest3") or ply:HasInventoryItem("cos_otavest2") or ply:HasInventoryItem("cos_otavest")) then
		ply:TakeInventoryItemClass("cos_otavest3")
		ply:TakeInventoryItemClass("cos_otavest2")
		ply:TakeInventoryItemClass("cos_otavest")
	end
	if class == "cos_otavest2" and (ply:HasInventoryItem("cos_otavest3") or ply:HasInventoryItem("cos_lightvest") or ply:HasInventoryItem("cos_otavest")) then
		ply:TakeInventoryItemClass("cos_otavest3")
		ply:TakeInventoryItemClass("cos_lightvest")
		ply:TakeInventoryItemClass("cos_otavest")
	end
	if class == "cos_otavest" and (ply:HasInventoryItem("cos_otavest3") or ply:HasInventoryItem("cos_lightvest") or ply:HasInventoryItem("cos_otavest2")) then
		ply:TakeInventoryItemClass("cos_otavest3")
		ply:TakeInventoryItemClass("cos_lightvest")
		ply:TakeInventoryItemClass("cos_otavest2")
	end
	if class == "food_tomato" then
		ply:ClearInventory(1)
	end
end

impulse.RegisterVendor(VENDOR)