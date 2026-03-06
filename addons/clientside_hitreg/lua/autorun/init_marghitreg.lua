if game.SinglePlayer() then
	return
end

CLHR = CLHR or {
	Exceptions = {
		weapon_zm_improvised = true,
	},
}

hook.Add("InitPostEntity", "CLHR_InitPostEntity", function()
	--timer.Simple(0, function()
		include("marghitreg/sh_marghitreg.lua")
	--end)
end)

hook.Add("PreGamemodeLoaded", "CLHR_PreGamemodeLoaded", function()
	if TTT_FOF then
		TTT_FOF.ClientsideHitreg = "MargHitreg"
	end
end)
