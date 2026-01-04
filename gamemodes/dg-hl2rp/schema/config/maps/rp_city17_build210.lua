impulse.Config.MapWorkshopID = "150899249"

impulse.Config.MenuCamPos = Vector(-949.344238, -358.096802, 390.704865)
impulse.Config.MenuCamAng = Angle(-13.080074, 8.854471, 0.000000)

impulse.Config.SpawnPos1 = Vector(-5364.854004, -1351.938354, -71.923126)
impulse.Config.SpawnPos2 = Vector(-2977.664795, 747.303223, 837.400513)

impulse.Config.BroadcastPos = Vector(5989.192871, -2484.513428, 4956.031250)

impulse.Config.CityCode = "C17"

impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.Zones = {
	{name = "Plaza", pos1 = Vector(-1252.9696044922, 1476.0078125, 1651.5496826172), pos2 = Vector(2139.5231933594, -1156.8065185547, -2.0121326446533)},
	{name = "Terminal Hotel", pos1 = Vector(66.684707641602, -1158.4270019531, 56.62451171875), pos2 = Vector(-415.3623046875, -1657.5985107422, 1556.1708984375)},
	{name = "Trainstation", pos1 = Vector(-1246.1105957031, 1215.3636474609, 735.86767578125), pos2 = Vector(-6780.0883789063, -1219.5194091797, -81.662071228027)},
	{name = "Trainstation Detention Centre", pos1 = Vector(-1940.875, 1236.2247314453, -69.507743835449), pos2 = Vector(-3987.9304199219, 2144.4533691406, 494.33990478516)},
	{name = "Sector C", pos1 = Vector(-1814.2443847656, 6138.0180664063, 1724.5280761719), pos2 = Vector(2326.0629882813, 3506.7734375, 55.17374420166)},
	{name = "Sector C Front Street", pos1 = Vector(379.21160888672, 3574.6088867188, -7.7053632736206), pos2 = Vector(-1261.9693603516, 1500.6304931641, 1415.7127685547)},
	{name = "Atlantic Square", pos1 = Vector(455.31536865234, 2899.556640625, 18.782068252563), pos2 = Vector(986.88635253906, 1806.6784667969, 1332.888671875)},
	{name = "Armoury", pos1 = Vector(4656.3735351563, -3859.1567382813, -547.55340576172), pos2 = Vector(1924.6031494141, -2430.0278320313, -22.262176513672)},
	{name = "Nexus Entrance", pos1 = Vector(2167.4582519531, -486.35049438477, -75.241134643555), pos2 = Vector(3304.2309570313, 382.52276611328, 299.43594360352)},
	{name = "Detainment Block", pos1 = Vector(3285.7214355469, -2305.9797363281, -315.52941894531), pos2 = Vector(5871.5776367188, 548.20318603516, 1979.8558349609)},
	{name = "Citadel", pos1 = Vector(6479.8032226563, -30.230411529541, 3475.9206542969), pos2 = Vector(3990.8771972656, -2823.6193847656, 1575.384765625)},
	{name = "Upper Citadel", pos1 = Vector(6617.40234375, -2.0270600318909, 3650.1247558594), pos2 = Vector(3618.7270507813, -2833.4423828125, 5491.3505859375)},
	{name = "Industrial Sector", pos1 = Vector(3422.0739746094, -6177.7309570313, 32.083457946777), pos2 = Vector(197.16593933105, -2336.5588378906, 1122.5556640625)},
	{name = "Sector B Front Street", pos1 = Vector(2.5352656841278, -5199.5590820313, 1335.0064697266), pos2 = Vector(-4984.3002929688, -3338.9526367188, 37.902862548828)},
	{name = "Civil Residence Block", pos1 = Vector(-1559.3557128906, -3338.7055664063, 1318.6353759766), pos2 = Vector(-3803.0864257813, -2370.1474609375, 68.921966552734)},
	{name = "Civil Residence Block Rear", pos1 = Vector(-3866.5466308594, -1472.0209960938, -15.400224685669), pos2 = Vector(-1553.5977783203, -2324.4216308594, 1028.1396484375)},
	{name = "North Road", pos1 = Vector(-1187.4016113281, -1541.4771728516, -69.377540588379), pos2 = Vector(-444.89096069336, -3019.8295898438, 962.37158203125)},
	{name = "Sewers", pos1 = Vector(-2357.8718261719, 8544.4921875, -26.356395721436), pos2 = Vector(3339.0678710938, -2353.1127929688, -509.47836303711)}
}

impulse.Config.IntroScenes = {
	{
	    pos = Vector(-3364.3195800781, -410.93460083008, 223.08819580078),
     	endpos = Vector(-3364.3195800781, -410.93460083008, 328.08819580078),
     	posNoLerp = true,
     	posSpeed = 0.0003,
	    ang = Angle(13.319949, 172.920380, 0.000000),
	    fovTo = 94,
	    fovSpeed = 0.19,
     	fovNoLerp = true,
	    time = 5,
	    text = "Welcome to City 17.",
     	onStart = function()
        	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0.1)
     	end,
     	fadeOut = true
    },
	{
		pos = Vector(-3418.7573242188, 1142.72265625, 120),
     	endpos = Vector(-3298.1435546875, 1150.3386230469, 120),
     	posSpeed = 0.1,
     	posNoLerp = true,
	    ang = Angle(7.8199257850647, 87.03881072998, 0),
     	endang = Angle(7.8199257850647, 89.03881072998, 0),
	    text = "This is a roleplay server set in the Half-Life 2 Universe. You play as an oppressed citizen.",
	    time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(5667.4375, -966.09375, 4221.125),
	    ang = Angle(-8.701171875, -5.2734375, 0),
	    endpos = Vector(5659.65625, -1061.53125, 4221.90625),
	    endang = Angle(-6.064453125, -0.87890625, 0),
	    posNoLerp = true,
	    posSpeed = 0.1,
	    speed = 0.1,
	    fovFrom = 10,
	    fovTo = 75,
	    fovSpeed = 0.1,
	    text = "An interdimensional empire known commonly as the Combine has taken control of Earth.",
	    time = 13.5,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = Vector(4034.6875, -242.28125, 217.3125),
	    endpos = Vector(4036.75, -468.21875, 176.59375),
	    posNoLerp = true,
	    posSpeed = 0.1,
	    ang = Angle(12.4365234375, -44.6484375, 0),
	    text = "Metropolice and trans-human OTA units uphold the Combine's rule and squash civil resistance.",
	    time = 11,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(-2014.59375, -555.875, 232.53125),
     	endpos = Vector(-2023.4375, -383.5, 250.875),
	    ang = Angle(18.369140625, 142.7783203125, 0),
     	endang = Angle(22.5439453125, -139.130859375, 0),
	    text = "Tokens and food rationed by the Combine are supplied at ration dispensers around the city.",
     	speed = 0.15,
	    time = 9.5,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = Vector(391.03125, 3708.65625, 210.34375),
	    endpos = Vector(345.5, 3687.0625, 200.28125),
	    ang = Angle(-15.5126953125, 19.86328125, 0),
	    endang = Angle(-11.77734375, 10.634765625, 0),
	    posSpeed = 0.18,
	    speed = 0.2,
	    fovFrom = 35,
	    fovTo = 80,
	    fovSpeed = 0.1,
	    text = "You can choose to join the Civil Workers Union and sell food, setup businesses or become a doctor.",
	    time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(-1791.875, -3000.125, 664.65625),
		endpos = Vector(-1795.75, -3007.84375, 380.1875),
		ang = Angle(88.9892578125, 115.9716796875, 0),
		endang = Angle(88.9892578125, 13.5791015625, 0),
		posSpeed = 0.1,
		speed = 0.1,
		text = "You can also purchase an apartment or property, decorate it or use it to store items.",
		time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = Vector(1827.78125, -5085.6875, 735.71875),
	    endpos = Vector(1893.625, -5159.5625, 727.875),
	    ang = Angle(-1.1865234375, 86.66015625, 0),
	    endang = Angle(-1.40625, 71.89453125, 0),
	    posSpeed = 0.002,
	    speed = 0.15,
	    fovFrom = 30,
	    fovTo = 93,
	    fovSpeed = 0.14,
	    text = "If you wish to revolt, you may join the resistance, however it is no easy task...",
	    time = 12,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = impulse.Config.MenuCamPos,
	    ang = impulse.Config.MenuCamAng,
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 13,
	    text = "Welcome to impulse: Half-Life 2 Roleplay.",
	    static = true,
	    fadeIn = true,
	    onStart = function()
	    	CHAR_MUSIC = CreateSound(LocalPlayer(), "music/hl2_song2.mp3")
	    	CHAR_MUSIC:SetSoundLevel(0)
	    	CHAR_MUSIC:ChangeVolume(1.5)
	    	CHAR_MUSIC:ChangePitch(70)
	    	CHAR_MUSIC:Play()
	    end
	}
}

impulse.Config.ScannerSpawnPos = Vector(-271.581757, -1572.765625, 816.031250)

impulse.Config.DealerLocations = {
	{pos = Vector(2132.75, -1085.3125, -465.96875), ang = Angle(0, 178.2421875, 0)},
	{pos = Vector(2696.75, -361.59375, -305.96875), ang = Angle(0, -19.6875, 0)},
	{pos = Vector(1751.71875, 6573.3125, -465.96875), ang = Angle(0, 154.5556640625, 0)},
	{pos = Vector(-3660.15625, -2666.59375, 80.03125), ang = Angle(0, 2.9443359375, 0)}
}

impulse.Config.FishermanPos = Vector(-1091.34375, 6013.5625, -465.96875)
impulse.Config.FishermanAng = Angle(0, -178.70361328125, 0)

impulse.Config.PrisonAngle = Angle(1.4399157762527, -178.96067810059, 0)
impulse.Config.PrisonCells = {
	Vector(4329.8447265625, -1728.5930175781, 76.03125),
	Vector(4330.5341796875, -1587.4171142578, 76.03125),
	Vector(4336.3193359375, -1441.3911132813, 76.03125),
	Vector(4337.0151367188, -1298.8934326172, 76.03125),
	Vector(4339.8955078125, -708.93499755859, 76.03125),
	Vector(4340.599609375, -564.56365966797, 76.03125),
	Vector(4341.3530273438, -410.26196289063, 76.03125),
	Vector(4338.79296875, -269.55780029297, 76.03125)
}

impulse.Config.JWButtonPos = Vector(5785.8125, -2666.15625, 4971)
impulse.Config.AJButtonPos = Vector(5564.6875, -2661.125, 4972.5)

impulse.Config.Buttons = {
	{
		desc = "Toggle Judgement Waiver",
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Toggle Autonomous Judgement",
		pos = impulse.Config.AJButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Toggle Broadcast Feed",
		pos = Vector(5961, -2506, 4935.5)
	},
	{
		desc = "Toggle Prison Alarm",
		pos = Vector(3809.5, -1796, 117),
		doorgroup = 1
	},
	{
		pos = Vector(2801.96875, -3561.375, -394),
		customCheck = function()
			return false
		end
	},
	{
		desc = "Toggle Headcrab Canister Launcher",
		pos = Vector(5515, -2045, 2221),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		desc = "Toggle Pod Door",
		pos = Vector(4987, 40.625, 119.875)
	},
	{
		desc = "Send Pod to Incinerator",
		pos = Vector(4936, 45.53125, 111.375),
		doorgroup = 1
	},
	{
		desc = "Return Pod",
		pos = Vector(5018, 49, 121.84375),
		doorgroup = 1
	},
	{
		desc = "Send Pod to Office",
		pos = Vector(5061, 43.53125, 120.875),
		doorgroup = 1
	},
	{
		desc = "Trainstation Gate Control",
		pos = Vector(-2135, -736, 209.40625),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	}
}

impulse.Config.ApartmentBlocks = {
	{
		name = "Terminal Hotel",
		apartments = {
			{name = "101", doors = {12, 1478}},
			{name = "102", doors = {10, 1479}},
			{name = "201", doors = {14, 1477}},
			{name = "202", doors = {13, 1480}},
			{name = "301", doors = {16, 1475}},
			{name = "302", doors = {15, 1481}},
			{name = "401", doors = {656, 1476}},
			{name = "402", doors = {655, 1482}}
		}
	},
	{
		name = "Atlantic Square",
		apartments = {
			{name = "101", doors = {191, 2183}},
			{name = "102", doors = {192, 2185}},
			{name = "201", doors = {195, 350}},
			{name = "202", doors = {194, 2190}},
			{name = "301", doors = {2459, 2456}},
			{name = "302", doors = {2475, 2476}},
			{name = "303", doors = {2458, 2460}}
		}
	},
	{
		name = "Civil Residence Block",
		apartments = {
			{name = "101", doors = {1067}},
			{name = "102", doors = {1066, 956, 955}},
			{name = "103", doors = {1409, 1407, 1065}},
			{name = "201", doors = {1085}},
			{name = "202", doors = {1083, 1068}},
			{name = "203", doors = {1082, 1070, 1074}}
		}
	}
}

impulse.Config.LoadScript = function()
	for v,k in pairs(ents.FindByClass("prop_dynamic")) do
		if k:GetModel() == "models/props_interiors/vendingmachinesoda01a.mdl" then
			local pos, ang = k:GetPos(), k:GetAngles()
			k:Remove()

			local new = ents.Create("impulse_hl2rp_vendingmachine")
			new:SetPos(pos)
			new:SetAngles(ang)
			new:Spawn()

			local phys = new:GetPhysicsObject()

			if phys and phys:IsValid() then
				phys:EnableMotion(false)
			end
		end
	end

	for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
		if k:MapCreationID() != -1 then
			local pos = k:GetPos()
			local ang = k:GetAngles()
			local values = k:GetKeyValues()

			k:Remove()

			local new = ents.Create("npc_combine_camera")
			new:SetPos(pos)
			new:SetAngles(ang)
			new:Spawn()
			new:Activate()

			new:SetKeyValue("innerradius", values.outerradius)
			new:SetKeyValue("outerradius", values.outerradius)
		end
	end
end