-- Server-side only
if CLIENT then return end

concommand.Add("tp_me", function(ply, cmd, args)
    -- Must be a player
    if not IsValid(ply) then
        print("This command must be run by a player.")
        return
    end

    -- Admin check
    if not ply:IsAdmin() then
        ply:ChatPrint("You must be an admin to use this command.")
        return
    end

    if #args < 3 then
        ply:ChatPrint("Usage: tp_me <x> <y> <z>")
        return
    end

    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])

    if not x or not y or not z then
        ply:ChatPrint("Invalid position values.")
        return
    end

    -- Teleport
    ply:SetPos(Vector(x, y, z))
    ply:SetVelocity(Vector(0, 0, 0))

    ply:ChatPrint(
        string.format("Teleported to (%.3f, %.3f, %.3f)", x, y, z)
    )
end)