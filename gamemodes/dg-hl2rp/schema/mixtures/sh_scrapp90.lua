local MIX = {}

MIX.Class = "scrapp90"

MIX.Level = 3
MIX.Bench = "scrap"

MIX.Output = "wep_p90"
MIX.Input = {
	["scrap_p90"] = {take = 1},
	["util_glue"] = {take = 2},
	["util_pipe"] = {take = 1},
    ["util_metalplate"] = {take = 2}
}

impulse.RegisterMixture(MIX)
