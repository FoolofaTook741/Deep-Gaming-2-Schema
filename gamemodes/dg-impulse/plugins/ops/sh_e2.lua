if not E2Lib then
	return
end

if SERVER then
	util.AddNetworkString("opsE2Viewer")
	util.AddNetworkString("opsE2ViewerRemove")

	local function CleanString(str, fallback)
		str = tostring(str or fallback or "")
		str = str:gsub("[\r\n\t]", " ")
		str = str:Trim()

		if str == "" then
			str = fallback or "unknown"
		end

		if #str > 160 then
			str = str:sub(1, 160) .. "..."
		end

		return str
	end

	local function GetE2Owner(chip)
		if not IsValid(chip) then return nil end

		if IsValid(chip.player) and chip.player:IsPlayer() then
			return chip.player
		end

		if chip.GetPlayer then
			local ply = chip:GetPlayer()
			if IsValid(ply) and ply:IsPlayer() then
				return ply
			end
		end

		if chip.CPPIGetOwner then
			local ply = chip:CPPIGetOwner()
			if IsValid(ply) and ply:IsPlayer() then
				return ply
			end
		end

		if IsValid(chip:GetCreator()) and chip:GetCreator():IsPlayer() then
			return chip:GetCreator()
		end

		return nil
	end

	net.Receive("opsE2ViewerRemove", function(len, ply)
		if not IsValid(ply) or not ply:IsAdmin() then return end

		local chip = net.ReadEntity()

		if not IsValid(chip) then
			ply:Notify("Invalid E2 chip.")
			return
		end

		if chip:GetClass() ~= "gmod_wire_expression2" then
			ply:Notify("That is not an E2 chip.")
			return
		end

		chip:Remove()
		ply:Notify("Expression chip removed.")
	end)

	local e2ViewerCommand = {
		description = "Opens the E2 viewer tool.",
		adminOnly = true,
		onRun = function(ply)
			if not IsValid(ply) or not ply:IsAdmin() then return end

			local chips = ents.FindByClass("gmod_wire_expression2")
			local out = {}

			for _, chip in ipairs(chips) do
				if IsValid(chip) then
					local overlay = chip.GetOverlayData and chip:GetOverlayData() or {}
					local owner = GetE2Owner(chip)

					local ownerName = "unknown"
					local ownerSteamID = "unknown"

					if IsValid(owner) then
						ownerName = CleanString(owner:Nick(), "unknown")
						ownerSteamID = CleanString(owner:SteamID(), "unknown")
					end

					out[#out + 1] = {
						ent = chip,
						ownerName = ownerName,
						ownerSteamID = ownerSteamID,
						name = CleanString(overlay.name or overlay.txt, "(no overlay data)"),
						perf = tonumber(overlay.timebench or 0) or 0
					}
				end
			end

			table.sort(out, function(a, b)
				return a.perf > b.perf
			end)

			net.Start("opsE2Viewer")
				net.WriteUInt(#out, 16)

				for _, v in ipairs(out) do
					net.WriteEntity(v.ent)
					net.WriteString(v.ownerName)
					net.WriteString(v.ownerSteamID)
					net.WriteString(v.name)
					net.WriteFloat(v.perf)
				end
			net.Send(ply)
		end
	}

	impulse.RegisterChatCommand("/e2viewer", e2ViewerCommand)
end