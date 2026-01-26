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
    
        ReqwestLog( embeds, DG_E2 )
    end

    local reviewURL       = "https://hl2rp.deepgaming2.com/whitelists/e2.php"
    local sharedSecret    = "kRS15O4xkcMT7AZ877tcxjCsCg6GPh67"
    local authFile        = "wire_e2_authorized.txt"
	local blacklistFile   = "wire_e2_blacklist.txt"
	local blacklisted     = {} -- [hash] = { by = "name", reason = "text", time = os.time() }
    local authorized      = {}
    local pending         = {}
    local pendingOrder    = {}
    local lastSubmit      = {}
    local MAX_CODE_LEN    = 48 * 1024
    local SUBMIT_COOLDOWN = 10
    local MAX_PENDING     = 20
    local PENDING_TIMEOUT = 1200

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
            if p:IsLeadAdmin() then recipients[#recipients+1] = p end
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

            local hash = util.SHA256(code)
            self._WireE2Hash = hash
            impulse.debugPrint("[WireE2] New submission by "..plyName.." → "..hash)
			
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

            if pending[hash] then
                if IsValid(ply) then
                    ply:SendChatClassMessage(231,
                      "Your E2 ("..hash..") is already pending approval.", ply)
                end
                if IsValid(self) then self:Remove() end
                return
            end

            if not authorized[hash] then
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
                            authorized[hash] = true
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
                            end

                            LogE2ApprovalToDiscord(hash, IsValid(data.player) and data.player or Entity(0), "Auto-Approved")
                            return
                        end

                        do
                            local recipients = {}
                            for _, p in ipairs(player.GetAll()) do if p:IsLeadAdmin() then recipients[#recipients+1]=p end end
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
            return origSetup(self, code, includes, restore, forcecompile, filepath)
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
        if not ply:IsLeadAdmin() then return end
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
        if not ply:IsLeadAdmin() then return end
        local hash = net.ReadString()
        local data = pending[hash]
        if not data then
            return
        end

        authorized[hash] = true
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
        if not ply:IsLeadAdmin() then return end
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
        if not admin:IsAdmin() then return end
    
        local e2 = net.ReadEntity()
        local plyOwner = net.ReadEntity()
    
        if not IsValid(e2) or e2:GetClass() ~= "gmod_wire_expression2" then return end
        if not IsValid(plyOwner) then return end
    
        local hash = e2._WireE2Hash
        if not hash then
            admin:SendChatClassMessage(231, "[WireE2] Error: that chip has no stored hash!", admin)
            return
        end
    
        if authorized[hash] then
            authorized[hash] = nil
            saveAuth()
			blacklisted[hash] = {
				by = admin:SteamName(),
				reason = "Revoked/Blacklisted by admin",
				time = os.time()
			}
			saveBlacklist()
            print(("[WireE2] %s revoked approval for %s"):format(admin:Nick(), hash))
			
        end
    
        for _, ent in ipairs(ents.FindByClass("gmod_wire_expression2")) do
            if ent._WireE2Hash == hash and ent.player == plyOwner then
                ent:Remove()
            end
        end
    
        admin:SendChatClassMessage(231,
          ("[WireE2] Revoked & removed E2 %s for %s")
            :format(hash, plyOwner:Nick()),
          admin
        )
    
        net.Start("wire_e2_user_denied")
        net.WriteString(admin:Nick())
        net.WriteString("Your E2 ("..hash..") has been revoked by an administrator.")
        net.Send(plyOwner)

        LogE2ApprovalToDiscord(hash, admin, "Blacklisted")
    end)

end