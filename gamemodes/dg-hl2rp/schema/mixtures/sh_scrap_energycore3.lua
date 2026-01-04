local MIX = {}

MIX.Class = "scrap_enerycore3"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_osiprmk1"] = {take = 1},
}

impulse.RegisterMixture(MIX)
