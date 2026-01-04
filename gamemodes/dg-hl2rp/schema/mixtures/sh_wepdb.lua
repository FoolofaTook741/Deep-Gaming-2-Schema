local MIX = {}

MIX.Class = "wepdb"

MIX.Level = 5
MIX.Bench = "weapon"

MIX.Output = "wep_db"
MIX.Input = {
	["util_pipe"] = {take = 5},
	["util_glue"] = {take = 3},
	["util_wood"] = {take = 8}
}

impulse.RegisterMixture(MIX)

