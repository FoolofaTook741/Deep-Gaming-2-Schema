if ChrononLabs ["ChrononLabs:SystemDispatcher"]:GetStateStatus (CLIENT) then
	return
end

local self   	= {}
local pairs 	= pairs
local tostring 	= tostring
local os		= os
local table		= table
local MsgC		= MsgC
local Color		= Color

function self:InternalId ()
	return "ChrononLabs:Diagnostics"
end

function self:Constructor ()
	-- Hook status tracking with their corresponding hook identifiers
	self.HookStatus = {
		PlayerInitialSpawn 		= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:BanDoubleCheck" },
		StartCommand 			= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:CmdPipeLineHandler" },
		PostEntityFireBullets 	= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:DriftSequencer" },
		PostEntityTakeDamage 	= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:DamageProcessor" },
		PlayerDeath 			= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:PlayerStateDT" },
		PlayerDisconnected 		= { fired = false, count = 0, last_fired = nil, errors = {}, hook_id = "ChrononLabs:PlayerStateDC" },
	}
	
	-- General error log
	self.ErrorLog = {}
	self.MaxErrorLog = 100

	self.BulletEventStats = { primary = 0, secondary = 0 }
	
	-- Server start time
	self.ServerStartTime = os.time ()
end

function self:IsHookRegistered (hookName)
	local status = self.HookStatus [hookName]
	if not status or not status.hook_id then
		return false
	end
	
	local hookTable = hook.GetTable ()
	if not hookTable or not hookTable [hookName] then
		return false
	end
	
	return hookTable [hookName] [status.hook_id] ~= nil
end

function self:MarkHookFired (hookName)
	local status = self.HookStatus [hookName]
	if status and not status.fired then
		status.fired = true
		status.count = status.count + 1
		status.last_fired = os.time ()
	end
end

function self:MarkBulletEvent (isSecondary)
	self.BulletEventStats = self.BulletEventStats or { primary = 0, secondary = 0 }

	if isSecondary then
		self.BulletEventStats.secondary = self.BulletEventStats.secondary + 1
	else
		self.BulletEventStats.primary = self.BulletEventStats.primary + 1
	end
end

function self:LogHookError (hookName, errorMessage)
	if self.HookStatus [hookName] then
		local errorEntry = {
			message = errorMessage,
			time = os.time ()
		}
		
		table.insert (self.HookStatus [hookName].errors, errorEntry)
		
		-- Limit errors per hook
		if #self.HookStatus [hookName].errors > 50 then
			table.remove (self.HookStatus [hookName].errors, 1)
		end
	end
	
	-- Also add to general error log
	self:LogError (hookName .. ": " .. errorMessage)
end

function self:LogError (errorMessage)
	local errorEntry = {
		message = errorMessage,
		time = os.time ()
	}
	
	table.insert (self.ErrorLog, errorEntry)
	
	if #self.ErrorLog > self.MaxErrorLog then
		table.remove (self.ErrorLog, 1)
	end
end

function self:GetUptime ()
	local uptime = os.time () - self.ServerStartTime
	local days = math.floor (uptime / 86400)
	local hours = math.floor ((uptime % 86400) / 3600)
	local minutes = math.floor ((uptime % 3600) / 60)
	local seconds = uptime % 60
	
	if days > 0 then
		return string.format ("%dd %dh %dm %ds", days, hours, minutes, seconds)
	elseif hours > 0 then
		return string.format ("%dh %dm %ds", hours, minutes, seconds)
	elseif minutes > 0 then
		return string.format ("%dm %ds", minutes, seconds)
	else
		return string.format ("%ds", seconds)
	end
end

function self:FormatTimestamp (timestamp)
	if not timestamp then
		return "Never"
	end
	
	local diff = os.time () - timestamp
	
	if diff < 60 then
		return string.format ("%d seconds ago", diff)
	elseif diff < 3600 then
		return string.format ("%d minutes ago", math.floor (diff / 60))
	elseif diff < 86400 then
		return string.format ("%d hours ago", math.floor (diff / 3600))
	else
		return os.date ("%Y-%m-%d %H:%M:%S", timestamp)
	end
end

function self:PrintDiagnostics (ply)
	local isConsole = not IsValid (ply)
	
	local function PrintLine (text, color)
		if isConsole then
			MsgC (color or Color (255, 255, 255), text .. "\n")
		else
			ply:PrintMessage (HUD_PRINTCONSOLE, text)
		end
	end
	
	local function PrintHeader (text)
		PrintLine ("")
		PrintLine ("========================================", Color (100, 200, 255))
		PrintLine ("  " .. text, Color (100, 200, 255))
		PrintLine ("========================================", Color (100, 200, 255))
	end
	
	-- Header
	PrintHeader ("ChrononLabs Diagnostics Report")
	PrintLine ("")
	PrintLine ("Server Uptime: " .. self:GetUptime (), Color (200, 200, 200))
	PrintLine ("Report Time: " .. os.date ("%Y-%m-%d %H:%M:%S"), Color (200, 200, 200))
	PrintLine ("")
	
	-- Hook Status
	PrintHeader ("Hook Status")
	PrintLine ("")
	
	local allHooksOk = true
	local hookOrder = {
		"PlayerInitialSpawn",
		"StartCommand",
		"PostEntityFireBullets",
		"PostEntityTakeDamage",
		"PlayerDeath",
		"PlayerDisconnected"
	}
	
	for _, hookName in ipairs (hookOrder) do
		local status = self.HookStatus [hookName]
		local isRegistered = self:IsHookRegistered (hookName)
		
		-- Determine status icon and color
		local statusIcon, statusColor
		if not isRegistered then
			statusIcon = "[FAIL]"
			statusColor = Color (255, 50, 50)
			allHooksOk = false
		elseif status.fired then
			statusIcon = "[OK]"
			statusColor = Color (100, 255, 100)
		else
			statusIcon = "[WAIT]"
			statusColor = Color (255, 200, 100)
			allHooksOk = false
		end
		
		local registeredText = isRegistered and "Yes" or "NO"
		
		local line = string.format (
			"%s %s - Registered: %s | Fired: %s | Count: %d | Last: %s",
			statusIcon,
			hookName,
			registeredText,
			status.fired and "Yes" or "No",
			status.count,
			self:FormatTimestamp (status.last_fired)
		)
		
		PrintLine (line, statusColor)
		
		-- Print errors for this hook if any
		if #status.errors > 0 then
			PrintLine ("    Errors (" .. #status.errors .. "):", Color (255, 150, 100))
			local errorsToShow = math.min (3, #status.errors)
			for i = #status.errors - errorsToShow + 1, #status.errors do
				local err = status.errors [i]
				PrintLine ("      - " .. err.message .. " (" .. self:FormatTimestamp (err.time) .. ")", Color (255, 100, 100))
			end
		end
	end
	
	PrintLine ("")
	
	-- Summary
	local hasRegistrationFailures = false
	local hasUnfiredHooks = false
	
	for _, hookName in ipairs (hookOrder) do
		local status = self.HookStatus [hookName]
		local isRegistered = self:IsHookRegistered (hookName)
		
		if not isRegistered then
			hasRegistrationFailures = true
		elseif not status.fired then
			hasUnfiredHooks = true
		end
	end
	
	if allHooksOk then
		PrintLine ("All monitored hooks are registered and have fired at least once.", Color (100, 255, 100))
	else
		if hasRegistrationFailures then
			PrintLine ("CRITICAL: Some hooks failed to register!", Color (255, 50, 50))
			PrintLine ("This indicates a Lua error occurred during hook.Add().", Color (255, 100, 100))
			PrintLine ("Check server console for Lua errors during startup.", Color (200, 200, 200))
			PrintLine ("")
		end
		
		if hasUnfiredHooks then
			PrintLine ("NOTE: Some hooks are registered but haven't fired yet.", Color (255, 200, 100))
			PrintLine ("This is normal if:", Color (200, 200, 200))
			PrintLine ("  - No players have joined (PlayerInitialSpawn, PlayerDisconnected)", Color (200, 200, 200))
			PrintLine ("  - No combat has occurred (PostEntityFireBullets, PostEntityTakeDamage, PlayerDeath)", Color (200, 200, 200))
		end
	end
	
	-- Bullet Events
	PrintHeader ("Bullet Events")
	PrintLine ("")

	local bulletStats = self.BulletEventStats or { primary = 0, secondary = 0 }
	local totalBulletEvents = bulletStats.primary + bulletStats.secondary

	PrintLine ("Primary bullet events (fired from the shooter): " .. bulletStats.primary, Color (200, 200, 200))
	PrintLine ("Secondary bullet events (re-fired/penetration): " .. bulletStats.secondary, Color (200, 200, 200))
	PrintLine ("")

	local constants = ChrononLabs ["ChrononLabs:Constants"]
	local filterEnabled = constants and constants.Config and constants.Config.FilterSecondaryBullets

	if totalBulletEvents == 0 then
		PrintLine ("No bullet events recorded yet. This is normal if no combat has occurred.", Color (200, 200, 200))
	elseif bulletStats.secondary == 0 then
		PrintLine ("No re-fired bullets detected. Shot statistics are reliable on this server.", Color (100, 255, 100))
	else
		local secondaryRatio = bulletStats.secondary / totalBulletEvents

		if filterEnabled then
			PrintLine (string.format (
				"Re-firing weapon base detected (%.0f%% of bullet events are secondary).",
				secondaryRatio * 100), Color (200, 200, 200))
			PrintLine ("FilterSecondaryBullets is ENABLED: shot statistics are protected.", Color (100, 255, 100))
		elseif bulletStats.secondary >= 10 and secondaryRatio >= 0.2 then
			PrintLine (string.format (
				"WARNING: This server's weapon base re-fires bullets (%.0f%% of bullet events are secondary).",
				secondaryRatio * 100), Color (255, 50, 50))
			PrintLine ("Per-tick hit registration remains correct, but shot statistics", Color (255, 100, 100))
			PrintLine ("(total_shots, misses, accuracy) are inflated by phantom bullet events.", Color (255, 100, 100))
			PrintLine ("To fix: set FilterSecondaryBullets = true in the Config table of", Color (255, 200, 100))
			PrintLine ("lua/chrononlabs/arch/constants.lua, then restart the server.", Color (255, 200, 100))
		else
			PrintLine (string.format (
				"Some secondary bullet events observed (%.0f%%). Occasional penetration or",
				secondaryRatio * 100), Color (255, 200, 100))
			PrintLine ("ricochet is normal; no action needed unless this ratio grows.", Color (255, 200, 100))
		end
	end

	-- Recent Errors
	if #self.ErrorLog > 0 then
		PrintHeader ("Recent Errors")
		PrintLine ("")
		
		local errorsToShow = math.min (10, #self.ErrorLog)
		for i = #self.ErrorLog - errorsToShow + 1, #self.ErrorLog do
			local err = self.ErrorLog [i]
			PrintLine (string.format ("[%s] %s", self:FormatTimestamp (err.time), err.message), Color (255, 150, 100))
		end
	else
		PrintLine ("")
		PrintLine ("No errors logged.", Color (100, 255, 100))
	end
	
	PrintLine ("")
	PrintHeader ("End of Diagnostics Report")
	PrintLine ("")
end

function self:RegisterConCommand ()
	concommand.Add ("chrononlabs_diagnosis", function (ply, cmd, args)
		if IsValid (ply) and not ply:IsSuperAdmin () then
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Player " .. ply:SteamName () .. " (" .. ply:SteamID () .. ") attempted to run chrononlabs_diagnosis")
			return
		end
		
		self:PrintDiagnostics (ply)
	end)
	
	concommand.Add ("chrononlabs_diagnosis_test", function (ply, cmd, args)
		if IsValid (ply) and not ply:IsSuperAdmin () then
			ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("Player " .. ply:SteamName () .. " (" .. ply:SteamID () .. ") attempted to run chrononlabs_diagnosis_test")
			return
		end
		
		self:RunHookTest (ply)
	end)
end

function self:RunHookTest (ply)
	local isConsole = not IsValid (ply)
	
	local function Log (msg)
		if isConsole then
			MsgC (Color (100, 200, 255), "[ChrononLabs Test] ", Color (255, 255, 255), msg .. "\n")
		else
			ply:PrintMessage (HUD_PRINTCONSOLE, "[ChrononLabs Test] " .. msg)
		end
	end
	
	Log ("Starting automated hook test...")
	Log ("This will spawn a bot and trigger all monitored hooks.")
	Log ("")
	
	-- Step 1: Spawn a bot (triggers PlayerInitialSpawn, StartCommand)
	Log ("Step 1: Spawning test bot...")
	local bot = player.CreateNextBot ("ChrononLabs_TestBot")
	
	if not IsValid (bot) then
		Log ("ERROR: Failed to create bot. Make sure you have bot slots available.")
		return
	end
	
	Log ("  Bot spawned: " .. bot:Nick ())
	
	-- Give bot time to fully initialize
	timer.Simple (0.5, function ()
		if not IsValid (bot) then
			Log ("ERROR: Bot became invalid after spawn. It may have been kicked by another addon or the server.")
			return
		end
		
		-- Step 2: Give bot a weapon and make them fire (triggers PostEntityFireBullets)
		Log ("Step 2: Giving bot a weapon and firing...")
		bot:StripWeapons ()
		bot:Give ("weapon_smg1")
		bot:SelectWeapon ("weapon_smg1")
		
		timer.Simple (0.2, function ()
			if not IsValid (bot) then 
				Log ("ERROR: Bot became invalid before firing. It may have been removed during weapon assignment.")
				return 
			end
			
			local weapon = bot:GetActiveWeapon ()
			if IsValid (weapon) then
				-- Fire a bullet manually to trigger PostEntityFireBullets
				local bullet = {
					Attacker = bot,
					Damage = 1,
					Force = 1,
					Num = 1,
					Tracer = 0,
					Dir = bot:GetAimVector (),
					Src = bot:GetShootPos (),
					Spread = Vector (0, 0, 0),
				}
				bot:FireBullets (bullet)
				Log ("  Bot fired weapon.")
			else
				Log ("  WARNING: Could not get bot weapon. weapon_smg1 may not be available on this server.")
			end
			
			-- Step 3: Damage the bot (triggers PostEntityTakeDamage)
			timer.Simple (0.2, function ()
				if not IsValid (bot) then
					Log ("ERROR: Bot became invalid before damage test. It may have been removed by the server.")
					return
				end
				
				Log ("Step 3: Applying damage to bot...")
				bot:SetHealth(100)
				local dmgInfo = DamageInfo ()
				dmgInfo:SetDamage (10)
				dmgInfo:SetDamageType (DMG_GENERIC)
				dmgInfo:SetAttacker (bot)
				dmgInfo:SetInflictor (bot)
				bot:TakeDamageInfo (dmgInfo)
				Log ("  Bot took 10 damage.")
				
				-- Step 4: Kill the bot (triggers PlayerDeath)
				timer.Simple (0.2, function ()
					if not IsValid (bot) then
						Log ("ERROR: Bot became invalid before kill test. The damage may have already killed it or it was removed.")
						return
					end
					
					Log ("Step 4: Killing bot...")
					bot:Kill ()
					Log ("  Bot killed.")
					
					-- Step 5: Kick the bot (triggers PlayerDisconnected)
					timer.Simple (0.5, function ()
						if not IsValid (bot) then
							Log ("Step 5: Bot already disconnected (removed after death).")
						else
							Log ("Step 5: Kicking bot...")
							bot:Kick ("ChrononLabs hook test complete")
							Log ("  Bot kicked.")
						end
						
						-- Final summary
						timer.Simple (0.5, function ()
							Log ("")
							Log ("Hook test complete! Run 'chrononlabs_diagnosis' to see results.")
						end)
					end)
				end)
			end)
		end)
	end)
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
