local MIX = {}

MIX.Class = "scraprappel"

MIX.Level = 1
MIX.Bench = "general"
MIX.Scrap = true --use to allow scrapping of one item into multiple things

MIX.Outputs = { "util_pipe", "util_plastic", "util_plastic" }
MIX.Input = {
	["item_rappel"] = {take = 1}
}

impulse.RegisterMixture(MIX)
