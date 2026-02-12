local VENDOR = {}

VENDOR.UniqueID = "ajotareq"
VENDOR.Name = "Emergency Supplies Quartermaster [C.T.A.]"
VENDOR.Desc = "Distributes emergency equipment in the event of Autonomous Judgment."

VENDOR.Model = "models/wn/ordinal.mdl"
VENDOR.Skin = 1
VENDOR.Sequence = "idle_unarmed"
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["wep_ar2"] = {
		Desc = "ECHO CSO+",
		Restricted = true,
		ItemType = "primaryWeapon",
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
		ItemType = "primaryWeapon",
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL && ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["wep_ar15"] = {
		Desc = "ECHO ECS+",
		Restricted = true,
		ItemType = "primaryWeapon",
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO and ply:GetTeamRank() >= RANK_EOS then
				return true
			else return false
			end
		end
	},
	["wep_m500"] = {
		Desc = "MACE ECS+",
		Restricted = true,
		ItemType = "primaryWeapon",
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
		ItemType = "primaryWeapon",
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
		ItemType = "primaryWeapon",
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
		ItemType = "weaponAttachments",
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
		ItemType = "weaponAttachments",
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
		ItemType = "weaponOptics",
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
		ItemType = "weaponOptics",
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
		ItemType = "weaponOptics",
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
		ItemType = "primaryWeapon",
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

function VENDOR.OnItemPurchased(class, itemclass, ply)
end

impulse.RegisterVendor(VENDOR)
