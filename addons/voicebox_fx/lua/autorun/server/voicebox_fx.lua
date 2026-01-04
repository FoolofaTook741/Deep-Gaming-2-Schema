local function BinaryModulePath( name )
	local realm = ( CLIENT and "gmcl_" or "gmsv_" )
	if ( system.IsWindows() ) then
		if ( jit.arch == "x86" ) then
			return string.format( "%s%s_win32.dll", realm, name )
		else
			return string.format( "%s%s_win64.dll", realm, name )
		end
	elseif ( system.IsLinux() ) then
		if ( jit.arch == "x86" ) then
			local is_x86_64 = file.IsDir( "bin/linux32", "BASE_PATH" )
			if is_x86_64 then
				-- linux32 can be used as a suffix only on 32-bit x86-64 branch
				-- BRANCH global cannot be relied on serverside because it is just set to "unknown" on x86-64
				local pathA = string.format( "%s%s_linux.dll", realm, name )
				if not file.Exists( "bin/" .. pathA, "LUA" ) then
					local pathB = string.format( "%s%s_linux32.dll", realm, name )
					if file.Exists( "bin/" .. pathB, "LUA" ) then
						return pathB
					end
				end
				return pathA
			else
				return string.format( "%s%s_linux.dll", realm, name )
			end
		else
			return string.format( "%s%s_linux64.dll", realm, name )
		end
	elseif ( system.IsOSX() ) then
		return string.format( "%s%s_osx.dll", realm, name )
	end
end

local name = BinaryModulePath("voicebox_fx")
if file.Exists("bin/" .. name, "LUA") then
	require("voicebox_fx")
	if not VoiceBox or not VoiceBox.FX then
		print()
		for i = 1, 10 do
			MsgC(Color(255, 0, 0), "VoiceBox FX | ", Color(255, 255, 255), "Something went wrong!\n")
		end
		return
	end
else
	print()
	for i = 1, 10 do
		MsgC(Color(255, 0, 0), "VoiceBox FX | ", Color(255, 255, 255), "garrysmod/lua/bin/", name, " not found!\n")
		MsgC(Color(255, 0, 0), "VoiceBox FX | ", Color(255, 255, 255), "You have not installed, or have installed the wrong binary module (DLL file) for VoiceBox FX.\n")
		MsgC(Color(255, 0, 0), "VoiceBox FX | ", Color(255, 255, 255), "The binary module should be installed to the garrysmod/lua/bin folder on your server.")
		MsgC(Color(255, 0, 0), "VoiceBox FX | ", Color(255, 255, 255), "If the bin folder doesn't exist, you can just create it.\n\n")
	end
end

include("voicebox_fx/lite.lua")
include("voicebox_fx/userid.lua")
include("voicebox_fx/accessories.lua")

do
	local meta = {}
	meta.__index = meta
	meta.__call = function()
		VoiceBox.FX.Config = setmetatable({
			TeamFX = {},
			PlayerFX = {},
			UsergroupFX = {},
			AccessoryFX = {},
			ModelFX = {},
			BodygroupFX = {}
		}, meta)
	end
	meta.__call()

	local function duplicateErr(fx, type, name, existingFx)
		ErrorNoHaltWithStack(string.format("[VoiceBox FX Config] Warning: Can't add voice FX \"%s\" to %s \"%s\" - it already has Voice FX \"%s\"!", fx, type, name, existingFx))
	end

	if not VoiceBox.FX.ApplyVoiceFXNextTick then
		function VoiceBox.FX.ApplyVoiceFXNextTick() end
	end

	local function decodeVarargs(idTransform, idInvalidErr, ...)
		-- last arg is the voice fx as a string, everything proceeding is the id
		-- idTransform is probably tostring or tonumber

		local args = {...}
		if #args == 1 then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Expected an identifier/Voice FX name!")
			return
		end

		local ids = {}
		for i = 1, #args - 1 do
			ids[i] = idTransform(args[i])
			if idInvalidErr and not ids[i] then
				ErrorNoHaltWithStack(idInvalidErr)
				return
			end
		end

		local fx = tostring(args[#args])
		return ids, fx
	end

	function meta.AddPlayerFX(self, ...)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		local ids, fx = decodeVarargs(tostring, nil, ...)
		if not ids then return end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		for _, id in ipairs(ids) do
			local steamid64
			if id:match("^STEAM_%d:%d:%d+$") then
				steamid64 = util.SteamIDTo64(id)
			elseif id:match("^7656119%d+$") then
				steamid64 = id
			else
				ErrorNoHaltWithStack("[VoiceBox FX Config] Invalid player FX! Expected a SteamID or SteamID64, got \"" .. tostring(id) .. "\"")
				return
			end

			if VoiceBox.FX.Config.PlayerFX[steamid64] and VoiceBox.FX.Config.PlayerFX[steamid64] ~= fx then
				duplicateErr(fx, "PLAYER", id, VoiceBox.FX.Config.PlayerFX[steamid64])
			end

			VoiceBox.FX.Config.PlayerFX[steamid64] = fx
		end

		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	function meta.AddUsergroupFX(self, ...)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		local ids, fx = decodeVarargs(tostring, nil, ...)
		if not ids then return end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		for _, id in ipairs(ids) do
			if VoiceBox.FX.Config.UsergroupFX[id] and VoiceBox.FX.Config.UsergroupFX[id] ~= fx then
				duplicateErr(fx, "USERGROUP", id, VoiceBox.FX.Config.UsergroupFX[id])
			end

			VoiceBox.FX.Config.UsergroupFX[id] = fx
		end

		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	function meta.AddTeamFX(self, ...)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		local ids, fx = decodeVarargs(tonumber, "[VoiceBox FX Config] Team/job not found! It should look like: TEAM_POLICE and should NOT be wrapped in quotes!", ...)
		if not ids then return end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		for _, id in ipairs(ids) do
			if VoiceBox.FX.Config.TeamFX[id] and VoiceBox.FX.Config.TeamFX[id] ~= fx then
				duplicateErr(fx, DarkRP and "JOB" or "TEAM", team.GetName(id) or id, VoiceBox.FX.Config.TeamFX[id])
			end

			VoiceBox.FX.Config.TeamFX[id] = fx
		end

		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	function meta.AddAccessoryFX(self, ...)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		local ids, fx = decodeVarargs(tostring, nil, ...)
		if not ids then return end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		for _, id in ipairs(ids) do
			if VoiceBox.FX.Config.AccessoryFX[id] and VoiceBox.FX.Config.AccessoryFX[id] ~= fx then
				duplicateErr(fx, "ACCESSORY", id, VoiceBox.FX.Config.AccessoryFX[id])
			end

			VoiceBox.FX.Config.AccessoryFX[id] = fx
		end

		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	function meta.AddModelFX(self, ...)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		local ids, fx = decodeVarargs(tostring, nil, ...)
		if not ids then return end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		for _, id in ipairs(ids) do
			if VoiceBox.FX.Config.ModelFX[id] and VoiceBox.FX.Config.ModelFX[id] ~= fx then
				duplicateErr(fx, "MODEL", id, VoiceBox.FX.Config.ModelFX[id])
			end

			VoiceBox.FX.Config.ModelFX[id] = fx
		end

		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	function meta.AddBodygroupFX(self, id, bodygroupId, bodygroupVal, fx)
		if not istable(self) then
			error("Your config is wrong. You need to call the functions like VoiceBox.FX.Config:AddModelFX() - NOT like VoiceBox.FX.Config.AddModelFX(). Notice the \":\" instead of \".\"")
		end

		id = tostring(id)
		fx = tostring(fx)
		bodygroupVal = tonumber(bodygroupVal)
		bodygroupId = string.lower(tostring(bodygroupId))

		if not file.Exists(id, "GAME") then
			ErrorNoHaltWithStack("[VoiceBox FX Config] WARNING: Model \"" .. id .. "\" is unknown to the server. Bodygroup voice FX may not work correctly.")
		end

		if not bodygroupVal then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Expected bodygroup value to be a string or number.")
			return
		end

		if not VoiceBox.FX.IsValidVoiceFX(fx) then
			ErrorNoHaltWithStack("[VoiceBox FX Config] Unknown Voice FX! (" .. fx .. ")")
			return
		end

		VoiceBox.FX.Config.BodygroupFX[id] = VoiceBox.FX.Config.BodygroupFX[id] or {}
		VoiceBox.FX.Config.BodygroupFX[id][bodygroupId] = VoiceBox.FX.Config.BodygroupFX[id][bodygroupId] or {}

		if VoiceBox.FX.Config.BodygroupFX[id][bodygroupId][bodygroupVal] and VoiceBox.FX.Config.BodygroupFX[id][bodygroupId][bodygroupVal] ~= fx then
			duplicateErr(fx, "BODYGROUP", id .. "[" .. bodygroupId .. "][" .. bodygroupVal .. "]", VoiceBox.FX.Config.BodygroupFX[id][bodygroupId][bodygroupVal])
		end

		VoiceBox.FX.Config.BodygroupFX[id][bodygroupId][bodygroupVal] = fx
		VoiceBox.FX.ApplyVoiceFXNextTick()
	end

	meta.AddJobFX = meta.AddTeamFX

	local function loadConfig()
		hook.Remove("PlayerInitialSpawn", "VoiceBox.FX.Init")
		include("voicebox_fx_config.lua")
	end
	hook.Add("postLoadCustomDarkRPItems", "VoiceBox.FX.Init", loadConfig)
	hook.Add("PlayerInitialSpawn", "VoiceBox.FX.Init", loadConfig)
end

hook.Run("VoiceBox.FX")