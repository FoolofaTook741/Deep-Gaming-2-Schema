local content = [[<font=Impulse-Elements18><font=Impulse-SpecialFont>Happy Halloween!</font>

<colour=255, 149, 11><font=Impulse-Elements23-Shadow>BooooOOOO! Oh it's you! #SteamName!</font></colour>
It's that spooooo0000kky time of the year again! Halloween! This time around, we've decided to make some special changes to impulse to get in the haunting spirit!

<colour=255, 149, 11><font=Impulse-Elements23-Shadow>Somethin's up with the city</font></colour>
I don't know about you but I feel like for some reason it's got darker, a purple haze has decended upon us and there's this awful storm that makes a constant racket. No, we haven't changed maps to Manchester, we've actually made some spooky thematic changes!

<colour=255, 149, 11><font=Impulse-Elements23-Shadow>Trick or treat!</font></colour>
Our resident spooky skeleton man/ghost/skeleton/entity, Numbskull has moved into the Plaza. He sells all sorts of spooky masks that you can wear to scare people with!

<colour=255, 149, 11><font=Impulse-Elements23-Shadow>Treats!</font></colour>
CWU commercial workers can now sell spooky halloween treats (TM) for a limited time!

<colour=255, 149, 11><font=Impulse-Elements23-Shadow>Warning</font></colour>
A serious final note - while adding all these changes I ran into a few weird things happening. A bugged bit of code seems to be taking over entities on the server. Really weird. Let me know if you see it.
</font>]]

function PLUGIN:ShowMenuModalMessage()
	local c = cookie.GetNumber("impulse_updatemessage_seen_hal2021")

    if c then
        return
    end

    cookie.Set("impulse_updatemessage_seen_hal2021", 1)

	local x = vgui.Create("impulseUpdateMessage")
	x:SetContent(string.Replace(content, "#SteamName", LocalPlayer():SteamName()))
end
