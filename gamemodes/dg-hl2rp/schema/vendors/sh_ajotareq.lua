local VENDOR = {}

VENDOR.UniqueID = "ajotareq"
VENDOR.Name = "Emergency Supplies Quartermaster [C.T.A.]"
VENDOR.Desc = "Distributes emergency equipment in the event of Autonomous Judgment."

VENDOR.Model = "models/dg_models/dg_combinepack/dg_ordinal/dg_combine_ordinal.mdl"
VENDOR.Skin = 1
VENDOR.Sequence = "idle_unarmed"
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["wep_ar2"] = {
		Desc = "ECHO CSo+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS && ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["item_armorrepairkit"] = {
		Restricted = true,
		Max = 2,
	},
	["wep_osiprmk1"] = {
		Desc = "ECHO CTL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL && ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["wep_m500"] = {
		Desc = "MACE ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE && ply:GetTeamRank() >= RANK_EOS then
				return true
			else return false end
		end
	},
	["wep_shotgun"] = {
		Desc = "MACE",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false end
		end
	},
	["wep_mp7"] = {
		Desc = "ECHO",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["item_mine"] = {
		Desc = "MACE ECS+",
		Restricted = true,
		Max = 1,
		Cooldown = 1200,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS && ply:GetTeamClass() == CLASS_MACE && impulse.Dispatch.GetCityCode() >= CODE_UNREST then
				return true
			else return false end
		end
	},
	["item_ammocrate"] = {
		Desc = "APF CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS && ply:GetTeamClass() == CLASS_APF then
				return true
			else return false end
		end
	},
	["wep_incendiary"] = {
		Desc = "CTL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false
			end
		end
	},
	["item_manhack"] = {
		Desc = "ECHO CTL+/PAYBACK",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OSL and ply:GetTeamClass() == CLASS_ECHO) or ply:GetTeamClass() == CLASS_PAYBACK then
				return true
			else return false
			end
		end
	},
	["item_grenade"] = {
		Desc = "ECHO CTL+/FIST/MACE CSO+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OSL and ply:GetTeamClass() == CLASS_ECHO) or (ply:GetTeamRank() >= RANK_OWS and ply:GetTeamClass() == CLASS_MACE) or ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["item_crimescenekit"] = {
		Restricted = true,
		Max = 1	
	},
	["att_dragonsbreath"] = {
		Desc = "MACE CTL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL and ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false
			end
		end
	},
	["att_slugrounds"] = {
		Desc = "MACE CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS and ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false
			end
		end
	},
	["att_reflex"] = {
		Desc = "ECHO",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false
			end
		end
	},
	["att_cmore"] = {
		Desc = "ECHO",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false
			end
		end
	},
	["att_optic"] = {
		Desc = "ECHO",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OWS and ply:GetTeamClass() == CLASS_ECHO) or ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["grenade_flashbang"] = {
		Desc = "ECS+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS then
				return true
			else return false
			end
		end
	},
	["wep_ar3"] = {
		Desc = "APF ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_ECS && ply:GetTeamClass() == CLASS_APF then
				return true
			else return false end
		end
	},
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_OTA and ply:GetTeamClass() != nil and (impulse.Dispatch.GetCityCode() >= CODE_AJ or (impulse.Dispatch.GetCityCode() >= CODE_AJ or RES_MASSPRODUCTION == true))
end

function VENDOR.OnItemPurchased(class, itemclass, ply) --Update the item removals here: gamemodes\dg-hl2rp\schema\scripts\sh_functions.lua **bottom of the file**
	itemType = meta.getItemType(itemclass)
	if itemType ~= nil then
		for i, val in ipairs(itemType) do
			ply:TakeInventoryItemClass(val)
		end
	end
end

impulse.RegisterVendor(VENDOR)
