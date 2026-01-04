local PANEL = {}

function PANEL:Clear()
end

function PANEL:LoadPlayer(ply)
	self.i__Player = ply

	self.m_Restore:Show()

	local btn = self.m_StateView
	btn:Show()
	btn:Clear()
	
	for index, istate in pairs(impulse.States[ply:SteamID()]) do
		
		btn:AddChoice(index, index)

	end

end

function PANEL:Init()

	-- self instance exists everywhere
	local panel = self

	-- Security!
	local Me = LocalPlayer()
	if not Me.IsAdmin(Me) then
		self.Remove(self)
		return
	end 

	-- Setup Screen
	self.SetSize(self, 400, 500)
	self.SetTitle(self, "Open Permission System - State Viewer")
	self.Center(self)
	self.MakePopup(self)

	-- Internal Values
	self.i__Visible = false -- Invis by default so you can load a player.
	self.i__State   = nil
	self.i__Player  = nil

	-- Create the elements
	self.m_Character = vgui.Create("DModelPanel", self, "opsCharacterDisplay")
	self.m_PlayerSel = vgui.Create("DTextEntry", self, "opsPlayerNameEntry")
	self.m_Download  = vgui.Create("DButton", self, "opsDownloadStateButton")
	self.m_StateView = vgui.Create("DComboBox", self, "opsStateSelector")
	self.m_Restore   = vgui.Create("DButton", self, "opsRestoreButton")
	self.m_Stats     = vgui.Create("DPanel", self, "opsStats")

	-- Setup the elements --

	-- Character Display
	local P = self.m_Character
	P:Dock(FILL)
	P:MoveToBack()
	P:Hide()

	function P:LayoutEntity() 
	end

	-- Player Selector
	local P = self.m_PlayerSel
	P:SetWide(370)
	P:CenterHorizontal()
	P:SetY(450 - P:GetTall())
	P:SetPlaceholderText("Player Name...")
	P:SetText("")

	-- Autocomplete!
	function P:GetAutoComplete(text)
		-- y es i did take this from gmod wiki :)
		local suggestions = {}

		for _, ply in ipairs( player.GetAll() ) do -- For every player,
			if string.StartWith( ply:Nick(), text ) then -- if the player's name starts with it...
				table.insert( suggestions, ply:Nick() ) -- ... insert it into the list.
			end
		end

		return suggestions
	end

	-- Download button
	local P = self.m_Download
	P:SetText("Download")
	P:SetWide(370)
	P:CenterHorizontal()
	P:SetY( 475 - P:GetTall() )
	
	function P:DoClick()

		local pl = impulse.FindPlayer( panel.m_PlayerSel:GetValue() )

		if IsValid(pl) then
			net.Start("opsStateDownload")
			net.WriteEntity( pl )
			net.SendToServer()
			return
		end

		self.SetText(self, "Invalid Player")
		self.SetEnabled(self, false)

		timer.Simple(2.5, function()

			if IsValid(self) then

				self.SetText(self, "Download")
				self.SetEnabled(self, true)

			end

		end)
		
	end
	
	local P = self.m_StateView
	P:SetWide(250)
	P:SetPos(15,40)
	P:Hide()

	local P = self.m_Restore
	P:SetWide(105)
	P:SetPos(280, 40)
	P:SetText("Restore State")
	P:Hide()
	function P:DoClick()
		local state = panel.m_StateView:GetSelected()
		local pl    = panel.i__Player

		net.Start("opsStateRestore")
		net.WriteEntity(pl)
		net.WriteString(state)
		net.SendToServer()
	end

	local P = self.m_Stats
	P:MoveToBack()
	P:Dock(FILL)

	local skipStats = {
		["model"] = true,
		["pos"] = true,
		["ang"] = true,
		["skin"] = true
	}

	P.Paint = function(p, w, h)
		if self.i__Player then
			local i = self.m_StateView:GetValue()
			if i then
				local state = impulse.States[self.i__Player:SteamID()][i] 
				if state then
					local str = ""
					for k, v in pairs(state.meta) do
						if skipStats[k] then continue end
						str = str .. k .. ": " .. tostring(v) .. "\n"
					end
					draw.DrawText(str, "BudgetLabel", 15, 60, color_white, TEXT_ALIGN_LEFT)
				end
			end
		end
	end

end

vgui.Register("opsStateMenu", PANEL, "DFrame")