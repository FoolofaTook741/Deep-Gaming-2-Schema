local MIX = {}

MIX.Class = "restraints"

MIX.Level = 3
MIX.XPMultiplier = 0.3
MIX.Bench = "general"

MIX.Output = "wep_restraints"
MIX.Input = {
	["util_metalplate"] = {take = 2},
	["util_plastic"] = {take = 5}
}

impulse.RegisterMixture(MIX)
