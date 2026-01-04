local MIX = {}

MIX.Class = "scrapstoplate"

MIX.Level = 1
MIX.Bench = "general"

MIX.Output = "util_metalplate"
MIX.Input = {
	["item_scraps"] = {take = 2}
}

impulse.RegisterMixture(MIX)
