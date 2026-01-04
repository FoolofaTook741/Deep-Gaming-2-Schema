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
	["wep_mp5sd"] = {
		Desc = "ECHO ECS+",
		Restricted = true,
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

function VENDOR:OnItemPurchased(class, ply)
	if class == "wep_mp7" and (ply:HasInventoryItem("wep_ar2") or ply:HasInventoryItem("wep_osips") or ply:HasInventoryItem("wep_mp5sd")) then
		ply:TakeInventoryItemClass("wep_ar2")
		ply:TakeInventoryItemClass("wep_osips")
		ply:TakeInventoryItemClass("wep_mp5sd")
	end
	if class == "wep_ar2" and (ply:HasInventoryItem("wep_osips") or ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_mp5sd")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_osips")
		ply:TakeInventoryItemClass("wep_mp5sd")
	end
	if class == "wep_osips" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_ar2") or ply:HasInventoryItem("wep_mp5sd")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ar2")
		ply:TakeInventoryItemClass("wep_mp5sd")
	end 
	if class == "att_reflex" and (ply:HasInventoryItem("att_cmore") or ply:HasInventoryItem("att_reddot") or ply:HasInventoryItem("att_holosight")) then
		ply:TakeInventoryItemClass("att_cmore")
		ply:TakeInventoryItemClass("att_reddot")
		ply:TakeInventoryItemClass("att_holosight")
	end
	if class == "att_cmore" and (ply:HasInventoryItem("att_reflex") or ply:HasInventoryItem("att_reddot") or ply:HasInventoryItem("att_holosight")) then
		ply:TakeInventoryItemClass("att_reflex")
		ply:TakeInventoryItemClass("att_reddot")
		ply:TakeInventoryItemClass("att_holosight")
	end
	if class == "wep_mp5sd" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_ar2") or ply:HasInventoryItem("wep_osips")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_ar2")
		ply:TakeInventoryItemClass("wep_osips")
	end
	if class == "wep_shotgun" and (ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_shotgun" and (ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "att_slugrounds" and (ply:HasInventoryItem("att_dragonsbreath")) then
		ply:TakeInventoryItemClass("att_dragonsbreath")
	end
	if class == "att_dragonsbreath" and (ply:HasInventoryItem("att_slugrounds")) then
		ply:TakeInventoryItemClass("att_slugrounds")
	end
	if class == "wep_m500" and (ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_osisg"))  then
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_osisg")
	end
	if class == "wep_osr" and ply:HasInventoryItem("wep_omr") then
		ply:TakeInventoryItemClass("wep_omr")
	end
	if class == "wep_omr" and ply:HasInventoryItem("wep_osr") then
		ply:TakeInventoryItemClass("wep_osr")
	end
	if class == "wep_apf" and ply:HasInventoryItem("wep_ar3") then
		ply:TakeInventoryItemClass("wep_ar3")
	end
	if class == "wep_ar3" and ply:HasInventoryItem("wep_apf") then
		ply:TakeInventoryItemClass("wep_apf")
	end
end

impulse.RegisterVendor(VENDOR)
