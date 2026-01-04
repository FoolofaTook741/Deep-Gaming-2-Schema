local MIX = {}

MIX.Class = "workboots"

MIX.Level = 3
MIX.Bench = "clothing"

MIX.Output = "clo_workboots"
MIX.Input = {
	["util_cloth"] = {take = 4},
    ["util_metalplate"] = {take = 1}
}

impulse.RegisterMixture(MIX)
