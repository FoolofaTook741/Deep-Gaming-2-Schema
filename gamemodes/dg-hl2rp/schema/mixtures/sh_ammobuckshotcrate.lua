local MIX = {}

MIX.Class = "ammobuckshotcrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_buckshotammocrate"
MIX.Input = {
	["ammo_buckshot"] = {take = 6},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
