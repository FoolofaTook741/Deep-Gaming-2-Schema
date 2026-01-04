local MIX = {}

MIX.Class = "scrap_energycorear2"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "util_energycore"
MIX.Input = {
	["scrap_ar2"] = {take = 1},
}

impulse.RegisterMixture(MIX)
