local VENDOR = {}

VENDOR.UniqueID = "otareq"
VENDOR.Name = "C.T.A. Quartermaster"
VENDOR.Desc = "Supplies soldiers with their equipment."

VENDOR.Model = "models/dg_models/dg_combinepack/dg_soldier/dg_combine_soldier.mdl"
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
		--Desc = "CGR+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OWG then
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
	["wep_osiprmk1c"] = {
		Desc = "CSC Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() > RANK_ORD) then
				return true
			else return false end
		end
	},
	["wep_osips"] = {
		Desc = "ECHO & NOMAD ECS+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_ECHO) or (ply:GetTeamClass() == CLASS_NOMAD and ply:GetTeamRank() >= RANK_EOS) then
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
	["wep_mp510"] = {
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
	--[[
	["wep_ar2e"] = {
		Desc = "FIST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false end
		end
	}, ]]--
	["item_broadcastkey"] = {
		Desc = "A key for the broadcast terminal, do not lose this.",
		Cost = 0,
		BuyMax = 1,
		TempCooldown = 600,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_ORD) then
				return true
			else return false
			end
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
		Desc = "MACE CSO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_MACE and ply:GetTeamRank() >= RANK_OWS then
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
	}, --[[
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
	}, ]]--
	["item_grenade"] = {
		Desc = "ECHO & Mace ECS+/FIST",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_EOS and ply:GetTeamClass() == CLASS_ECHO) or (ply:GetTeamRank() >= RANK_EOS and ply:GetTeamClass() == CLASS_MACE) or ply:GetTeamClass() == CLASS_FIST then
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
	--[[
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
	["att_extendedmag"] = {
		Desc = "FIST",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	},
	["att_optic"] = {
		Desc = "FIST",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_FIST then
				return true
			else return false
			end
		end
	}, ]]--
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
		Desc = "CTL+/FIST/APF",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_OSL or ply:GetTeamClass() == CLASS_FIST or ply:GetTeamClass() == CLASS_APF then
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
	["item_otastimshot"] = {
		Desc = "ECS & CCP",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_EOS && ply:GetTeamRank() < RANK_OSL) then
				return true
			else return false
			end
		end
	},
	["item_otastimshotctl"] = {
		Desc = "CTL+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OSL) then
				return true
			else return false
			end
		end
	}, --[[
	["wep_gausspistol"] = {
		Desc = "Collaborator (VIP+)",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:IsCollaborator() then
				return true
			else return false
			end
		end
	}, ]]--
	["item_enhancedvial"] = {
		Desc = "Ordinal+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_ORD) then
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

function VENDOR.OnItemPurchased(class, itemclass, ply) --Update the item removals here: gamemodes\dg-hl2rp\schema\scripts\sh_functions.lua **bottom of the file**
	itemType = meta.getItemType(itemclass)
	if itemType ~= nil then
		for i, val in ipairs(itemType) do
			ply:TakeInventoryItemClass(val)
		end
	end
end

impulse.RegisterVendor(VENDOR)