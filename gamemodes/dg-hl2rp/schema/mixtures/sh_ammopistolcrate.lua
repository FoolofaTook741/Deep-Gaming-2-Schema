local MIX = {}

MIX.Class = "ammopistolcrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_pistolammocrate"
MIX.Input = {
	["ammo_pistol"] = {take = 8},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
