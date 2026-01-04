Plutonic.Hooks = Plutonic.Hooks or {}
Plutonic.Hooks.Data = Plutonic.Hooks.Data or {}
Plutonic.Hooks.Add = function(hookName, callback)
	if Plutonic.Hooks.Data[hookName] then
		Plutonic.Framework.Print("Hook: " .. hookName .. " already exists. Overwriting...")
		Plutonic.Hooks.Remove(hookName)
	end

	Plutonic.Framework.Print("Hook: " .. hookName .. " added.")
	Plutonic.Hooks.Data[hookName] = callback
	hook.Add(hookName, "Plutonic.Hooks." .. hookName, callback)
end

Plutonic.Hooks.Remove = function(hookName)
	if not Plutonic.Hooks.Data[hookName] then
		Plutonic.Framework.Print("Hook: " .. hookName .. " does not exist!")

		return
	end

	Plutonic.Framework.Print("Hook: " .. hookName .. " removed.")
	hook.Remove(hookName, "Plutonic.Hooks." .. hookName)
end