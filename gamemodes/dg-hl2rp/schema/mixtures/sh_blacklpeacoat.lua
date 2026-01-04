local MIX = {}

MIX.Class = "blackpeacoat"

MIX.Level = 10
MIX.Bench = "clothing"

MIX.Output = "clo_blackpeacoat"
MIX.Input = {
	["util_cloth"] = {take = 35}
}

impulse.RegisterMixture(MIX)
