util.AddNetworkString("impulseHalloweenStrike")
util.PrecacheModel("models/lightning/lightning1.mdl")
util.PrecacheModel("models/lightning/lightning2.mdl")
util.PrecacheModel("models/lightning/lightning3.mdl")

local strikePoses = {
	["rp_nc_d47_v2"] = {
		Vector(-8780.96875, 11935.03125, -3037.375),
		Vector(-8856.5, 12503.5, -3092.34375),
		Vector(-8231.03125, 12345.71875, -3080.53125),
		Vector(-9255.28125, 11686.9375, -3074.8125),
		Vector(-9245, 12443.96875, -3059.59375),
		Vector(-9893.8974609375, 12017.140625, -2888.216796875)
	},
	["rp_c18_dg"] = {
		Vector(-1555.6083984375, 5447.4233398438, 848.03125),
		Vector(1356.1500244141, -2734.1989746094, 656.5322265625),
		Vector(1359.7880859375, -4695.7099609375, 656.03125),
		Vector(-269.67422485352, -1652.1948242188, 656.03125),
		Vector(978.53302001953, -690.36157226563, 656.03125),
		Vector(-1273.1431884766, 2152.7690429688, 840.03125),
		Vector(3655.0239257813, 164.03895568848, 656.03125)
	}
}

function doLightningStrike(rf)
	net.Start("impulseHalloweenStrike")
	net.WriteVector(strikePoses[game.GetMap()][math.random(1, #strikePoses[game.GetMap()])])
	if rf then
		net.Send(rf)
	else
		net.Broadcast()
	end
end

local nextStrike
function PLUGIN:Think()
	if nextStrike and nextStrike > CurTime() then
		return
	end

	if not strikePoses[game.GetMap()] then
		return print("[impulse] Halloween lightning strike positions NOT SETUP!!!! PANIC (goto sv_storm.lua and set them up please)")
	end

	if math.random(1, 10) > 7 then
		nextStrike = CurTime() + math.random(1.1, 4)
	else
		nextStrike = CurTime() + math.random(35, 57)
	end

	doLightningStrike()
end