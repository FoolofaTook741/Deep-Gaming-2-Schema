-- net and caching

impulse.States = impulse.States or {}

ops_statemenu = ops_statemenu or nil

net.Receive("opsOpenStateMenu", function()
    if not IsValid(ops_statemenu) then
        ops_statemenu = vgui.Create("opsStateMenu")
    end
end)

net.Receive("opsStateUpload", function()
    local ply = net.ReadEntity()
    local ste = net.ReadTable()

    impulse.States[ply:SteamID()] = ste
    
    if IsValid(ops_statemenu) then
        ops_statemenu:LoadPlayer(ply)
    end
end)

function clIPban(targ, duration)
    net.Start("DeepBanIPAddress")
    net.WriteUInt(duration, 8)
    net.WriteEnt(targ)
    net.SendToServer()
end