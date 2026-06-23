
impulse.chatCommands = impulse.chatCommands or {}
impulse.chatClasses = impulse.chatClasses or {}

function impulse.RegisterChatCommand(name, cmdData)
	if not cmdData.adminOnly then cmdData.adminOnly = false end
	if not cmdData.leadAdminOnly then cmdData.leadAdminOnly = false end
	if not cmdData.superAdminOnly then cmdData.superAdminOnly = false end
	if not cmdData.gameMasterOnly then cmdData.gameMasterOnly = false end
	if not cmdData.description then cmdData.description = "" end
	if not cmdData.requiresArg then cmdData.requiresArg = false end
	if not cmdData.requiresAlive then cmdData.requiresAlive = false end

    impulse.chatCommands[name] = cmdData
end

if SERVER then
	util.AddNetworkString("impulseChatNetMessage")
	function meta:SendChatClassMessage(id, message, target)
		local idx = IsValid(target) and target:EntIndex() or 0
		net.Start("impulseChatNetMessage")
		net.WriteUInt(id, 8)
		net.WriteString(message)
		net.WriteUInt(idx, 8)
		net.Send(self)
	end
else
	function impulse.RegisterChatClass(id, onReceive)
		impulse.chatClasses[id] = onReceive
	end
end

local oocCol = color_white
local oocTagCol = Color(200, 0, 0)
local yellCol = Color(255, 140, 0)
local whisperCol = Color(65, 105, 225)
local infoCol = Color(135, 206, 250)
local talkCol = Color(255, 255, 100)
local radioCol = Color(0, 148, 255)
local ctaCol = Color(100, 100, 100)
local cpCol = Color(0, 255, 255)
local caCol = Color(255, 0, 0)
local pmCol = Color(45, 154, 6)

impulse.RegisterChatCommand("/toggleraise", {
    description = "Raise or lower your weapon with a command.",
    onRun = function(ply)
		timer.Simple(0.5, function()
			ply:ToggleWeaponRaised()
		end)
    end
})

local oocCommand = {
    description = "Talk out of character globally.",
    requiresArg = true,
    onRun = function(ply, arg, rawText)
        if impulse.OOCClosed and (!ply:IsSuperAdmin() and !ply:IsLeadAdmin() and !ply:IsAdmin()) then
            return ply:Notify("OOC chat has been suspended by the game moderators and will return shortly.")
        end

        local steamID = ply:SteamID()
        local curTime = CurTime()

        local timeout = impulse.OOCTimeouts[steamID]
        if timeout and timeout > curTime then
            return ply:Notify("You have an active OOC timeout for "..string.NiceTime(timeout - curTime)..".")
        end

        ply.OOCMessages = ply.OOCMessages or {}
        local messages = ply.OOCMessages

        local spamThreshold = 4 -- how many messages to send
        local spamWindow = 5 -- before 5 seconds is up to consider spamming (so its 4 messages in 5 seconds it'll mute them)
        local muteDuration = 600

        table.insert(messages, curTime)

        for i = #messages, 1, -1 do
            if curTime - messages[i] > spamWindow then
                table.remove(messages, i)
            end
        end

        if #messages >= spamThreshold and not ply:IsAdmin() then
            impulse.OOCTimeouts[steamID] = curTime + muteDuration
            ply.OOCLimit = 0

            ply:Notify("Reason: Spamming OOC chat.")
            ply:Notify("You have been issued an OOC communication timeout for 10 minutes due to spamming.")

            timer.Create("impulseOOCTimeout"..steamID, muteDuration, 1, function()
                if not impulse.OOCTimeouts[steamID] then return end

                impulse.OOCTimeouts[steamID] = nil

                if IsValid(ply) then
                    ply:Notify("Your OOC communication timeout has expired. You may now use OOC again. Please review the community guidelines before sending messages again.")
                end
            end)

            for _, k in pairs(player.GetAll()) do
                k:AddChatText(Color(255, 100, 100), ply:SteamName().." has been timed out by automod for 10 minutes.")
            end

            net.Start("opsGiveOOCBan")
            net.WriteUInt(os.time() + muteDuration, 16)
            net.Send(ply)

            return
        end

        ply.OOCLimit = ply.OOCLimit or ((ply:IsDonator() and impulse.Config.OOCLimitVIP) or impulse.Config.OOCLimit)
        local timeLeft = timer.TimeLeft(ply:UserID().."impulseOOCLimit")

        if ply.OOCLimit < 1 and not ply:IsAdmin() then
            return ply:Notify("You have run out of OOC messages. Wait "..string.NiceTime(timeLeft).." for more.")
        end

        for _, k in pairs(player.GetAll()) do
            k:SendChatClassMessage(2, rawText, ply)
        end

        ply.OOCLimit = ply.OOCLimit - 1

        net.Start("impulseUpdateOOCLimit")
        net.WriteUInt(timeLeft or 0, 16)
        net.WriteBool(false)
        net.Send(ply)

        hook.Run("ProcessOOCMessage", rawText)
    end
}

impulse.RegisterChatCommand("/ooc", oocCommand)
impulse.RegisterChatCommand("//", oocCommand)

local loocCommand = {
	description = "Talk out of character locally.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if ply.hasOOCTimeout then
			return ply:Notify("You have an active OOC timeout that will remain for "..string.NiceTime(ply.hasOOCTimeout - CurTime())..".")
		end

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(3, rawText, ply)
			end
		end

		hook.Run("ProcessOOCMessage", rawText)
	end
}

impulse.RegisterChatCommand("/looc", loocCommand)
impulse.RegisterChatCommand("//.", loocCommand)

local pmCommand = {
	description = "Directly messages the player specified.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		local name = arg[1]
		local message = string.sub(rawText, (string.len(name) + 2))
		message = string.Trim(message)

		if not message or message == "" then
			return ply:Notify("Invalid argument.")
		end

		local plyTarget = impulse.FindPlayer(name)

		if plyTarget and ply != plyTarget then
			plyTarget:SendChatClassMessage(4, message, ply, plyTarget)
			plyTarget.PMReply = ply

			ply:SendChatClassMessage(5, message, plyTarget, ply)
		else
			return ply:Notify("Could not find player: "..tostring(name))
		end

		for k,v in pairs(player.GetAll()) do 
			if v.SnooperMode == true then
				v:SendChatClassMessage(4, message, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/pm", pmCommand)

local replyCommand = {
	description = "Replies to the last player who directly messaged you.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		local message = rawText

		if not message or message == "" then
			return ply:Notify("Invalid argument.")
		end

		if not ply.PMReply or not IsValid(ply.PMReply) then
			return ply:Notify("Target not found.")
		end

		local plyTarget = ply.PMReply

		if plyTarget and ply != plyTarget then
			plyTarget:SendChatClassMessage(4, message, ply)
			plyTarget.PMReply = ply

			ply:SendChatClassMessage(5, message, ply)
		end
	end
}

impulse.RegisterChatCommand("/reply", replyCommand)

local yellCommand = {
	description = "Yell in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 6, rawText, ply) or rawText

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.YellDistance ^ 2) or k.SnooperMode == true then 
				k:SendChatClassMessage(6, rawText, ply)
			end
		end
		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						rawText = "*YELLING* " .. rawText
						v:SendChatClassMessage(74, rawText, ply)
					else
						rawText = "*SIGNAL JAMMED*"
						v:SendChatClassMessage(74, "*SIGNAL JAMMED*", ply)
					end
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/y", yellCommand)

local whisperCommand = {
	description = "Whisper in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 7, rawText, ply) or rawText

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.WhisperDistance ^ 2) or k.SnooperMode == true then 
				k:SendChatClassMessage(7, rawText, ply)
			end
		end

		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						v:SendChatClassMessage(74, "*whispering* ", rawText, ply)
					else
						v:SendChatClassMessage(74, "*SIGNAL JAMMED*", ply)
					end
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/w", whisperCommand)

local radioCommand = {
	description = "Send a radio message to all units.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if impulse.CommsNetWorkOn == false or ply.IsRogue then
			ply:Notify("The radio is not available at this time.")
		else
			rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText
			if (not ply:GetTeamRank() and ply:Team() == TEAM_CP) or (not ply:GetTeamRank() and ply:Team() == TEAM_OTA )then
				ply:Notify("You cannot use this as an unranked unit.")
				return
			end
			if ply:IsCP() then
				for v,k in pairs(player.GetAll()) do
					if ((k:IsCP() or (k:GetPos():Distance(ply:GetPos()) < 100 and k != ply)) and not k.IsRogue) or k.SnooperMode == true then 
						k:SendChatClassMessage(8, rawText, ply)
					end
				end
				ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
			else
				hook.Run("RadioMessageFallback", ply, rawText)
			end
		end
	end
}

impulse.RegisterChatCommand("/radio", radioCommand)
impulse.RegisterChatCommand("/r", radioCommand)

local meCommand = {
	description = "Perform an action in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) or k.SnooperMode == true then 
				k:SendChatClassMessage(10, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/me", meCommand)

local itCommand = {
	description = "Perform an action from a third party.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) or k.SnooperMode == true then 
				k:SendChatClassMessage(9, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/it", itCommand)

local advertCommand = {
	description = "Broadcasts the advert provided.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:Team() != TEAM_CWU then 
			return ply:Notify("Your team cannot make an advert.") 
		end

		local rank = ply:GetTeamRank()
        if not rank or rank < RANK_EMPLOYEE then
            ply:Notify("You must be an employee to advert.") 
            return
        end

		timer.Simple(15, function()
			if IsValid(ply) and ply:IsPlayer() then
				for v,k in pairs(player.GetAll()) do
					k:SendChatClassMessage(14, rawText, ply)
				end
			end
		end)

		ply:Notify("Your advert has been sent and will be broadcast shortly.")
	end
}

impulse.RegisterChatCommand("/advert", advertCommand)

local rollCommand = {
    description = "Generate a random number between 0 and whatever number you enter.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        local s = tostring(arg[1] or ""):Trim()

        if not s:match("^%d+$") then
            ply:Notify("Usage: /roll <number> (Digits only, max 10000).")
            return
        end

        local max = tonumber(s)
        if not max then
            ply:Notify("Invalid number.")
            return
        end

        if max > 10000 then
            ply:Notify("The max number is 10000.")
            return
        end

        local result = math.random(0, max)
        local rollResult = tostring(result) .. " (0 - " .. max .. ")."

        local distSqr = impulse.Config.TalkDistance ^ 2
        for _, k in ipairs(player.GetAll()) do
            if (ply:GetPos() - k:GetPos()):LengthSqr() <= distSqr then
                k:SendChatClassMessage(11, rollResult, ply)
            end
        end
    end
}

impulse.RegisterChatCommand("/roll", rollCommand)

local dropMoneyCommand = {
	description = "Drops the specified amount of money on the floor.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if arg[1] and tonumber(arg[1]) then
			local value = math.floor(tonumber(arg[1]))
			if ply:CanAfford(value) and value > 0 then
				ply:TakeMoney(value)

				local trace = {}
				trace.start = ply:EyePos()
				trace.endpos = trace.start + ply:GetAimVector() * 85
				trace.filter = ply

				local tr = util.TraceLine(trace)
				local note = impulse.SpawnMoney(tr.HitPos, value, ply)

				ply.DroppedMoneyC = math.Clamp((ply.DroppedMoneyC and ply.DroppedMoneyC + 1) or 1, 0, impulse.Config.DroppedMoneyLimit)
				ply.DroppedMoney = ply.DroppedMoney or {}
				ply.DroppedMoneyCA = (ply.DroppedMoneyCA and ply.DroppedMoneyCA + 1) or 1

				ply.DroppedMoney[ply.DroppedMoneyCA] = note
				note.DropKey = ply.DroppedMoneyCA

				if ply.DroppedMoneyC == impulse.Config.DroppedMoneyLimit then
					for v,k in pairs(ply.DroppedMoney) do
						if k and IsValid(k) then
							k:Remove()
							break
						end
					end
				end

				hook.Run("PlayerDropMoney", ply, note)
				ply:Notify("You have dropped "..impulse.Config.CurrencyPrefix..value..".")
			else
				return ply:Notify("You cannot afford to drop that amount of money.")
			end
		else
			return ply:Notify("Invalid argument.")
		end
	end
}

impulse.RegisterChatCommand("/dropmoney", dropMoneyCommand)

local writeCommand = {
	description = "Writes a letter with the text specified.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, args, text)
		if ply.letterCount and ply.letterCount > impulse.Config.MaxLetters then
			ply:Notify("You have reached the max amount of letters.")
			return
		end

		if string.len(text) > 900 then
			ply:Notify("Letter max character limit reached. (900)")
			return
		end

		text = impulse.SafeString(text)

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)

		local letter = ents.Create("impulse_letter")
		letter:SetPos(tr.HitPos)
		letter:SetText(text)
		letter:SetPlayerOwner(ply)
		letter:Spawn()

		undo.Create("letter")
		undo.AddEntity(letter)
		undo.SetPlayer(ply)
		undo.Finish()

		for v,k in pairs(player.GetAll()) do
			if k.SnooperMode then
				k:AddChatText(Color(135, 206, 235), "[ops] Player "..ply:SteamName().." wrote a letter that says: "..text..".")
			end
		end
	end
}

impulse.RegisterChatCommand("/write", writeCommand)

local setscsCommand = {
	description = "Sets the sterilized credits of a user.",
	requiresArg = true,
	requiresAlive = true,
	superAdminOnly = true,
	onRun = function(ply, args, text)
		local targ = impulse.FindPlayer(args[1])
		local amount = tonumber(text)
		if amount and amount > 3000 and ply:SteamID() != "STEAM_0:0:104958683" then
			ply:Notify("Max per allotment: 3000.")
			return
		end 
		if amount then
			targ:SetSCs(amount)
			return
		end
		ply:Notify("Invalid amount.")
	end
}

impulse.RegisterChatCommand("/setscs", setscsCommand)

local searchCommand = {
    description = "Searches a players inventory.",
    requiresArg = false,
    requiresAlive = true,
    onRun = function(ply, args, text)
        if not ply:IsCP() then return end
        if ply.InvSearching and IsValid(ply.InvSearching) then return end

        local trace = {}
        trace.start = ply:EyePos()
        trace.endpos = trace.start + ply:GetAimVector() * 50
        trace.filter = ply

        local tr = util.TraceLine(trace)
        local targ = tr.Entity

        if targ and IsValid(targ) and targ:IsPlayer() and targ:OnGround() then
            if not targ.beenInvSetup then return end

            if not ply:CanArrest(targ) then
                return ply:Notify("You cannot search this player.")
            end

            if not targ:GetSyncVar(SYNC_ARRESTED, false) then
                return ply:Notify("You must detain a player before searching them.")
            end

            targ:Freeze(true)
            targ:Notify("You are currently being searched.")
            ply:Notify("You have started searching "..targ:Nick()..".")
            ply.InvSearching = targ
            hook.Run("DoInventorySearch", ply, targ)

            local inv = targ:GetInventory(1) or {}

            net.Start("impulseInvDoSearch")
                net.WriteUInt(targ:EntIndex(), 8)
                net.WriteUInt(table.Count(inv), 16)
                net.WriteUInt(math.Clamp(tonumber(targ:GetMoney()) or 0, 0, 65535), 16)

                for invid, slot in pairs(inv) do
                    local netid = slot and slot.class and impulse.Inventory.ClassToNetID(slot.class)
                    if netid then
                        net.WriteUInt(netid, 10)
                        net.WriteUInt(invid, 16)
						net.WriteBool(slot.restricted == true)
                    end
                end
            net.Send(ply)
        else
            ply:Notify("No player in search range.")
        end
    end
}

impulse.RegisterChatCommand("/invsearch", searchCommand)

local eventCommand = {
	description = "Sends a global chat message to all players. Only for use in events.",
	gameMasterOnly = true,
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ply:IsGameMaster() then
			ply:Notify("You must be a gamemaster or staff team member to use this command.")
			return
		else
			for v,k in pairs(player.GetAll()) do
				k:SendChatClassMessage(12, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/event", eventCommand)

local adminannounceCommand = {
	description = "Sends a global chat message to all players. Only for use in events.",
	adminOnly = true,
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ply:IsGameMaster() then
			ply:Notify("You must be an admin to use this command.")
			return
		else
			for v,k in pairs(player.GetAll()) do
				k:SendChatClassMessage(167, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/adminannouncement", adminannounceCommand)

local gmChatCommand = {
	description = "Sends a chat message to all gamemasters.",
	gameMasterOnly = true,
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ply:IsGameMaster() then
			ply:Notify("You must be a gamemaster or staff team member to use this command.")
			return
		else
			for v,k in pairs(player.GetAll()) do
				if k:IsGameMaster() then
					k:SendChatClassMessage(165, rawText, ply)
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/gmc", gmChatCommand)

local managerChatCommand = {
	description = "Sends a chat message to all managers.",
	leadAdminOnly = true,
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ply:IsLeadAdmin() then
			ply:Notify("You must be a manager to use this command.")
			return
		else
			for v,k in pairs(player.GetAll()) do
				if k:IsLeadAdmin() then
					k:SendChatClassMessage(166, rawText, ply)
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/mc", managerChatCommand)


local groupChatCommand = {
	description = "Sends a message to members of your group.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if ply:Alive() == false then
			ply:Notify("You must be alive to use this command.")
			return
		end
		if ply:IsCP() or ply:Team() == TEAM_ZOMBIE then
			ply:Notify("Combine/Zombies cannot use this command.")
			return
		end
		local group = ply:GetSyncVar(SYNC_GROUP_NAME, nil)


		for v,k in pairs(player.GetAll()) do
			if (k:GetSyncVar(SYNC_GROUP_NAME, "") == group and not k:IsCP()) and k:Team() != TEAM_ZOMBIE or k.SnooperMode then
				k:SendChatClassMessage(15, rawText, ply)
			end
		end

		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						v:SendChatClassMessage(74, rawText, ply)
					else
						rawText = "*SIGNAL JAMMED*"
						v:SendChatClassMessage(74, rawText, ply)
					end
				end
			end
		end
	end
}

impulse.RegisterChatCommand("/group", groupChatCommand)
impulse.RegisterChatCommand("/g", groupChatCommand)

impulse.RegisterChatCommand("/unshackle", {
    description = "Removes shackles from a vortigaunt by Steam ID.",
    leadAdminOnly = true,
    requiresArg = true,
    onRun = function(ply, args, rawText)
        local targetSID = args[1]

        if not targetSID then
            ply:Notify("Usage: /unshackle <steamid>")
            return
        end

        local target = nil
        for _, p in pairs(player.GetAll()) do
            if p:SteamID() == targetSID then
                target = p
                break
            end
        end

        if not target then
            ply:Notify("Could not find a player with Steam ID: " .. targetSID)
            return
        end

        if target:Team() ~= TEAM_VORT or target:GetBodygroup(7) ~= 1 then
            ply:Notify(target:Nick() .. " is not a shackled vortigaunt.")
            return
        end

        target:SetBodygroup(7, 0)
        target:SetBodygroup(8, 0)
        target:Notify("You have had your shackles removed by " .. ply:Nick() .. ".")

        if target:HasWeapon("plutonic_broom") then
            target:StripWeapon("plutonic_broom")
        end

        target:Give("plutonic_vort")
        target.IsARebel = true
        target:SetRPName(target:GetSavedRPName())

        ply:Notify("You have unshackled " .. target:Nick() .. ".")
    end
})

impulse.RegisterChatCommand("/vl", {
	description = "Toggles your text chat voice lines. (DEFAULT IS ON)",
    requiresArg = false,
    onRun = function(ply)
        ply.VoiceLines = not ply.VoiceLines
        ply:Notify("Text chat voice lines are now " .. (ply.VoiceLines and "enabled" or "disabled") .. ".")
    end
})

impulse.RegisterChatCommand("/checkbodygroups", {
    description = "Prints your current bodygroups to chat.",
    onRun = function(ply, args, rawText)
        for _, group in pairs(ply:GetBodyGroups()) do
            ply:Notify("Bodygroup " .. group.id .. " (" .. group.name .. "): " .. ply:GetBodygroup(group.id))
        end
    end
})

impulse.RegisterChatCommand("/gotov", {
    description = "Teleports you to a specified vector position.",
    superAdminOnly = true,
    requiresArg = true,
    onRun = function(ply, args, rawText)
        local joined = table.concat(args, " ")
        local x, y, z = string.match(joined, "Vector%(([%-%d%.]+),%s*([%-%d%.]+),%s*([%-%d%.]+)%)")

        if not x or not y or not z then
            x, y, z = string.match(rawText, "Vector%(([%-%d%.]+),%s*([%-%d%.]+),%s*([%-%d%.]+)%)")
        end

        if not x or not y or not z then
            ply:Notify("Usage: /gotov Vector(x, y, z)")
            return
        end

        local pos = Vector(tonumber(x), tonumber(y), tonumber(z))

        if not pos or not isvector(pos) then
            ply:Notify("Invalid vector provided.")
            return
        end

        ply:SetPos(pos)
        ply:Notify("Teleported to " .. tostring(pos) .. ".")
    end
})

impulse.RegisterChatCommand("/entid", {
    description = "Gets the map creation ID of the entity you're looking at.",
    superAdminOnly = true,
    onRun = function(ply)
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity

        if not IsValid(ent) then
            ply:Notify("Not looking at a valid entity.")
            return
        end

        local id = ent:MapCreationID()
        local name = ent:GetName()
        local class = ent:GetClass()
        local pos = ent:GetPos()

        ply:Notify("Class: " .. class .. " | Name: " .. name .. " | MapID: " .. tostring(id) .. " | Pos: " .. tostring(pos))
    end
})

if SERVER then
    util.AddNetworkString("impulseOpenContentLink")
end

impulse.RegisterChatCommand("/content", {
    description = "Opens the content pack link.",
    onRun = function(ply)
        net.Start("impulseOpenContentLink")
        net.Send(ply)
    end
})

local checkSpeedCommand = {
    description = "Outputs your current walk and run speed.",
    superAdminOnly = true,
    requiresArg = false,
    onRun = function(ply, arg, rawText)
        ply:Notify("Walk Speed: " .. ply:GetWalkSpeed() .. " | Run Speed: " .. ply:GetRunSpeed())
    end
}

impulse.RegisterChatCommand("/checkspeed", checkSpeedCommand)

impulse.RegisterChatCommand("/whois", {
    description = "Returns player information by their database ID.",
    adminOnly = true,
    requiresArg = true,
    onRun = function(ply, args, rawText)
        local id = tonumber(args[1])

        if not id then
            ply:Notify("Usage: /whois <id>")
            return
        end

        local query = mysql:Select("impulse_players")
        query:Select("rpname")
        query:Select("steamid")
        query:Where("id", id)
        query:Callback(function(result)
            if not IsValid(ply) then return end

            if not result or #result == 0 then
                ply:Notify("No player found with ID " .. id .. ".")
                return
            end

            local data = result[1]
            local steamName = "Offline"

            for _, p in ipairs(player.GetAll()) do
                if p:SteamID() == data.steamid then
                    steamName = p:SteamName()
                    break
                end
            end
			ply:ConCommand("say /ac ID: " .. id .. " | RP Name: " .. (data.rpname or "N/A") .. " | Steam Name: " .. steamName .. " | SteamID: " .. (data.steamid or "N/A"))
        end)
        query:Execute()
    end
})

local groupCheckCommand = {
    description = "Checks a player's RP group and rank.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local steamid = arg[1]

        if not steamid:match("^STEAM_%d:%d:%d+$") then
            ply:Notify("Invalid SteamID format.")
            return
        end

        local targ = player.GetBySteamID(steamid)
        if not IsValid(targ) then
            ply:Notify("Player is not online.")
            return
        end

        local groupName = targ:GetSyncVar(SYNC_GROUP_NAME, nil)
        local groupRank = targ:GetSyncVar(SYNC_GROUP_RANK, nil)

        if not groupName or groupName == "" then
            ply:Notify(targ:Name() .. " is not in a group.")
            return
        end

        ply:ConCommand("say /ac " .. targ:Name() .. " is a " .. (groupRank or "Member") .. " of group " .. groupName .. ".")
    end
}
impulse.RegisterChatCommand("/groupcheck", groupCheckCommand)

local slayCommand = {
	description = "Slay a player, uses steamid.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
    	local steamid = arg[1]
    	if ply:SteamID() ~= "STEAM_0:0:29204032" then
    		ply:Notify("This command is for Fool of a Took only.") 
    		return
    	elseif not steamid:match("^STEAM_%d:%d:%d+$") then
            ply:Notify("Invalid SteamID format.")
            return
        end

        local targ = player.GetBySteamID(steamid)
        if IsValid(targ) then 
        	targ:Kill()
        else
        	ply:Notify("What did you do dummy?")
        end
    end
}

impulse.RegisterChatCommand("/slay", slayCommand)

if CLIENT then
	local infoCol = Color(135, 206, 250)
	local oocCol = color_white
	local oocTagCol = Color(200, 0, 0)
	local yellCol = Color(255, 140, 0)
	local whisperCol = Color(65, 105, 225)
	local infoCol = Color(135, 206, 250)
	local talkCol = Color(255, 255, 100)
	local radioCol = Color(65, 120, 200)
	local pmCol = Color(45, 154, 6)
	local advertCol = Color(255, 174, 66)
	local acCol = Color(0, 161, 255)
	local eventCol = Color(3, 127, 252)
	local fallbackRankCol = Color(211, 211, 211)
	local groupCol = Color(3, 188, 0)
	local hcCol = Color(255, 100, 0)
	
	local rankCols = impulse.Config.RankColours

	local ghostRadioCol = Color(51, 153, 255)
	local gmChatCol = Color(255, 123, 0)
	local gmChatMessageCol = Color(255, 175, 0)
	local managerChatCol = Color(111, 0, 0)
	local managerChatMessageCol = Color(255, 0, 21)
	local adminAnnounceCol = Color(255, 50, 50)
	local emergencyCol = Color(194,64,0)
	local wireE2Col = Color(255, 200, 0)

	local fontmedium = "Impulse-ChatMedium"
	local fontlarge = "Impulse-ChatLarge"
	local fontsmall = "Impulse-ChatSmall"

	--[[if playe.selection then
		fontmedium = playe.selection
	end

	if playe.selectionbig then
		fontlarge = playe.selectionbig
	end

	if playe.selectionmall then
		fontsmall = playe.selectionbig
	end]]

	impulse.RegisterChatClass(1, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message

		chat.AddText(speaker, talkCol, " says: ", message)
	end)

	local strFind = string.find
	impulse.RegisterChatClass(2, function(message, speaker)
		if not impulse.GetSetting("chat_oocenabled", true) then
			return print("(OOC DISABLED) [OOC] "..speaker:SteamName()..": "..message)
		end

		impulse.customChatPlayer = speaker

		if LocalPlayer and IsValid(LocalPlayer()) then
			local tag = "@"..LocalPlayer():SteamName()
			local findStart, findEnd = strFind(string.lower(message), string.lower(tag), 1, true)

			if findStart then
				local pre = string.sub(message, 1, findStart - 1)
				local post = string.sub(message, findEnd + 1)

				if impulse.GetSetting("chat_pmpings") then
					surface.PlaySound("buttons/blip1.wav")
				end

				chat.AddText(oocTagCol, "[OOC] ", (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol), speaker:SteamName(), oocCol, ": ", pre, infoCol, tag, oocCol, post)
				return
			end
		end

		chat.AddText(oocTagCol, "[OOC] ", (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol), speaker:SteamName(), oocCol, ": ", message)
	end)

	impulse.RegisterChatClass(3, function(message, speaker)
		impulse.customChatPlayer = speaker
		chat.AddText(oocTagCol, "[LOOC] ", (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol), speaker:SteamName(), (team.GetColor(speaker:Team())), " (", speaker:Name(), ")", oocCol, ": ",  message)
	end)

	impulse.RegisterChatClass(4, function(message, speaker)
		surface.PlaySound("buttons/blip1.wav")
		chat.AddText(pmCol, "[PM] ", speaker:SteamName(), ": ", message)
	end)

	impulse.RegisterChatClass(5, function(message, speaker)
		surface.PlaySound("buttons/blip1.wav")
		chat.AddText(pmCol, "[PM SENT] ", speaker:SteamName(), ": ", message)
	end)

	impulse.RegisterChatClass(6, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message

		impulse.customChatFont = "Impulse-ChatLarge"
		chat.AddText(speaker, yellCol, " yells: ", message)
	end)

	impulse.RegisterChatClass(7, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message
		
		impulse.customChatFont = "Impulse-ChatSmall"
		chat.AddText(speaker, whisperCol, " whispers: ", message)
	end)

	impulse.RegisterChatClass(8, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		chat.AddText(radioCol, "[RADIO] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(9, function(message, speaker)
		chat.AddText(infoCol, "** ", message)
	end)

	impulse.RegisterChatClass(10, function(message, speaker)
		chat.AddText(talkCol, "** " .. speaker:Name() .. " " .. message .. " **")
	end)

	impulse.RegisterChatClass(11, function(message, speaker)
		chat.AddText(speaker, yellCol, " rolled ", message)
	end)

	impulse.RegisterChatClass(12, function(message, speaker)
		chat.AddText(eventCol, "[EVENT] ", message)
	end)

	impulse.RegisterChatClass(13, function(message, speaker)
		chat.AddText(acCol, "[Admin Chat] ", speaker:SteamName(), ": ", acCol, message)
	end)

	impulse.RegisterChatClass(6969, function(message, speaker)
		chat.AddText(ghostRadioCol, "[Ghost Radio] ", speaker:SteamName(), ": ", color_white, message)
	end)

	impulse.RegisterChatClass(14, function(message, speaker)
		chat.AddText(advertCol, "[Advertisement] ", speaker:Name(), ": ", advertCol, message)
	end)

	impulse.RegisterChatClass(165, function(message, speaker)
		chat.AddText(gmChatCol, "[Game Master Chat] ", speaker:SteamName(), ": ", gmChatMessageCol, message)
	end)

	impulse.RegisterChatClass(166, function(message, speaker)
		chat.AddText(managerChatCol, "[Management Chat] ", speaker:SteamName(), ": ", managerChatMessageCol, message)
	end)

	impulse.RegisterChatClass(167, function(message, speaker)
		chat.AddText(adminAnnounceCol, "[Administrative Announcement] ", speaker:SteamName(), ": ", message)
	end)

	impulse.RegisterChatClass(168, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		chat.AddText(emergencyCol, "[EMERGENCY BROADCAST] ", message)
	end)

	impulse.RegisterChatClass(169, function(message)
		impulse.customChatFont = "Impulse-ChatRadio" 
		chat.AddText(emergencyCol, "[PRIORITY TRANSMISSION] You (" .. message ..") are charged with terminal violation 148, 243, 245. All units, verdict code is immediate amputation. Final verdict administered.")
	end)

	impulse.RegisterChatClass(231, function(message)
		chat.AddText(wireE2Col, "[WireE2] ", color_white, message)
	end)

	impulse.RegisterChatClass(15, function(message, speaker)
		local groupName = LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil)
		local groupRank = speaker:GetSyncVar(SYNC_GROUP_RANK, nil)

		if not groupName or not groupRank then
			return
		end
		
		local myGroup = impulse.Group.Groups[1]

		if not myGroup then
			return
		end
		
		if myGroup.Color then
			chat.AddText(myGroup.Color, "["..groupName.."] ("..groupRank..") ", speaker:Nick(), ": ", message)
		else
			chat.AddText(groupCol, "["..groupName.."] ("..groupRank..") ", speaker:Nick(), ": ", message)
		end
	end)

	net.Receive("impulseOpenContentLink", function()
	    gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails?id=3690442796")
	end)
	
end
