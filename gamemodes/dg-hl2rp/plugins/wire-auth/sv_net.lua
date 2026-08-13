if SERVER then
    util.AddNetworkString("wire_e2_request_list")
    util.AddNetworkString("wire_e2_pending_list")
    util.AddNetworkString("wire_e2_approve")
    util.AddNetworkString("wire_e2_removed")
    util.AddNetworkString("wire_e2_deny")
    util.AddNetworkString("wire_e2_review")
    util.AddNetworkString("wire_e2_user_approved")
    util.AddNetworkString("wire_e2_user_denied")
    util.AddNetworkString("wire_e2_revoke")
	util.AddNetworkString("wire_e2_blacklist_hash")
	

    local function LogE2ApprovalToDiscord(hash, adminPly, action)
        local ts           = os.time()
        local humanTime    = os.date("%A, %d %B %Y %I:%M %p", ts)
        local discordTime  = string.format("<t:%d:R>", ts)
    
        local embeds = {{
            title       = "E2 Script ".. action,
            color       = 5763719,
            fields      = {
                { name = "Hash", value = hash, inline = false },
                { name = action.." By", value = string.format("%s (%s)", adminPly:SteamName(), adminPly:SteamID()), inline = false },
                { name = "Time", value = string.format("%s (%s)", humanTime, discordTime),  inline = false },
            }
        }}
    
        --ReqwestLog( embeds, DG_E2 )
    end

    local reviewURL       = "https://hl2rp.deepgaming2.com/whitelists/e2.php"
    local sharedSecret    = "kRS15O4xkcMT7AZ877tcxjCsCg6GPh67"
    local authFile        = "wire_e2_authorized.txt"
	local blacklistFile   = "wire_e2_blacklist.txt"
	local blacklisted     = {} -- [hash] = { by = "name", reason = "text", time = os.time() }
    impulse.WireE2 = impulse.WireE2 or {}
    impulse.WireE2.memberBlacklistFile = "wire_e2_member_blacklist.txt"
    impulse.WireE2.memberBlacklisted   = impulse.WireE2.memberBlacklisted or {}
    local authorized      = {}
    local pending         = {}
    local pendingOrder    = {}
    local lastSubmit      = {}
    local MAX_CODE_LEN    = 48 * 1024
    local SUBMIT_COOLDOWN = 10
    local MAX_PENDING     = 20
    local PENDING_TIMEOUT = 1200
    local MAX_E2_PER_PLAYER = 2
    local MAX_E2_PER_COLLAB = 4

    if file.Exists(impulse.WireE2.memberBlacklistFile, "DATA") then
        impulse.WireE2.memberBlacklisted = util.JSONToTable(file.Read(impulse.WireE2.memberBlacklistFile, "DATA")) or {}
        impulse.debugPrint("[WireE2] Loaded "..table.Count(impulse.WireE2.memberBlacklisted).." member blacklists")
    end

    function impulse.WireE2.SaveMemberBlacklist()
        file.Write(impulse.WireE2.memberBlacklistFile, util.TableToJSON(impulse.WireE2.memberBlacklisted, true))
    end

    function impulse.WireE2.IsMemberBlacklisted(steamID32)
        local e = impulse.WireE2.memberBlacklisted[steamID32]
        if not e then return false end

        local untilTs = tonumber(e.untilTs or 0) or 0
        if untilTs ~= 0 and untilTs <= os.time() then
            impulse.WireE2.memberBlacklisted[steamID32] = nil
            impulse.WireE2.SaveMemberBlacklist()
            return false
        end

        return true
    end

    local function CountPlayerE2s(ply, ignoreEnt)
        if not IsValid(ply) then return 0 end

        local count = 0

        for _, ent in ipairs(ents.FindByClass("gmod_wire_expression2")) do
            if IsValid(ent) and ent ~= ignoreEnt then
                local owner = ent.player

                if not IsValid(owner) and ent.GetPlayer then
                    owner = ent:GetPlayer()
                end

                if owner == ply then
                    count = count + 1
                end
            end
        end

        return count
    end

    function impulse.WireE2.MemberBlacklistSet(steamID32, minutes, reason, adminName)
        minutes = tonumber(minutes) or 0
        reason = tostring(reason or "Blacklisted from E2."):Trim()
        if reason == "" then reason = "Blacklisted from E2." end

        local untilTs = (minutes <= 0) and 0 or (os.time() + (minutes * 60))

        impulse.WireE2.memberBlacklisted[steamID32] = {
            untilTs = untilTs,
            reason  = reason,
            by      = tostring(adminName or "Unknown"),
            time    = os.time()
        }

        impulse.WireE2.SaveMemberBlacklist()
        return untilTs
    end

    function impulse.WireE2.MemberBlacklistRemove(steamID32)
        impulse.WireE2.memberBlacklisted[steamID32] = nil
        impulse.WireE2.SaveMemberBlacklist()
    end
	
	local function IsAuthorized(hash)
		local v = authorized[hash]
		if v == true then return true end
		if istable(v) and v.approved == true then return true end
		return false
	end

	local function GetAuthInfo(hash)
		local v = authorized[hash]
		if istable(v) then return v end
		return nil
	end
	
	if plogs and plogs.Register then
		plogs.Register("WireE2", true, Color(80, 200, 255))
	end
	
	local function PLogsLiveApproved(ent)
		if not (plogs and plogs.PlayerLog) then return end
		if not IsValid(ent) or ent:GetClass() ~= "gmod_wire_expression2" then return end

		local hash = ent._WireE2Hash
		if not hash or not IsAuthorized(hash) then return end

		local ply = ent.player
		if not IsValid(ply) then return end

		local auth = GetAuthInfo(hash) or {}
		local pos  = ent:GetPos()
		
		local details = (auth.details and auth.details ~= "") and tostring(auth.details) or "n/a"
		details = details:gsub("[%c]+", " "):Trim()
		if #details > 220 then details = details:sub(1, 220) .. "..." end

		local msg = string.format(
			"%s spawned approved E2 | %s",
			ply:SteamName(),
			details
		)

		plogs.PlayerLog(ply, "WireE2", msg, {
			["SteamName"] = ply:SteamName(),
			["SteamID"]   = ply:SteamID(),
			["Hash"]      = hash,
			["EntIndex"]  = ent:EntIndex(),
			["Pos"]       = string.format("%.1f, %.1f, %.1f", pos.x, pos.y, pos.z),
		})
	end


    if file.Exists(authFile, "DATA") then
        authorized = util.JSONToTable(file.Read(authFile, "DATA")) or {}
        impulse.debugPrint("[WireE2] Loaded "..table.Count(authorized).." approved scripts")
    end
	
	if file.Exists(blacklistFile, "DATA") then
		blacklisted = util.JSONToTable(file.Read(blacklistFile, "DATA")) or {}
		impulse.debugPrint("[WireE2] Loaded "..table.Count(blacklisted).." blacklisted scripts")
	end

	local function saveBlacklist()
		file.Write(blacklistFile, util.TableToJSON(blacklisted, true))
		impulse.debugPrint("[WireE2] Saved "..table.Count(blacklisted).." blacklisted scripts")
	end
	
    local function saveAuth()
        file.Write(authFile, util.TableToJSON(authorized, true))
        impulse.debugPrint("[WireE2] Saved "..table.Count(authorized).." approvals")
    end

    local function notifyAdmins(msgType, ...)
        local recipients = {}
        for _, p in ipairs(player.GetAll()) do
            if p:IsAdmin() then recipients[#recipients+1] = p end
        end
        net.Start(msgType)
          for _, v in ipairs({...}) do
            if type(v)=="string" then
              net.WriteString(v)
            elseif type(v)=="number" then
              net.WriteFloat(v)
            end
          end
        net.Send(recipients)
    end

    local function expirePending(hash)
        if not pending[hash] then return end
        pending[hash] = nil
        for i,h in ipairs(pendingOrder) do
            if h==hash then table.remove(pendingOrder,i); break end
        end
        impulse.debugPrint("[WireE2] Pending timeout expired for "..hash)
        notifyAdmins("wire_e2_removed", hash)
    end

    local function WrapE2(ent)
        if not IsValid(ent) or ent._WireE2Hooked then return end
        ent._WireE2Hooked = true
        local origSetup = ent.Setup
        ent._WireE2OrigSetup = origSetup

        function ent:Setup(code, includes, restore, forcecompile, filepath)
            local ply     = self.player
            local plyName = IsValid(ply) and ply:Nick() or "Unknown"
            local steamID = IsValid(ply) and ply:SteamID() or "unknown"
            local now     = CurTime()

            if IsValid(ply) then
                local sid32 = ply:SteamID()
                if sid32 and impulse.WireE2.IsMemberBlacklisted(sid32) then
                    local e = impulse.WireE2.memberBlacklisted[sid32] or {}
                    local reason = tostring(e.reason or "Blacklisted from E2.")
                    ply:SendChatClassMessage(231, "You are blacklisted from using E2.\nReason: "..reason, ply)
                    if IsValid(self) then self:Remove() end
                    return
                end
            end

            if IsValid(ply) then
                local activeE2s = CountPlayerE2s(ply, self)


                if ply:IsCollaborator() then
                    if activeE2s >= MAX_E2_PER_COLLAB then
                        ply:SendChatClassMessage(231,"You already have the maximum allowed E2 chips placed. Limit: " .. MAX_E2_PER_COLLAB, ply)

                        if IsValid(self) then
                            self:Remove()
                        end

                        impulse.debugPrint("[WireE2] Blocked " .. plyName .. " (COLLABORATOR) from spawning more than " .. MAX_E2_PER_COLLAB .. " E2s")
                        return
                    end
                elseif activeE2s >= MAX_E2_PER_PLAYER then
                    ply:SendChatClassMessage(231,"You already have the maximum allowed E2 chips placed. Limit: " .. MAX_E2_PER_PLAYER, ply)

                    if IsValid(self) then
                        self:Remove()
                    end

                    impulse.debugPrint("[WireE2] Blocked " .. plyName .. " from spawning more than " .. MAX_E2_PER_PLAYER .. " E2s")
                    return
                end
            end

            local hash = util.SHA256(code)
            self._WireE2Hash = hash

			if blacklisted[hash] then
				local info = blacklisted[hash]
				local reason = (type(info) == "table" and info.reason) or "Blacklisted by an administrator."
				if IsValid(ply) then
					ply:SendChatClassMessage(231,
						"[WireE2] This E2 is blacklisted and cannot be used.\nReason: "..tostring(reason),
						ply
					)
				end
				if IsValid(self) then self:Remove() end
				impulse.debugPrint("[WireE2] Blocked blacklisted submission "..hash.." from "..plyName)
				return
			end
                                    
			if ply:IsGameMaster() then 
				return origSetup(self, code, includes, restore, forcecompile, filepath) 
			end
			
            if #code > MAX_CODE_LEN then
                if IsValid(ply) then
                    ply:SendChatClassMessage(231,
                      "Your code is too large ("..
                      math.Round(#code/1024,1).."KB), max is "..(MAX_CODE_LEN/1024).."KB.", ply)
                end
                if IsValid(self) then self:Remove() end
                return
            end

            if lastSubmit[steamID] and now - lastSubmit[steamID] < SUBMIT_COOLDOWN then
                if IsValid(ply) then
                    ply:SendChatClassMessage(231,
                      "Please wait "..math.ceil(SUBMIT_COOLDOWN - (now-lastSubmit[steamID]))
                      .."s before submitting another E2.", ply)
                end
                if IsValid(self) then self:Remove() end
                return
            end
            lastSubmit[steamID] = now

            impulse.debugPrint("[WireE2] New submission by "..plyName.." → "..hash)

            if pending[hash] then
                if IsValid(ply) then
                    ply:SendChatClassMessage(231,
                      "Your E2 ("..hash..") is already pending approval.", ply)
                end
                if IsValid(self) then self:Remove() end
                return
            end

            if not IsAuthorized(hash) then
                if #pendingOrder >= MAX_PENDING then
                    local old = table.remove(pendingOrder,1)
                    pending[old] = nil
                    impulse.debugPrint("[WireE2] Dropped oldest pending entry "..old)
                    notifyAdmins("wire_e2_removed", old)
                end

                pending[hash] = {
                    player = ply,
                    ent = self,
                    code = code,
                    time = now,
                    includes = includes,
                    restore = restore,
                    forcecompile = forcecompile,
                    filepath = filepath
                }
                table.insert(pendingOrder, hash)
                impulse.debugPrint("[WireE2] Pending approval: "..hash)

                timer.Simple(PENDING_TIMEOUT, function() expirePending(hash) end)

                HTTP({
                    url    = reviewURL,
                    method = "POST",
                    headers = {
                      ["Content-Type"]       = "application/json",
                      ["X-E2-Review-Secret"] = sharedSecret,
                    },
                    body   = util.TableToJSON({ code = code }),

                    success = function(statusCode, body, headers)
                        if statusCode ~= 200 then
                          impulse.debugPrint("[WireE2] HTTP error "..statusCode.." for "..hash)
                          return
                        end

                        local ok, res = pcall(util.JSONToTable, body)
                        if not ok or type(res)~="table" or res.score==nil then
                          impulse.debugPrint("[WireE2] Invalid AI response for "..hash)
                          return
                        end

                        local data = pending[hash]
                        if not data then return end

                        data.score   = res.score
                        data.verdict = res.verdict or "safe"
                        data.details = res.details or ""

                        if data.verdict == "safe" and tonumber(data.score) and data.score <= 30 then
							authorized[hash] = {
								approved     = true,
								score        = tonumber(data.score) or 0,
								verdict      = tostring(data.verdict or "safe"),
								details      = tostring(data.details or ""),
								owner_steamid   = IsValid(data.player) and data.player:SteamID() or nil,
								owner_steamname = IsValid(data.player) and data.player:SteamName() or nil,
								approved_by  = "Auto-Approved",
								approved_time = os.time()
							}
							saveAuth()

                            pending[hash] = nil
                            for i,h in ipairs(pendingOrder) do if h == hash then table.remove(pendingOrder, i) break end end

                            if IsValid(data.player) then
                                net.Start("wire_e2_user_approved")
                                net.WriteString("Auto-Approved")
                                net.Send(data.player)
                            end

                            if IsValid(data.ent) and data.ent._WireE2OrigSetup then
                                data.ent._WireE2Code = data.code
                                data.ent._WireE2Hash = hash
                                data.ent:EmitSound("buttons/button14.wav")
                                data.ent:_WireE2OrigSetup(data.code, data.includes, data.restore, data.forcecompile, data.filepath)
								PLogsLiveApproved(data.ent)
                            end

                            LogE2ApprovalToDiscord(hash, IsValid(data.player) and data.player or Entity(0), "Auto-Approved")
                            return
                        end

                        do
                            local recipients = {}
                            for _, p in ipairs(player.GetAll()) do if p:IsAdmin() then recipients[#recipients+1]=p end end
                            net.Start("wire_e2_pending_list")
                            net.WriteUInt(1,16)
                            net.WriteString(hash)
                            net.WriteString((IsValid(data.player) and data.player:Nick()) or "Unknown")
                            net.WriteString(data.code)
                            net.Send(recipients)
                        end

                        notifyAdmins("wire_e2_review", hash, data.score, data.verdict, data.details)

                        print(string.format(
                          "[WireE2] Review complete for %s: score=%d, verdict=%s, analysis=\"%s\"",
                          hash,
                          res.score,
                          pending[hash].verdict,
                          pending[hash].details:gsub("\n"," ")
                        ))
                    end,

                    failed = function(err)
                        impulse.debugPrint("[WireE2] AI HTTP error for "..hash..": "..tostring(err))
                    end,
                })

                return
            end
            
			self._WireE2Code = code
			local ret = origSetup(self, code, includes, restore, forcecompile, filepath)
			PLogsLiveApproved(self)
			return ret
        end
    end

    hook.Add("InitPostEntity", "WireE2_OverrideExisting", function()
        for _, ent in ipairs(ents.FindByClass("gmod_wire_expression2")) do
            WrapE2(ent)
        end
    end)
    hook.Add("OnEntityCreated", "WireE2_HookSetup", function(ent)
        if ent:GetClass()=="gmod_wire_expression2" then
            timer.Simple(0, function() WrapE2(ent) end)
        end
    end)
    hook.Add("PlayerSpawnedSENT", "WireE2_PlayerSpawnedE2", function(ply,ent)
        if IsValid(ent) and ent:GetClass()=="gmod_wire_expression2" then
            WrapE2(ent)
        end
    end)

    net.Receive("wire_e2_request_list", function(_, ply)
        if not ply:IsAdmin() then return end
        local cnt = 0
        for _ in pairs(pending) do cnt = cnt+1 end

        net.Start("wire_e2_pending_list")
          net.WriteUInt(cnt,16)
          for hash,data in pairs(pending) do
            net.WriteString(hash)
            net.WriteString((IsValid(data.player) and data.player:Nick()) or "Unknown")
            net.WriteString(data.code)
          end
        net.Send(ply)
    end)

    net.Receive("wire_e2_approve", function(_, ply)
        if not ply:IsAdmin() then return end
        local hash = net.ReadString()
        local data = pending[hash]
        if not data then
            return
        end

		local info = {
			approved      = true,
			approved_by   = ply:SteamName(),
			approved_time = os.time()
		}

		-- if it was reviewed already, preserve AI info
		if data then
			info.score   = tonumber(data.score) or info.score
			info.verdict = data.verdict or info.verdict
			info.details = data.details or info.details
			info.owner_steamid   = IsValid(data.player) and data.player:SteamID() or nil
			info.owner_steamname = IsValid(data.player) and data.player:SteamName() or nil
		end

		authorized[hash] = info
		saveAuth()
        pending[hash] = nil
        for i,h in ipairs(pendingOrder) do if h==hash then table.remove(pendingOrder,i) break end end

        LogE2ApprovalToDiscord(hash, ply, "Approved")
        impulse.debugPrint("[WireE2] "..ply:Nick().." approved "..hash)
        if IsValid(data.player) then
            net.Start("wire_e2_user_approved")
            net.WriteString(ply:SteamName())
            net.Send(data.player)
        end
    end)

    net.Receive("wire_e2_deny", function(_, ply)
        if not ply:IsAdmin() then return end
        local hash, reason = net.ReadString(), net.ReadString()
        local data = pending[hash]
        if data then
            if IsValid(data.player) then
                net.Start("wire_e2_user_denied")
                net.WriteString(ply:SteamName())
                net.WriteString(reason)
                net.Send(data.player)
            end

            if IsValid(data.ent) then 
                data.ent:Remove() 
            end
        end
        pending[hash] = nil
        for i,h in ipairs(pendingOrder) do if h==hash then table.remove(pendingOrder,i) break end end

        impulse.debugPrint("[WireE2] "..ply:Nick().." denied "..hash.." ("..reason..")")
        notifyAdmins("wire_e2_removed", hash)
    end)

    net.Receive("wire_e2_revoke", function(_, admin)
        if not IsValid(admin) or not admin:IsAdmin() then return end

        local e2 = net.ReadEntity()

        if not IsValid(e2) or e2:GetClass() ~= "gmod_wire_expression2" then
            admin:SendChatClassMessage(231, "Invalid E2 selected.", admin)
            return
        end

        local plyOwner = e2.player

        if not IsValid(plyOwner) and e2.GetPlayer then
            plyOwner = e2:GetPlayer()
        end

        if not IsValid(plyOwner) and e2.CPPIGetOwner then
            plyOwner = e2:CPPIGetOwner()
        end

        local hash = e2._WireE2Hash

        if not hash then
            admin:SendChatClassMessage(231, "Error: that chip has no stored hash!", admin)
            return
        end

        hash = tostring(hash):gsub("[%s%c]", ""):lower()

        if authorized[hash] then
            authorized[hash] = nil
            saveAuth()
        end

        blacklisted[hash] = {
            by = admin:SteamName(),
            reason = "Revoked/Blacklisted by admin",
            time = os.time()
        }

        saveBlacklist()

        local removed = 0

        for _, ent in ipairs(ents.FindByClass("gmod_wire_expression2")) do
            if IsValid(ent) and tostring(ent._WireE2Hash or ""):lower() == hash then
                ent:Remove()
                removed = removed + 1
            end
        end

        local ownerName = IsValid(plyOwner) and plyOwner:Nick() or "unknown owner"

        admin:SendChatClassMessage(
            231,
            ("Revoked, blacklisted, and removed E2 %s for %s. Removed chips: %d")
                :format(hash, ownerName, removed),
            admin
        )

        if IsValid(plyOwner) then
            net.Start("wire_e2_user_denied")
                net.WriteString(admin:Nick())
                net.WriteString("Your E2 (" .. hash .. ") has been revoked by an administrator.")
            net.Send(plyOwner)
        end

        LogE2ApprovalToDiscord(hash, admin, "Blacklisted")
    end)
	
    net.Receive("wire_e2_blacklist_hash", function(_, admin)
        if not IsValid(admin) or not admin:IsAdmin() then return end

        local hash   = tostring(net.ReadString() or "")
		local reason = tostring(net.ReadString() or ""):Trim()
		if reason == "" then reason = "Blacklisted by an administrator." end

		hash = hash:gsub("[%s%c]", ""):lower()

		if not hash:match("^[0-9a-f]+$") then
			admin:SendChatClassMessage(
				231,
				"[WireE2] Invalid hash: contains non-hex characters.",
				admin
			)
			return
		end

		if #hash ~= 64 then
			admin:SendChatClassMessage(
				231,
				"[WireE2] Invalid hash length (expected 64 hex characters).",
				admin
			)
			return
		end

        if authorized[hash] then
            authorized[hash] = nil
            saveAuth()
        end

        blacklisted[hash] = {
            by     = admin:SteamName(),
            reason = reason,
            time   = os.time()
        }
        saveBlacklist()

        if pending[hash] then
            pending[hash] = nil
            for i,h in ipairs(pendingOrder) do
                if h == hash then table.remove(pendingOrder, i) break end
            end
            notifyAdmins("wire_e2_removed", hash)
        end

        admin:SendChatClassMessage(231, ("Blacklisted hash %s"):format(hash), admin)

        LogE2ApprovalToDiscord(hash, admin, "Blacklisted (Manual Hash)")

        for _, ent in ipairs(ents.FindByClass("gmod_wire_expression2")) do
            if ent._WireE2Hash == hash then
                ent:Remove()
            end
        end
    end)


end