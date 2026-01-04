local MIX = {}

MIX.Class = "scrap_enerycore4"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_omr"] = {take = 1},
}

impulse.RegisterMixture(MIX)
