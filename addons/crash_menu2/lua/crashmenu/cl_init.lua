include("crashmenu/vgui/ReconnectPanel.lua")

local function create()
    if not IsValid(crashmenu.Panel) then
        crashmenu.Panel = vgui.Create("ReconnectPanel")
        crashmenu.Panel:Hide()
    end
end
hook.Add("PostRender", "crashmenu", function()
    timer.Simple(0, function()
        create()
    end)
    hook.Remove("PostRender", "crashmenu")
end)

local function urlencode(url)
    if not url then
        return
    end

    url = tostring(url)
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    url = url:gsub(" ", "+")
    return url
end
local function ping(success)
    HTTP({
        url = ("http://%s/server/status?host=%s&hostname=%s&chatroomUuid=%s"):format(
            crashmenu.Host,
            urlencode(game.GetIPAddress()),
            urlencode(GetHostName()),
            urlencode(crashmenu.Config.ChatRoomID)
            -- urlencode(os.time())
        ),
        method = "GET",
        success = success,
        failed = function(...) print(...) end
    })
end

local checkDelay = 1
local offlineTimes = 0
local lastCheck = 0
local lastHeartbeat = RealTime()
local joinTime

net.Receive("crashmenu_heartbeat", function()
    lastHeartbeat = RealTime()
end)

hook.Add("Think", "crashmenu", function()
    if not IsValid(crashmenu.Panel) then return end
    if RealTime() < lastCheck then return end

    if not joinTime then
        joinTime = 0
        ping(function(code, res)
            if code == 200 then
                joinTime = (tonumber(res) or 0)
            else
                joinTime = nil
            end
        end)
    end

    local sinceHeartbeat = RealTime() - lastHeartbeat
    local stalled = sinceHeartbeat > 2

    if stalled then
        offlineTimes = offlineTimes + 1
        --print(("[crashmenu-debug] stall check #%d sinceHeartbeat=%.3f"):format(offlineTimes, sinceHeartbeat))
        if offlineTimes > 3 then
            --print("[crashmenu-debug] SHOWING panel")
            checkDelay = 5
            crashmenu.Panel:Show()
            ping(function(code, res)
                if code == 200 and joinTime < (tonumber(res) or 0) then
                    crashmenu.Panel.Reconnecting = true
                    crashmenu.Panel.NextTry = RealTime() + 3
                end
            end)
        end
    else
        if offlineTimes > 0 then
            --print(("[crashmenu-debug] reset after %d stall check(s), sinceHeartbeat=%.3f"):format(offlineTimes, sinceHeartbeat))
        end
        checkDelay = 1
        offlineTimes = 0
        crashmenu.Panel.Reconnecting = false
        crashmenu.Panel.NextTry = nil
        crashmenu.Panel:Hide()
    end

    lastCheck = RealTime() + checkDelay
end)
