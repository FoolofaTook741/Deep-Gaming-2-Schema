hook.Add("Initialize", "crashmenu", function()
    if game.SinglePlayer() then return end

    crashmenu = {}
    crashmenu.Host = "reconnect.bell.moe"

    include("crashmenu/sh_config.lua")

    if SERVER then
        AddCSLuaFile("crashmenu/sh_config.lua")
        AddCSLuaFile("crashmenu/vgui/ReconnectPanel.lua")
        AddCSLuaFile("crashmenu/cl_init.lua")
        include("crashmenu/sv_init.lua")
    end

    if CLIENT then
        include("crashmenu/cl_init.lua")

        RunConsoleCommand("cl_timeout", "7200")
    end
end)
