local MIX = {}

MIX.Class = "ammoriflecrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_rifleammocrate"
MIX.Input = {
	["ammo_rifle"] = {take = 10},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
