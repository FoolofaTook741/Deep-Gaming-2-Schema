local MIX = {}

MIX.Class = "ammodeaglecrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_deagleammocrate"
MIX.Input = {
	["ammo_deagle"] = {take = 5},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
