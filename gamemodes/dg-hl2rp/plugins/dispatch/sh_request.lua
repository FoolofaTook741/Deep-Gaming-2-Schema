if SERVER then
	util.AddNetworkString("impulseHL2RPRequest")
	util.AddNetworkString("impulseHL2RPTerminalRequest")

	local WEBHOOK_URL = DG_NME

	local function LogExploit(ply, action, detail)
		if not IsValid(ply) then return end

		local msg = string.format(
			"[Request] NET EXPLOIT: %s (%s) attempted: %s — %s",
			ply:SteamName(), ply:SteamID(), action, detail or ""
		)
		ServerLog(msg .. "\n")
		print(msg)

		local embeds = {{
			title       = "Request Net Exploit Attempted",
			description = string.format("`%s` sent a spoofed identity in a request net message.", ply:SteamName()),
			color       = 15548997,
			fields = {
				{ name = "Name",    value = ply:SteamName(), inline = true  },
				{ name = "SteamID", value = ply:SteamID(),   inline = true  },
				{ name = "Action",  value = action,          inline = false },
				{ name = "Detail",  value = detail or "none",inline = false },
			},
		}}

		if ReqwestLog and WEBHOOK_URL then
			ReqwestLog(embeds, WEBHOOK_URL)
		end
	end

	net.Receive("impulseHL2RPTerminalRequest", function(len, ply)
		if not IsValid(ply) then return end
		if not ply:Alive() then return end
		if not (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) then return end
		if (ply.nextRequest or 0) > CurTime() then return end
		if ply:GetSyncVar(SYNC_ARRESTED, false) then return end
		if ply:IsRebelSmart() then return end

		local claimedIdx = net.ReadUInt(8)
		local rawText    = net.ReadString()

		if not rawText or #rawText < 1 or #rawText > 128 then return end

		if claimedIdx ~= ply:EntIndex() then
			LogExploit(ply, "impulseHL2RPTerminalRequest",
				string.format("Claimed entindex %d does not match sender entindex %d", claimedIdx, ply:EntIndex()))
			return
		end

		local recipFilter = RecipientFilter()
		for _, k in pairs(player.GetAll()) do
			if k:Team() == TEAM_CP then
				recipFilter:AddPlayer(k)
			end
		end

		for _, v in pairs(player.GetAll()) do
			if v:GetPos():Distance(ply:GetPos()) < 200 then
				v:SendChatClassMessage(10, "makes a request to M.P.F. teams: " .. rawText, ply)
			end
		end

		net.Start("impulseHL2RPRequest")
			net.WriteUInt(ply:EntIndex(), 8)
			net.WriteString(rawText)
		net.Send(recipFilter)

		ply.nextRequest = CurTime() + 30
	end)
end

if CLIENT then
	net.Receive("impulseHL2RPRequest", function()
		local sender = net.ReadUInt(8)
		local message = net.ReadString()
		sender = Entity(sender)

		if sender and IsValid(sender) and sender:IsPlayer() then
			LocalPlayer():SendCombineMessage("NEW REQUEST FROM: "..sender:Name(), Color(0, 0, 255))
			LocalPlayer():SendCombineMessage("MESSAGE: "..message, Color(0, 0, 255))

			impulse.AddCombineWaypoint("Civil Request", sender:GetPos(), 90, 2, 5, nil, nil, sender)

			surface.PlaySound("npc/overwatch/radiovoice/allteamsrespondcode3.wav")
		end
	end)
end

local requestCommand = {
	description = "Sends a request to Civil Protection teams for assistance.",
	requiresArg = true,
	requiesAlive = true,
	onRun = function(ply, arg, rawText)
		if ply:Alive() and (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) then
			if (ply.nextRequest or 0) > CurTime() then 
				return ply:Notify("Please wait a while before sending another request.") 
			end
			if ply:GetSyncVar(SYNC_ARRESTED, false) then
				return ply:Notify("You can not send a request when arrested.")
			end
			if ply:IsRebelSmart() then
				return ply:Notify("You can not send a request as a rebel.")
			end

			if SERVER then
				local recipFilter = RecipientFilter()
				for v,k in pairs(player.GetAll()) do
					if k:Team() == TEAM_CP then
						recipFilter:AddPlayer(k)
					end
				end
				for k,v in pairs(player.GetAll()) do
					if v:GetPos():Distance(ply:GetPos()) < 200 then
						v:SendChatClassMessage(10, "makes a request to M.P.F. teams: " .. rawText, ply)
					end
				end
				net.Start("impulseHL2RPRequest")
				net.WriteUInt(ply:EntIndex(), 8)
				net.WriteString(rawText)
				net.Send(recipFilter)
				ply.nextRequest = CurTime() + 30
			end

			ply:Notify("You have sent a request to Civil Protection teams.")
			ply:EmitBudgetSound("ambient/levels/prison/radio_random2.wav")
		else
			ply:Notify("You must be a citizen to make a request.")
		end
	end
}

impulse.RegisterChatCommand("/request", requestCommand)