impulse.Config.MapWorkshopID = "2544078330"

impulse.Config.MenuCamPos = Vector(6601.3046875, 6139.5590820313, 616.40753173828)
impulse.Config.MenuCamAng = Angle(10.380861282349, 16.599912643433, 0)

impulse.Config.SpawnPos1 = Vector(6103.9750976563, 356.21481323242, 72.03125)
impulse.Config.SpawnPos2 = Vector(6143.0849609375, 32.808116912842, 72.03125)

impulse.Config.BroadcastPos = Vector(12270.6875, 3807.03125, 2064.03125)
impulse.Config.BroadcastDistance = 600

impulse.Config.CityCode = "C24"
impulse.Config.OverwatchCode = "S24"

impulse.Config.BlacklistEnts = {
	["game_text"] = true,
	["lua_run"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true,
	["trigger_weapon_strip"] = true,
	["npc_turret_ceiling"] = true
}

impulse.Config.RationsTextOn = "Attention all residents of City 24. Your hourly intake of rations are now available for retrieval. Please proceed to the ration distribution terminal at your earliest convenience."
impulse.Config.RationsTextOff = "Attention residents of City 24. Rations are no longer available, thank you for your cooperation."
impulse.Config.RationsSoundOff = "ambient/cmb_alarm.mp3"
impulse.Config.RationsSoundOn = "dispatch/rations_available.mp3"

impulse.Config.Zones = {
	{name = "Trainstation", pos1 = Vector(8174.46484375, 1353.4069824219, 1014.6024169922), pos2 = Vector(3420.5849609375, -854.76428222656, -71.546257019043), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Ration Distribution Center", pos1 = Vector(7466.5146484375, 7905.212890625, 1128.0200195313), pos2 = Vector(6774.8032226563, 7191.8452148438, 115.93505859375), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Victory Square", pos1 = Vector(8613.1103515625, 6872.3657226563, 1391.7685546875), pos2 = Vector(5647.3603515625, 5763.2788085938, 260.28186035156), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Checkpoint One", pos1 = Vector(5767.8095703125, 5089.2221679688, 137.35078430176), pos2 = Vector(4554.1655273438, 5664.8286132813, 481.73321533203), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Checkpoint Two", pos1 = Vector(4714.96484375, 5673.9555664063, 123.94586181641), pos2 = Vector(5560.0991210938, 8173.8286132813, 1682.6832275391), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Willard Street East", pos1 = Vector(8898.24609375, 6952.4702148438, 1540.4293212891), pos2 = Vector(9631.6396484375, 9734.66015625, 420.92053222656), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Willard Street North", pos1 = Vector(6662.2592773438, 8613.697265625, 1412.6848144531), pos2 = Vector(8865.9970703125, 9261.3212890625, 449.58270263672), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Overwatch Catwalks", pos1 = Vector(5041.7006835938, 5640.193359375, 856.23870849609), pos2 = Vector(5168.4677734375, 8099.2841796875, 1194.5532226563), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Overwatch Deployment Zone", pos1 = Vector(6757.0893554688, 7819.5297851563, 876.6435546875), pos2 = Vector(6311.2783203125, 8247.80859375, 1060.087890625), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Overwatch Catwalks Hallway", pos1 = Vector(6305.6494140625, 8136.3686523438, 864.03125), pos2 = Vector(5001.44140625, 8279.8427734375, 1145.4038085938), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},
	{name = "Abandoned District", pos1 = Vector(8718.654296875, 1322.7801513672, 41.141204833984), pos2 = Vector(10845.845703125, 5300.77734375, 524.73553466797), dispatch = {
		"npc/overwatch/radiovoice/condemnedzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Warehouse", pos1 = Vector(5664.3276367188, 8402.68359375, 766.50268554688), pos2 = Vector(6284.34375, 7098.796875, 227.25161743164), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Loyalist Housing", pos1 = Vector(6525.5112304688, 9455.8017578125, 1432.3872070313), pos2 = Vector(8856.0078125, 10791.298828125, 519.54382324219), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "CMU Clinic", pos1 = Vector(7329.69921875, 8198.61328125, 327.89001464844), pos2 = Vector(8431.0693359375, 7176.044921875, 79.541412353516), dispatch = {
		"npc/overwatch/radiovoice/externaljurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Civil Protection Holding Block", pos1 = Vector(8668.2939453125, 5785.212890625, 262.7077331543), pos2 = Vector(9097.1552734375, 6106.9970703125, 460.11221313477), dispatch = {
		"npc/overwatch/radiovoice/highpriorityreigion5.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Overwatch Catwalks", pos1 = Vector(8016.0673828125, 6920.91015625, 682.31280517578), pos2 = Vector(7922.8745117188, 5669.9936523438, 863.42926025391), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Quick Deployment Zone", pos1 = Vector(8087.8911132813, 5450.8623046875, 662.72747802734), pos2 = Vector(7736.3491210938, 5663.4501953125, 890.26501464844), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},
	{name = "Housing Block 2", pos1 = Vector(7944.3388671875, 3677.2485351563, 208.05186462402), pos2 = Vector(8701.0048828125, 2266.2761230469, 593.94604492188), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Housing Block 2", pos1 = Vector(8061.0791015625, 3180.3798828125, 22), pos2 = Vector(8357.7490234375, 2554.0676269531, 187.55041503906), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Housing Block 2", pos1 = Vector(7561.5727539063, 2765.8654785156, -27.366847991943), pos2 = Vector(7943.736328125, 2265.9716796875, 570.79803466797), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Housing Block 3", pos1 = Vector(7037.544921875, 2766.8608398438, -12.292039871216), pos2 = Vector(4808.7788085938, 2287.6884765625, 556.72540283203), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Housing Block 3", pos1 = Vector(6431.9926757813, 2286.7668457031, 554.14904785156), pos2 = Vector(5412.1787109375, 1724.9990234375, 186.95356750488), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Housing Block 3", pos1 = Vector(5999.0239257813, 2773.2893066406, 558.71697998047), pos2 = Vector(5417.7358398438, 3789.7346191406, 175.87010192871), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Triumph Trainstation Ingress", pos1 = Vector(8152.06640625, 1778.2202148438, -14.721506118774), pos2 = Vector(6460.888671875, 2263.2995605469, 599.96466064453), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Triumph Street", pos1 = Vector(7550.1010742188, 2226.7912597656, -9.1380634307861), pos2 = Vector(7052.388671875, 2770.3571777344, 725.35266113281), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Triumph Street", pos1 = Vector(7942.4375, 2771.5231933594, 8), pos2 = Vector(7070.3500976563, 5089.4741210938, 1466.3393554688), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Triumph Street", pos1 = Vector(7057.03125, 4295.326171875, 8.03125), pos2 = Vector(4732.7822265625, 5087.9565429688, 1599.9847412109), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Triumph Park", pos1 = Vector(7042.79296875, 4283.6264648438, 7.1229023933411), pos2 = Vector(6007.9091796875, 2774.6560058594, 1028.3286132813), dispatch = {
		"npc/overwatch/radiovoice/repurposedarea.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Ration Distribution Centre", pos1 = Vector(6894.4672851563, 7146.4599609375, 339.82965087891), pos2 = Vector(7267.80859375, 8109.9985351563, 62.092147827148), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Sewer Gate", pos1 = Vector(9360.03125, 1307.0991210938, 0.03125), pos2 = Vector(10364.197265625, -660.57208251953, 253.26275634766), dispatch = {
		"npc/overwatch/radiovoice/condemnedzone.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "City Administrator Meeting Room", pos1 = Vector(11703.344726563, 4296.078125, 2064.2553710938), pos2 = Vector(9787.3505859375, 5683.18359375, 3124.9987792969), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/six.wav"
	}},
	{name = "City Administrator Offices", pos1 = Vector(11756.84375, 7307.703125, 1842.3171386719), pos2 = Vector(13689.512695313, 3237.2409667969, 2530.4169921875), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},
	{name = "City Administrator Lobby", pos1 = Vector(13722.5859375, 5626.7451171875, 2042.8232421875), pos2 = Vector(15965.51953125, 2749.421875, 3239.3132324219), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Lower Nexus", pos1 = Vector(12470.078125, 9050.1953125, 430.69119262695), pos2 = Vector(13379.827148438, 10628.782226563, 1037.7504882813), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Lower Nexus", pos1 = Vector(12468.5390625, 10599.999023438, 696.03125), pos2 = Vector(12214.350585938, 9039.3720703125, 1042.1262207031), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Nexus Prison Wing", pos1 = Vector(13131.9296875, 9094.4375, 451.70788574219), pos2 = Vector(13993.87109375, 9721.43359375, 709.20239257813), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Nexus Interrogation Wing", pos1 = Vector(13996.990234375, 9031.6376953125, 465.96881103516), pos2 = Vector(14653.697265625, 9546.869140625, 734.62365722656), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Nexus Interrogation Room", pos1 = Vector(14008.315429688, 9776.2685546875, 444.73736572266), pos2 = Vector(14387.036132813, 9563.5869140625, 602.29943847656), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Nexus Urban Killhouse", pos1 = Vector(14767.026367188, 8818.658203125, 462.8987121582), pos2 = Vector(15720.578125, 9904.517578125, 875.23413085938), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Nexus Killhouse", pos1 = Vector(12313.185546875, 11281.947265625, 394.68176269531), pos2 = Vector(13137.466796875, 8917.76953125, 132.83337402344), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},
	{name = "Nexus Deservicement Pit", pos1 = Vector(14405.885742188, 9573.4091796875, 1172.0413818359), pos2 = Vector(14707.513671875, 10373.045898438, -46.04638671875), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/six.wav"
	}},
	{name = "Nexus Civil Protection Wing", pos1 = Vector(12435.252929688, 10566.012695313, 675.48492431641), pos2 = Vector(11898.501953125, 9019.4384765625, 487.86169433594), dispatch = {
		"npc/overwatch/radiovoice/terminalrestrictionzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Transhuman Stasis Wing", pos1 = Vector(12167.87109375, 9045.1572265625, 712.53607177734), pos2 = Vector(11901.752929688, 10412.885742188, 946.68939208984), dispatch = {
		"npc/overwatch/radiovoice/terminalrestrictionzone.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Nexus Medical Wing", pos1 = Vector(13348.073242188, 9040.7265625, 702.42364501953), pos2 = Vector(13860.765625, 9703.7333984375, 894.51684570313), dispatch = {
		"npc/overwatch/radiovoice/restrictedblock.wav",
		"npc/overwatch/radiovoice/seven.wav"
	}},
	{name = "Nexus Cafeteria Wing", pos1 = Vector(13383.4921875, 9777.05078125, 696.03125), pos2 = Vector(14286.490234375, 10585.904296875, 990.89996337891), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Nexus Lobby", pos1 = Vector(12048.71875, 8780.1904296875, 985.22692871094), pos2 = Vector(14836.729492188, 5509.8081054688, 319.39508056641), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Nexus Courtyard", pos1 = Vector(11762.649414063, 8591.2451171875, 1700.1571044922), pos2 = Vector(9804.0263671875, 6244.6958007813, 297.61645507813), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Sewers", pos1 = Vector(10836.848632813, -539.00207519531, -160.10148620605), pos2 = Vector(4828.3159179688, 10645.048828125, -514.93194580078), dispatch = {
		"npc/overwatch/radiovoice/404zone.wav"
	}},
		{name = "Drainage Tunnel", pos1 = Vector(10380.709960938, 8215.4404296875, -1657.2177734375), pos2 = Vector(7879.94140625, 7669.1899414063, -1987.4110107422), dispatch = {
		"npc/overwatch/radiovoice/infestedzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Drainage Tunnel", pos1 = Vector(7885.6284179688, 7728.3520507813, -1650.3562011719), pos2 = Vector(8400.431640625, 5887.0307617188, -1900.3796386719), dispatch = {
		"npc/overwatch/radiovoice/infestedzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Overwatch Sewer Deployment", pos1 = Vector(4449.6782226563, 5817.1474609375, -1347.3479003906), pos2 = Vector(4810.484375, 4980.6435546875, -1523.8306884766), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Maintenance Tunnel", pos1 = Vector(8448.140625, 5855.5102539063, -1752.9514160156), pos2 = Vector(9689.4970703125, 7664.6259765625, -1933.2622070313), dispatch = {
		"npc/overwatch/radiovoice/stationblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Lower Condemned Metro", pos1 = Vector(4861.375, 3940.2475585938, -1437.9342041016), pos2 = Vector(7825.01171875, 8666.7509765625, -2294.3635253906), dispatch = {
		"npc/overwatch/radiovoice/404zone.wav"
	}},
	{name = "Western Condemned Metro", pos1 = Vector(6094.3232421875, 7161.6938476563, -986.54669189453), pos2 = Vector(8832.2412109375, 9542.8984375, -1487.7161865234), dispatch = {
		"npc/overwatch/radiovoice/404zone.wav"
	}},
	{name = "Abandoned Parking Garage", pos1 = Vector(8814.4814453125, 5813.6840820313, -922.05120849609), pos2 = Vector(10445.666992188, 4848.01953125, -1511.3970947266), dispatch = {
		"npc/overwatch/radiovoice/404zone.wav"
	}},
	{name = "Abandoned Parking Garage", pos1 = Vector(9224.828125, 6481.7250976563, -1159.8060302734), pos2 = Vector(10438.930664063, 5757.2856445313, -1771.4675292969), dispatch = {
		"npc/overwatch/radiovoice/404zone.wav"
	}}
}

impulse.Config.IntroScenes = {
	{
	    pos = impulse.Config.MenuCamPos,
	    ang = impulse.Config.MenuCamAng,
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 6,
	    text = "Welcome to Deep Gaming 2.",
	    static = true,
	    fadeIn = true,
	    onStart = function()
	    end
	}
}

impulse.Config.ScannerSpawnPos = Vector(11684.259766, 6737.431152, 627.106812)

impulse.Config.DealerLocations = {
	{pos = Vector(9931.1875, 6317.59375, -1691.125), ang = Angle(0, -93.570556640625, 0)},
	{pos = Vector(9273.125, 5038.40625, -1768), ang = Angle(0, 9.964599609375, 0)},
	{pos = Vector(6621.90625, 4225.9375, -1183), ang = Angle(0, -110.46752929688, 0)},
	{pos = Vector(9603.15625, 2517, -24), ang = Angle(0, 89.066162109375, 0)}
}

impulse.Config.FishermanPos = Vector(5624.59375, 8269.8125, -1903.96875)
impulse.Config.FishermanAng = Angle(0, -30.624389648438, 0)

impulse.Config.PrisonAngle = Angle(-1.2061611413956, -88.935508728027, 0)
impulse.Config.PrisonCells = {
	Vector(13257.470703125, 9558.28515625, 456.03125),
	Vector(13549.956054688, 9559.818359375, 456.03125)
}

impulse.Config.JWButtonPos = Vector(14547.5, 3583.28125, 2152.5)
impulse.Config.JWOffButtonPos = Vector(14547.5, 3583.28125, 2152.5)
--[[impulse.Config.AJButtonPos = Vector(14547.5, 3583.28125, 2152.5)
impulse.Config.AJOffButtonPos = Vector(14547.5, 3583.28125, 2152.5)]]

impulse.Config.JWDirectOn = "jw_on"
impulse.Config.JWDirectOff = "jw_off"
--[[impulse.Config.AJDirectOn = "jw_on"
impulse.Config.AJDirectOff = "jw_off"]]

impulse.Config.Buttons = {
	{
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Open Gate",
		pos = Vector(5507.03125, 6572, 631.9375),
		doorgroup = 3
	},
	{
		desc = "Use Room Camera",
		pos = Vector(12107, 3782.3125, 2111.34375)
	},
	{
		desc = "Use Studio Camera",
		pos = Vector(12602, 3782.3125, 2111.34375)
	},
	{
		desc = "Use Speech Camera",
		pos = Vector(12542, 3981.5, 2108)
	},
	{
		desc = "Play Anthem",
		pos = Vector(11878.59375, 3844.65625, 2111.09375),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Show Technical Difficulties",
		pos = Vector(12191, 3783, 2111.34375)
	},
	{
		desc = "Show Intermission",
		pos = Vector(12263, 3783, 2111.34375)
	},
	{
		desc = "Disable Cameras",
		pos = Vector(12329, 3783, 2111.34375)
	},
	{
		desc = "Play Applause",
		pos = Vector(12765.5, 3783, 2111.34375),
		customCheck = function(ply)
			if not ply:IsAdmin() then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 30
			return true
		end
	},
	{
		desc = "Play Laughter",
		pos = Vector(12685.5, 3783, 2096.3125),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		desc = "Play Intro",
		pos = Vector(12253.5, 4019.96875, 2109.34375),
		doorgroup = 1,
		customCheck = function(ply)
			if not ply:IsAdmin() then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		desc = "Play Outro",
		pos = Vector(12350, 4019.96875, 2109.34375),
		doorgroup = 1,
		customCheck = function(ply)
			if not ply:IsAdmin() then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 200
			return true
		end
	},
	{
		desc = "Play News Intro",
		pos = Vector(12444, 4019.96875, 2109.34375),
		doorgroup = 1,
		customCheck = function(ply)
			if not ply:IsAdmin() then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 90
			return true
		end
	},
	{
		desc = "Call Lift to Upper Nexus",
		pos = Vector(12713, 5745.5, 517)
	},
	{
		desc = "Call Lift to Nexus Lobby",
		pos = Vector(12519, 6870.5, 2125)
	},
	{
		desc = "Goto Upper Nexus",
		pos = Vector(12845.5, 5616, 512)
	},
	{
		desc = "Goto Nexus Lobby",
		pos = Vector(12509.5, 7000, 2120)
	},
	{
		desc = "Call Lift to Lower Nexus",
		pos = Vector(14489, 3041.5, 2125)
	},
	{
		desc = "Goto Lower Nexus",
		pos = Vector(14498.5, 2912, 2120)
	},
	{
		desc = "Call Lift to Upper Nexus",
		pos = Vector(12855, 10606.5, 757)
	},
	{
		desc = "Goto Upper Nexus",
		pos = Vector(12722.5, 10736, 752)
	},
	{
		desc = "Ration Announcement",
		pos = Vector(12952, 4119, 2144),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		desc = "Suspend Rations",
		pos = Vector(12952, 4119, 2169),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		pos = Vector(14547.59375, 3583.3125, 2129.5),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Play Announcement",
		pos = Vector(14551.875, 3651.96875, 2157.6875),
		customCheck = function(ply)
			if ply:Team() != TEAM_CA then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		desc = "Play Announcement",
		pos = Vector(14551.875, 3651.96875, 2141.6875)
	},
	{
		desc = "Play Announcement",
		pos = Vector(14551.875, 3651.96875, 2125.6875),
		customCheck = function(ply)
			if ply:Team() != TEAM_CA then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		desc = "Play Announcement",
		pos = Vector(14515.875, 3623.78125, 2123.6875),
		customCheck = function(ply)
			if ply:Team() != TEAM_CA then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		desc = "Play Announcement",
		pos = Vector(14515.875, 3623.78125, 2123.6875),
		customCheck = function(ply)
			if ply:Team() != TEAM_CA then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		desc = "Play Announcement",
		pos = Vector(14515.875, 3623.78125, 2155.6875),
		customCheck = function(ply)
			if ply:Team() != TEAM_CA then
				return false
			end

			if HL2RP_ANNOUNCEMENT_COOLDOWN and HL2RP_ANNOUNCEMENT_COOLDOWN > CurTime() then
				return false
			end

			HL2RP_ANNOUNCEMENT_COOLDOWN = CurTime() + 100
			return true
		end
	},
	{
		pos = Vector(8859, 887, -157),
		customCheck = function(ply)
			return false
		end
	},
	{

		desc = "Close Rations",
		pos = Vector(7057, 7876.65625, 188.53125),
		doorgroup = 3

	},
	{
			desc = "Ration Open Announcement",
			pos = Vector(7161, 7881, 178),
			doorgroup = 3
	},
	{
		desc = "Ration Closed Announcement",
		pos = Vector(7199, 7970.96875, 186),
		doorgroup = 3
	},
	{
		desc = "Activate Alarm",
		pos = Vector(5691.9375, 6677.53125, 613.96875),
		doorgroup = 3
	},
	{
		desc = "Activate Alarm",
		pos = Vector(9379.5, 7912.96875, 673.625),
		doorgroup = 3
	},
	{
		desc = "Warehouse Announcement",
		pos = Vector(5778, 8457, 514),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		desc = "Open Gate",
		pos = Vector(9538.03125, 7801, 686.9375),
		doorgroup = 3
	},
	{
		desc = "Call Lift",
		pos = Vector(4768, 5440, -1468)
	},
	{
		desc = "Call Lift",
		pos = Vector(4800.03125, 5131.96875, 180),
	},
	{
		desc = "Open Blast Door",
		pos = Vector(12236, 10344, 760),
		doorgroup = 2
	},
	{
		desc = "Open Blast Door",
		pos = Vector(12177, 10137, 760)
	},
	{
		desc = "Toggle Lights",
		pos = Vector(12736, 9718.125, 306.84375)
	},
	{
		desc = "Open Blast Door",
		pos = Vector(13332, 9080, 760),
		doorgroup = 1
	},
	{
		desc = "Open Blast Door",
		pos = Vector(13391, 9287, 760),
		doorgroup = 1
	},
	{
		desc = "Open Execution Door",
		pos = Vector(14441.1875, 9771.5, 520.15625),
		doorgroup = 1
	},
	{    --Slums Elevator
		pos = Vector(9762, 3740, 19.75),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(9774, 3729, -1715.21875),
		customCheck = function(ply)
			return false
		end
	}    --Slums Elevator
}


impulse.Config.Buildings = {
	-- Victory Square Stores
	{tag="V 1",name="Victory 1",doors={1291, 1295, 1297, 1297},cost=50},
	{tag="V 2",name="Victory 2",doors={1289, 1290, 1293},cost=20},
	{tag="V 3",name="Victory 3",doors={1279, 1261, 1262, 1267, 1274, 1264, 1265},cost=50},
	{tag="V 4",name="Victory 4",doors={1280, 1263},cost=20},
	{tag="V 5",name="Victory 5",doors={1281, 1268, 1273},cost=20},

	-- Triumph Stores
	{tag="T 1",name="Triumph 1",doors={1278, 1485, 1282, 1570},cost=20},
	{tag="T 2",name="Triumph 2",doors={1276, 1288, 2264},cost=20},
	{tag="T 3",name="Triumph 3",doors={1277, 4022, 1328, 1569},cost=20},
	{tag="T 4",name="Triumph 4",doors={623, 625},cost=20},

	-- Apartment Block: 2
	{cat="apt",tag="APT 2 101",name="Apartment 101",doors={781, 780},cost=20},
	{cat="apt",tag="APT 2 102",name="Apartment 102",doors={631, 630},cost=20},
	{cat="apt",tag="APT 2 103",name="Apartment 103",doors={628, 629},cost=20},
	{cat="apt",tag="APT 2 103",name="Apartment 103",doors={628, 629},cost=20},
	{cat="apt",tag="APT 2 104",name="Apartment 104",doors={4146, 4144},cost=20},
	{cat="apt",tag="APT 2 201",name="Apartment 201",doors={663, 634},cost=20},
	{cat="apt",tag="APT 2 202",name="Apartment 202",doors={664, 635},cost=20},
	{cat="apt",tag="APT 2 203",name="Apartment 203",doors={787, 786},cost=20},

	-- Apartment Block: 3
	{cat="apt",tag="APT 3 101",name="Apartment 101",doors={652, 653, 654},cost=20},
	{cat="apt",tag="APT 3 102",name="Apartment 102",doors={791, 792},cost=20},
	{cat="apt",tag="APT 3 103",name="Apartment 103",doors={793, 794},cost=20},
	{cat="apt",tag="APT 3 104",name="Apartment 104",doors={793, 794},cost=20},
	{cat="apt",tag="APT 3 105",name="Apartment 105",doors={795, 796},cost=20},
	{cat="apt",tag="APT 3 106",name="Apartment 106",doors={790, 789},cost=20},
	{cat="apt",tag="APT 3 107",name="Apartment 107",doors={715, 713},cost=20},
	{cat="apt",tag="APT 3 108",name="Apartment 108",doors={665, 651},cost=20},
	{cat="apt",tag="APT 3 201",name="Apartment 201",doors={800, 801},cost=20},
	{cat="apt",tag="APT 3 202",name="Apartment 202",doors={802, 803},cost=20},
	{cat="apt",tag="APT 3 203",name="Apartment 203",doors={804, 805},cost=20},
	{cat="apt",tag="APT 3 204",name="Apartment 204",doors={806, 807},cost=20},
	{cat="apt",tag="APT 3 205",name="Apartment 205",doors={668, 648, 649},cost=20},
	{cat="apt",tag="APT 3 206",name="Apartment 206",doors={667, 655},cost=20},
	{cat="apt",tag="APT 3 207",name="Apartment 207",doors={716, 714},cost=20},
	{cat="apt",tag="APT 3 208",name="Apartment 208",doors={666, 647},cost=20},



	-- Loyalist Housing
	{cat="apt",tag="LH 101",name="Apartment 101",doors={878, 887, 886, 879, 1681},cost=35},
	{cat="apt",tag="LH 102",name="Apartment 102",doors={890, 893, 892, 1691},cost=35},
	{cat="apt",tag="LH 103",name="Apartment 103",doors={901, 896, 895, 1690},cost=35},
	{cat="apt",tag="LH 104",name="Apartment 104",doors={891, 899, 898, 899, 898, 1686},cost=35},
	{cat="apt",tag="LH 105",name="Apartment 105",doors={876, 880, 881, 1683, 877},cost=35},
	{cat="apt",tag="LH 106",name="Apartment 106",doors={888, 884, 883, 889, 1682},cost=35},
	{cat="apt",tag="LH 201",name="Apartment 201",doors={925, 935, 934, 926, 1693},cost=35},
	{cat="apt",tag="LH 202",name="Apartment 202",doors={939, 941, 942, 1697},cost=35},
	{cat="apt",tag="LH 203",name="Apartment 203",doors={950, 944, 945, 1696},cost=35},
	{cat="apt",tag="LH 204",name="Apartment 204",doors={940, 948, 947, 1695},cost=35},
	{cat="apt",tag="LH 205",name="Apartment 205",doors={923, 927, 928, 1694, 924},cost=35},
	{cat="apt",tag="LH 206",name="Apartment 206",doors={937, 931, 932, 938, 1692},cost=35},

	-- Ration Distribution Center
	{tag="RDT 1",name="RDT-1",doors={1555, 4078, 4077, 4076, 4075},cost=50},
	{tag="RDT 2",name="RDT-2",doors={1572},cost=20},
	{tag="RDT 3",name="RDT-3",doors={1571, 1583, 1584, 1585},cost=50},
	{tag="RDT 4",name="RDT-4",doors={1559},cost=50},
	{tag="RDT 5",name="RDT-5",doors={1560, 1576, 1575, 1561, 1562},cost=50},
	{tag="RDT 6",name="RDT-6",doors={1563, 1568, 1567},cost=50},
	{tag="RDT 7",name="RDT-7",doors={1564, 1565, 1566},cost=50},
	{tag="RDT 8",name="RDT-8",doors={1573, 1580, 1581, 1582},cost=50},

	-- Miscellaneous
	{tag="RS 1",name="Reserviced Area 1",doors={2161, 578},cost=15},
	{tag="RS 2",name="Reserviced Area 2",doors={1495, 1502, 4143, 1531, 1510, 3827},cost=20},
	{tag="RS 3",name="Reserviced Area 3",doors={857, 859, 858},cost=10}
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

impulse.Config.LoadScript = function()
	for v,k in pairs(ents.FindInBox(Vector(11559.77734375, 5143.9931640625, 1322.8232421875), Vector(10845.040039063, 4381.3544921875, 830.97869873047))) do
		if k:GetClass() == "func_button" then
			k:Remove()
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

impulse.Config.CPSpawnLocations = {Vector(13034.672851563, 7144.25, 456.03125),
Vector(12506.428710938, 9075.1494140625, 456.03125),
Vector(13233.494140625, 9056.03125, 696.03125),
Vector(12697.53125, 6182.2373046875, 456.03125),
Vector(13195.240234375, 10115.546875, 456.03125),
Vector(12870.205078125, 6505.5400390625, 456.03125),
Vector(12142.072265625, 7607.541015625, 456.03125),
Vector(13418.672851563, 7670.8696289063, 456.03125)
}

impulse.Config.OTASpawnLocations = {Vector(13034.672851563, 7144.25, 456.03125),
Vector(12506.428710938, 9075.1494140625, 456.03125),
Vector(13233.494140625, 9056.03125, 696.03125),
Vector(12697.53125, 6182.2373046875, 456.03125),
Vector(13195.240234375, 10115.546875, 456.03125),
Vector(12870.205078125, 6505.5400390625, 456.03125),
Vector(12142.072265625, 7607.541015625, 456.03125),
Vector(13418.672851563, 7670.8696289063, 456.0312)
}

impulse.Config.CASpawnLocations = {Vector(13449.540039063, 5759.96875, 2064.03125),
Vector(11955.890625, 5911.96875, 2064.0463867188),
Vector(12447.96875, 5007.1752929688, 1872.03125),
Vector(11581.420898438, 4501.7836914063, 2064.03125)
}

impulse.Config.ZombieSpawnLocations = {Vector(8343.7841796875, 6008.7158203125, -1887.96875),
Vector(6704.03125, 7772.4389648438, -1871.96875),
Vector(5460.0024414063, 6098.0844726563, -1675.0681152344),
Vector(5510.7373046875, 7850.0986328125, -1678.2032470703),
Vector(8848.5673828125, 8144.8012695313, -1887.96875),
Vector(6548.8481445313, 4500.2221679688, -1281.8980712891),
Vector(7021.8217773438, 5204.5322265625, -1543.96875),
Vector(8110.4111328125, 6394.4140625, -1077.7442626953)
}
impulse.Config.StalkerSpawnLocations = {
	Vector(12629.116210938, 8109.8046875, 456.83813476563),
	Vector(12484.724609375, 9391.5966796875, 456.03125),
	Vector(12063.513671875, 7246.0048828125, 456.03125),
	Vector(12143.232421875, 7670.2231445313, 456.03125)
}