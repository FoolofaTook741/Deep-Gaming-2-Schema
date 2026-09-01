util.AddNetworkString("crashmenu_heartbeat")

timer.Create("crashmenu_heartbeat_broadcast", 1, 0, function()
    net.Start("crashmenu_heartbeat")
    net.Broadcast()
end)

RunConsoleCommand("sv_hibernate_think", "1")

local posting = false
hook.Add("Think", "crashmenu", function()
    if posting then return end
    if game.GetIPAddress():match("^0.0.0.0:%d+$") or game.GetIPAddress():match("loopback") then return end
    posting = true
    HTTP({
        url = ("https://%s/server/status"):format(crashmenu.Host),
        method = "POST",
        parameters = {
            host = game.GetIPAddress(),
            hostname = GetHostName(),
            chatroomUuid = crashmenu.Config.ChatRoomID
        },
        success = function(code, res)
            hook.Remove("Think", "crashmenu")
            posting = false
            Msg("[crashmenu] ")print("sent POST")
        end,
        failed = function()
            posting = false
        end
    })
end)
