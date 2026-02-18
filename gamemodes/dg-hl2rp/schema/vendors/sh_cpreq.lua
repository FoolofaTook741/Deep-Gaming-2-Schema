local VENDOR = {}

VENDOR.UniqueID = "cpreq"
VENDOR.Name = "Civil Protection Equipment Vendor"
VENDOR.Desc = "Can supply CPs with equipment."

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
	["weapon_cuff_elastic"] = {
		Desc = "GHOST Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST then
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
			if ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I3 then
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
		Desc = "HELIX i2+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_HELIX && ply:GetTeamRank() >= RANK_I2 then
				return true
			end

			return false
		end
	},
	--[[
	["util_radio"] = {
		Restricted = true,
		Max = 1,
	},
	--]]
	["wep_sw500"] = {
		Desc = "CmD Only",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			return ply:GetTeamRank() >= RANK_CMD
		end
	},
	["wep_incendiary"] = {
		Desc = "GRID/SWORD",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_I2 and ply:GetTeamClass() == CLASS_GRID) or ply:GetTeamClass() == CLASS_SWORD then
				return true
			else return false
			end
		end
	},
	["wep_teargas"] = {
		Desc = "GRID i2+",
		Restricted = true,
		Max = 3,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I2 and ply:GetTeamClass() == CLASS_GRID then
				return true
			else return false
			end
		end
	},
	["wep_shotgun"] = {
		Desc = "SWORD i1+/UNION i1+/DvL+/Grid i2+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			local teamClass = ply:GetTeamClass()
			local teamRank = ply:GetTeamRank()
			if (teamClass == CLASS_SWORD and teamRank >= RANK_I1) or (teamClass == CLASS_UNION and teamRank >= RANK_I1) or (teamRank >= RANK_SQL) then
				return true
			else
				return false
			end
		end
	},
	["wep_m500"] = {
		Desc = "GRID i1+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			local teamClass = ply:GetTeamClass()
			local teamRank = ply:GetTeamRank()
			if (teamClass == CLASS_GRID and teamRank >= RANK_I1) then
				return true
			else
				return false
			end
		end
	},
	["att_slugrounds"] = {
		Desc = "UNION RL+/DVL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_OFC and ply:GetTeamClass() == CLASS_UNION) or (ply:GetTeamRank() >= RANK_DVL && ply:GetTeamClass() != CLASS_SWORD) then
				return true
			else return false
			end
		end
	},
	["wep_osisg"] = {
		Desc = "UNION i2+/Grid i3+",
		Restricted = true, 
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() == RANK_I2 and ply:GetTeamClass() == CLASS_UNION) or (ply:GetTeamRank() >= RANK_I3 and ply:GetTeamClass() == CLASS_GRID) then
				return true
			else return false
			end
		end
	},
	["wep_mp7"] = {
		Desc = "U i3+/i1+/GHOST/i3 AJ+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_UNION && ply:GetTeamRank() >= RANK_I3) or (ply:GetTeamRank() >= RANK_I1 or ply:GetTeamClass() == CLASS_GHOST) or (ply:GetTeamRank() >= RANK_I3 && impulse.Dispatch.GetCityCode() >= CODE_JW) then
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
	["wep_ar15"] = {
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
	["wep_honeybadger"] = {
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
	["wep_p90"] = {
		Desc = "UNION i3+/AJ:UNION i4+ /i2+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_I2) or (ply:GetTeamClass() == CLASS_UNION and ply:GetTeamRank() >= RANK_I3) or (ply:GetTeamClass() == CLASS_UNION and ply:GetTeamRank() >= RANK_I4 and impulse.Dispatch.GetCityCode() >= CODE_JW) then
				return true
			else return false
			end
		end
	},
	["wep_357"] = {
		Desc = "DcO+/Sword DvL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
            if (ply:GetTeamRank() >= RANK_DCO) or (ply:GetTeamRank() >= RANK_DVL and ply:GetTeamClass() == CLASS_SWORD) then
                return true
            else
                return false
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
	["clo_backpack"] = {
		Desc = "GRID only +10kg",
		Restricted = true,
		Max = 1,
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
	["wep_sledgehammer"] = {
		Desc = "GRID i2+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2 then
				return true
			else return false
			end
		end
	},
	["cos_radiodetector"] = {
		Desc = "GRID i2+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2 then
				return true
			else return false
			end
		end
	},
	["wep_pistol"] = {
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
	["att_pistol_silencer"] = {
		Desc = "Ghost",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() >= CLASS_GHOST then
				return true
			else return false
			end
		end
	},
	["att_rifle_silencer"] = {
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
	["att_huntersight"] = {
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
	["att_reflex"] = {
		Desc = "i2+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I2 then
				return true
			else return false
			end
		end
	},
	["att_cmore"] = {
		Desc = "U i2+/U i3 MRG/i1+/GHOST/i3 JW+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_UNION && ply:GetTeamRank() >= RANK_I2) or (ply:GetTeamRank() >= RANK_I1 or ply:GetTeamClass() == CLASS_GHOST) or (ply:GetTeamRank() >= RANK_I3 && impulse.Dispatch.GetCityCode() >= CODE_JW) or (ply:GetTeamRank() >= RANK_I3 && ply:GetTeamClass() == CLASS_UNION && impulse.Dispatch.GetCityCode() >= CODE_UNREST) then
				return true
			else return false
			end
		end
	},
	["att_holosight"] = {
		Desc = "UNION I3+/I2+/GHOST",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_UNION && ply:GetTeamRank() >= RANK_I3) or ply:GetTeamRank() >= RANK_I2 or ply:GetTeamClass() == CLASS_GHOST then
				return true
			else return false
			end
		end
	},
	["grenade_flashbang"] = {
		Desc = "GHOST/SqL+/SWORD/GRID i2+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GHOST or ply:GetTeamRank() >= RANK_SQL or ply:GetTeamClass() == CLASS_SWORD or (ply:GetTeamClass() == CLASS_UNION && ply:GetTeamRank() >= RANK_I2) then
				return true
			else return false
			end
		end
	},
	["grenade_9bang"] = {
		Desc = "SWORD RL+",
		Restricted = true,
		Max = 2,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD and ply:GetTeamRank() >= RANK_OFC then
				return true
			else return false
			end
		end
	},
	["wep_mp7a8"] = {
		Desc = "SWORD or DcO+/JW: UNION i1+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD or ply:GetTeamRank() >= RANK_DCO or (ply:GetTeamClass() == CLASS_UNION and ply:GetTeamRank() >= RANK_I1 and impulse.Dispatch.GetCityCode() >= CODE_JW) then
				return true
			else 
				return false
			end
		end
	},
	["wep_tt"] = {
		Desc = "SWORD or SqL+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD or ply:GetTeamRank() >= RANK_SQL then
				return true
			else 
				return false
			end
		end
	},
	["item_manhack"] = {
		Desc = "GRID Only+",
		Restricted = true,
		Max = 2,
		Cooldown = 150,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2 then
				return true
			else return false
			end
		end
	},
	["item_morphine"] = {
		Desc = "HELIX i1+",
		Restricted = true,
		BuyMax = 2,
		TempCooldown = 600,
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
		BuyMax = 4,
		TempCooldown = 600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 and ply:GetTeamClass() == CLASS_HELIX then
				return true
			else return false
			end
		end
	},
	["cos_cpvest1"] = {
		Desc = "i3+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_I3 then
				return true
			end

			return false
		end
	},
	["cos_cpvest2"] = {
		Desc = "MARGINAL Only or SWORD",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if impulse.Dispatch.GetCityCode() >= CODE_UNREST or ply:GetTeamClass() == CLASS_SWORD then
				return true
			end

			return false
		end
	},
	["cos_cpvest3"] = {
		Desc = "SWORD/RL+ MARGINAL or HC",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (impulse.Dispatch.GetCityCode() >= CODE_UNREST and (ply:GetTeamClass() == CLASS_SWORD or ply:GetTeamRank() >= RANK_OFC)) or ply:GetTeamRank() >= RANK_DVL then
				return true
			end

			return false
		end
	},
	["cos_cpvest4"] = {
		Desc = "DvL MARGINAL or DcO+",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamRank() == RANK_DVL && impulse.Dispatch.GetCityCode() >= CODE_UNREST) or ply:GetTeamRank() >= RANK_DCO then
				return true
			end

			return false
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
		Desc = "SWORD RL+/DcO+",
		Restricted = true,
		ItemType = "primaryWeapon",
		Max = 1,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_SWORD && ply:GetTeamRank() >= RANK_OFC) or ply:GetTeamRank() >= RANK_DCO then
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
	["item_combinelock"] = {
		Desc = "GRID I1+",
		Restricted = true,
		Cooldown = 900,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_GRID && ply:GetTeamRank() >= RANK_I3  then
				return true
			else 
				return false
			end 
		end
	},
	["util_turret"] = {
		Desc = "GRID Turret [GRID I2+ Only]",
		BuyMax = 1,
		Restricted = true,
		TempCooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2) then
				return true
			else return false
			end
		end
	},
	["util_conduit"] = {
		Desc = "Conduit Deployer [GRID Only]",
		BuyMax = 1,
		TempCooldown = 600,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_GRID and ply:GetTeamRank() >= RANK_I2 ) then
				return true
			else return false
			end
		end
	},
	["item_broadcastkey"] = {
		Desc = "A key for the broadcast terminal, do not lose this. [DvL+]",
		BuyMax = 1,
		TempCooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_DVL) then
				return true
			else return false
			end
		end
	},
	["wep_heavyrestraints"] = {
		Desc = "Rope Restraints. [GHOST Only]",
		Max = 1,
		Restricted = true,
		TempCooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_GHOST) then
				return true
			else return false
			end
		end
	},
	["portablecam"] = {
		Desc = "Portable Camera. [GHOST Only]",
		BuyMax = 4,
		Restricted = true,
		TempCooldown = 600,
		CanBuy = function(ply)
			if (ply:GetTeamClass() == CLASS_GHOST) then
				return true
			else return false
			end
		end
	},
	["food_noodles"] = {
		Restricted = true,
		Max = 1,
		Cooldown = 720
	},
	["util_nvgs"] = {
		Restricted = true,
		Max = 1
	},
	["clo_reinforcedcphelmet"] = {
		Desc = "UNION/SWORD i3+ (MARGINAL+) | SWORD SqL+ (Any Code)",
		Restricted = true,
		Max = 1,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_SWORD and ply:GetTeamRank() >= RANK_SQL then
				return true
			end

			if impulse.Dispatch.GetCityCode() < CODE_UNREST then return false end

			if (ply:GetTeamClass() == CLASS_UNION or ply:GetTeamClass() == CLASS_SWORD) and ply:GetTeamRank() >= RANK_I3 then
				return true
			end

			return false
		end
	}
}

VENDOR.Buy = {
	["item_emptymedkit"] = {
		Desc = "An empty medical kit used to carry various medications and first aid items.",
		Cost = 65,
	}
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CP and ply:GetTeamClass() != nil
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