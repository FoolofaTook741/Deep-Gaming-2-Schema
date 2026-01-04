net.Receive("DeepRadioSetSong", function()
    local radio = net.ReadEntity()
	Derma_StringRequest("impulse", 
		"Enter string of song you'd like to play (To find strings, use the spawn menu):",
		nil, function(text)
			if not text then
				return LocalPlayer():Notify("You must enter text.")
			end

			net.Start("DeepRadioPlaySong")
			net.WriteString(text)
            net.WriteEntity(radio)
			net.SendToServer()
		end, nil, "Play Song")
end)