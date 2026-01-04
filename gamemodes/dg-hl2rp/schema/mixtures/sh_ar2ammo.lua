local MIX = {}

MIX.Class = "ammoar2"

MIX.Level = 10
MIX.Bench = "general"

MIX.Output = "ammo_ar2"
MIX.Input = {
	["util_bulletcasing"] = {take = 9},
	["util_gunpowder"] = {take = 9},
    ["util_energycore"] = {take = 2}
}

impulse.RegisterMixture(MIX)
