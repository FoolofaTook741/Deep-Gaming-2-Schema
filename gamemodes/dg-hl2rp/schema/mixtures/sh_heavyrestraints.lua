local MIX = {}

MIX.Class = "heavyrestraints"

MIX.Level = 8
MIX.XPMultiplier = 1
MIX.Bench = "general"

MIX.Output = "wep_heavyrestraints"
MIX.Input = {
	["util_refinedmetalplate"] = {take = 3},
    ["util_plastic"] = {take = 4},
	["wep_restraints"] = {take = 1}
}

impulse.RegisterMixture(MIX)
