local MIX = {}

MIX.Class = "scrapdeagle"

MIX.Level = 2
MIX.Bench = "scrap"

MIX.Output = "wep_tt"
MIX.Input = {
	["scrap_deagle"] = {take = 1},
	["util_pipe"] = {take = 2},
	["util_metalplate"] = {take = 2},
}

impulse.RegisterMixture(MIX)
