impulse.Config.MapWorkshopID = "3235552039"
--impulse.Config.MapContentWorkshopID = "1406336883"

impulse.Config.MenuCamPos = Vector(4907.0581054688, 3543.6696777344, 1670.8859863281)
impulse.Config.MenuCamAng = Angle(58.938064575195, 179.45385742188, 0)


impulse.Config.SpawnPos1 = Vector(-477.28939819336, 3715.5017089844, 32.03125)
impulse.Config.SpawnPos2 = Vector(566.20593261719, 3706.875, 32.03125)

impulse.Config.BroadcastPos = Vector(8974.0224609375, 3341.6506347656, 6912.03125)


impulse.Config.MapType = "Woodland"

impulse.Config.CityCode = "C17"
impulse.Config.OverwatchCode = "S17"

impulse.Config.OverworldPortalPos = Vector(-3469.5261230469, 6366.1162109375, -4179.6337890625)
impulse.Config.OverworldPortalAng = Angle(90,0,0)
impulse.Config.OverworldPortalModel = "models/effects/intro_vortshield.mdl"
impulse.Config.OverworldPortalScale = 10

impulse.Config.TP1Pos = Vector(9372.2880859375, 11879.58203125, -146.70945739746)
impulse.Config.TP2Pos = Vector(-11455.01953125, 12435.165039063, -2606.5107421875)


impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.SporeClusters = {
	Vector(2251.6801757813, 2362.2072753906, -321.02215576172),
	Vector(3317.2416992188, 536.79650878906, -227.02362060547),
	Vector(3330.1845703125, 6386.150390625, -415.96875),
	Vector(46.645263671875, 797.95062255859, -123.93669128418),
	Vector(-2494.4169921875, 758.47741699219, 0.03125),
	Vector(3257.833984375, 5946.322265625, 32.03125),
	Vector(-477.4387512207, 1953.8616943359, -135.76184082031)
}

impulse.Config.XenClusters = {
	Vector(-2556.5903320313, 1203.8480224609, 7.0557823181152),
	Vector(-871.61492919922, 1345.3927001953, -245.01123046875),
	Vector(3706.2541503906, 2630.1960449219, -316.89099121094),
	Vector(395.49395751953, 1700.7503662109, 128.77334594727),
	Vector(3596.2729492188, 8872.7705078125, -191.96875)
}


impulse.Config.XenPocalypse = {
	Vector(-13335.139648438, 8261.8525390625, -231.96875),
	Vector(-2542.9291992188, -92.828536987305, -255.96875),
	Vector(-3774.90234375, -1242.0002441406, -319.96875),
	Vector(-6804.4584960938, -425.51104736328, -255.96875),
	Vector(-9391.96875, 152.03125, -255.96875),
	Vector(-3981.0908203125, 2931.5668945313, 0.03125),
	Vector(-3926.7158203125, 1761.6436767578, 0.03125),
}


impulse.Config.Zones = {
	{name = "Outland Zone 1", pos1 = Vector(-5505.7543945313, 2049.6994628906, 2139.9350585938), pos2 = Vector(-15725.127929688, 10821.666015625, -256.91720581055)},
	{name = "Outlands Cave", pos1 = Vector(-15595.6953125, 10050.619140625, -374.6921081543), pos2 = Vector(-7258.8193359375, 16436.5, -4865.4731445313)},
	{name = "Abandoned Tunnel Exit", pos1 = Vector(-10088.916015625, 4230.76953125, 1452.5134277344), pos2 = Vector(-6168.7485351563, -5521.3759765625, -858.16693115234)},
	{name = "Abandoned Tunnel Entrance", pos1 = Vector(-6548.35546875, -4822.8139648438, 1296.4437255859), pos2 = Vector(-604.16302490234, -2378.7053222656, -259.34289550781)},
	{name = "District 4", pos1 = Vector(-266.50686645508, -3316.7338867188, 1901.9520263672), pos2 = Vector(-4441.7846679688, 16.022979736328, -165.10008239746)},
	{name = "District 4 (South Side)", pos1 = Vector(-3748.798828125, -452.83972167969, 1432.8092041016), pos2 = Vector(-6020.5654296875, 1714.9771728516, -219.50289916992)},
	{name = "District 2", pos1 = Vector(5331.904296875, 1729.3856201172, 1634.5721435547), pos2 = Vector(-320.67001342773, -2899.5146484375, -94.634910583496)},
	{name = "District 7", pos1 = Vector(1879.2797851563, 1785.3963623047, 1634.5520019531), pos2 = Vector(5154.6274414063, 5329.5673828125, -144.82865905762)},
	{name = "District 3", pos1 = Vector(6254.8803710938, 5064.5864257813, 1961.7863769531), pos2 = Vector(-91.564254760742, 9345.5283203125, -502.62405395508)},
	{name = "Combine Tunnel (East)", pos1 = Vector(-107.68616485596, 6732.6000976563, 528.17364501953), pos2 = Vector(-2504.0026855469, 13579.448242188, -97.508979797363)},
	{name = "Combine Tunnel (North)", pos1 = Vector(9893.0615234375, 13662.174804688, -582.46557617188), pos2 = Vector(-1639.9471435547, 14811.087890625, 563.59442138672)},
	{name = "Combine Tunnel (South)", pos1 = Vector(-2145.9538574219, 14539.333007813, 407.64837646484), pos2 = Vector(-7674.86328125, 10263.557617188, -251.72578430176)},
	{name = "Outland Zone 2", pos1 = Vector(6348.9145507813, 8609.1181640625, 1153.5750732422), pos2 = Vector(14651.958007813, 14091.526367188, -800.01000976563)},
	{name = "OZ-2 F.O.B.", pos1 = Vector(10098.268554688, 13718.752929688, -103.8458480835), pos2 = Vector(8764.3173828125, 13912.75, -329.11782836914)},
	{name = "Underground (West)", pos1 = Vector(5139.3090820313, 9097.548828125, -198.3370513916), pos2 = Vector(2243.8352050781, 5765.31640625, -563.20642089844)},
	{name = "Underground (Central)", pos1 = Vector(5288.9599609375, 148.2018737793, -90.983062744141), pos2 = Vector(1292.7058105469, 3374.818359375, -418.24053955078)},
	{name = "Underground (South)", pos1 = Vector(1389.3688964844, 2991.4899902344, -39.842613220215), pos2 = Vector(-4413.4975585938, -19.018728256226, -130.03092956543)},
	{name = "???", pos1 = Vector(7130.2080078125, 5114.466796875, 304.69448852539), pos2 = Vector(8265.7978515625, 7164.8559570313, -115.05758666992)},
	{name = "Ration Distribution Center", pos1 = Vector(4610.3676757813, 3239.9958496094, 288.90795898438), pos2 = Vector(5244.9848632813, 2681.5239257813, 12.648548126221)},
	{name = "Transit Tunnel", pos1 = Vector(10854.34765625, 7690.1655273438, 338.70816040039), pos2 = Vector(10097.680664063, -1039.1190185547, -343.39688110352)},
	{name = "Train Station", pos1 = Vector(1815.0620117188, 5075.654296875, 559.56402587891), pos2 = Vector(-208.97361755371, 2717.9733886719, -50.484401702881)}
}	

impulse.Config.ScannerSpawnPos = Vector(3005.9011230469, 3565.3161621094, 869.08825683594)


impulse.Config.MBExit = Vector(-7168.25390625, 761.50329589844, -39.96875)
impulse.Config.MBEntrance = Vector(-6932.8071289063, 722.53826904297, -39.96875)

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
	{pos = Vector(-889.44512939453, 1233.9439697266, -225.97172546387), ang = Angle(0, 38.048923492432, 0)},
	{pos = Vector(-3749.0258789063, 849.27386474609, 0.03125), ang = Angle(0, 86.822631835938, 0)},
	{pos = Vector(822.52301025391, 2472.380859375, -210.71173095703), ang = Angle(0, -92.307472229004, 0)},
	{pos = Vector(1925.4547119141, 2337.318359375, -207.96875), ang = Angle(0, -89.637428283691, 0)},
	{pos = Vector(3236.2504882813, 8921.650390625, -364.64227294922), ang = Angle(0, -46.574676513672, 0)}
}

impulse.Config.ConverterLocations = {
	{pos = Vector(3619.8959960938, 7375.5703125, -415.96875), ang = Angle(0, 38.048923492432, 0)},
	{pos = Vector(4444.2822265625, 5650.3237304688, -594.64227294922), ang = Angle(0, 86.822631835938, 0)},
	{pos = Vector(3606.4416503906, 3481.5256347656, -335.96875), ang = Angle(0, -46.574676513672, 0)}
}

impulse.Config.FishermanPos = Vector(-13917.853515625, 11845.447265625, -2349.1301269531)

impulse.Config.FishermanAng = Angle(0, 0, 0)



impulse.Config.PrisonAngle = Angle(0, 0, 0)
impulse.Config.PrisonCells = {
    Vector(6968.3227539063, 3332.3381347656, -271.96875)
}

impulse.Config.JWButtonPos = Vector(9999.96875, 9999, 9999)
impulse.Config.JWOffButtonPos = Vector(9999, 9999, 9999)
impulse.Config.AJButtonPos = Vector(9999, 9999, 9999)
impulse.Config.AJOffButtonPos = Vector(9999, 9999, 9999)

impulse.Config.Buttons = {	
}

impulse.Config.Buildings = {
}

impulse.Config.RationsSoundOn = "ambience/speech/i24announce/rdt_online.mp3"
impulse.Config.RationsSoundOff = "ambience/speech/i24announce/rdt_offline.mp3"
impulse.Config.RationsTextOn = "Attention please. The ration distribution terminal is now online."
impulse.Config.RationsTextOff = "Attention please. Rationing terminals have been disabled until further notice."

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

impulse.Config.CPSpawnLocations = {Vector(9166.4892578125, 1701.6187744141, 64.03125),
Vector(7761.4443359375, 2965.9665527344, 64.03125),
Vector(8286.2490234375, 496.40747070313, -63.96875),
Vector(7377.3471679688, 432.95812988281, -63.96875),
Vector(7940.6044921875, 3926.2473144531, 64.03125)
}

impulse.Config.OTASpawnLocations = {Vector(6650.0551757813, 3513.0854492188, -271.96875),
Vector(7152.0908203125, 3891.7297363281, -223.96875),
Vector(6616.7607421875, 3742.138671875, -271.96875),
Vector(7097.3637695313, 3919.96875, -223.96875)
}

impulse.Config.CASpawnLocations = {Vector(7951.3383789063, 2472.8803710938, 64.03125),
Vector(7741.1762695313, 3440.1240234375, 64.03125)
}

impulse.Config.ZombieSpawnLocations = {Vector(11591.744140625, 11834.419921875, -444.49987792969),
Vector(12110.75390625, 11894.24609375, -413.52319335938),
Vector(-12742.319335938, 9378.9384765625, -2478.4094238281),
Vector(-14917.518554688, 13281.997070313, -2243.0095214844)
}

impulse.Config.StalkerSpawnLocations = {Vector(7519.474609375, 3363.9370117188, 68.031257629395),
}