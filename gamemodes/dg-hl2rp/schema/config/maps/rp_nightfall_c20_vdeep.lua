impulse.Config.MapWorkshopID = "3132024232"
--impulse.Config.MapContentWorkshopID = "1406336883"
impulse.Config.MenuCamPos = Vector(1978.6875, -246.35052490234, 826.97082519531)
impulse.Config.MenuCamAng = Angle(34.056148529053, 163.88415527344, 0)
impulse.Config.SpawnPos1 = Vector(81.093910217285, -2931.7448730469, -288.96875)
impulse.Config.SpawnPos2 = Vector(-614.86627197266, -3005.1789550781, -288.96875)
impulse.Config.BroadcastPos = Vector(3628.5461425781, -5568.69921875, 261.03125)
impulse.Config.MapType = "Woodland"
impulse.Config.CityCode = "C20"
impulse.Config.OverwatchCode = "S20"
impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}
impulse.Config.SporeClusters = {
	Vector(5342.197265625, 2622.9311523438, 8176.498046875),
	Vector(12439.185546875, -1276.2651367188, 7964.482421875),
	Vector(7385.0141601563, 278.56002807617, 7797.3813476563),
	Vector(871.90887451172, -1764.3485107422, 8424.62109375),
	Vector(2212.5512695313, 3142.1770019531, -331.66198730469),
	Vector(2936.0322265625, 2460.4597167969, -279.96875),
	Vector(2233.0842285156, 2572.4138183594, -338.82836914063),
	Vector(11928.73046875, 507.69592285156, 8462.130859375),
	Vector(6311.4428710938, 5130.0854492188, 8422.8408203125),
	Vector(1370.7698974609, 5250.0336914063, 7961.794921875)
}
impulse.Config.Zones = {
	{name = "City 20 Subway Station", pos1 = Vector(-853.21173095703, -2600.7602539063, 994.20159912109), pos2 = Vector(2148.0947265625, -3418.6303710938, -211.8911895752)},
    {name = "Residential District 1", pos1 = Vector(1895.2142333984, -269.42593383789, 1490.2958984375), pos2 = Vector(-516.7138671875, -2185.4714355469, -369.10681152344)},
    {name = "Commerical District", pos1 = Vector(2297.0617675781, 894.83666992188, 913.24212646484), pos2 = Vector(-704.37487792969, -733.20794677734, -346.25692749023)},
    {name = "Ration Center", pos1 = Vector(6271.7416992188, 93.773773193359, 930.54473876953), pos2 = Vector(5084.76171875, -773.13189697266, -363.75180053711)},
    {name = "Nexus Garage Entrance", pos1 = Vector(4348.9560546875, -831.91912841797, -16.870733261108), pos2 = Vector(5018.0688476563, -2307.5290527344, -413.96884155273)},
    {name = "Nexus Garage", pos1 = Vector(3986.3981933594, -1882.7336425781, -263.41076660156), pos2 = Vector(3157.3388671875, -3634.2111816406, -554.13208007813)},
    {name = "Nexus Tram", pos1 = Vector(4828.1328125, -5028.66015625, -394.70162963867), pos2 = Vector(5119.2998046875, -3251.2756347656, -649.55511474609)},
    {name = "Nexus Front Entrance", pos1 = Vector(3714.1923828125, -4540.5073242188, 255.40423583984), pos2 = Vector(4420.7099609375, -5638.5576171875, -351.1943359375)},
    {name = "Outlands Gate", pos1 = Vector(5447.552734375, -4157.8295898438, -90.30256652832), pos2 = Vector(4704.1967773438, -4509.5034179688, -367.47717285156)},
    {name = "Alderwood Street", pos1 = Vector(4804.5625, -2544.5432128906, 492.86297607422), pos2 = Vector(3610.2163085938, -4482.8740234375, -306.56607055664)},
    {name = "Richards Street", pos1 = Vector(5203.5009765625, -491.68746948242, 610.63055419922), pos2 = Vector(1850.9498291016, 20.793811798096, -306.36773681641)},
    {name = "Henry Road", pos1 = Vector(1426.1625976563, 2231.5388183594, -410.19967651367), pos2 = Vector(1023.7740478516, 403.59710693359, 919.58477783203)},
    {name = "Industrial District", pos1 = Vector(1006.1365966797, 1755.8605957031, -412.33877563477), pos2 = Vector(-787.33288574219, 2821.9775390625, 1157.3032226563)},
    {name = "Condemned District", pos1 = Vector(2071.0737304688, 3437.1696777344, 719.68786621094), pos2 = Vector(3489.1962890625, 1794.6630859375, -272.93237304688)},
    {name = "Industrial District Sewer Entrance", pos1 = Vector(1231.7124023438, 2862.037109375, -97.194885253906), pos2 = Vector(573.52777099609, 3421.8796386719, -669.02770996094)},
    {name = "Sewer System Zone 1", pos1 = Vector(1719.7230224609, 2744.171875, -511.45166015625), pos2 = Vector(162.83737182617, 1110.9986572266, -783.24499511719)},
    {name = "Sewer System Zone 2", pos1 = Vector(3977.7333984375, -1.7811808586121, -483.51983642578), pos2 = Vector(1983.6414794922, 3973.3984375, -920.56628417969)},
    {name = "Sewer System Zone 3", pos1 = Vector(4171.3627929688, -2050.1682128906, -569.78216552734), pos2 = Vector(1529.1761474609, -588.01782226563, -822.95617675781)},
    {name = "Sewer System Zone 4", pos1 = Vector(167.25357055664, -639.73321533203, -312.16473388672), pos2 = Vector(2384.6691894531, -2170.2043457031, -547.79571533203)},
    {name = "Abandoned Train Rail", pos1 = Vector(-1097.3688964844, -2167.5510253906, -219.65623474121), pos2 = Vector(2756.5209960938, -2554.4035644531, -554.15106201172)},
    {name = "Residential District 2", pos1 = Vector(4297.1240234375, -3029.0666503906, -199.96487426758), pos2 = Vector(2763.2602539063, -715.58752441406, 1014.705078125)},
    {name = "Abandoned Bridge", pos1 = Vector(2375.189453125, -1048.373046875, 1119.5731201172), pos2 = Vector(3177.4992675781, 1468.3664550781, 331.98318481445)},
    {name = "Condemned Apartment Block", pos1 = Vector(3081.6650390625, 1417.9368896484, 1119.5017089844), pos2 = Vector(2120.9853515625, 2077.24609375, 436.89071655273)},
    {name = "Upper Nexus", pos1 = Vector(7380.3466796875, -7160.970703125, 749.64105224609), pos2 = Vector(3514.2473144531, -5133.359375, -6.6408748626709)},
    {name = "Nexus Prison", pos1 = Vector(4166.5, -5914.3618164063, -137.86279296875), pos2 = Vector(4853.91015625, -7202.576171875, -525.26995849609)},
    {name = "M.P.F. Command Center", pos1 = Vector(6720.99609375, -7741.9560546875, 156.58392333984), pos2 = Vector(5013.6176757813, -6231.6171875, -474.16986083984)},
    {name = "Outlands Woodland Sector", pos1 = Vector(-3232.2419433594, -3619.0932617188, 9840.1513671875), pos2 = Vector(14366.420898438, 6676.0595703125, 7569.0517578125)},
    {name = "Outlands Coastal Sector", pos1 = Vector(10416.66015625, 10685.237304688, -5974.7490234375), pos2 = Vector(-5418.1635742188, -5515.8383789063, -11313.384765625)},
    {name = "Port Lentierrez", pos1 = Vector(-5411.408203125, -4643.078125, -8430.892578125), pos2 = Vector(-11113.564453125, -749.81121826172, -10776.8125)},
    {name = "Nexus Ground Floor", pos1 = Vector(4251.8525390625, -5886.4697265625, -106.42002868652), pos2 = Vector(5153.7568359375, -5617.1806640625, -355.93319702148)}
}
impulse.Config.ScannerSpawnPos = Vector(689.75146484375, 149.54406738281, 1216.0462646484)
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
	{pos = Vector(3247.6079101563, -1398.4295654297, -715.96875), ang = Angle(0, 66, 0)},
	{pos = Vector(2245.3195800781, 1085.93359375, -715.96875), ang = Angle(0,35,0)},
	{pos = Vector(907.59118652344, -1531.9603271484, -447.96875), ang = Angle(0, -23, 0)},
	{pos = Vector(656.94903564453, 125.88054656982, -1023.4157714844), ang = Angle(0, 89, 0)},
}
impulse.Config.FishermanPos = Vector(-2056.7094726563, 1085.8952636719, -10558.5859375)
impulse.Config.FishermanAng = Angle(0, -1.1269649267197, 0)
impulse.Config.PrisonAngle = Angle(1.8799510002136, -177.92010498047, 0)
impulse.Config.PrisonCells = { Vector(4787.095703125, -6582.3154296875, -447.96875),
    Vector(4775.47265625, -6704.732421875, -447.96875),
	Vector(4793.572265625, -6841.4819335938, -263.96875),
	Vector(4801.2724609375, -6847.4008789063, -447.96875),
    Vector(4804.5180664063, -6706.8334960938, -263.96875),
    Vector(4794.9848632813, -6590.095703125, -263.96875)
}
impulse.Config.JWButtonPos = Vector(-195, -4583, -664.5)
impulse.Config.JWOffButtonPos = Vector(-162, -4583, -664.5)
impulse.Config.AJButtonPos = Vector(6881.28125, 1899, -349.46875)
impulse.Config.AJOffButtonPos = Vector(6881.28125, 1869, -349.46875)
impulse.Config.Buttons = {
	{
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)
            if not ply:IsSuperAdmin() then
			    return false
            end
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
impulse.Config.CPSpawnLocations = {Vector(5335.5185546875, -5696.6879882813, -327.96875),
Vector(5665.96875, -7002.96875, -207.96875),
Vector(4303.1557617188, -5931.8188476563, -447.96875),
Vector(4243.96875, -5535.96875, -283.96875),
Vector(5032.677734375, -5359.96875, -555.96875),
Vector(5233.2255859375, -5879.96875, -327.96875),
Vector(4312.65234375, -5152.4106445313, -283.96875),
Vector(5076.2094726563, -5488.03125, -327.96875)
}
impulse.Config.OTASpawnLocations = {Vector(6216.5913085938, -5724.96875, 252.03125),
Vector(4446.1577148438, -5645.3159179688, 252.30603027344),
Vector(5511.96875, -5815.5092773438, 252.03125),
Vector(5555.4208984375, -5867.2915039063, -327.96875),
Vector(6268.03125, -5946.96875, 252.03125),
Vector(6823.96875, -5370.96875, 252.03125),
Vector(5043.2915039063, -5507.1689453125, -327.96875),
Vector(4284.03125, -5839.3002929688, -327.96875)
}
impulse.Config.CASpawnLocations = {Vector(6216.5913085938, -5724.96875, 252.03125),
Vector(4446.1577148438, -5645.3159179688, 252.30603027344),
Vector(5511.96875, -5815.5092773438, 252.03125),
Vector(5555.4208984375, -5867.2915039063, -327.96875),
Vector(6268.03125, -5946.96875, 252.03125),
Vector(6823.96875, -5370.96875, 252.03125),
Vector(5043.2915039063, -5507.1689453125, -327.96875),
Vector(4284.03125, -5839.3002929688, -327.96875)
}
impulse.Config.ZombieSpawnLocations = {Vector(5553.1381835938, -3487.5148925781, -10521.275390625),
Vector(10469.583984375, 3463.0832519531, 8335.3974609375),
Vector(-1501.3930664063, -536.79083251953, 8379.5009765625),
Vector(6250.0791015625, 5919.0815429688, 8425.31640625),
Vector(5787.1850585938, 5708.3798828125, 8399.4287109375),
Vector(12377.48046875, 2126.0300292969, 8522.9970703125),
Vector(6121.2016601563, 1876.7001953125, 8145.7412109375),
Vector(-644.97418212891, 3930.0983886719, -10175.344726563),
Vector(-309.52545166016, 9635.65625, -10498.254882813),
}