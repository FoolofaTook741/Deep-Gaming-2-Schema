local MIX = {}

MIX.Class = "scrap_energycoreosips"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_osips"] = {take = 1},
}

impulse.RegisterMixture(MIX)
