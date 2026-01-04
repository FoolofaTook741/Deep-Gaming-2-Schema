local MIX = {}

MIX.Class = "taugun"

MIX.Level = 10
MIX.Bench = "heavyweapon"

MIX.Output = "wep_tau"
MIX.Input = {
	["util_particleaccelerator"] = {take = 1},
	["util_energycore"] = {take = 20},
	["util_gear"] = {take = 2},
	["util_steel"] = {take = 3},
	["util_refinedmetalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
