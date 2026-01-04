
--[[ 
    Copyright (c) 2024; Dylan L.
    
    Created by mage_tearz@protonmail.com // github.com/mage-tearz

    Made for Pinecrest Project Half-Life 2 Roleplay;
    intended for use with the impulse framework.

    -- TERMS OF USE --
    The 'Code' is defined as any unique code or scripts found within this file which have been created by the author(s).

    You are required to include this entire Copyright notice in all copies of the Code.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute the Code.
    You are required to have prior written authorization from the original author(s) in order to use the Code in a multi-player game server.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute works derived from the Code.
    By using the Code, you agree to the TERMS OF USE.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    
    Failiure to comply with the TERMS OF USE is considered Copyright Infringement under 17 U.S. Code § 501.
]]

local util_AddNetworkString = util.AddNetworkString
local net_Receive = net.Receive
local net_ReadString = net.ReadString
local net_ReadUInt = net.ReadUInt
local GetSyncVar = GetSyncVar
local Alive = Alive
local EyePos = EyePos
local GetAimVector = GetAimVector
local util_TraceLine = util.TraceLine
local Entity = Entity
local IsValid = IsValid
local CanBuyDoor = CanBuyDoor
local IsCP = IsCP
local Notify = Notify
local CanAfford = CanAfford
local TakeMoney = TakeMoney
local hook_Run = hook.Run
local hook_Add = hook.Add

util_AddNetworkString( "Pinecrest.PurchaseProperty" )
util_AddNetworkString( "Pinecrest.SellProperty" )
util_AddNetworkString( "Pinecrest.SetPropertyName" )
util_AddNetworkString( "Pinecrest.UpdatePropertyData" )
util_AddNetworkString( "Pinecrest.AddPropertyOwner" )
util_AddNetworkString( "Pinecrest.RemovePropertyOwner" )


net_Receive( "Pinecrest.PurchaseProperty", function( _, ply )
    if (ply.nextDoorBuy or 0) > CurTime() then return end
    if not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    local Trace = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 85,
        filter = ply
    }
    
    local TraceEnt = util_TraceLine(Trace).Entity
    local DoorID = TraceEnt:GetDoor()
    local MasterDoor = Entity( DoorID )

    if not IsValid(TraceEnt) or not IsValid(MasterDoor) then
        return
    end

    if not ply:CanBuyDoor( MasterDoor:GetSyncVar( SYNC_DOOR_OWNERS, nil ), MasterDoor:GetSyncVar( SYNC_DOOR_BUYABLE, true ) ) then
        return
    end

    if ply:IsCP() then
        ply:Notify("You can't purchase a property as this team.")
        return
    end

    if not ply:CanAfford( impulse.Config.DoorPrice ) then
        ply:Notify("You cannot afford to buy this property.")
        return
    end

    for _, Dooor in ipairs( impulse.Properties.FindFellowDoors( DoorID ) ) do

        ply:SetDoorMaster( Entity( Dooor ) )

    end

--[[     if ply.CurrentQuest == QUEST_HOME_SWEET_HOME then
        ply:CompleteQuest(QUEST_HOME_SWEET_HOME)
    end ]]

    local Property = impulse.Properties.PropertyData[ impulse.Properties.FindByDoor( DoorID ) ]

    ply:TakeMoney( Property.Cost )
    ply:Notify("You have bought ".. Property.NiceName .. " for " .. impulse.Config.CurrencyPrefix .. Property.Cost .. ".")
    hook_Run("PlayerPurchaseDoor", ply, MasterDoor )
    ply.nextDoorBuy = CurTime() + 2
end)

net_Receive( "Pinecrest.SellProperty", function( _, ply )
    if (ply.nextDoorBuy or 0) > CurTime() then return end
    if not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    local Trace = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 85,
        filter = ply
    }
    
    local TraceEnt = util_TraceLine(Trace).Entity
    local DoorID = TraceEnt:GetDoor()
    local MasterDoor = Entity( DoorID )

    if not IsValid(TraceEnt) or not IsValid(MasterDoor) then
        return
    end

    if MasterDoor:GetDoorMaster() != ply then
        return
    end

    local ReturnCost = 0

    for _, Dooor in ipairs( impulse.Properties.FindFellowDoors( DoorID ) ) do
        ply:RemoveDoorMaster( Entity( Dooor ) )
    end

    local Property = impulse.Properties.PropertyData[ impulse.Properties.FindByDoor( DoorID ) ]
    local Cost = Property.Cost - ( 3 * #Property.Doors )

    Property.CustomName = Property.NiceName
    net.Start( "Pinecrest.UpdatePropertyData" )
        net.WriteUInt( impulse.Properties.FindByDoor( DoorID ), 8 ) -- The Property
        net.WriteString( "CustomName" )
        net.WriteString( Property.NiceName )
    net.Broadcast()

    ply:GiveMoney( Cost )
    ply:Notify("You have sold " .. impulse.Properties.PropertyData[ impulse.Properties.FindByDoor( DoorID ) ].NiceName .. " for " .. impulse.Config.CurrencyPrefix .. Cost .. ".")

    ply.nextDoorBuy = CurTime() + 2
end)

net.Receive( "Pinecrest.SetPropertyName", function( _, ply )
    if (ply.nextDoorBuy or 0) > CurTime() then return end
    if not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    local Trace = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 85,
        filter = ply
    }
    
    local TraceEnt = util_TraceLine(Trace).Entity
    local DoorID = TraceEnt:GetDoor()
    local MasterDoor = Entity( DoorID )

    if not IsValid(TraceEnt) or not IsValid(MasterDoor) then
        return
    end

    if MasterDoor:GetDoorMaster() != ply then
        return
    end

    local NameString = net.ReadString()

    if not NameString or not isstring( NameString ) then
        return
    end

    NameString = string.Left( NameString, 27 )
    impulse.Properties.PropertyData[ impulse.Properties.FindByDoor( DoorID ) ].CustomName = NameString
    
    ply:Notify( "You've set the property's name to " .. NameString .. "." )

    net.Start( "Pinecrest.UpdatePropertyData" )
        net.WriteUInt( impulse.Properties.FindByDoor( DoorID ), 8 ) -- The Property
        net.WriteString( "CustomName" )
        net.WriteString( NameString )
    net.Broadcast()

    ply.nextDoorBuy = CurTime() + 2
end )

net.Receive( "Pinecrest.AddPropertyOwner", function( _, ply )
    if (ply.nextDoorBuy or 0) > CurTime() then return end
    if not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    local Trace = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 85,
        filter = ply
    }
    
    local TraceEnt = util_TraceLine(Trace).Entity
    local DoorID = TraceEnt:GetDoor()
    local MasterDoor = Entity( DoorID )
    local Owners = MasterDoor:GetSyncVar(SYNC_DOOR_OWNERS, nil)

    if not IsValid(TraceEnt) or not IsValid(MasterDoor) then
        return
    end

    if MasterDoor:GetDoorMaster() != ply then
        return
    end

    local Target = net.ReadEntity()

    if Target.OwnedDoors and Target.OwnedDoors[ MasterDoor ] then
        return
    end

    if #Owners > 9 then
        return ply:Notify( "Occupant limit reached (9)." )
    end

    for I = 1, #impulse.Properties.FindFellowDoors( DoorID ) do
        local Dooor = impulse.Properties.FindFellowDoors( DoorID )[ I ]
        Target:SetDoorUser( Entity( Dooor ) )
    end
    

    local Cost = math.ceil(impulse.Config.DoorPrice / 2)

    ply:Notify("You have added " .. Target:Nick().." to this property for "..impulse.Config.CurrencyPrefix..Cost..".")
    ply:TakeMoney( Cost )
end )

net.Receive( "Pinecrest.RemovePropertyOwner", function( _, ply )
    if (ply.nextDoorBuy or 0) > CurTime() then return end
    if not ply:Alive() or ply:GetSyncVar(SYNC_ARRESTED, false) then return end

    local Trace = {
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * 85,
        filter = ply
    }
    
    local TraceEnt = util_TraceLine(Trace).Entity
    local DoorID = TraceEnt:GetDoor()
    local MasterDoor = Entity( DoorID )
    local Owners = MasterDoor:GetSyncVar(SYNC_DOOR_OWNERS, nil)

    if not IsValid(TraceEnt) or not IsValid(MasterDoor) then
        return
    end

    if MasterDoor:GetDoorMaster() != ply then
        return
    end

    local Target = net.ReadEntity()

    if not Target.OwnedDoors or not Target.OwnedDoors[  MasterDoor ] then
        return
    end

    if Target == ply then
        return
    end

    for I = 1, #impulse.Properties.FindFellowDoors( DoorID ) do
        local Dooor = impulse.Properties.FindFellowDoors( DoorID )[ I ]
        Target:RemoveDoorUser( Entity( Dooor ) )
    end

    ply:Notify( "You've removed " .. Target:Nick() .. " from this property." )
end )
