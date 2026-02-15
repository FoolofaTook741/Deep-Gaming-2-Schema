local MIX = {}

MIX.Class = "ammoar2crate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_ar2ammocrate"
MIX.Input = {
	["ammo_ar2"] = {take = 8},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
