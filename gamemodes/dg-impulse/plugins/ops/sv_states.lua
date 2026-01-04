-- State loader and downloader!

util.AddNetworkString("opsStateDownload")
util.AddNetworkString("opsStateUpload")
util.AddNetworkString("opsStateRestore")
util.AddNetworkString("opsOpenStateMenu")

net.Receive("opsStateDownload", function(len, ply)
    if (ply.lastTryStateDL or 0) > CurTime() then
        return
    end

    ply.lastTryStateDL = CurTime() + 2.5

    if not ply:IsAdmin() then
        return
    end

    local ent = net.ReadEntity()

    if not IsValid(ent) then
        return
    end

    if not ent:IsPlayer() then
        return
    end

    local states = table.Copy(ent:GetAllStates())

    if not states then
        return ply:Notify("This user has no saved states!")
    end

    local iStates = {} 

    for index, data in pairs(states) do
        for k, v in pairs(data) do
            if isfunction(v) then
                data[k] = nil
            end
        end
        iStates[index] = data
    end

    -- Callback to the user!
    net.Start("opsStateUpload")
    net.WriteEntity(ent)
    net.WriteTable(iStates)
    net.Send(ply)

end)

net.Receive("opsStateRestore", function(len, ply)
    if (ply.lastTryStateRestore or 0) > CurTime() then
        return
    end

    ply.lastTryStateRestore = CurTime() + 2.5

    if not ply:IsAdmin() then
        return
    end

    local ent = net.ReadEntity()

    if not IsValid(ent) then
        return
    end

    if not ent:IsPlayer() then
        return
    end

    local stateIndex = net.ReadString()

    local state = ent:ReadState(stateIndex)

    if not state then
        return
    end

    ent:Notify("You have been restored to a previous point in time by a Game Moderator.")
    ent:RestoreState(stateIndex)
end)