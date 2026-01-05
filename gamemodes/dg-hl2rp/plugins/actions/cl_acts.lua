concommand.Add("impulse_hl2rp_printacts", function(ply, cmd, args)
    if ((ply.ListActions or 0) > CurTime()) then return end

    net.Start("impulseListActions")
    net.SendToServer()
end)

net.Receive("impulseListActions", function()
    local actlist = net.ReadTable()

    impulse.debugPrint("\nGetting Actions for your current team...")

    timer.Simple(1, function()
        for v,k in pairs(actlist) do
            print(v:lower())
        end
    end)
end)