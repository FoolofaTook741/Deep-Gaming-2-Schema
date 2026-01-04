local MIX = {}

MIX.Class = "heavy_stock"

MIX.Level = 3
MIX.Bench = "attachment"

MIX.Output = "att_foregrip"
MIX.Input = {
	["util_metalplate"] = {take = 1},
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 5}
}

impulse.RegisterMixture(MIX)
