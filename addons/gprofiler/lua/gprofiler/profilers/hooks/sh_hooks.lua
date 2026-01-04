GProfiler.Hooks = GProfiler.Hooks or {}
GProfiler.Hooks.IsDetoured = GProfiler.Hooks.IsDetoured or false
GProfiler.Hooks.ProfileData = GProfiler.Hooks.ProfileData or {}
GProfiler.Hooks.RestoreHookTable = GProfiler.Hooks.RestoreHookTable or {}

local SysTime = SysTime
local unpack = unpack
local debug = debug

function GProfiler.Hooks:StartProfiler(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or GProfiler.Hooks.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " hook profiler started!", 2)
	GProfiler.Hooks.ProfileData = {}
	GProfiler.Hooks.IsDetoured = true
	GProfiler.Hooks.ProfileStarted = SysTime()
	GProfiler.Hooks.AddHook = GProfiler.Hooks.AddHook or hook.Add

	local function profileHook(hookName, receiverName, receiverFunc, ...)
		if type(receiverName) ~= "string" or type(receiverFunc) ~= "function" then return end
		local dataIdent = string.format("%s_%s", hookName, receiverName)
		GProfiler.Hooks.ProfileData[dataIdent] = {
			h = hookName,
			r = receiverName,
			c = 0,
			t = 0,
			f = receiverFunc,
			extra = {...}
		}

		local hookTbl = GProfiler.Hooks.ProfileData[dataIdent]

		local Source = debug.getinfo(receiverFunc, "S")
		if Source and Source.short_src and Source.linedefined and Source.lastlinedefined then
			hookTbl.Source = Source.short_src
			hookTbl.Lines = { Source.linedefined, Source.lastlinedefined }
		end

		GProfiler.Hooks.AddHook(hookName, receiverName, function(...)
			local startTime = SysTime()
			local result = { receiverFunc(...) }
			local endTime = SysTime()
			local deltaTime = endTime - startTime

			hookTbl.c = hookTbl.c + 1
			hookTbl.t = hookTbl.t + deltaTime

			return unpack(result)
		end, ...)
	end

	for hookName, hookReceivers in pairs(hook.GetTable()) do
		for receiverName, receiverFunc in pairs(hookReceivers) do
			profileHook(hookName, receiverName, receiverFunc)
		end
	end

	hook.Add = function(hookName, receiverName, receiverFunc, ...)
		profileHook(hookName, receiverName, receiverFunc, ...)
	end
end

hook.Add("testhook", "testreceiver", function() end)
timer.Create("testhook", .1, 0, function() hook.Run("testhook") end)

function GProfiler.Hooks:RestoreHooks(ply)
	if not GProfiler.Access.HasAccess(ply or LocalPlayer()) or not GProfiler.Hooks.IsDetoured then return end

	GProfiler.Log((SERVER and "Server" or "Client") .. " hook profile stopped, sending data!", 2)
	GProfiler.Hooks.IsDetoured = false
	GProfiler.Hooks.ProfileStarted = nil

	hook.Add = GProfiler.Hooks.AddHook

	for hookName, hookReceivers in pairs(hook.GetTable()) do
		for receiverName, receiverFunc in pairs(hookReceivers) do
			if type(receiverName) ~= "string" or type(receiverFunc) ~= "function" then continue end
			local data = GProfiler.Hooks.ProfileData[string.format("%s_%s", hookName, receiverName)]
			if data then
				-- 36e28b0189c43e68a03e0d502ae38f466e68be55e9c7ffde39904e4373fc9a75
				hook.Add(hookName, receiverName, data.f, unpack(data.extra or {}))
			end
		end
	end

	if CLIENT then return end

	for k, v in pairs(GProfiler.Hooks.ProfileData) do
		if v.c == 0 then
			GProfiler.Hooks.ProfileData[k] = nil
		end
	end

	local Count = table.Count(GProfiler.Hooks.ProfileData)
	if GProfiler.ExpressAvailable() and Count > GProfiler.Config.ExpressMinimumResults-1 and Count > 0 then
		local Data = {}
		for k, v in pairs(GProfiler.Hooks.ProfileData) do
			Data[k] = v
			v.f = nil
		end

		express.Send("GProfiler_Hooks_SendData", Data, ply)
	else
		net.Start("GProfiler_Hooks_SendData")
		net.WriteUInt(Count, 20)
		local i = 0
		for k, v in pairs(GProfiler.Hooks.ProfileData) do
			i = i + 1
			if i >= 1048574 then break end
			net.WriteString(v.r)
			net.WriteString(v.h)
			net.WriteUInt(tonumber(v.c) or 0, 32)
			net.WriteFloat(tonumber(v.t) or 0)
			net.WriteString(v.Source or "")
			net.WriteUInt(v.Lines and v.Lines[1] or 0, 16)
			net.WriteUInt(v.Lines and v.Lines[2] or 0, 16)
		end
		net.Send(ply)
	end
end

if SERVER then
	util.AddNetworkString("GProfiler_Hooks_ToggleServerProfile")
	util.AddNetworkString("GProfiler_Hooks_ServerProfileStatus")
	util.AddNetworkString("GProfiler_Hooks_SendData")
	util.AddNetworkString("GProfiler_Hooks_HookTbl")
	util.AddNetworkString("GProfiler_Hooks_RemoveHook")

	net.Receive("GProfiler_Hooks_ToggleServerProfile", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		if net.ReadBool() then
			GProfiler.Hooks:StartProfiler(ply)
			net.Start("GProfiler_Hooks_ServerProfileStatus")
			net.WriteBool(true)
			net.WriteEntity(ply)
			net.Broadcast()
		else
			GProfiler.Hooks:RestoreHooks(ply)
			net.Start("GProfiler_Hooks_ServerProfileStatus")
			net.WriteBool(false)
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end)

	net.Receive("GProfiler_Hooks_HookTbl", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local hooks = hook.GetTable()
		net.Start("GProfiler_Hooks_HookTbl")
		net.WriteUInt(table.Count(hooks), 15)
		for hookName, hookReceivers in pairs(hooks) do
			net.WriteString(hookName)
			net.WriteUInt(table.Count(hookReceivers), 10)
		end
		net.Send(ply)
	end)

	net.Receive("GProfiler_Hooks_RemoveHook", function(len, ply)
		if not GProfiler.Access.HasAccess(ply) then return end

		local hookName = net.ReadString()
		local receiverName = net.ReadString()

		if not hookName or not receiverName then return end

		hook.Remove(hookName, receiverName)
	end)
end
