local VENDOR = {}

GL_ICT_MULT = 1

VENDOR.UniqueID = "ictvendor"
VENDOR.Name = "Infestation Control Team Supplier"
VENDOR.Desc = "Can sell supplies to the members of the I.C.T."

VENDOR.Model = "models/hlvr/characters/worker/npc/worker_combine.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = false

VENDOR.Sell = {
	["item_emptybag"] = {
		Cost = 30,
		BuyMax = 12,
		Restricted = true,
		TempCooldown = 300
	},
    ["item_ictbox"] = {
		Cost = 30,
		BuyMax = 1,
		Restricted = true,
		TempCooldown = 300
	},
    ["item_barrel"] = {
		Cost = 25,
		BuyMax = 1,
		Restricted = true,
		TempCooldown = 300
	},
    ["item_sporeanalyzer"] = {
		Cost = 70,
		BuyMax = 1,
		Restricted = true,
		TempCooldown = 300
	},
    ["item_emptyspecimencrate"] = {
		Cost = 40,
		BuyMax = 5,
		Restricted = true,
		TempCooldown = 300
	},
    ["item_hcdomestication"] = {
		Cost = 60,
		BuyMax = 5,
		Restricted = true,
		TempCooldown = 300
	},
}

VENDOR.Buy = {
    ["item_fullbag"] = {
		Cost = 50 * GL_ICT_MULT
	},
	["item_fullbag"] = {
		Cost = 50 * GL_ICT_MULT
	},
	["item_fullbag_spore"] = {
		Cost = 200 * GL_ICT_MULT
	},
	["item_fullbag_barnacle"] = {
		Cost = 200 * GL_ICT_MULT
	},
    ["item_grubcrate"] = {
		Cost = 70 * GL_ICT_MULT
	},
    ["item_headcrabcrate"] = {
		Cost = 130 * GL_ICT_MULT
	},
	["item_poisioneadcrabcrate"] = {
		Cost = 130 * GL_ICT_MULT
	},
	["item_fastheadcrabcrate"] = {
		Cost = 65 * GL_ICT_MULT
	},
    ["item_domesticatedheadcrab"] = {
		Cost = 150 * GL_ICT_MULT
	},
	["item_barnaclecrate"] = {
		Cost = 130 * GL_ICT_MULT
	},
}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CWU && ply:GetTeamClass() == CLASS_ICT
end

impulse.RegisterVendor(VENDOR)
