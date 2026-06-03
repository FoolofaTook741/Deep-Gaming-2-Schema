local PANEL = {}

function PANEL:Init()
	self:SetSize(705, 470)
	self:Center()
	self:SetTitle("ops E2 Viewer")
	self:MakePopup()
end

function PANEL:SetupE2S(e2s)
	self.list = vgui.Create("DListView", self)
	self.list:Dock(FILL)
	self.list:SetMultiSelect(false)

	self.list:AddColumn("Owner"):SetFixedWidth(210)
	self.list:AddColumn("SteamID"):SetFixedWidth(130)
	self.list:AddColumn("Name"):SetFixedWidth(260)
	self.list:AddColumn("CPU Time"):SetFixedWidth(90)

	self.list.lines = {}

	local panel = self

	for _, data in ipairs(e2s) do
		local cpuTime = tonumber(data.perf or 0) * 1000000

		if cpuTime < 0.01 then
			cpuTime = 0
		end

		local line = self.list:AddLine(
			data.owner or "unknown",
			data.steamid or "unknown",
			data.name or "unknown",
			string.format("%.3f", cpuTime)
		)

		line.Ent = data.ent
		line.E2OwnerName = data.owner or "unknown"
		line.E2SteamID = data.steamid or "unknown"

		table.insert(self.list.lines, line)

		function line:OnSelect()
			local row = self
			local m = DermaMenu()

			m:AddOption("Copy Owner SteamID", function()
				if not IsValid(row) then return end

				SetClipboardText(row.E2SteamID or "unknown")
				LocalPlayer():Notify("Copied SteamID.")
			end)

			m:AddOption("Delete E2", function()
				if not IsValid(row) then return end
				if not IsValid(row.Ent) then
					LocalPlayer():Notify("That E2 no longer exists.")
					return
				end

				net.Start("opsE2ViewerRemove")
					net.WriteEntity(row.Ent)
				net.SendToServer()

				panel:Remove()
			end):SetIcon("icon16/delete.png")

			m:AddOption("Blacklist E2", function()
				if not IsValid(row) then return end
				if not IsValid(row.Ent) then
					LocalPlayer():Notify("That E2 no longer exists.")
					return
				end

				net.Start("wire_e2_revoke")
					net.WriteEntity(row.Ent)
				net.SendToServer()

				panel:Remove()
			end):SetIcon("icon16/cancel.png")

			m:Open()
		end
	end
end

vgui.Register("impulseE2Viewer", PANEL, "DFrame")