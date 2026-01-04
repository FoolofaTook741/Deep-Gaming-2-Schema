local MIX = {}

MIX.Class = "ammo54r"

MIX.Level = 9
MIX.Bench = "general"

MIX.Output = "ammo_54r"
MIX.Input = {
	["util_bulletcasing"] = {take = 3},
	["util_gunpowder"] = {take = 2}
}

impulse.RegisterMixture(MIX)
