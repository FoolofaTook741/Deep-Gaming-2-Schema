local MIX = {}

MIX.Class = "cos_constructionhelmet"

MIX.Level = 4
MIX.Bench = "general"

MIX.Output = "cos_constructionhelmet"
MIX.Input = {
	["util_glue"] = {take = 1},
	["util_plastic"] = {take = 6}
}

impulse.RegisterMixture(MIX)
