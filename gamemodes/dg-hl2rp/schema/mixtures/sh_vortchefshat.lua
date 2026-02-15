local MIX = {}

MIX.Class = "vortchefshat"

MIX.Level = 3
MIX.Bench = "Hats"

MIX.Output = "clo_vortchefshat"
MIX.Input = {
	["util_cloth"] = {take = 3}
}

impulse.RegisterMixture(MIX)
