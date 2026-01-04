if not BMSWEP then
	BMSWEP = {}
	BMSWEP.__index = BMSWEP
end

BMSWEP.DisablePickUpAnimations = CreateConVar("bmswep_disablepickupanims", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Disable pickup animations."):GetBool()
cvars.AddChangeCallback("bmswep_disablepickupanims", function(cvar, oldvalue, newvalue)
	BMSWEP.DisablePickUpAnimations = tonumber(newvalue) == 1
end)

BMSWEP.GaussPushScale = math.ceil(100 * CreateConVar("bmswep_gausspushscalemul", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Gauss pushscale. (Default 1)"):GetFloat()) * 0.01
cvars.AddChangeCallback("bmswep_gausspushscalemul", function(cvar, oldvalue, newvalue)
	BMSWEP.GaussPushScale = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

BMSWEP.GaussChargePushScale = math.ceil(100 * CreateConVar("bmswep_gausschargepushscalemul", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Gauss charge pushscale. (Default 1)"):GetFloat()) * 0.01
cvars.AddChangeCallback("bmswep_gausschargepushscalemul", function(cvar, oldvalue, newvalue)
	BMSWEP.GaussChargePushScale = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

BMSWEP.DisableSprintAnimations = CreateConVar("bmswep_disablesprintanims", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Disable sprint animations."):GetBool()
cvars.AddChangeCallback("bmswep_disablesprintanims", function(cvar, oldvalue, newvalue)
	BMSWEP.DisableSprintAnimations = tonumber(newvalue) == 1
end)