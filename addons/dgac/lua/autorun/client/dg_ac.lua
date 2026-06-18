local setmetatable 	= _G.setmetatable

local function readonly(tab)
	return setmetatable({},{
		__index 	= tab,
		__newindex 	= function() end,
		__metatable = true
	})
end

local g = readonly {
	pairs				= _G.pairs,
	ipairs				= _G.ipairs,
	type 				= _G.type,
	LocalPlayer 		= _G.LocalPlayer,
	ConVarExists 		= _G.ConVarExists,
	GetConVarNumber 	= _G.GetConVarNumber,
	CurTime 			= _G.CurTime,
	tostring 			= _G.tostring,
	isfunction 			= _G.isfunction,
	istable 			= _G.istable,
	isstring 			= _G.isstring,
	require 			= _G.require,
	rawset 				= _G.rawset,
	rawget 				= _G.rawget,
	HTTP 				= _G.HTTP,
	ScrH 				= _G.ScrH,
	ScrW 				= _G.ScrW,
}

local timer = readonly {
	Destroy = _G.timer.Destroy,
	Create 	= _G.timer.Create,
	Simple 	= _G.timer.Simple,
	Exists  = _G.timer.Exists,
}

local file = readonly{
	Exists = _G.file.Exists
}

local table = readonly {
	insert = _G.table.insert,
}

local net = readonly {
	Start 			= _G.net.Start,
	WriteTable 		= _G.net.WriteTable,
	WriteString 	= _G.net.WriteString,
	ReadString 		= _G.net.ReadString,
	SendToServer 	= _G.net.SendToServer,
	Receive 		= _G.net.Receive
}

local debug = readonly {
	getinfo 	= _G.debug.getinfo,
	getupvalue 	= _G.debug.getupvalue,
}

local string = readonly {
	dump 	= _G.string.dump,
	find 	= _G.string.find,
	lower 	= _G.string.lower,
	char    = _G.string.char,
}

local render = readonly {
	Capture = _G.render.Capture,
}

local concommand = readonly {
	GetTable = _G.concommand.GetTable,
}

local hook = readonly {
	GetTable = _G.hook.GetTable,
	Add      = _G.hook.Add,
	Remove      = _G.hook.Remove,
}

local sha2 = readonly {
	hash256 = util.SHA256
}

g.rawset(_G.debug, 'setlocal', function() end)
g.rawset(_G.debug, 'getlocal', function() end)
g.rawset(_G.debug, 'setupvalue', function() end)

local function hashfunc(func)
	local info = debug.getinfo(func)
	return sha2.hash256(info.short_src .. info.source .. info.what)
end

local bad_terms = {'cheat', 'hack', 'bypass', 'nospread', 'aim', 'aimbot', 'exploit', 'fakeqacpart', 'horizon', 'blacksmurf', 'xray', 'defqon', 'smeghack'}

local whitelist = {
	"iaccheaterlog",
	"lvs_mouseaim_toggle",
	"lvs_",
}

local function is_whitelisted_string_lower(lowered)
	for _, w in g.ipairs(whitelist) do
		if string.find(lowered, w, 1, true) then
			return true
		end
	end
	return false
end

local function isbadstring(str)
	if not str then return false end
	local lowered = string.lower(str)

	if is_whitelisted_string_lower(lowered) then
		return false
	end

	for k, v in g.ipairs(bad_terms) do
		if string.find(lowered, v, 1, true) then
			return true
		end
	end

	return false
end

local function RandomString( intMin, intMax )
	local ret = ""
	for _ = 1, math.random( intMin, intMax ) do
		ret = ret.. string.char( math.random(65, 90) )
	end

	return ret
end

local detections 	= {}
local to_scan 		= {}
local timer_id 		= RandomString(5, 10)
local hs            = RandomString( 5, 10 )

local function detect(id, typ)
	table.insert(detections, {_id = id, _type = typ})
end

local function scan(callback)
	table.insert(to_scan, callback)
end

timer.Create(timer_id, 60, 0, function()
	for k, v in g.ipairs(to_scan) do
		v()
	end
	if (#detections > 0) then
		net.Start('ac.detect')
		net.WriteTable(detections)
		net.SendToServer()
	end
end)

local protected_libs = {'debug', 'render', 'cvars', 'concommand', 'timer', 'file', 'net', 'table', 'hook', 'jit', 'sha2'}

local lib_whitelist = {
	debug = { setlocal = true, getlocal = true, setupvalue = true },
	hook  = { remove = true, add = true},
	concommand = {},
	timer = {},
	file = {},
	net = {},
	table = {},
	string = {},
	render = {},
	sha2 = {}
}

local protected_functions = {'GetConVar', 'GetConVarNumber', 'GetConVarString', 'RunConsoleCommand', 'setfenv', 'getfenv', 'rawset', 'RunString', 'RunStringEx', 'CompileString', 'CompileFile'}
local lib_lookup = {}
local g_lookup = {}
for _, name in g.ipairs(protected_libs) do
	lib_lookup[name] = {}
	local raw = g.rawget(_G, name)
	if g.istable(raw) then
		for k, v in g.pairs(raw) do
			if g.isfunction(v) then
				lib_lookup[name][tostring(k)] = hashfunc(v)
			end
		end
	end
end

for k, v in g.ipairs(protected_functions) do
	g_lookup[v] = hashfunc(g.rawget(_G, v))
end

scan(function()
	for _, lib in g.ipairs(protected_libs) do
		local raw = g.rawget(_G, lib)
		for k, v in g.pairs(raw) do
			if g.isfunction(v) and (lib_lookup[lib][tostring(k)] ~= nil) and (hashfunc(v) ~= lib_lookup[lib][tostring(k)]) then
				local fname = tostring(k)
				local libwl = lib_whitelist[lib]
				if not (libwl and libwl[string.lower(fname)]) then
					print("[DG AC DEBUG] Detected Lib change:", lib, fname)
					detect(1, "Lib changes")
					break
				end
			end
		end
	end
end)

scan(function()
	for k, v in g.pairs(g_lookup) do
		if (hashfunc(g.rawget(_G, k)) ~= v) then
			detect(1, "Lib changes")
			break
		end
	end
end)

local protected_convars = {
	{'sv_cheats', 0},
	{'host_timescale', 1},
	{'mat_wireframe', 0},
	{'mat_fullbright', 0}
}
scan(function()
	for k, v in g.ipairs(protected_convars) do
		if (not g.ConVarExists(v[1])) or (g.GetConVarNumber(v[1]) ~= v[2]) then
			detect(2, v[1] .. " - " .. g.GetConVarNumber(v[1]))
		end
	end
end)

local markers = {"Lenny","GDAAP_CLIENT_INTERFACE","R8","MOTDgd","lmfao1","iZNX","odium","Betrayed","BackdoorLaunch","toxic","ValidNetString","Bhop","LoadSmegHack","UnloadSmegHack","ReloadSmegHack","SmegHack","IdiotBox","FAUCHEUSE"}
scan(function()
	for _, name in ipairs(markers) do
		if _G[name] ~= nil then
			detect(3, name)
		end
	end
end)

local bad_commands = {
	['phack_lua_reload'] = true,
	['mapex_dancin'] = true,
	['mapex_esp'] = true,
	['mapex_allents'] = true,
	['mapex_wall'] = true,
	['sasha_menu'] = true,
	['0_u_found'] = true,
	['external'] = true,
	['aspire_reload'] = true,
	['cs_unload'] = true,
	['cs_load'] = true,
	['xhack_menu'] = true,
	['r8_menu'] = true,
	['exploits_open'] = true,
	['music_troll'] = true,
	['blacksmurf_noclip'] = true,
	['ace_menu'] = true,
	['ace_ents'] = true,
	['ace_players'] = true,
	['betrayed_open'] = true,
	['betrayed_configs'] = true,
	['betrayed_exploit'] = true,
	['toxic.pro'] = true,
	['defqon_bigmenu'] = true,
	['smeghack_menu'] = true,
	['lua_view_cl'] = true,
	['rainbow'] = true,
	['_z_open'] = true,
}

scan(function()
	for k, v in g.pairs(concommand.GetTable()) do
		if bad_commands[k:lower()] then
			detect(4, "Blacklisted command: " .. k:lower())
		elseif isbadstring(k) then
			detect(4, "BadString in command " .. k)
			break
		end
	end
end)

scan(function()
	for _, hooks in g.pairs(hook.GetTable()) do
		for k, v in g.pairs(hooks) do
			if g.isstring(k) and isbadstring(k) then
				detect(5, "BadString in hook " .. k)
				break
			end
		end
	end
end)

local bad_timers = {
	["lovedarkexploitsxd"] = true,
	["exploit_revive"] = true,
	["1tap"] = true,
	["blacksmurf_exploit_money"] = true,
	["blacksmurf_exploit_shekels"] = true,
	["blacksmurf_exploit_errorz"] = true,
	["chatspam1"] = true,
}

scan(function()
	for k, v in g.pairs(bad_timers) do
		if timer.Exists(k) then
			detect(6, "BadTimer: ".. k)
		end
	end
end)

local bad_dll = {
	["gmcl_aaa_win32.dll"] = true,
	["gmcl_bsendpacket_win32.dll"] = true,
	["gmcl_dickwrap_win32.dll"] = true,
	["gmcl_fhook_win32.dll"] = true,
	["gm_No_core.dll"] = true,
	["gm_No_fvar.dll"] = true,
	["gmcl__nyx_win32.dll"] = true,
	["gmcl_autism_win32.dll"] = true,
	["gmcl_BridgeHack_win32.dll"] = true,
	["gmcl_Dead_win32.dll"] = true,
	["gmcl_external_win32.dll"] = true,
	["gmsv_stringtable_win32"] = true,
	["gmsv_luamio_win32.dll"] = true,
	["gmcl_stringtables_win32.dll"] = true,
	["gmcl_nspred_win32.dll"] = true,
	["gmcl_spreadthebutter_win32.dll"] = true,
	["gmcl_svm_win32.dll"] = true,
}

scan(function()
	for k, v in g.pairs(bad_dll) do
		if file.Exists('bin/' .. k, 'LUA') then
			detect(7, "BadDll: ".. k)
		end
	end
end)
