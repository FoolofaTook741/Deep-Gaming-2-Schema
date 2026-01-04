local MIX = {}

MIX.Class = "portablecamera"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "portablecam"
MIX.Input = {
	["util_metalplate"] = {take = 1},
	["util_electronics"] = {take = 2},
	["util_plastic"] = {take = 3}
}

impulse.RegisterMixture(MIX)
