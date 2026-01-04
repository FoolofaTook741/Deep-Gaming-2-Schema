net.Receive("opsDevOpen",function()
    local lp = LocalPlayer()
    if not lp:IsSuperAdmin() and not lp:IsDeveloper() then return end
    impulse.DevTools = vgui.Create("impulseOpsDevTools")
end)