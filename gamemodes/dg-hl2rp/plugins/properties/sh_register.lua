
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


impulse.Properties.PropertyData = {

    -- Industrial 17 landis, Plaza and Shops

    [1] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 3173,
            [2] = 2460,
            [3] = 2462,
            [4] = 2470,
        },
        ["NiceName"] = "Change",
    },
    [2] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 2471,
            [2] = 2466,
            [3] = 2467,
            [4] = 2469,
        },
        ["NiceName"] = "Foto",
    },
    [3] = {
        ["Cost"] = 25,
        ["Doors"] = {
            [1] = 1021,
            [2] = 1731,
            [3] = 1732,
        },
        ["NiceName"] = "Café Baltic",
    },
    [4] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 1093,
        },
        ["NiceName"] = "Atlantic",
    },
    [5] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 1076,
        },
        ["NiceName"] = "Commercial Center 2",
    },
    [6] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 2582,
            [2] = 2495,
            [3] = 2500,
            [4] = 2502,
        },
        ["NiceName"] = "Souvenirs",
    },
    [7] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 2723,
            [2] = 2491,
            [3] = 2503,
        },
        ["NiceName"] = "ХССГ",
    },

    -- Diordna

    [8] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1019,
            [2] = 1242,
            [3] = 1243,
        },
        ["NiceName"] = "101",
    },
    [9] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1328,
            [2] = 1329,
            [3] = 1330,
        },
        ["NiceName"] = "102",
    },

    [10] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1331,
            [2] = 1335,
            [3] = 1336,
        },
        ["NiceName"] = "201",
    },
    [11] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1332,
            [2] = 1333,
            [3] = 1334,
        },
        ["NiceName"] = "202",
    },

-- Random housing next to 404 Zone

    [12] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 1557
        },
        ["NiceName"] = "001",
    },

    [13] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 2717
        },
        ["NiceName"] = "002",
    },

    [14] = {
        ["Cost"] = 10,
        ["Doors"] = {
            [1] = 1558
        },
        ["NiceName"] = "003",
    },

    -- Random Shop next to 404 zone

    [15] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1567,
            [2] = 3221,
        },
        ["NiceName"] = "Integral",
    },

    -- Grizzly Groto
    [16] = {
        ["Cost"] = 25,
        ["Doors"] = {
            [1] = 2594,
            [2] = 2593,
            [3] = 2607,
            [4] = 3215,
            [5] = 3163,
        },
        ["NiceName"] = "Grizzly Groto",
    },

    -- Metropol

    [17] = {
        ["Cost"] = 5,
        ["Doors"] = {
            [1] = 1866
        },
        ["NiceName"] = "101",
    },
    [18] = {
        ["Cost"] = 5,
        ["Doors"] = {
            [1] = 1867
        },
        ["NiceName"] = "201",
    },
    [19] = {
        ["Cost"] = 5,
        ["Doors"] = {
            [1] = 1868
        },
        ["NiceName"] = "301",
    },

    -- Theatre

    [20] = {
        ["Cost"] = 25,
        ["Doors"] = {
            [1] = 3444,
            [2] = 3443,
            [3] = 3446,
            [4] = 3445,
            [5] = 2711,
            [6] = 120,
            [7] = 121,
        },
        ["NiceName"] = "Theatre",
    },

    -- Terminal Hotel

    [21] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1319,
            [2] = 2270,
            [3] = 1322
        },
        ["NiceName"] = "101",
    },

    [22] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1320,
            [2] = 2275,
            [3] = 1321
        },
        ["NiceName"] = "102",
    },

    [23] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1315,
            [2] = 2269,
            [3] = 1318
        },
        ["NiceName"] = "201",
    },

    [24] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1316,
            [2] = 2274,
            [3] = 1317
        },
        ["NiceName"] = "202",
    },
    [25] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1311,
            [2] = 2268,
            [3] = 1314
        },
        ["NiceName"] = "301",
    },
    [26] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1312,
            [2] = 2273,
            [3] = 1313
        },
        ["NiceName"] = "302",
    },
    [27] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1307,
            [2] = 2271,
            [3] = 1310
        },
        ["NiceName"] = "401",
    },
    [28] = {
        ["Cost"] = 15,
        ["Doors"] = {
            [1] = 1308,
            [2] = 2272,
            [3] = 139
        },
        ["NiceName"] = "402",
    },
}
for _, property in pairs(impulse.Properties.PropertyData) do
    if property.Doors then
        for k, v in pairs(property.Doors) do
            property.Doors[k] = v + 6
        end
    end
end-- disregard
-- lua_run_cl print(LocalPlayer():GetEyeTrace().Entity:EntIndex())
-- wait till i get back to make the entities!


if SERVER then
  util.AddNetworkString( "Pinecrest.OpenPanel" )
else
  net.Receive("Pinecrest.OpenPanel", function()
    vgui.Create( net.ReadString() )
  end)
end

function meta:OpenPanel( panel )
    if SERVER then
        net.Start( "Pinecrest.OpenPanel" )
            net.WriteString( panel )
        net.Send( self )
    else
        vgui.Create( panel )
    end
end




--[[
impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(9467, 2812, 150), Vector(9363, 2492, 150)
    },
    NiceName = "Change",
    Cost = impulse.Config.DoorPrice * 2
} )


impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(9220, 3963, 182), Vector(9404, 3635, 182)
    },
    NiceName = "Foto",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(9220, 4037, 182), Vector(9404, 4411, 182)
    },
    NiceName = "Teko",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
       Vector(6995, 2872, 182), Vector(6675, 2692, 182)
    },
    NiceName = "atlantic",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(6171, 2872, 182), Vector(6175, 2500, 182), Vector(6491, 2692, 182)
    },
    NiceName = "Cafe Baltic",
    Cost = impulse.Config.DoorPrice * 3
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(6648, 3501, 150), Vector(6340, 3629, 150)
    },
    NiceName = "Commerical 1",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(6648, 3753, 150), Vector(6340, 3877, 150)
    },
    NiceName = "Commerical 2",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(6648, 4017, 150), Vector(6340, 4141, 150)
    },
    NiceName = "Commerical 3",
    Cost = impulse.Config.DoorPrice * 2
} )

impulse.Properties.RegisterProperty( {
    DoorPos = {
        Vector(6648, 4265, 150), Vector(6340, 4389, 150)
    },
    NiceName = "Commerical 4",
    Cost = impulse.Config.DoorPrice * 2
} )
]]

if CLIENT then
    timer.Simple( 5, function()
        impulseRegisteredProperties = true
    end )
end
