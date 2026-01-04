local MIX = {}

MIX.Class = "ceramicplateb"

MIX.Level = 9
MIX.Bench = "general"

MIX.Output = "util_ceramicplate"
MIX.Input = {
	["cos_otavest3"] = {take = 1}
}

impulse.RegisterMixture(MIX)
