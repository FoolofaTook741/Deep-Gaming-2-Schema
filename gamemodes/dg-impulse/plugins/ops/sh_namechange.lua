if SERVER then
	util.AddNetworkString("impulseOpsNamechange")
	util.AddNetworkString("impulseOpsDoNamechange")


	local function CapitalizeName(str)
		str = string.Trim(str or "")
		str = string.lower(str)

		
		str = string.gsub(str, "(%a)([%w_']*)", function(first, rest)
			return string.upper(first) .. rest
		end)

		return str
	end

	net.Receive("impulseOpsDoNamechange", function(len, ply)
		if not ply.NameChangeForced then
			return
		end

		local charName = net.ReadString()
		charName = CapitalizeName(charName)

		local canUse, output = impulse.CanUseName(charName)

		if not canUse then
			ply:Kick("Inappropriate roleplay name.")
			return
		end

		ply:SetRPName(output, true)
		ply:Notify("You have changed your name to "..output..".")

		ply.NameChangeForced = nil
	end)
else
	local nameChangeText = "You have been forced to change your name by a game moderator as it was deemed inappropriate.\nPlease change your name below to something more suitable.\nEXAMPLE: John Doe"

	net.Receive("impulseOpsNamechange", function()
		
		local function CapitalizeName(str)
			str = string.Trim(str or "")
			str = string.lower(str)

			
			str = string.gsub(str, "(%a)([%w_']*)", function(first, rest)
				return string.upper(first) .. rest
			end)

			return str
		end

		local panel = vgui.Create("DFrame")
		panel:SetSize(500, 170)
		panel:SetTitle("impulse")
		panel:Center()
		panel:ShowCloseButton(false)
		panel:MakePopup()

		local notice = vgui.Create("DLabel", panel)
		notice:SetPos(5, 30)
		notice:SetText(nameChangeText)
		notice:SizeToContents()

		local newName = vgui.Create("DLabel", panel)
		newName:SetPos(15, 85)
		newName:SetText("New name:")
		newName:SetFont("Impulse-Elements18-Shadow")
		newName:SizeToContents()

		local entry = vgui.Create("DTextEntry", panel)
		entry:SetPos(15, 105)
		entry:SetSize(470, 20)

		
		entry.OnChange = function(self)
			local caretPos = self:GetCaretPos()
			local value = self:GetValue()
			local formatted = CapitalizeName(value)

			if value ~= formatted then
				self:SetText(formatted)
				self:SetCaretPos(caretPos)
			end
		end

		local done = vgui.Create("DButton", panel)
		done:SetPos(15, 135)
		done:SetSize(80, 25)
		done:SetText("Done")

		function done:DoClick()
			local value = entry:GetValue()
			local formatted = CapitalizeName(value)

			
			if value ~= formatted then
				Derma_Message("Names must use proper capitalisation.\nExample: John Doe", "impulse", "OK")
				entry:SetText(formatted)
				entry:RequestFocus()
				entry:SetCaretPos(#formatted)
				return
			end

			local clear, rejectReason = impulse.CanUseName(formatted)

			if not clear then
				Derma_Message(rejectReason, "impulse", "OK")
			else
				net.Start("impulseOpsDoNamechange")
				net.WriteString(formatted)
				net.SendToServer()

				panel:Remove()
			end
		end
	end)
end

local changeNameCommand = {
	description = "Force changes the specified players name.",
	requiresArg = true,
	adminOnly = true,
	onRun = function(ply, arg, rawText)
		local name = arg[1]
		local plyTarget = impulse.FindPlayer(name)

		if plyTarget then
			net.Start("impulseOpsNamechange")
			net.Send(plyTarget)

			plyTarget.NameChangeForced = true
			ply:Notify(plyTarget:Name() .. " has been forced name-changed.")
		else
			return ply:Notify("Could not find player: " .. tostring(name))
		end
	end
}

impulse.RegisterChatCommand("/forcenamechange", changeNameCommand)
