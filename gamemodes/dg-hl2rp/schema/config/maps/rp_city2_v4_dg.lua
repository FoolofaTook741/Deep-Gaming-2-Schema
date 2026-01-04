impulse.Config.MapWorkshopID = "648741981"
impulse.Config.MapContentWorkshopID = "837571030"

impulse.Config.MenuCamPos = Vector(307.74411010742, 542.55139160156, 1282.8167724609)
impulse.Config.MenuCamAng = Angle(36.463932037354, 87.761840820313, 0)

impulse.Config.SpawnPos1 = Vector(2113.6779785156, 3777.4975585938, 557.24523925781)
impulse.Config.SpawnPos2 = Vector(2094.8171386719, 4528.9291992188, 557.24523925781)

impulse.Config.BroadcastPos = Vector(1599.4530029297, -1520.2065429688, 1652.03125)

impulse.Config.MapType = "Woodland"
impulse.Config.CityCode = "C2"
impulse.Config.OverwatchCode = "S2"

impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.SporeClusters = {
	Vector(1972.7459716797, 3006.6643066406, 660.71057128906),
	Vector(1961.0349121094, 2720.7153320313, 659.80963134766),
	Vector(-2803.8645019531, 4081.1120605469, 624.03125),
	Vector(-2125.1472167969, 4204.9189453125, 624.03125),
	Vector(-2986.296875, 3639.2419433594, 573.03125),
	Vector(1437.8115234375, 3228.8400878906, 1144.03125),
	Vector(738.88659667969, 2295.98046875, 1240.03125),
	Vector(-480.53524780273, 3014.1115722656, 848.03125),
	Vector(-1832.1038818359, 968.97265625, 792.03125),
	Vector(-1958.0827636719, -274.40353393555, 696.03125)
}

impulse.Config.Zones = {
	{name = "City-2 Train Station", pos1 = Vector(1846.4444580078, 3473.9299316406, 1342.3269042969), pos2 = Vector(4241.3642578125, 4830.0297851563, 384.76858520508)},
    {name = "City-2 Processing Center", pos1 = Vector(1865.2935791016, 4989.1958007813, 1311.6279296875), pos2 = Vector(28.629425048828, 3196.2917480469, 955.88006591797)},
    {name = "City-2 Train Station Lobby", pos1 = Vector(1697.7395019531, 3178.2370605469, 1055.3673095703), pos2 = Vector(749.26257324219, 2173.3874511719, 552.50451660156)},
    {name = "City-2 Train Station Entrance", pos1 = Vector(878.44403076172, 986.80474853516, 1069.8321533203), pos2 = Vector(1424.1102294922, 2098.3696289063, 615.66650390625)},
    {name = "Capital Theater", pos1 = Vector(-140.73852539063, 1717.9208984375, 1302.193359375), pos2 = Vector(-1242.548828125, 1039.7545166016, 438.84970092773)},
    {name = "Capital Avenue", pos1 = Vector(1521.2730712891, 450.36938476563, 516.52288818359), pos2 = Vector(-1953.4158935547, 928.16949462891, 1269.7171630859)},
    {name = "Nova Tunnel", pos1 = Vector(1510.6116943359, 891.1494140625, 1283.1649169922), pos2 = Vector(3573.5397949219, -419.06478881836, -103.86483764648)},
    {name = "Industrial District", pos1 = Vector(1819.8026123047, -1134.6326904297, 1655.806640625), pos2 = Vector(-964.06219482422, 508.45123291016, -121.7223815918)},
    {name = "Communal District", pos1 = Vector(1256.2019042969, -5135.1616210938, 1057.3803710938), pos2 = Vector(-1933.8640136719, -2614.3461914063, -149.40274047852)},
    {name = "Main Street", pos1 = Vector(-2183.29296875, 548.11492919922, 491.38162231445), pos2 = Vector(-773.47149658203, -2582.7658691406, -68.744430541992)},
    {name = "Rundown District", pos1 = Vector(-5.8823370933533, 2559.0947265625, 357.53192138672), pos2 = Vector(-2208.2958984375, 547.77319335938, -143.31951904297)},
    {name = "Sewer System", pos1 = Vector(2262.4304199219, -1865.8254394531, -173.21253967285), pos2 = Vector(-2658.4445800781, 2795.1635742188, -1355.1535644531)},
    {name = "Subway Tracks", pos1 = Vector(4299.2729492188, -2553.3752441406, -9.3687143325806), pos2 = Vector(-6448.9135742188, -1926.6936035156, -1242.2253417969)},
    {name = "Maintenance Tunnels", pos1 = Vector(1037.0098876953, -2568.1499023438, -135.3247833252), pos2 = Vector(-1409.4039306641, -4733.6201171875, -726.61279296875)},
    {name = "Outlands Entrance", pos1 = Vector(-3006.7087402344, -2569.3740234375, -1230.1640625), pos2 = Vector(-3923.2038574219, -3280.5590820313, -894.14544677734)},
    {name = "Nexus", pos1 = Vector(-1427.0499267578, 3159.7250976563, 933.55834960938), pos2 = Vector(788.02777099609, 1685.6058349609, 539.39880371094)},
    {name = "Upper Nexus", pos1 = Vector(-489.26577758789, 1569.6213378906, 1499.1585693359), pos2 = Vector(1912.4320068359, 4394.3608398438, 3098.4047851563)},
    {name = "Nexus Prison", pos1 = Vector(623.19934082031, 2304.3469238281, 978.59509277344), pos2 = Vector(-98.788139343262, 3240.3823242188, 356.67330932617)},
    {name = "Nexus Interrogation Center", pos1 = Vector(747.94653320313, 1659.3531494141, 511.25329589844), pos2 = Vector(55.913471221924, 2422.6923828125, 367.15771484375)},
	{name = "Abandoned District", pos1 = Vector(-1994.3182373047, 323.15280151367, 1445.9542236328), pos2 = Vector(-3259.2358398438, 2775.8259277344, 538.97613525391)}
}

impulse.Config.ScannerSpawnPos = Vector(1411.4184570313, 193.82264709473, 1182.03125)

impulse.Config.IntroScenes = {
	{
	    pos = impulse.Config.MenuCamPos,
	    ang = impulse.Config.MenuCamAng,
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 13,
	    text = "Welcome to Deep Gaming: Half-Life 2 Roleplay.",
	    static = true,
	    fadeIn = true,
	}
}

impulse.Config.DealerLocations = {
	{pos = Vector(-1496.3237304688, -410.39181518555, -1124.96875), ang = Angle(0, 131.71751403809, 0)},
	{pos = Vector(376.96875, 1062.2703857422, -788.96875), ang = Angle(0, -178.91456604004, 0)},
	{pos = Vector(-476.96875, -3278.96875, -599.96875), ang = Angle(0, 33.671321868896, 0)},
	{pos = Vector(212.85255432129, -1378.8525390625, 4.03125), ang = Angle(0, -54.702610015869, 0)},
}

impulse.Config.FishermanPos = Vector(-1757.2418212891, 3376.8471679688, -0.024967193603516)
impulse.Config.FishermanAng = Angle(0, 135, 0)

impulse.Config.PrisonAngle = Angle(0, 1.1813678741455, 0)
impulse.Config.PrisonCells = {
	Vector(-56.842674255371, 2900.349609375, 460.03125),
	Vector(-62.96875, 2759.2312011719, 460.03125),
	Vector(-53.223693847656, 2617.5695800781, 460.03125),
    Vector(-50.296752929688, 2619.30078125, 596.03125),
    Vector(-46.792804718018, 2762.7473144531, 596.03125),
    Vector(-47.034572601318, 2897.8293457031, 596.03125)
}

impulse.Config.JWButtonPos = Vector(6881.28125, 1899, -349.46875)
impulse.Config.JWOffButtonPos = Vector(6881.28125, 1869, -349.46875)
impulse.Config.AJButtonPos = Vector(6881.28125, 1899, -349.46875)
impulse.Config.AJOffButtonPos = Vector(6881.28125, 1869, -349.46875)

impulse.Config.Buttons = {
	{
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)
			return false
		end
	}
}

impulse.Config.Buildings = {
}

impulse.Config.BuildingCategories = {
	["apt"] = {
		nicename = "Apartment",
		limit = 1,
		draw3D2DText = true,
		textData = {
			font = "ApartmentDoorFont",
			onlyOnFront = true
		}
	},
	["hide_name"] = {
		nicename = "BUILDING",
		draw3D2DText = false
	}
}

impulse.Config.ApartmentBlocks = {}

impulse.Config.RemoveEnts = {
}

impulse.Config.LoadScript = function()
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

	-- get rid of abusable radios
	for v,k in pairs(ents.FindByClass("prop_physics")) do
		if k:GetModel() == "models/props_lab/citizenradio.mdl" then
			local phys = k:GetPhysicsObject()
			if IsValid(phys) then
				phys:EnableMotion(false)
				phys:Sleep()
			end
		end
	end
end

impulse.Config.CPSpawnLocations = {Vector(1500.1013183594, 213.04747009277, 512.03125),
Vector(2390.8491210938, 413.98986816406, 368.03125),
Vector(2798.6611328125, 813.13940429688, 368.03125),
Vector(3021.1525878906, 435.58822631836, 232.03125),
Vector(1754.8898925781, 590.46496582031, 512.03125),
Vector(2021.3864746094, 1046.4724121094, 928.03125),
Vector(2120.0615234375, 1080.2357177734, 564.03125),
Vector(2024.03125, -195.60620117188, 520.03125)
}

impulse.Config.OTASpawnLocations = {Vector(2204.3100585938, -367.96875, 2192.03125),
Vector(2248.3984375, 546.45361328125, 1440.03125),
Vector(1394.03125, -30.788293838501, 1520.03125),
Vector(1327.08203125, 644.85186767578, 1440.03125),
Vector(1862.6005859375, 1291.6358642578, 1312.03125),
Vector(2207.5998535156, 586.00439453125, 1440.03125),
Vector(1568.03125, 995.76672363281, 1440.03125),
Vector(1916.3858642578, -16.03125, 1440.03125)
}

impulse.Config.CASpawnLocations = {Vector(2503.96875, 496.03125, 928.03125),
Vector(2503.96875, 496.03125, 928.03125),
Vector(2503.96875, 496.03125, 928.03125),
Vector(2000.03125, 1091.8126220703, 928.03125),
Vector(2000.03125, 1091.8126220703, 928.03125),
Vector(2000.03125, 1091.8126220703, 928.03125),
Vector(2503.96875, 504.36169433594, 1056.03125),
Vector(2503.96875, 504.36169433594, 1056.03125)
}

impulse.Config.ZombieSpawnLocations = {Vector(-1743.9227294922, 3187.408203125, 2.1379852294922),
Vector(-1743.9227294922, 3187.408203125, 2.1379852294922),
Vector(-1743.9227294922, 3187.408203125, 2.1379852294922),
Vector(-1743.9227294922, 3187.408203125, 2.1379852294922),
Vector(-1345.7257080078, 3614.7622070313, -6.9286932945251),
Vector(-1345.7257080078, 3614.7622070313, -6.9286932945251),
Vector(-1345.7257080078, 3614.7622070313, -6.9286932945251),
Vector(-1345.7257080078, 3614.7622070313, -6.9286932945251),
}

impulse.Config.CWUSpawnLocations = {Vector(1570.4255371094, 1292.4862060547, 896.03125),
Vector(1291.3189697266, 987.90045166016, 896.03125),
Vector(919.87738037109, 1397.0343017578, 896.03125),
Vector(1352.0523681641, 1165.9136962891, 704.03125),
Vector(1071.1669921875, 1191.3004150391, 704.03125),
Vector(1656.4366455078, 736.97393798828, 728.03125),
Vector(1579.8924560547, 971.96875, 728.03125),
Vector(688.03125, 806.08099365234, 728.03125)
}