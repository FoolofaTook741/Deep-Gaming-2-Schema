if hook.Author ~= "Srlion" then
	GAS:print("WARNING: Srlion's hooking library not installed. Shit might not work properly.", GAS_PRINT_COLOR_BAD, GAS_PRINT_TYPE_WARN)
end

GAS.Hooking = {}

--# Superior hooking #--
-- "call my hooks before any others, and override their return value(s) with mine"

function GAS.Hooking:SuperiorHook(hook_name, identifier, func)
	hook.Add(hook_name, "gmodadminsuite:" .. identifier, func, PRE_HOOK_RETURN or HOOK_MONITOR_HIGH)
end

--# Feedback hooking #--
-- "call others' hooks before mine, but pass their return value(s) to my hook function and override their return value(s) with mine"

function GAS.Hooking:FeedbackHook(hook_name, identifier, func)
	hook.Add(hook_name, "gmodadminsuite:" .. identifier, func, POST_HOOK_RETURN)
end

--# Inferior hooking #--
-- "call others' hooks before mine, and override my return value(s) with theirs"

function GAS.Hooking:InferiorHook(hook_name, identifier, func)
	hook.Add(hook_name, "gmodadminsuite:" .. identifier, func, POST_HOOK or HOOK_MONITOR_LOW)
end

--# Observer hooking #--
-- "call my hook before anything else, but don't allow it to override any return values"

function GAS.Hooking:ObserverHook(hook_name, identifier, func)
	hook.Add(hook_name, "gmodadminsuite:" .. identifier, func, PRE_HOOK or HOOK_MONITOR_HIGH)
end

-- backwards compatibility with old hooking lib
GAS.InferiorHook = GAS.Hooking.InferiorHook
GAS.SuperiorHook = GAS.Hooking.SuperiorHook
