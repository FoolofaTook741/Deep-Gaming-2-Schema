Plutonic.Static = {}
Plutonic.Static.CachedSettings = {}
Plutonic.Static.Dirty = false
--- The core level functionality of Plutonic.
-- @module Framework
--- Empties the cache of all control data.
-- @realm client
-- @internal
function Plutonic.Framework.InvalidateControlCache()
	Plutonic.Static.CachedSettings = {}
	Plutonic.Static.Dirty = true -- We rebuild the cache on the next frame, and as needed.
end

--- Gets the value of a control.
-- @realm client
-- @string name The name of the control.
-- @treturn string The controls saved value.
function Plutonic.Framework.GetControl_Data(name)
	if Plutonic.Static.CachedSettings[name] == nil then
		Plutonic.Static.CachedSettings[name] = cookie.GetString("p0c0s0::" .. name, "")
	end

	return Plutonic.Static.CachedSettings[name] or ""
end

--- Gets the value of a control as a boolean.
-- @realm client
-- @string name The name of the control.
-- @bool[opt] default The default value of the control.
-- @treturn bool The controls saved value.
function Plutonic.Framework.GetControl_Bool(name, default)
	local Control_Data = Plutonic.Framework.GetControl_Data(name)
	if Control_Data == "" then
		Plutonic.Static.CachedSettings[name] = default

		return default
	end

	return Control_Data == "1"
end

--- Gets the value of a control as a number.
-- @realm client
-- @string name The name of the control.
-- @number[opt] default The default value of the control.
-- @treturn number The controls saved value.
function Plutonic.Framework.GetControl_Number(name, default)
	local Control_Data = Plutonic.Framework.GetControl_Data(name)
	if Control_Data == "" or tonumber(Control_Data) == nil then
		Plutonic.Static.CachedSettings[name] = default

		return default
	end

	return tonumber(Control_Data)
end

--- Gets the value of a control as a string.
-- @realm client
-- @string name The name of the control.
-- @string[opt] default The default value of the control.
-- @treturn string The controls saved value.
function Plutonic.Framework.GetControl_String(name, default)
	local Control_Data = Plutonic.Framework.GetControl_Data(name)
	if Control_Data == "" then
		Plutonic.Static.CachedSettings[name] = default

		return default
	end

	return Control_Data
end

--- Sets the value of a control.
-- @realm client
-- @string name The name of the control.
-- @param value The value to set the control to.
function Plutonic.Framework.SetControl(name, value)
	Plutonic.Static.CachedSettings[name] = value
	cookie.Set("p0c0s0::" .. name, value)
end

--- Sets the value of a control as a boolean.
-- @realm client
-- @string name The name of the control.
-- @bool value The value to set the control to.
function Plutonic.Framework.SetControl_Bool(name, value)
	Plutonic.Framework.SetControl(name, value and "1" or "0")
end

--- Sets the value of a control as a number.
-- @realm client
-- @string name The name of the control.
-- @number value The value to set the control to.
function Plutonic.Framework.SetControl_Number(name, value)
	Plutonic.Framework.SetControl(name, tostring(value))
end

--- Sets the value of a control as a string.
-- @realm client
-- @string name The name of the control.
-- @string value The value to set the control to.
function Plutonic.Framework.SetControl_String(name, value)
	Plutonic.Framework.SetControl(name, tostring(value))
end