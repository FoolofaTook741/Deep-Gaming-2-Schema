if not E2Lib then
	return
end

if SERVER then
	util.AddNetworkString("opsE2Viewer")
	util.AddNetworkString("opsE2ViewerRemove")

	net.Receive("opsE2ViewerRemove", function(len, ply)
		if not ply:IsAdmin() then
			return
		end

		local chip = net.ReadEntity()

		if not IsValid(chip) then
			return
		end

		if chip:GetClass() != "gmod_wire_expression2" then
			return
		end

		chip:Remove()
		ply:Notify("Expression chip removed.")
	end)
end

local e2ViewerCommand = {
    description = "Opens the E2 viewer tool.",
    adminOnly = true,
    onRun = function(ply)
        local chips = ents.FindByClass("gmod_wire_expression2")
        local out = {}

        for _, chip in ipairs(chips) do
            if IsValid(chip) then
                local data = chip.GetOverlayData and chip:GetOverlayData() or nil

                out[#out + 1] = {
                    ent  = chip,
                    name = (data and data.txt) or "(no overlay data)",
                    perf = (data and data.timebench) or 0
                }
            end
        end

        net.Start("opsE2Viewer")
            net.WriteUInt(#out, 16)
            for _, v in ipairs(out) do
                net.WriteEntity(v.ent)
                net.WriteString(v.name)
                net.WriteFloat(v.perf)
            end
        net.Send(ply)
    end
}
impulse.RegisterChatCommand("/e2viewer", e2ViewerCommand)

