local MIX = {}

MIX.Class = "vortessence"

MIX.Level = 5
MIX.Bench = "general"

MIX.Output = "sh_item_vortessence"
MIX.Input = {
	["util_xenextract"] = {take = 2},
  ["util_spices"] = {take = 2}
}

impulse.RegisterMixture(MIX)
