local MIX = {}

MIX.Class = "ied"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_ied"
MIX.Input = {
	["util_plastic"] = {take = 17},
	["util_glue"] = {take = 13},
	["util_electronics"] = {take = 25},
	["util_rdxcompound"] = {take = 7},
	["util_gunpowder"] = {take = 30}
}

impulse.RegisterMixture(MIX)
