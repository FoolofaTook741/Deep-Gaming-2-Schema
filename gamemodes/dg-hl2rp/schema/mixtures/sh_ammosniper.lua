local MIX = {}

MIX.Class = "ammosniper"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "ammo_sniper"
MIX.Input = {
	["util_bulletcasing"] = {take = 4},
	["util_gunpowder"] = {take = 3}
}

impulse.RegisterMixture(MIX)
