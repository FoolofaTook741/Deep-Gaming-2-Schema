local MIX = {}

MIX.Class = "ammosnipercrate"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "item_sniperammocrate"
MIX.Input = {
	["ammo_sniper"] = {take = 5},
	["util_wood"] = {take = 2},
	["util_glue"] = {take = 1}
}


impulse.RegisterMixture(MIX)
