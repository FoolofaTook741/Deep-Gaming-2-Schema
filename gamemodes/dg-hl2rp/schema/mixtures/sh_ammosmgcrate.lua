local MIX = {}

MIX.Class = "ammosmgcrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_smgammocrate"
MIX.Input = {
	["ammo_smg"] = {take = 10},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
