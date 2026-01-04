
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

local ApartmentID = 0
impulse.Properties = impulse.Properties or {}
impulse.Properties.ApartmentData = impulse.Properties.ApartmentData or {}

-------------
-- Hooks   --
-------------
function PLUGIN:PostSetupPlayer( ply )
    timer.Simple( 15, function()
        ply:SetSyncVar( SYNC_APARTMENT, impulse.Properties.VacantApartment(), true )
    end )
end

local combine_teams = {
    [TEAM_OTA] = true,
    [TEAM_CP] = true,
    [TEAM_CA] = true
}

function PLUGIN:PlayerChangeTeam( ply, OldTeam, NewTeam )

    if combine_teams[ NewTeam ] then
        impulse.Properties.MakeVacant( ply )
        return
    end

    if NewTeam == TEAM_CWU and not ply:GetSyncVar( SYNC_APARTMENT, nil ) then
        ply:AssignApartment()
    end

end



----------------
-- Functions  --
----------------

function impulse.Properties.VacantApartment()


    for I = 1, #impulse.Properties.ApartmentData do
        local Data = impulse.Properties.ApartmentData[ I ]

        if Data.Owners != {} then
            continue
        end

        return I
    end

end

function meta:AssignApartment()
    local apt = impulse.Properties.VacantApartment()
    self:SetSyncVar( SYNC_APARTMENT, apt, true )

    for _, DoorIndex in ipairs( impulse.Properties.ApartmentData[ apt ].Doors ) do
        local Door = Entity( DoorIndex )
        self:SetDoorMaster( Door )
    end

    impulse.Properties.ApartmentData[ apt ].Owners[ self ] = true
end

function impulse.Properties.MakeVacant( Apt )

    if Apt:IsPlayer() then
        impulse.Properties.ApartmentData[ Apt:GetSyncVar( SYNC_APARTMENT, nil ) ].Owners[ Apt ] = nil
        Apt:SetSyncVar( SYNC_APARTMENT, nil, true )
    elseif isnumber( Apt ) then
        local owners = impulse.Properties.ApartmentData[ Apt ].Owners

        for I = 1, #owners do
            local owner = owners[ I ]

            if not owner:IsValid() then
                continue
            end

            owner:SetSyncVar( SYNC_APARTMENT, nil, true )
        end

        impulse.Properties.ApartmentData[ Apt ].Owners = {}
    end

end

function impulse.Properties.RegisterApartment( Data )
    ApartmentID = ApartmentID + 1

    Data.Doors = {}

    for Index, Pos in ipairs( Data.DoorPos ) do

        for _, Ent in ipairs( ents.FindInBox( Pos, Pos ) ) do

            if ( Ent:GetClass() != "func_door" ) and ( Ent:GetClass() != "prop_door_rotating" ) then
                continue
            end

            Data.Doors[ Index ] = Ent:EntIndex()
            break
        end
    end

    Data.DoorPos = nil
    Data.Owners = Data.Owners or {}
    impulse.Properties.ApartmentData[ ApartmentID ] = Data
end


-----------------------
-- Register template --
-----------------------
--[[
-- use impulse_debug_ent_pos to get doorpos
impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -69, 214.25),
    },
    NiceName = "Apartment 101",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(405, -325, 214.25),
    },
    NiceName = "Apartment 102",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -581, 214.25),
    },
    NiceName = "Apartment 103",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -69, 342.25),
    },
    NiceName = "Apartment 111",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -325, 342.25),
    },
    NiceName = "Apartment 112",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -581, 342.25),
    },
    NiceName = "Apartment 113",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -69, 470.25),
    },
    NiceName = "Apartment 121",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -325, 470.25),
    },
    NiceName = "Apartment 122",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(8405, -581, 470.25),
    },
    NiceName = "Apartment 123",
} )



impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9476, 3763, 310),
        Vector(9325, 3659, 310),
        Vector(9220, 3931, 310)
    },
    NiceName = "Apartment 201",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9475, 4237, 310),
        Vector(9220, 4053, 310),
        Vector(9324, 4387, 310)
    },
    NiceName = "Apartment 202",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9476, 3763, 438),
        Vector(9220, 3931, 438),
        Vector(9325, 3659, 438)
    },
    NiceName = "Apartment 211",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9475, 4237, 438),
        Vector(9220, 4053, 438),
        Vector(9324, 4387, 438)
    },
    NiceName = "Apartment 212",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9476, 3763, 566),
        Vector(9325, 3659, 566),
        Vector(9220, 3931, 566)
    },
    NiceName = "Apartment 221",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9475, 4237, 566),
        Vector(9220, 4053, 566),
        Vector(9324, 4387, 566)
    },
    NiceName = "Apartment 222",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9476, 3763, 694),
        Vector(9325, 3659, 694),
        Vector(9220, 3931, 694)
    },
    NiceName = "Apartment 231",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(9475, 4237, 694),
        Vector(9324, 4387, 694),
        Vector(9220, 4053, 694)
    },
    NiceName = "Apartment 232",
} )



impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6659, 2564, 310),
        Vector(6995, 2748, 310)
    },
    NiceName = "Apartment 301",
} )


impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6195, 2564, 310),
        Vector(6523, 2748, 310)
    },
    NiceName = "Apartment 302",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6659, 2564, 438),
        Vector(6995, 2748, 438)
    },
    NiceName = "Apartment 311",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6195, 2564, 438),
        Vector(6523, 2748, 438)
    },
    NiceName = "Apartment 312",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6659, 2564, 566),
        Vector(6995, 2748, 566)
    },
    NiceName = "Apartment 321",
} )

impulse.Properties.RegisterApartment( {
    DoorPos = {
        Vector(6195, 2564, 566),
        Vector(6523, 2748, 566)
    },
    NiceName = "Apartment 322",
} )
]]