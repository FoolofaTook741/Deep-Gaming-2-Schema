plogs.Register('Chat', false)

local hook_name = 'iPostPlayerSay'
plogs.AddHook(hook_name, function(pl, text)
	if (text ~= '') then

		local  msg = pl:NameID() .. ' said ' .. string.Trim(text)
		local msgLog = '`' .. pl:NameID() .. '` said `' .. string.Trim(text) .. '`'
		
		MsgC(team.GetColor(pl:Team()),pl:Name(),Color(180,180,180),"(",pl:SteamID(),")(",pl:SteamName(),") ",Color(255,255,255),"said ",string.Trim(text),"\n")

		plogs.PlayerLog(pl, 'Chat', msg, {
			['Name'] 	= pl:Name(),
			['SteamID']	= pl:SteamID()
		})
	end
end)