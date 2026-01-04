local MIX = {}

MIX.Class = "scrap_enerycore5"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_apf"] = {take = 1},
}

impulse.RegisterMixture(MIX)
