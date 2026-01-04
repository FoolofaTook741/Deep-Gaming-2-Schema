local MIX = {}

MIX.Class = "greasedbelt"

MIX.Level = 5
MIX.Bench = "attachment"

MIX.Output = "att_greasedbelt"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 5},
	["util_plastic"] = {take = 8}
}

impulse.RegisterMixture(MIX)
