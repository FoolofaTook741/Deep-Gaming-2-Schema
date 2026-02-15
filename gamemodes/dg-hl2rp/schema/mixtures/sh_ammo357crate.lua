local MIX = {}

MIX.Class = "ammo357crate"

MIX.Level = 7
MIX.Bench = "general"

MIX.Output = "item_357ammocrate"
MIX.Input = {
	["ammo_357"] = {take = 5},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
