local MIX = {}

MIX.Class = "ghilliesuit"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_ghilliesuit"
MIX.Input = {
	["util_cloth"] = {take = 20},
    ["util_wood"] = {take = 10},
    ["util_refinedmetalplate"] = {take = 5}

}

impulse.RegisterMixture(MIX)
