net.Receive("pinnacle_lockdestroyed", function()
	local lock = net.ReadVector()
	local add = 0.1
	timer.Simple(add, function()
		surface.PlaySound("npc/overwatch/radiovoice/attention.wav")
	end)
	timer.Simple(2 + add, function()
		LocalPlayer():SendCombineMessage("LOCK DESTROYED IN "..impulse.GetZoneFromPos(lock), Color(255, 165, 0))
		impulse.AddCombineWaypoint("LOCKBREACH", lock, 60, 6, 4, 4)
	end)
end)

net.Receive("PGVoiceRadioOn", function()
    surface.PlaySound("npc/overwatch/radiovoice/on1.wav")
end)

net.Receive("PGVoiceRadioOff", function()
    surface.PlaySound("npc/metropolice/vo/off1.wav")
end)
