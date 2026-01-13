local MIX = {}

MIX.Class = "repairedturret"

MIX.Level = 10
MIX.Bench = "tech"

MIX.Output = "item_autoturret"
MIX.Input = {
	["util_bulletcasing"] = {take = 4},
    ["util_gunpowder"] = {take = 4},
    ["scrap_ar2"] = {take = 1},
	["util_electronics"] = {take = 5}
}

impulse.RegisterMixture(MIX)
