local MIX = {}

MIX.Class = "formalshoes"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_formalshoes"
MIX.Input = {
	["util_plastic"] = {take = 9}
}

impulse.RegisterMixture(MIX)
