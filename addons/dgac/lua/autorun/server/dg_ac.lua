-- Took it from an old github repo, temp AC before we get IACv2
-- 302 net message exploiting

util.AddNetworkString("_Detect") -- Detection network string
util.AddNetworkString('Sandbox_ArmDupe') -- Sandbox ArmDupe network string
util.AddNetworkString('Ulib_Message') -- ULib_Message network string
util.AddNetworkString('DarkRP_AdminWeapons') -- DarkRP AdminWeapons network string
util.AddNetworkString('ac.detect') -- ac.detect network string



local function RequestLeyScreenshot(ply, reason)
    if not IsValid(ply) then return end

    local sid64 = ply:SteamID64()
    local method = 1
    local quality = 50
    local wants_stream = false
    local stream_wait = 0
	if LeyScreenCap and LeyScreenCap.StartCapture then
		LeyScreenCap.StartCapture(nil, ply, sid64, method, quality, wants_stream, stream_wait)
	end

    timer.Simple(10, function()
        if not IsValid(ply) then return end
        ply:Kick(reason)
        if VyHub then
            VyHub.Ban:create(ply:SteamID64(), 0, reason)
        end
    end)
end

net.Receive("ac.detect", function(len, ply)
	RequestLeyScreenshot(ply, "[PG AC]: Incident #200")
end)

net.Receive("DarkRP_AdminWeapons", function(len, ply)
	RequestLeyScreenshot(ply, "[PG AC]: Incident #299")
end)

net.Receive("StackGhost", function(len, ply)
	RequestLeyScreenshot(ply, "[PG AC]: Incident #300")
end)

net.Receive("Sandbox_ArmDupe", function(len, ply)	
	RequestLeyScreenshot(ply, "[PG AC]: Incident #301")
end)

net.Receive("Ulib_Message", function(len, ply)
	RequestLeyScreenshot(ply, "[PG AC]: Incident #302")
end)

net.Receive("_Detect", function(len,ply)
	local a = net.ReadString()
	if a == "external" then
		RequestLeyScreenshot(ply, "[PG AC]: Incident #400")
	elseif a == '' then
		RequestLeyScreenshot(ply, "[PG AC]: Incident #401")
	end
end)

net.OldIncoming = net.OldIncoming or net.Incoming
local netplys = {}
local nextlog = 0

function net.Incoming(length, client)
    netplys[client] = (netplys[client] or 0) + 1
    net.OldIncoming(length, client)
end

--[[timer.Create("netabuse_timer", 1, 0, function() 
    for pl, num  in pairs(netplys) do
        if num > 250 then
        	print("DETECTED -- NET MESSAGE SPAM -- "..pl:Name().." ("..pl:SteamID()..")")
            pl:Kick("[PG AC]: You have been banned from this server!") -- Kick message for NET message spam
            
            for _, admin in ipairs(player.GetHumans()) do
                if admin:IsAdmin() then
                    admin:Notify(pl:Name() .. " is attempting to lag the server using NET message spam. -- False positives may be possible!")
                end
            end
            
            if CurTime() > nextlog then
                local Timestamp = os.time()
                local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)

                if not file.Exists("lognetfucker.txt", "DATA") then
                    file.Write("lognetfucker.txt", pl:Name() .. " (" .. pl:SteamID() .. ") - " .. TimeString .. "  NET: " .. strName .. "\n")
                else
                    file.Append("lognetfucker.txt", pl:Name() .. " (" .. pl:SteamID() .. ") - " .. TimeString .. "  NET: " .. strName .. "\n")
                end
                nextlog = CurTime() + 15
            end
        end
    end
    table.Empty(netplys)
end)]]

--[[
hook.Add('PlayerSpawnedProp', 'AntiGay_PS', function(pl, mdl, ent)

	for k, v in pairs(ents.FindInSphere(ent:LocalToWorld(ent:OBBCenter()), ent:BoundingRadius())) do
        if v:IsPlayer() and not v:InVehicle() and not tobool(v:GetObserverMode()) or v:IsVehicle() then
            if ent:NearestPoint(v:NearestPoint(ent:GetPos())):Distance(v:NearestPoint(ent:GetPos())) <= 20 then
              	ent.lalka = true
            end
        end
    end

    if ent.lalka then
    	--ent:Remove()			
        -- 
    end
end)
--]]