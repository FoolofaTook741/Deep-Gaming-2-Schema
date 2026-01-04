local MIX = {}

MIX.Class = "enrichedvortessence"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_enrichedvortessence"
MIX.Input = {
	["item_vortessence"] = {take = 4},
	["food_waterspecial"] = {take = 1},
	["util_xenextract"] = {take = 2}
}

impulse.RegisterMixture(MIX)
