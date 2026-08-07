net.Receive("impulseRefreshGroupRank", function()
    local expectedGroup = net.ReadString()

    timer.Remove("impulseWaitForGroupRank")

    timer.Create("impulseWaitForGroupRank", 0.1, 50, function()
        local ply = LocalPlayer()

        if not IsValid(ply) then
            return
        end

        if ply:GetUserGroup() != expectedGroup then
            return
        end

        timer.Remove("impulseWaitForGroupRank")
        hook.Run("PostReloadToolsMenu")
    end)
end)