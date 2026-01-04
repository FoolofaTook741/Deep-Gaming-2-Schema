util.AddNetworkString("impulseHL2RPApartmentNew")
util.AddNetworkString("impulseHL2RPApartmentNewDerma")
util.AddNetworkString("impulseHL2RPApartmentNewBroadcast")

util.AddNetworkString("impulseHL2RPApartmentAddDoor")
util.AddNetworkString("impulseHL2RPApartmentAddDoorDerma")
util.AddNetworkString("impulseHL2RPApartmentAddDoorBroadcast")

util.AddNetworkString("impulseHL2RPApartmentRemoveDoor")
util.AddNetworkString("impulseHL2RPApartmentRemoveDoorBroadcast")

util.AddNetworkString("impulseHL2RPApartmentAddBlock")
util.AddNetworkString("impulseHL2RPApartmentAddBlockDerma")
util.AddNetworkString("impulseHL2RPApartmentAddBlockBroadcast")

local function AddApartment(name, block)
    impulse.ApartmentBlocks[block]:AddApartment(Apartment(name))
    net.Start("impulseHL2RPApartmentNewBroadcast")
    net.WriteString(name)
    net.WriteInt(block, 8)
    net.Broadcast()
end

concommand.Add("impulse_apartments_add", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    net.Start("impulseHL2RPApartmentNewDerma")
    net.Send(ply)
end)

net.Receive("impulseHL2RPApartmentNew", function(len, ply)
    if not ply:IsSuperAdmin() then return end
    AddApartment(net.ReadString(), net.ReadInt(8))
    ply:Notify("You have added a new apartment.")
end)

local function AddDoorToApartment(door, blockNr, aptNr)
    local block = impulse.ApartmentBlocks[blockNr]
    local apartment = block.apartments[aptNr]
    apartment:AddDoor(door)

    net.Start("impulseHL2RPApartmentAddDoorBroadcast")
    net.WriteEntity(door)
    net.WriteInt(blockNr, 8)
    net.WriteInt(aptNr, 8)
    net.Broadcast()
end

local function RemoveDoorFromApartment(door)
    for v, k in pairs(impulse.ApartmentBlocks) do
        for a, b in pairs(k.apartments) do
            b:RemoveDoor(door)
        end
    end

    net.Start("impulseHL2RPApartmentRemoveDoorBroadcast")
    net.WriteEntity(door)
    net.Broadcast()
end

concommand.Add("impulse_apartments_markdoor", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    net.Start("impulseHL2RPApartmentAddDoorDerma")
    net.Send(ply)
end)

concommand.Add("impulse_apartments_unmarkdoor", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 200
    trace.filter = ply
    local traceEnt = util.TraceLine(trace).Entity

    RemoveDoorFromApartment(traceEnt)
end)

net.Receive("impulseHL2RPApartmentAddDoor", function(len, ply)
    if not ply:IsSuperAdmin() then return end
    local door = net.ReadEntity()
    local aptBlockNr = net.ReadInt(8)
    local aptNr = net.ReadInt(8)

    AddDoorToApartment(door, aptBlockNr, aptNr)

    ply:Notify("You have added a door to an apartment")
end)

local function AddBlock(name)
    table.insert(impulse.ApartmentBlocks, ApartmentBlock(name))
    net.Start("impulseHL2RPApartmentAddBlockBroadcast")
    net.WriteString(name)
    net.Broadcast()
end

concommand.Add("impulse_apartments_newblock", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    net.Start("impulseHL2RPApartmentAddBlockDerma")
    net.Send(ply)
end)

net.Receive("impulseHL2RPApartmentAddBlock", function(len, ply)
    if not ply:IsSuperAdmin() then return end
    local name = net.ReadString()
    AddBlock(name)
    ply:Notify("New city block added called " .. name)
end)

concommand.Add("impulse_apartments_save", function(ply, cmd, args)
    if not ply:IsSuperAdmin() then return end
    local maxPlayers = game.MaxPlayers()
    local savedApartments = {}
    savedApartments = impulse.ApartmentBlocks

    for v, k in pairs(impulse.ApartmentBlocks) do
        for a, b in pairs(k.apartments) do
            for c, d in pairs(b.doors) do
                savedApartments[v].apartments[a].doors[c] = d - maxPlayers
            end
        end
    end

    print(table.ToString(savedApartments, "copy this --> ", false))
    ply:Notify("Table printed to console.")
end)

