local MIX = {}

MIX.Class = "ammo54rcrate"

MIX.Level = 9
MIX.Bench = "general"

MIX.Output = "item_54rammocrate"
MIX.Input = {
	["ammo_54r"] = {take = 10},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}

impulse.RegisterMixture(MIX)
