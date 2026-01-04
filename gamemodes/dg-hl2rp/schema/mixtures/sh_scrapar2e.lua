local MIX = {}

MIX.Class = "scrap_energycorear2e"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_ar2e"] = {take = 1},
}

impulse.RegisterMixture(MIX)
