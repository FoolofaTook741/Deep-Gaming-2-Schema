impulse.Config.MapWorkshopID = "3314018313"
--impulse.Config.MapContentWorkshopID = "1406336883"

impulse.Config.MenuCamPos = Vector(3578.6557617188, 812.6650390625, 1113.3162841797)
impulse.Config.MenuCamAng = Angle(25.129280090332, 56.971920013428, 0)

impulse.Config.SpawnPos1 = Vector(1332.3743896484, 2311.9812011719, -102.96875)
impulse.Config.SpawnPos2 = Vector(1345.9365234375, 2655.3891601562, -102.96875)

impulse.Config.BroadcastPos = Vector(5641.2451171875, 3612.6804199219, 1402.03125)

impulse.Config.MapType = "Arctic"
impulse.Config.CityCode = "C27"
impulse.Config.OverwatchCode = "S27"
impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.BulkCrateSpawn = Vector(8695.1435546875, 710.25433349609, 358.7184753418)

impulse.Config.SporeClusters = {
	Vector(-1142.0340576172, -392.09164428711, 249.03125),
	Vector(-1722.7127685547, 270.28955078125, 249.03125),
	Vector(-1375.1789550781, -1250.1225585938, 249.03125),
	Vector(-518.25347900391, 54.469657897949, -6.96875),
	Vector(-461.1780090332, -172.04273986816, -49.96875),
	Vector(-1804.0056152344, -12.010543823242, -49.96875),
	Vector(-1802.6419677734, -141.09831237793, -49.96875),
	Vector(325.00946044922, -105.29583740234, -49.96875),
	Vector(-65.271087646484, 737.92987060547, 258.63955688477),
	Vector(-520.41064453125, -421.3180847168, 249.03125)
}

impulse.Config.TrashSpawns = {
	Vector(1543.6866455078, 1242.0490722656, 238.03125),
	Vector(3883.0749511719, 1184.4443359375, 291.03125),
	Vector(6749.482421875, 1137.9925537109, 343.03125),
	Vector(8643.01171875, 866.08746337891, 343.03125),
	Vector(7948.9047851562, 1526.4113769531, 343.03125),
	Vector(6599.9448242188, 3299.2556152344, 343.03125),
	Vector(6776.529296875, 5130.5727539062, 343.03125),
	Vector(4572.3491210938, 3784.7163085938, 296.03125)
}

impulse.Config.vortPortalSpawnPos = {
    Vector(5791.6401367188, -11458.216796875, 532.03118896484),
    Vector(2933.0336914062, -8252.32421875, -487.54159545898),
    Vector(3452.9943847656, -14654.255859375, -682.96875),
    Vector(451.91815185547, -14430.416992188, -353.77416992188),
    Vector(3580.275390625, -13529.525390625, 2.0393943786621),
    Vector(5874.8540039062, -9403.5546875, 532.03125),
    Vector(7371.6674804688, -8985.4326171875, -434.1311340332),
    Vector(9023.8115234375, -11076.810546875, -328.13989257812),
    Vector(8155.0170898438, -10195.258789062, -398.84295654297),
    Vector(10932.293945312, -9570.32421875, -345.96875),
    Vector(9107.2783203125, -2848.0732421875, 7.9436683654785),
    Vector(14068.599609375, -2680.4113769531, -67.237258911133)
}

impulse.Config.Zone404Name = "Sewer System Entrance"
impulse.Config.BulkCrateSpawn = Vector(1214.0338134766, -447.62561035156, 728.03125)

impulse.Config.Zones = {
	{name = "Stabalization Jurisdiction 1", pos1 = Vector(-7417.2260742188, -10079.870117188, -1415.4825439453), pos2 = Vector(-2665.0600585938, -3364.0080566406, 790.84497070312), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
{name = "Outland Zone 1", pos1 = Vector(-2645.9582519531, -6862.3154296875, 2644.1240234375), pos2 = Vector(5788.2265625, -16266.438476562, -925.61804199219), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
{name = "Outland Zone 2", pos1 = Vector(5788.2265625, -16266.438476562, -925.61804199219), pos2 = Vector(11430.072265625, -7059.8232421875, 2665.6083984375), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
  {name = "Outland Zone 3", pos1 = Vector(8563.4951171875, -2198.1516113281, 2305.7026367188), pos2 = Vector(14895.625, -7043.828125, -289.60382080078), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
{name = "Redidential Block 1", pos1 = Vector(9791.154296875, 332.69927978516, 181.21109008789), pos2 = Vector(6653.8520507812, -2164.9682617188, 2248.7099609375), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "Residential Block 2", pos1 = Vector(5253.6889648438, -2160.1997070312, 1767.888671875), pos2 = Vector(8562.5673828125, -4575.5009765625, 179.42193603516), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/two.wav"
    }},
  {name = "Residential Zone 3", pos1 = Vector(6218.87109375, 6229.240234375, 1660.7651367188), pos2 = Vector(8459.001953125, 3967.1828613281, 78.766845703125), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/three.wav"
    }},
  {name = "Residential Zone 4", pos1 = Vector(6326.7856445312, 892.55651855469, 1128.8670654297), pos2 = Vector(5235.9594726562, -298.5647277832, 178.69091796875), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/four.wav"
    }},
  {name = "Plaza 1", pos1 = Vector(6324.349609375, 891.08972167969, 1338.1127929688), pos2 = Vector(3698.7436523438, 3957.1938476562, 178.61737060547), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "Production Block 4", pos1 = Vector(5238.9077148438, -3333.9360351562, 2141.0373535156), pos2 = Vector(3700.8312988281, 887.6083984375, 46.753349304199), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
  {name = "Production Block 3", pos1 = Vector(3697.4831542969, -1680.5251464844, 2307.6828613281), pos2 = Vector(199.00286865234, 2001.0727539062, 127.86260986328), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
  {name = "Production Block 2", pos1 = Vector(6321.3842773438, 3966.4565429688, 141.48677062988), pos2 = Vector(11045.919921875, 338.86364746094, 1853.4959716797), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
  {name = "Production Block 1", pos1 = Vector(3700.7702636719, 3960.1315917969, 775.81341552734), pos2 = Vector(2460.6242675781, 2853.6020507812, 305.32626342773), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "Condembed Zone 1", pos1 = Vector(198.80453491211, 2003.2032470703, 1060.9562988281), pos2 = Vector(-3599.2824707031, -1978.4987792969, 43.733013153076), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
  {name = "Train Station 3", pos1 = Vector(3356.8427734375, 1997.3959960938, 453.90875244141), pos2 = Vector(1866.109375, 2845.2143554688, 82.633331298828), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
  {name = "Train Station 2", pos1 = Vector(827.53234863281, 2843.3764648438, 378.201171875), pos2 = Vector(2544.732421875, 4323.6499023438, -366.68041992188), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
  {name = "Train Station 1", pos1 = Vector(822.26580810547, 1379.0515136719, -249.07783508301), pos2 = Vector(1863.0520019531, 2842.783203125, 406.02255249023), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "Train Station 4", pos1 = Vector(2543.4311523438, 3995.0563964844, 130.05471801758), pos2 = Vector(2820.7253417969, 3655.3198242188, 329.66979980469), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/four.wav"
    }},
  {name = "High Priority Region 1", pos1 = Vector(3383.4780273438, 5520.7885742188, 172.61395263672), pos2 = Vector(5549.8803710938, 3958.61328125, 625.18920898438), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "High Priority Region 2", pos1 = Vector(4419.3500976562, 5521.6997070312, 647.72448730469), pos2 = Vector(5769.69921875, 8667.0322265625, 163.59753417969), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
  {name = "High Priority Region 3", pos1 = Vector(2235.6779785156, 4467.5595703125, 752.81677246094), pos2 = Vector(6131.4130859375, 8865.4111328125, 1262.7735595703), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
  {name = "High Priority Region 4", pos1 = Vector(3660.9208984375, 2866.8703613281, 1345.6403808594), pos2 = Vector(6218.1552734375, 7435.5205078125, 2554.955078125), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
  {name = "Storm System 1", pos1 = Vector(8559.072265625, -3520.6525878906, 195.81254577637), pos2 = Vector(5264.5361328125, 967.96087646484, -259.94772338867), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
  {name = "Storm System 3", pos1 = Vector(-4414.4404296875, -2486.6274414062, 25.324234008789), pos2 = Vector(817.35290527344, 3807.6870117188, -711.79296875), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
  {name = "Storm Systems 2", pos1 = Vector(5239.4091796875, -1845.5994873047, 33.594551086426), pos2 = Vector(819.58935546875, 1364.0406494141, -768.58319091797), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
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
	{pos = Vector(7720.7377929688, -8928.5166015625, -257.96871948242), ang = Angle(5.8681530952454, -0.91772466897964, 0)},
	{pos = Vector(-2604.6081542969, 1540.8454589844, -447.96875), ang = Angle(2.228494644165, -16.501768112183, 0)},
	{pos = Vector(1337.9375, 2088.2009277344, -102.96875), ang = Angle(2.6544098854065, -86.487373352051, 0)},
	{pos = Vector(5959.2075195312, -8425.189453125, 530.80224609375), ang = Angle(2.6544115543365, -168.49630737305, 0)}
}

impulse.Config.ConverterLocations = {
	{pos = Vector(0, 0, 0), ang = Angle(7.7879543304443, 89.61058807373, 0)},
}

impulse.Config.FishermanPos = Vector(1936.6748046875, -14457.947265625, -662.45935058594)
impulse.Config.FishermanAng = Angle(0.67967188358307, -164.58839416504, 0)

impulse.Config.PrisonAngle = Angle(1.25062084198, -88.852066040039, 0)
impulse.Config.PrisonCells = {
	Vector(4929.0815429688, 7635.3374023438, 296.03125),
	Vector(5314.8393554688, 7623.8369140625, 296.03125),
	Vector(4918.201171875, 8179.8916015625, 296.03125)
}

impulse.Config.AJButtonPos = Vector(2560, 8056, 880)

impulse.Config.AJOffButtonPos = Vector(2160, 8056, 880)
impulse.Config.JWButtonPos = Vector(2320, 8056, 880)
impulse.Config.JWOffButtonPos = Vector(2416, 8056, 880)


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
	
	local lockDoorIDs = { 
		3610, 4584, 5664, 8319, 8320, 7114, 2556, 1574, 4321, 8284,
		9176, 2393, 8904, 2161, 2939, 2051, 6800, 2198, 7924, 7735,
		8589, 6598, 8064, 5995, 9147, 9496, 9473, 4918, 8859, 2257,
		1825, 9592, 3674, 3822, 7672, 5124, 2863, 5178, 8962, 5490,
		4725, 7160, 9392, 2027, 2028, 2077, 2076, 3342
	}

	local lockDoors = {}
	for _, id in ipairs(lockDoorIDs) do
		lockDoors[id] = true
	end

	for _, ent in ipairs(ents.GetAll()) do
		if IsValid(ent) then
			local class = ent:GetClass()
			if class == "func_door" or class == "func_door_rotating" or class == "prop_door_rotating" then
				local hammerID = ent:MapCreationID()
				if lockDoors[hammerID] then
					ent:Fire("Lock", "", 0)
					print("Locked door with Hammer ID:", hammerID)
				end
			end
		end
	end
	
end

impulse.Config.CPSpawnLocations = {Vector(3791.7395019531, 4856.708984375, 296.03125),
Vector(3787.0258789062, 4762.6645507812, 296.03125),
Vector(3782.9780273438, 4681.9052734375, 296.03125),
Vector(3779.3852539062, 4610.2250976562, 296.03125),
Vector(3675.310546875, 4615.44140625, 296.03125),
Vector(3678.9780273438, 4688.6162109375, 296.03125),
Vector(3683.7407226562, 4783.6376953125, 296.03125),
Vector(3688.4711914062, 4878.015625, 296.03125)
}

impulse.Config.OTASpawnLocations = {Vector(2559.7204589844, 6202.9619140625, 898.03125),
Vector(2677.6489257812, 6201.8681640625, 898.03125),
Vector(2770.9020996094, 6200.8110351562, 898.03125),
Vector(2865.306640625, 6199.7407226562, 898.03125),
Vector(2863.9855957031, 6082.9624023438, 898.03125),
Vector(2774.6069335938, 6083.9750976562, 898.03125),
Vector(2675.9489746094, 6086.0209960938, 898.03125),
Vector(2571.7976074219, 6089.1005859375, 898.03125)
}

impulse.Config.CASpawnLocations = {Vector(4469.6840820312, 4583.9233398438, 296.03125),
Vector(4471.5424804688, 4655.6728515625, 296.03125),
Vector(4474.0825195312, 4753.732421875, 296.03125)
}

impulse.Config.ZombieSpawnLocations = {Vector(7485.3896484375, 163.38970947266, -137.6258392334),
Vector(7493.0893554688, -2584.4714355469, -160.96875),
Vector(5395.205078125, -1632.5744628906, -160.96875),
Vector(1339.6392822266, 635.54339599609, -281.18035888672),
}

impulse.Config.StalkerSpawnLocations = {Vector(4474.0825195312, 4753.732421875, 296.03125),
}

impulse.Config.CitizenSpawnLocations = {
    Vector(1293.9588623047, 2226.5178222656, -102.96875),
    Vector(1395.8309326172, 2223.529296875, -102.96875),
    Vector(1391.3212890625, 2322.8283691406, -102.96875),
    Vector(1295.0385742188, 2326.2177734375, -102.96875),
    Vector(1298.0430908203, 2411.5759277344, -102.96875),
    Vector(1383.3989257813, 2408.5712890625, -102.96875),
    Vector(1385.2475585938, 2500.7915039063, -102.96875),
    Vector(1320.3865966797, 2503.0747070313, -102.96875),
    Vector(1281.8962402344, 2601.6218261719, -102.96875),
    Vector(1389.9650878906, 2597.8176269531, -102.96875),
    Vector(1393.2894287109, 2692.2612304688, -102.96875),
    Vector(1298.8483886719, 2695.5856933594, -102.96875),
    Vector(1302.0128173828, 2785.4865722656, -102.96875),
    Vector(1400.9964599609, 2782.0021972656, -102.96875),
    Vector(1379.1423339844, 2868.4375, -102.96875),
    Vector(1275.6160888672, 2872.0817871094, -102.96875),
    Vector(1278.9404296875, 2966.525390625, -102.96875),
    Vector(1376.0823974609, 2963.1059570313, -102.96875),
    Vector(1378.6071777344, 3034.8359375, -102.96875),
    Vector(1270.8063964844, 3042.8269042969, -102.96875),
    Vector(1273.1712646484, 3110.0141601563, -102.96875),
    Vector(1372.1549072266, 3106.5297851563, -102.96875),
    Vector(1374.5197753906, 3173.7170410156, -102.96875),
    Vector(1289.1639404297, 3176.7216796875, -102.96875),
    Vector(1284.8630371094, 3275.3771972656, -102.96875),
    Vector(1383.8466796875, 3271.8928222656, -102.96875),
    Vector(1387.4908447266, 3375.421875, -102.96875),
    Vector(1293.0498046875, 3378.7463378906, -102.96875),
    Vector(1352.8601074219, 3427.3029785156, -102.96875),
    Vector(1245.3470458984, 3477.7722167969, -102.96875),
    Vector(1269.8033447266, 3590.2680664063, -102.96875),
    Vector(1368.8479003906, 3590.9223632813, -102.96875),
    Vector(1375.818359375, 3669.1989746094, -102.96875),
    Vector(1281.3192138672, 3668.5747070313, -102.96875),
    Vector(1280.7551269531, 3753.9829101563, -102.96875),
    Vector(1375.2542724609, 3754.6071777344, -102.96875),
    Vector(1374.7802734375, 3826.3791503906, -102.96875),
    Vector(1289.3719482422, 3825.8149414063, -102.96875),
    Vector(1296.9270019531, 3869.6428222656, -102.96875),
    Vector(1377.7486572266, 3867.0109863281, -102.96875),
}



-- chat commands
local gates = {
	["INTERNAL OUTLANDS GATE"] = Vector(-182, 1133.5, 410),
	["EXTERNAL OUTLANDS GATE"] = Vector(-4446, -9477, -325.03125),
	["INDUSTRIAL GATE"] = Vector(10342.5, 699.5, 441.5),
	["STORMSYSTEM GATE"] = Vector(-3264, -3387, 148),
}

local cooldowns = {}
local howCloseYouNeedToBe = 300^2

impulse.RegisterChatCommand("/combinegate", {
	description = "Opens the closest Combine Bulkhead. (Combine only)",
	requiesAlive = true,
	onRun = function(ply, arg, rawText)
		if not ((ply:Team() == TEAM_OTA) or (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_OFC)) then
			ply:Notify("You must be a member of the OTA or CP RL+ to use this.")
			return
		end

		local gateName
		local gatePos
		for name, pos in pairs( gates ) do
			local dist = (pos - ply:GetPos()):LengthSqr()
			if dist < howCloseYouNeedToBe then
				gateName = name
				gatePos = pos
				break
			end
		end

		if not gatePos then
			ply:Notify( "You aren't near a large Combine door." )
			return
		end

		local cooldown = cooldowns[gatePos] or 0

		if CurTime() < cooldown then
			local timeLeft = math.floor( cooldown - CurTime() )
			ply:Notify( ("This gate can open in %i seconds."):format( timeLeft ) )
			return
		end

		for _, door in ipairs( ents.FindByClass("func_door") ) do
			if door:GetPos():DistToSqr(gatePos) > 100 then
				continue
			end

			door:Fire("open", "", .6)

			local time = 20
			if gateName == "STORMSYSTEM GATE" then
				time = 40
			end

			for _, combine in pairs(player.GetAll()) do
				if combine:IsCP() then
					combine:SendCombineMessage(ply:Name() .. " HAS OPENED THE "..gateName..".", Color(0, 100, 0))
				end
			end

			timer.Simple(time, function()
				if not IsValid( door ) then return end
				door:Fire("close", "", .6)
				for _, combine in pairs(player.GetAll()) do
					if combine:IsCP() then
						combine:SendCombineMessage("THE "..gateName.." HAS CLOSED.", Color(0, 100, 0))
					end
				end
			end)

			cooldowns[gatePos] = CurTime() + time + 10
			break
		end

		ply:Notify( "You have opened the gate." )
	end
} )

if SERVER then
	-- Workshop content
	resource.AddWorkshop( "3465221427" ) -- Deep Gaming 2 - Content Pack #2
	resource.AddWorkshop( "2853989986" ) -- Half-Life Alyx: Hazmat male and female
	resource.AddWorkshop( "2685051966" ) -- Image Tool - Your pictures in the world!
	resource.AddWorkshop( "2905875154" ) -- Project: Synapse - Props Pack
	resource.AddWorkshop( "2942500044" ) -- Project: Synapse - Resource Pack
	resource.AddWorkshop( "2979382377" ) -- Project: Synapse - Sound Pack
	resource.AddWorkshop( "1562056573" ) -- Large Sci-Fi Generator / Reactor
	resource.AddWorkshop( "2714660044" ) -- rp_industrial17_landis
	resource.AddWorkshop( "3490155976" ) -- HL Alyx Combine Animated Prop [discontinued]
	resource.AddWorkshop( "635535045" ) -- Handheld Radio
	resource.AddWorkshop( "3303394137" ) -- rp_c18_dg
	resource.AddWorkshop( "3235982889" ) -- City 26 - District 12 [Roleplay]
	resource.AddWorkshop( "104491619" ) -- Metropolice Pack
	resource.AddWorkshop( "104603291" ) -- Extended Spawnmenu
	resource.AddWorkshop( "105042805" ) -- Combine Administrators v2
	resource.AddWorkshop( "108024198" ) -- Food and Household items
	resource.AddWorkshop( "121412995" ) -- Combine AR3 Machine Gun
	resource.AddWorkshop( "173482196" ) -- SProps Workshop Edition
	resource.AddWorkshop( "206166550" ) -- Sabre-aN's Headcrab Zombie Mod
	resource.AddWorkshop( "282312812" ) -- HL2RP ID Cards
	resource.AddWorkshop( "411141331" ) -- PPSh-41 [CW2.0]
	resource.AddWorkshop( "744901224" ) -- 4K Templar Sword
	resource.AddWorkshop( "1144876357" ) -- Infantry First Aid Kit
	resource.AddWorkshop( "1574676244" ) -- Half-Life 2 Building Kit
	resource.AddWorkshop( "1651398810" ) -- impulse framework content
	resource.AddWorkshop( "1689357640" ) -- impulse: Half-Life 2 Roleplay Content
	resource.AddWorkshop( "1784911999" ) -- LED screens
	resource.AddWorkshop( "1929148608" ) -- impulse: Christmas Content
	resource.AddWorkshop( "1931077830" ) -- impulse: Half-Life 2 Roleplay Content 2
	resource.AddWorkshop( "1967574455" ) -- impulse: Half-Life 2 Roleplay Content 3
	resource.AddWorkshop( "1996672418" ) -- [TFA] Half-Life: Alyx - Shotgun
	resource.AddWorkshop( "2035519790" ) -- HL:Alyx Combine Grunt
	resource.AddWorkshop( "2037241085" ) -- HL:Alyx Combine Suppressor
	resource.AddWorkshop( "2043900984" ) -- [Half Life: Alyx] Infestation Control props
	resource.AddWorkshop( "2085971768" ) -- impulse: Half-Life 2 Roleplay Content 4
	resource.AddWorkshop( "2109019567" ) -- [Half Life: Alyx] Combine Workers (Player, NPC, Ragdoll)
	resource.AddWorkshop( "2117238555" ) -- impulse: Half-Life 2 Roleplay Content 5
	resource.AddWorkshop( "2131228609" ) -- [ArcCW] M2 Browning
	resource.AddWorkshop( "2160883169" ) -- [TFA] BAR M1918 - Service Model
	resource.AddWorkshop( "2228994615" ) -- [Half Life: Alyx] Xen Pack (Props)
	resource.AddWorkshop( "2230543274" ) -- Willard Combine Upgrades
	resource.AddWorkshop( "2473879362" ) -- Willard 2.0 Combine Pack
	resource.AddWorkshop( "2521715069" ) -- [TFA] Combine-Modified SMG
	resource.AddWorkshop( "2630235485" ) -- [TFA] AK47 and Type 56 (Call of Duty Black Ops: Cold War)
	resource.AddWorkshop( "2631194512" ) -- Nemez Combine Soldier Remake Pack
	resource.AddWorkshop( "2653493568" ) -- Combine Suits 2.0 - Tweaked
	resource.AddWorkshop( "2665902404" ) -- [TFA] [AT] Project HL2 MMod Pack
	resource.AddWorkshop( "2774420106" ) -- [HALF-LIFE: ALYX] Infestation Control models.
	resource.AddWorkshop( "2797830728" ) -- TFA HL:A Weapons
	resource.AddWorkshop( "2866027579" ) -- AmmoWorkbench
	resource.AddWorkshop( "2891252709" ) -- Half Life 2 Props Extended
	resource.AddWorkshop( "2920724950" ) -- Willard Networks V1 Models
	resource.AddWorkshop( "2926909009" ) -- Willard Networks V1 Playermodels
	resource.AddWorkshop( "2941435647" ) -- Fast Zombie With Headcrab Playermodel
	resource.AddWorkshop( "2965143123" ) -- [TFA] PTRS-41
	resource.AddWorkshop( "2980005772" ) -- Deep Gaming Materials Pack
	resource.AddWorkshop( "3032450089" ) -- DGH Asset Pack A
	resource.AddWorkshop( "3035353556" ) -- DGH Asset Pack B
	resource.AddWorkshop( "3096690838" ) -- Deep Gaming music pack

	resource.AddWorkshop( "3159278363" ) -- DGH Asset Pack C
	resource.AddWorkshop( "3222165323" ) -- Deep Gaming HL2RP - Content Pack #1
	resource.AddWorkshop( "2452057425" ) -- Soviet Lab Electronics Prop Pack from Snowdrop Escape
	resource.AddWorkshop( "1909557607" ) -- [TTT/Sandbox] Combine Sniper
	resource.AddWorkshop( "3028357706" ) -- [LVS] - Half-Life 2
	resource.AddWorkshop( "2912816023" ) -- [LVS] - Framework
	resource.AddWorkshop( "3027255911" ) -- [LVS] - Military - Pack
	resource.AddWorkshop( "2922255746" ) -- [LVS] - Helicopters - Pack
	resource.AddWorkshop( "2840031720" ) -- TFA Base
	resource.AddWorkshop( "2216838577" ) -- [Half Life: Alyx] Consumables Misc (Props)
	resource.AddWorkshop( "3490004161" ) -- Pinnacle Gaming Content #2
	resource.AddWorkshop( "1744257891" ) -- i17 v3 Content
	resource.AddWorkshop( "2041528484" ) -- HL:Alyx Vanilla Combine
	resource.AddWorkshop( "2892681669" ) -- [NPC] VALKYRIA Civil Protection maskless
	resource.AddWorkshop( "771487490" ) -- [simfphys] LUA Vehicles - Base
	resource.AddWorkshop( "831680603" ) -- [simfphys] - Armed
	resource.AddWorkshop( "2892682541" ) -- [MATERIALS] VALKYRIA Civil Protection maskless
	resource.AddWorkshop( "417428923" ) -- Episodic Pill Pack
	resource.AddWorkshop( "950845673" ) -- Parakeet's Pill Pack
	resource.AddWorkshop( "3529402381" ) -- Sound Muffling Effect
	resource.AddWorkshop( "3616199913" ) -- Fallout 76 Workbenches
end