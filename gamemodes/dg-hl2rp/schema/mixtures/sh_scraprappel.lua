local MIX = {}

MIX.Class = "scraprappel"

MIX.Level = 1
MIX.Bench = "general"
MIX.Multi = true --this is for multiple output mixtures so that they show up properly on the workbenches. 
--******** Please note, you cannot have more than one input item. This is really just for scrapping items. ********

MIX.Outputs = { "util_pipe", "util_plastic", "util_plastic" }
MIX.Input = {
	["item_rappel"] = {take = 1}
}

impulse.RegisterMixture(MIX)
