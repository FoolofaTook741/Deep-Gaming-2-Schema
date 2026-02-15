local MIX = {}

MIX.Class = "ammolmgcrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_lmgammocrate"
MIX.Input = {
	["ammo_lmg"] = {take = 8},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
