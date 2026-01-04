local VENDOR = {}

VENDOR.UniqueID = "ajcpreq"
VENDOR.Name = "Civil Protection Emergency Equipment Vendor"
VENDOR.Desc = "Can supply CPs with special equipment during Judgement Waiver."

VENDOR.Model = "models/wn7new/metropolice/male_0" .. math.random(1,6).. ".mdl"
VENDOR.Skin = 3
VENDOR.Bodygroups = "01" -- manhack
VENDOR.Gender = "cp" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["item_ziptie"] = {
		Restricted = true,
		Max = 6
	},
	["wep_stunstick"] = {
		Restricted = true,
		Max = 1
	},
	["item_breachingcharge"] = {
		Desc = "UNION/GHOST",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_UNION or ply:GetTeamClass() == CLASS_GHOST then
				return true
			end

			return false
		end
	},
	["wep_medkit"] = {
		Desc = "HELIX Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_HELIX then
				return true
			end

			return false
		end
	},
	["wep_wsmoke"] = {
		Desc = "SWORD Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD then
				return true
			end

			return false
		end
	},
	["wep_ysmoke"] = {
		Desc = "GRID Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID then
				return true
			end

			return false
		end
	},
	["item_splint"] = {
		Desc = "HELIX Only",
		Restricted = true,
		Max = 6,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_HELIX then
				return true
			end

			return false
		end
	},
	["item_healthkit"] = {
		Desc = "HELIX i3+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_HELIX && ply:GetTeamRank() >= RANK_I3 then
				return true
			end

			return false
		end
	},
	["wep_357"] = {
		Desc = "DvL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DVL then
				return true
			else return false
			end
		end
	},
	["wep_sw500"] = {
		Desc = "DcO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DCO then
				return true
			else return false
			end
		end
	},
	["wep_incendiary"] = {
		Desc = "GRID i1+/SWORD",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_I1 and ply:GetTeamClass() == CLASS_GRID) or ply:GetTeamClass() == CLASS_SWORD then
				return true
			else return false
			end
		end
	},
	["wep_teargas"] = {
		Desc = "GRID i3+",
		Restricted = true,
		Max = 3,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 and ply:GetTeamClass() == CLASS_GRID then
				return true
			else return false
			end
		end
	},
	["wep_shotgun"] = {
		Desc = "SWORD i2+/UNION i1+/SqL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			local teamClass = ply:GetTeamClass()
			local teamRank = ply:GetTeamRank()
			if (teamClass == CLASS_SWORD and teamRank >= RANK_I2) or (teamClass == CLASS_UNION and teamRank >= RANK_I1) or (teamRank >= RANK_SQL) then
				return true
			else
				return false
			end
		end
	},
	["att_slugrounds"] = {
		Desc = "UNION i1+/SqL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_I1 and ply:GetTeamClass() == CLASS_UNION) or (ply:GetTeamRank() >= RANK_SQL && ply:GetTeamClass() != CLASS_SWORD) then
				return true
			else return false
			end
		end
	},
	["wep_osisg"] = {
		Desc = "i1+/UNION i2+",
		Restricted = true, 
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I1 or (ply:GetTeamRank() == RANK_I2 and ply:GetTeamClass() == CLASS_UNION) then
				return true
			else return false
			end
		end
	},
	["wep_mp7"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() == RANK_I3 then
				return true
			else return false
			end
		end
	},
	["item_lockpick"] = {
		Desc = "GHOST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST then
				return true
			else return false
			end
		end
	},
	["wep_mp5sd"] = {
		Desc = "GHOST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST then
				return true
			else return false
			end
		end
	},
	["wep_pm63"] = {
		Desc = "UNION i4+/i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_UNION && ply:GetTeamRank() >= RANK_I4) or ply:GetTeamRank() >= RANK_I3 then
				return true
			else return false
			end
		end
	},
	["item_camerarepairkit"] = {
		Desc = "GRID only",
		Restricted = true,
		Max = 4,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID then
				return true
			else return false
			end
		end
	},
	["item_healthvial"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 3,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 then
				return true
			else return false
			end
		end
	},
	["item_enhancedvial"] = {
		Desc = "JW+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if impulse.Dispatch.GetCityCode() >= CODE_AJ then
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
	["item_defusekit"] = {
		Desc = "GRID Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID then
				return true
			else return false
			end
		end
	},
	["wep_pistol"] = {
		Restricted = true,
		Max = 1,
	},
	["att_pistol_silencer"] = {
		Desc = "GHOST/UNION Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() >= CLASS_GHOST or ply:GetTeamClass() == CLASS_UNION then
				return true
			else return false
			end
		end
	},
	["att_reflex"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 then
				return true
			else return false
			end
		end
	},
	["att_cmore"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 then
				return true
			else return false
			end
		end
	},
	["att_holosight"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if RANK_I3 then
				return true
			else return false
			end
		end
	},
	["grenade_flashbang"] = {
		Desc = "GHOST/RL+/SWORD",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST or ply:GetTeamRank() >= RANK_OFC or ply:GetTeamClass() == CLASS_SWORD then
				return true
			else return false
			end
		end
	},
	["grenade_9bang"] = {
		Desc = "SWORD i1+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD and ply:GetTeamRank() >= RANK_I1 then
				return true
			else return false
			end
		end
	},
	["wep_mp7a8"] = {
		Desc = "DvL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DVL then
				return true
			else 
				return false
			end
		end
	},
	["wep_tt"] = {
		Desc = "SWORD or RL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD or ply:GetTeamRank() >= RANK_OFC then
				return true
			else 
				return false
			end
		end
	},
	["item_manhack"] = {
		Desc = "UNION i2+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I2 and ply:GetTeamClass() == CLASS_UNION then
				return true
			else return false
			end
		end
	},
	["item_morphine"] = {
		Desc = "HELIX i2+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I2 and ply:GetTeamClass() == CLASS_HELIX then
				return true
			else return false
			end
		end
	},
	["item_stimshot"] = {
		Desc = "HELIX i3+",
		Restricted = true,
		BuyMax = 2,
		TempCooldown = 600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 and ply:GetTeamClass() == CLASS_HELIX then
				return true
			else return false
			end
		end
	},
	["item_crimescenekit"] = {
		Restricted = true,
		Max = 1	
	},
	["item_portablehpcharger"] = {
		Desc = "HELIX i2+",
		Restricted = true,
		Max = 1,
		Cooldown = 600,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_HELIX && ply:GetTeamRank() >= RANK_I2 then
				return true
			else return false
			end
		end
	},
	["wep_m500"] = {
		Desc = "SWORD i1+/DvL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_SWORD && ply:GetTeamRank() >= RANK_I1) or ply:GetTeamRank() >= RANK_DVL then
				return true
			else return false
			end 
		end
	},
	["wep_cz75"] = {
		Desc = "i5+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I5 then
				return true
			else return false
			end 
		end
	},
	["item_motionsensor"] = {
		Desc = "GHOST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST then
				return true
			else return false
			end 
		end
	},
	["item_audiobug"] = {
		Desc = "GHOST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST then
				return true
			else return false
			end 
		end
	},
	["wep_sledgehammer"] = {
		Desc = "GRID i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I3 then
				return true
			else return false
			end
		end
	},
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CP and ply:GetTeamClass() != nil and (impulse.Dispatch.GetCityCode() >= CODE_AJ or RES_MASSPRODUCTION == true)
end

function VENDOR:OnItemPurchased(class, ply)
	if class == "wep_357" and (ply:HasInventoryItem("wep_pistol") or ply:HasInventoryItem("wep_tt") or ply:HasInventoryItem("wep_sw500") or ply:HasInventoryItem("wep_cz75")) then
		ply:TakeInventoryItemClass("wep_pistol")
		ply:TakeInventoryItemClass("wep_tt")
		ply:TakeInventoryItemClass("wep_sw500")
		ply:TakeInventoryItemClass("wep_cz75")
	end
	if class == "wep_pistol" and (ply:HasInventoryItem("wep_357") or ply:HasInventoryItem("wep_tt") or ply:HasInventoryItem("wep_sw500") or ply:HasInventoryItem("wep_cz75")) then
		ply:TakeInventoryItemClass("wep_357")
		ply:TakeInventoryItemClass("wep_tt")
		ply:TakeInventoryItemClass("wep_sw500")
		ply:TakeInventoryItemClass("wep_cz75")
	end
	if class == "wep_tt" and (ply:HasInventoryItem("wep_357") or ply:HasInventoryItem("wep_pistol") or ply:HasInventoryItem("wep_sw500") or ply:HasInventoryItem("wep_cz75")) then
		ply:TakeInventoryItemClass("wep_357")
		ply:TakeInventoryItemClass("wep_pistol")
		ply:TakeInventoryItemClass("wep_sw500")
		ply:TakeInventoryItemClass("wep_cz75")
	end
	if class == "wep_sw500" and (ply:HasInventoryItem("wep_357") or ply:HasInventoryItem("wep_pistol") or ply:HasInventoryItem("wep_tt") or ply:HasInventoryItem("wep_cz75")) then
		ply:TakeInventoryItemClass("wep_357")
		ply:TakeInventoryItemClass("wep_pistol")
		ply:TakeInventoryItemClass("wep_tt")
		ply:TakeInventoryItemClass("wep_cz75")
	end
	if class == "wep_cz75" and (ply:HasInventoryItem("wep_357") or ply:HasInventoryItem("wep_pistol") or ply:HasInventoryItem("wep_tt") or ply:HasInventoryItem("wep_sw500")) then
		ply:TakeInventoryItemClass("wep_357")
		ply:TakeInventoryItemClass("wep_pistol")
		ply:TakeInventoryItemClass("wep_tt")
		ply:TakeInventoryItemClass("wep_sw500")
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
	if class == "att_reddot" and (ply:HasInventoryItem("att_reflex") or ply:HasInventoryItem("att_cmore") or ply:HasInventoryItem("att_holosight")) then
		ply:TakeInventoryItemClass("att_reflex")
		ply:TakeInventoryItemClass("att_cmore")
		ply:TakeInventoryItemClass("att_holosight")
	end
	if class == "att_reddot" and (ply:HasInventoryItem("att_reflex") or ply:HasInventoryItem("att_cmore") or ply:HasInventoryItem("att_holosight")) then
		ply:TakeInventoryItemClass("att_reflex")
		ply:TakeInventoryItemClass("att_cmore")
		ply:TakeInventoryItemClass("att_holosight")
	end
	if class == "att_slugrounds" and (ply:HasInventoryItem("att_pistol_silencer")) then
		ply:TakeInventoryItemClass("att_pistol_silencer")
	end
	if class == "wep_mp7" and (ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_mp7a8") or ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_pm63")
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_mp7a8")
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_pm63" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_mp7a8") or ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_mp7a8")
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_shotgun" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_mp7a8") or ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_pm63")
		ply:TakeInventoryItemClass("wep_mp7a8")
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_mp7a8" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_osisg") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_pm63")
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_osisg")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_osisg" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_mp7a8") or ply:HasInventoryItem("wep_m500")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_pm63")
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_mp7a8")
		ply:TakeInventoryItemClass("wep_m500")
	end
	if class == "wep_m500" and (ply:HasInventoryItem("wep_mp7") or ply:HasInventoryItem("wep_pm63") or ply:HasInventoryItem("wep_shotgun") or ply:HasInventoryItem("wep_mp7a8") or ply:HasInventoryItem("wep_osisg")) then
		ply:TakeInventoryItemClass("wep_mp7")
		ply:TakeInventoryItemClass("wep_pm63")
		ply:TakeInventoryItemClass("wep_shotgun")
		ply:TakeInventoryItemClass("wep_mp7a8")
		ply:TakeInventoryItemClass("wep_osisg")
	end
	if class == "wep_shield" and (ply:HasInventoryItem("wep_heavyshield")) then
		ply:TakeInventoryItemClass("wep_heavyshield")
	end
	if class == "wep_heavyshield" and (ply:HasInventoryItem("wep_shield")) then
		ply:TakeInventoryItemClass("wep_shield")
	end
	if class == "grenade_flashbang" and (ply:HasInventoryItem("grenade_9bang")) then
		ply:TakeInventoryItemClass("grenade_9bang")
	end
	if class == "grenade_9bang" and (ply:HasInventoryItem("grenade_flashbang")) then
		ply:TakeInventoryItemClass("grenade_flashbang")
	end
end

impulse.RegisterVendor(VENDOR)
