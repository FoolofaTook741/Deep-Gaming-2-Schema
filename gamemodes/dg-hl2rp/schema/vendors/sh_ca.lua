local VENDOR = {}

VENDOR.UniqueID = "ca"
VENDOR.Name = "O.C.A. Supplies"
VENDOR.Desc = "Distributes permits and weapons for O.C.A."

VENDOR.Model = "models/taggart/gallahan.mdl"
VENDOR.Skin = 0
VENDOR.Bodygroups = "0"
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
	["item_constructionpermit"] = {
		Desc = "Admin Branch - 4/2 minutes",
		Cost = 15,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_metalpermit"] = {
		Desc = "Admin Branch - 4/2 minutes",
		Cost = 20,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_outdoorspermit"] = {
		Desc = "Admin Branch - 4/2 minutes",
		Cost = 15,
		BuyMax = 4,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_firearmspermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 45,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_heavyfirearmspermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_CA && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_miningpermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_knifepermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 60,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_broadcastkey"] = {
		Desc = "A key for the broadcast terminal, do not lose this.",
		Cost = 0,
		BuyMax = 1,
		TempCooldown = 600,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE) then
				return true
			else return false
			end
		end
	},
	["event_relocation"] = {
		Desc = "A Relocation Coupon for a new city",
		BuyMax = 1,
		TempCooldown = 60,
		Restricted = true,
		Cost = 50,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE) then
				return true
			else return false
			end
		end
	},
	["item_lumberjackpermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_cleaverpermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_homerefinerypermit"] = {
		Desc = "Admin Branch - 1/2 minutes",
		Cost = 90,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_alcoholpermit"] = {
		Desc = "Admin Branch - 2/2 minutes",
		Cost = 20,
		BuyMax = 2,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_generatorpermit"] = {
		Desc = "Admin Branch - 3/2 minutes",
		Cost = 40,
		BuyMax = 3,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["item_ttpermit"] = {
		Desc = "Admin Branch, Executive+ - 1/2 minutes",
		Cost = 150,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DEPUTY && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["wep_pistol"] = {
		Desc = "Councilman+",
		Max = 1,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_COUNCILMAN) then
				return true
			else return false
			end
		end
	},
	["wep_tt"] = {
		Desc = "Exec+/SV's",
		BuyMax = 1,
		TempCooldown = 120,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_DEPUTY and ply:GetTeamClass() == CLASS_BASE) or 
			   (ply:GetTeamRank() >= RANK_COUNCILMAN && impulse.Dispatch.GetCityCode() >= CODE_JW) then
				return true
			else
				return false
			end
		end
	},
	["wep_357"] = {
		Desc = "CA Only",
		BuyMax = 1,
		TempCooldown = 120,
		Restricted = true,
		CanBuy = function(ply)
			if (ply:GetTeamRank() >= RANK_CA and ply:GetTeamClass() == CLASS_BASE) or 
			   (ply:GetTeamRank() >= RANK_DEPUTY && impulse.Dispatch.GetCityCode() >= CODE_JW) then
				return true
			else return false
			end
		end
	},
	["gunbox_usp"] = {
		Desc = "Admin Branch Councilman+ - 1/5 minutes",
		Cost = 25,
		BuyMax = 1,
		TempCooldown = 300,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["gunbox_deagle"] = {
		Desc = "Admin Branch Exec+ - 1/5 minutes",
		Cost = 50,
		BuyMax = 1,
		TempCooldown = 300,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DEPUTY && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["gunbox_357"] = {
		Desc = "Admin Branch DCA+ - 1/5 minutes",
		Cost = 75,
		BuyMax = 1,
		TempCooldown = 300,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_CA && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["toolbox_axe"] = {
		Desc = "Admin Branch Rep+ - 1/2 minutes",
		Cost = 30,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["toolbox_pickaxe"] = {
		Desc = "Admin Branch Rep+ - 1/2 minutes",
		Cost = 30,
		BuyMax = 1,
		TempCooldown = 120,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_REPRESENTATIVE && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["book_italian"] = {
		Desc = "Admin Branch Councilman+ - 1/60 minutes",
		Cost = 3000,
		BuyMax = 1,
		TempCooldown = 3600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_COUNCILMAN && ply:GetTeamClass() == CLASS_BASE then
				return true
			else return false
			end
		end
	},
	["book_german"] = {
		Desc = "Admin Branch Exec+ - 1/60 minutes",
		Cost = 3000,
		BuyMax = 1,
		TempCooldown = 3600,
		CanBuy = function(ply)
			if ply:GetTeamRank() >= RANK_DEPUTY && ply:GetTeamClass() == CLASS_BASE then
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
}

function VENDOR:CanUse(ply)
    return ply:Team() == TEAM_CA and ply:GetTeamRank() != nil and ply:GetTeamRank() >= RANK_INTERN
end

function VENDOR:OnItemPurchased(class, ply)
	if class == "wep_tt" and (ply:HasInventoryItem("wep_pistol")) then
		ply:TakeInventoryItemClass("wep_pistol")
	end
	if class == "wep_pistol" and (ply:HasInventoryItem("wep_tt")) then
		ply:TakeInventoryItemClass("wep_tt")
	end
end

impulse.RegisterVendor(VENDOR)
