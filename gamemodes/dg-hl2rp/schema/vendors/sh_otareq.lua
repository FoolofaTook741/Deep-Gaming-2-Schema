local VENDOR = {}

VENDOR.UniqueID = "otareq"
VENDOR.Name = "C.T.A. Quartermaster"
VENDOR.Desc = "Supplies soldiers with their equipment."

VENDOR.Model = "models/hlvr/characters/combine_captain_night/combine_captain_night.mdl"
VENDOR.Skin = 1
VENDOR.Sequence = "idle_unarmed"
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["wep_ar2"] = {
		Desc = "ECHO ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS && ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["util_nvgs"] = {
		Restricted = true,
		Max = 1
	},
	--[[
	["util_radio"] = {
		Restricted = true,
		Max = 1,
	},
	--]]
	["wep_omr"] = {
		Desc = "RANGER CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS && ply:GetTeamClass() == CLASS_RANGER then
				return true
			else return false end
		end 
	},
	["wep_osr"] = {
		Desc = "RANGER CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS && ply:GetTeamClass() == CLASS_RANGER then
				return true
			else return false end
		end 
	},
	["wep_ar2r"] = {
		Desc = "RANGER ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS && ply:GetTeamClass() == CLASS_RANGER then
				return true
			else return false end
		end
	},
	["item_armorrepairkit"] = {
		Desc = "CSO+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS then
				return true
			else 
				return false 
			end
		end
	},
	["wep_osiprmk1"] = {
		Desc = "ECHO ORD+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_ORD && ply:GetTeamClass() == CLASS_ECHO) or (ply:GetTeamRank() >= RANK_ORD && ply:GetTeamClass() == CLASS_FIST) then
				return true
			else return false end
		end
	},
	["wep_osips"] = {
		Desc = "ECHO Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false end
		end
	},
	["wep_osisg"] = {
		Desc = "MACE Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false end
		end
	},
	["wep_mp5sd"] = {
		Desc = "ECHO CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO and ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false
			end
		end
	},
	["att_holosight"] = {
		Desc = "ECHO CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO and ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false
			end
		end
	},
	["att_huntersight"] = {
		Desc = "ECHO CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_ECHO and ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false
			end
		end
	},
	["wep_m500"] = {
		Desc = "MACE CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE && ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false end
		end
	},
	["wep_shotgun"] = {
		Desc = "MACE CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE && ply:GetTeamRank() >= RANK_OWS then
				return true
			else return false end
		end
	},
	["wep_mp7"] = {
		Desc = "ECHO CSO+/NOMAD CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_ECHO && ply:GetTeamRank() >= RANK_OWS) or (ply:GetTeamClass() == CLASS_NOMAD and ply:GetTeamRank() >= RANK_OCP) then
				return true
			else return false end
		end
	},
	["item_breachingcharge"] = {
		Restricted = true,
		Max = 5,
	},
	["item_ziptie"] = {
		Restricted = true,
		Max = 2,
	},
	["wep_ar2e"] = {
		Desc = "FIST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false end
		end
	},


	--[[["wep_ar2orb"] = {
		Desc = "FIST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false end
		end
	},
	["wep_ar1orb"] = {
		Desc = "ETL Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST && ply:GetTeamRank() >= RANK_ORD then
				return true
			else return false end
		end
	},--]]


	--[[
	["ammo_darkenergy"] = {
		Desc = "FIST Only",
		Restricted = true,
		BuyMax = 2,
		Max = 2,
		Cooldown = 600,
		CooldownOnMax = true,
		CanBuy = function(ply)
			if ply:GetTeamClass() ~= CLASS_FIST then
				return false
			end
			
			local currentAmmo = ply:GetAmmoCount("ar2altfire")
			if currentAmmo >= 2 then
				return false
			end

			return true
		end
	},
	]]--
	["item_mine"] = {
		Desc = "NOMAD",
		Restricted = true,
		Max = 1,
		Cooldown = 1200,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_NOMAD then
				return true
			else return false end
		end
	},
	["wep_sledgehammer"] = {
		Desc = "MACE ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE and ply:GetTeamRank() >= RANK_EOS then
				return true
			else return false
			end
		end
	},
	["item_autoturret"] = {
		Desc = "ECHO CTL+/NOMAD",
		Restricted = true,
		Max = 1,
		Cooldown = 1200,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OSL && ply:GetTeamClass() == CLASS_ECHO) or ply:GetTeamClass() == CLASS_NOMAD then
				return true
			else return false end
		end
	},
	["item_ammocrate"] = {
		Desc = "APF ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS && ply:GetTeamClass() == CLASS_APF then
				return true
			else return false end
		end
	},
	["wep_ar3"] = {
		Desc = "APF CCP+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OCP && ply:GetTeamClass() == CLASS_APF then
				return true
			else return false end
		end
	},
	["wep_apf"] = {
		Desc = "APF ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS && ply:GetTeamClass() == CLASS_APF then
				return true
			else return false end
		end
	},
	["item_healthvial"] = {
		Restricted = true,
		Max = 4
	},
	["wep_incendiary"] = {
		Desc = "CTL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL then
				return true
			else return false
			end
		end
	},
	["item_manhack"] = {
		Desc = "PAYBACK/ECHO ORD+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_ORD and ply:GetTeamClass() == CLASS_ECHO) or ply:GetTeamClass() == CLASS_PAYBACK then
				return true
			else return false
			end
		end
	},
	["att_assault_shield"] = {
		Desc = "PAYBACK Only [Testing]",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_PAYBACK then
				return true
			else return false
			end
		end
	},
	["item_grenade"] = {
		Desc = "ECHO ORD+/FIST/MACE ECS+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_ORD and ply:GetTeamClass() == CLASS_ECHO) or (ply:GetTeamRank() >= RANK_EOS and ply:GetTeamClass() == CLASS_MACE) or ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["wep_rsmoke"] = {
		Desc = "SWEEPER",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() >= CLASS_APF) then
				return true
			else return false
			end
		end
	},
	["item_slam"] = {
		Desc = "MACE ECS+ & Research Project",
		Restricted = true,
		Max = 1,
		Cooldown = 1200,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_MACE and ply:GetTeamRank() >= RANK_ECS and RES_SLAMS) then
				return true
			else
				return false
			end
		end
	},
	["item_enhancedvial"] = {
		Desc = "Requires O.C.A.A.B. Treasury Purchase",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if OCAAB_HEALTHVIALS_UPGRADE then
				return true
			else 
				return false
			end
		end
	},
	["wep_incendiaryb"] = {
		Desc = "Requires O.C.A.A.B. Treasury Purchase",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if OCAAB_INCENDIARY_UPGRADE then
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
		Desc = "MACE ORD+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_ORD and ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false
			end
		end
	},
	["att_slugrounds"] = {
		Desc = "MACE ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_EOS and ply:GetTeamClass() == CLASS_MACE then
				return true
			else return false
			end
		end
	},
	["att_reflex"] = {
		Desc = "ECHO CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS and ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false
			end
		end
	},
	["att_cmore"] = {
		Desc = "ECHO CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWS and ply:GetTeamClass() == CLASS_ECHO then
				return true
			else return false
			end
		end
	},
	["att_optic"] = {
		Desc = "ECHO ECS+/FIST",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_EOS and ply:GetTeamClass() == CLASS_ECHO) or ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["grenade_flashbang"] = {
		Desc = "CCP+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OCP then
				return true
			else return false
			end
		end
	},
	["wep_rsmoke"] = {
		Desc = "CTL+ or FIST",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL or ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["wep_psmoke"] = {
		Desc = "NOMAD Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_NOMAD then
				return true
			else return false
			end
		end
	},
	["wep_m320"] = {
		Desc = "MACE CTL+ & JW+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OSL && ply:GetTeamClass() == CLASS_MACE) && impulse.Dispatch.GetCityCode() >= CODE_AJ then
				return true
			else return false
			end
		end
	},
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_OTA and ply:GetTeamClass() != nil
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
	if class == "wep_ar3" and ply:HasInventoryItem("wep_apf") then
		ply:TakeInventoryItemClass("wep_apf")
	end
	if class == "wep_apf" and ply:HasInventoryItem("wep_ar3") then
		ply:TakeInventoryItemClass("wep_ar3")
	end
	if class == "wep_omr" and (ply:HasInventoryItem("wep_osr") or ply:HasInventoryItem("wep_ar2r")) then
		ply:TakeInventoryItemClass("wep_ar2r")
		ply:TakeInventoryItemClass("wep_osr")
	end
	if class == "wep_osr" and (ply:HasInventoryItem("wep_omr") or ply:HasInventoryItem("wep_ar2r")) then
		ply:TakeInventoryItemClass("wep_omr")
		ply:TakeInventoryItemClass("wep_ar2r")
	end
	if class == "wep_ar2r" and (ply:HasInventoryItem("wep_osr") or ply:HasInventoryItem("wep_omr")) then
		ply:TakeInventoryItemClass("wep_osr")
		ply:TakeInventoryItemClass("wep_omr")
	end
	if class == "wep_osiprmk1" and (ply:HasInventoryItem("wep_ar2e")) then
		ply:TakeInventoryItemClass("wep_ar2e")
	end
	if class == "wep_ar2e" and (ply:HasInventoryItem("wep_osiprmk1")) then
		ply:TakeInventoryItemClass("wep_osiprmk1")
	end
	if class == "wep_ar2orb" and (ply:HasInventoryItem("wep_ar1orb")) then
		ply:TakeInventoryItemClass("wep_ar1orb")
	end
	if class == "wep_ar1orb" and (ply:HasInventoryItem("wep_ar2orb")) then
		ply:TakeInventoryItemClass("wep_ar2orb")
	end
end

impulse.RegisterVendor(VENDOR)
