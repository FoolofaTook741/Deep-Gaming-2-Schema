if SERVER then
	util.AddNetworkString("impulseHL2RPJoinRank")
else
	net.Receive("impulseHL2RPJoinRank", function()
	local redColor = Color(255, 0, 0)

		local entIndex = net.ReadUInt(8)
	    local team = net.ReadUInt(8)
	    local class = net.ReadUInt(8)
		local ply = Entity(entIndex)
		timer.Simple(2.5, function() 
			if ply and IsValid(ply) and ply:IsPlayer() then
				if team == TEAM_OTA and class == CLASS_FIST then
					LocalPlayer():SendCombineMessage("ELITE GRADE ASSET " ..ply:Name().. " IS FULL ACTIVE", redColor)
				elseif team == TEAM_OTA then
					LocalPlayer():SendCombineMessage(ply:Name().." IS FULL ACTIVE")
				elseif team == TEAM_CP then
					LocalPlayer():SendCombineMessage(ply:Name().." IS 10-8")
				elseif team == TEAM_STALKER then
					LocalPlayer():SendCombineMessage(string.upper(ply:GetSavedRPName()).." HAS BEEN STALKERIZED")
				else
					LocalPlayer():SendCombineMessage(string.upper(ply:Name()).." IS IN SERVICE")
				end
			end
		end)
	end)
end

local dispatchNumbers = {
	[0] = "npc/overwatch/radiovoice/zero.wav",
	[1] = "npc/overwatch/radiovoice/one.wav",
	[2] = "npc/overwatch/radiovoice/two.wav",
	[3] = "npc/overwatch/radiovoice/three.wav",
	[4] = "npc/overwatch/radiovoice/four.wav",
	[5] = "npc/overwatch/radiovoice/five.wav",
	[6] = "npc/overwatch/radiovoice/six.wav",
	[7] = "npc/overwatch/radiovoice/seven.wav",
	[8] = "npc/overwatch/radiovoice/eight.wav",
	[9] = "npc/overwatch/radiovoice/nine.wav"
}

function impulse.DispatchNumbersToVoice(number)
	number = tostring(number)
	local sounds = {}

	for v,k in pairs(string.ToTable(number)) do
		k = tonumber(k)
		if dispatchNumbers[k] then
			table.insert(sounds, dispatchNumbers[k])
		end
	end

	return sounds
end

function impulse.DispatchVoiceRead(lines, wait)
	local wait = wait or .6
	local queue = 0

	for v,k in pairs(lines) do
		timer.Simple(queue, function()
			surface.PlaySound(k)
		end)
		queue = queue + wait
	end

	return queue - wait
end