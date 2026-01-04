--[[
local fog = {				
	["fog_start"] = 0,
	["fog_end"] = 1300,
	["fog_max_density"] = 0.35,
	["fog_color"] = Vector(255, 255, 255) * 0.9
}


local fogFade = 0
local transSpeed = 0.3
local transWait = 2
local wait = 0
local function SetupFog()
	if not LocalPlayer().InSnow then
		if CurTime() > wait and fogFade != 0 then
			fogFade = math.Clamp(fogFade - (FrameTime() * transSpeed), 0, 1)
		end
	else
		wait = CurTime() + transWait
		fogFade = math.Clamp(fogFade + (FrameTime() * transSpeed), 0, 1)
	end
	
	render.FogMode(MATERIAL_FOG_LINEAR)
	render.FogStart(fog.fog_start)
	render.FogEnd(fog.fog_end)
	render.FogColor(fog.fog_color.r, fog.fog_color.g, fog.fog_color.b)
	render.FogMaxDensity(math.Clamp(fog.fog_max_density * fogFade, 0.19, 1))
				
	return true
end

-- hook it
PLUGIN.SetupWorldFog = SetupFog
PLUGIN.SetupSkyboxFog = SetupFog


no more fog
--]]