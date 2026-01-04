local MIX = {}

MIX.Class = "dragonsbreath"

MIX.Level = 10
MIX.Bench = "attachment"

MIX.Output = "att_dragonsbreath"
MIX.Input = {
	["util_moonshine"] = {take = 5},
	["util_bulletcasing"] = {take = 10},
    ["util_gunpowder"] = {take = 10}
}

impulse.RegisterMixture(MIX)
