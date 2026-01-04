--[[
local nextGlitchedDataScan = 0
hook.Add( "Think", "corruptedplayersweep", function()
    if nextGlitchedDataScan <= CurTime() then
        for k,v in pairs(player.GetAll()) do
            if v:Team() and v:Team() >= 1 then
                if v:Nick() == v:SteamName() then
                    v:Kick("You have been disconnected for the server to prevent data corruption. If your Steam Name matches your RP Name, please change your Steam Name to connect.")
                end
            end
        end
        nextGlitchedDataScan = CurTime() + 30
    end
end)

hook.Add( "Think", "corruptedplayersweep", function()
	if nextGlitchedDataScan <= CurTime() then
    	for k,v in pairs(player.GetAll()) do
    	    if v:Team() < 1 then
				local ply = v
    	        local query = mysql:Select("impulse_players")
    	    	query:Select("id")
    	    	query:Select("rpname")
    	    	query:Select("group")
    	    	query:Select("rpgroup")
    	    	query:Select("rpgrouprank")
    	    	query:Select("xp")
    	    	query:Select("money")
    	    	query:Select("bankmoney")
    	    	query:Select("model")
    	    	query:Select("skin")
    	    	query:Select("data")
    	    	query:Select("skills")
    	    	query:Select("ammo")
    	    	query:Select("firstjoin")
    	    	query:Select("languages")
    	    	query:Select("sterilizedcredits")
    	    	query:Where("steamid", ply:SteamID())
    	    	query:Callback(function(result)
    	    		if IsValid(ply) and type(result) == "table" and #result > 0 then -- if player exists in db
    	    			isNew = false
    	    			impulse.SetupPlayer(ply, result[1])
    	    		elseif IsValid(ply) then
    	    			ply:Freeze(true)
    	    		end
				
    	    		if IsValid(ply) then
    	    			net.Start("impulseJoinData")
    	    			net.WriteBool(isNew)
    	    			net.Send(ply)
					
    	    			net.Start("impulseGetButtons")
    	    			net.WriteUInt(table.Count(impulse.ActiveButtons), 16)
					
    	    			for v,k in pairs(impulse.ActiveButtons) do
    	    				net.WriteUInt(v, 16)
    	    				net.WriteUInt(k, 16)
    	    			end
					
    	    			net.Send(ply)
    	    		end
    	    	end)
    	    	query:Execute()
    	    end
    	end
    	nextGlitchedDataScan = CurTime() + 30
	end
end)
--]]