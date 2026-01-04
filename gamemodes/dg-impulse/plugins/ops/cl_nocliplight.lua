local wait = 0
local lightOn = lightOn or false
OPS_LIGHT = OPS_LIGHT or false
local cols = {
	["Blue"] = Color(46, 207, 255),
	["Blue Soft"] = Color(22, 78, 94),
	["Amber"] = Color(255, 182, 66),
	["Amber Soft"] = Color(115, 82, 31),
	["White"] = Color(192, 255, 255)
}
function PLUGIN:Think()
	if (not LocalPlayer():IsAdmin() and not LocalPlayer():IsGameMaster()) or LocalPlayer():GetMoveType() != MOVETYPE_NOCLIP or not LocalPlayer():Alive() then
		OPS_LIGHT = false
		lightOn = false
		return
	end

	if lightOn then
		local dLight = DynamicLight(LocalPlayer():EntIndex() + 1000)
		if dLight then
			dLight.pos = LocalPlayer():EyePos()

			local col = cols[impulse.GetSetting("admin_lightcol")] or cols["White"]
			dLight.r = col.r
			dLight.g = col.g
			dLight.b = col.b
			dLight.brightness = 3
			local size = 1200
			dLight.Size = size
			dLight.Decay = size * 5
			dLight.DieTime = CurTime() + 1
		end
	end

	if vgui.CursorVisible() then
		return
	end

	if (wait > CurTime()) then return end

	if input.IsKeyDown(KEY_F) then
		wait = CurTime() + 0.3

		if lightOn then
			OPS_LIGHT = false
			lightOn = false
			surface.PlaySound("buttons/button14.wav")
			return
		end

		surface.PlaySound("buttons/button14.wav")
		lightOn = true
		OPS_LIGHT = true
	end
end