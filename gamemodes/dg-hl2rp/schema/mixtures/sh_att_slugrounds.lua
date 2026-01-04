local MIX = {}

MIX.Class = "slugrounds"

MIX.Level = 9
MIX.Bench = "attachment"

MIX.Output = "att_slugrounds"
MIX.Input = {
	["ammo_buckshot"] = {take = 3},
	["util_bulletcasing"] = {take = 4}
}

impulse.RegisterMixture(MIX)
