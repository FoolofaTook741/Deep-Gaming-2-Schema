local MIX = {}

MIX.Class = "scrapshotgun"

MIX.Level = 5
MIX.Bench = "scrap"

MIX.Output = "wep_shotgun"
MIX.Input = {
	["scrap_shotgun"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_gear"] = {take = 1},
	["util_metalplate"] = {take = 3}
}

impulse.RegisterMixture(MIX)
