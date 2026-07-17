impulse.Config.MapWorkshopID = "3132024232"
--impulse.Config.MapContentWorkshopID = "1406336883"

impulse.Config.MenuCamPos = Vector(-765.56866455078, 3562.11328125, 1048.875)
impulse.Config.MenuCamAng = Angle(-43.157539367676, 177.13320922852, 0)


impulse.Config.SpawnPos1 = Vector(-4059.7294921875, 2897.4719238281, 464.03125)
impulse.Config.SpawnPos2 = Vector(-2150.8576660156, 2882.19140625, 464.03125)

impulse.Config.BroadcastPos = Vector(2725.4353027344, 4052.03125, 3416.03125)

impulse.Config.TPCPos = Vector(-11780.508789062, 2391.7241210938, 8192.03125)
impulse.Config.MBEntrance = Vector(3384.1794433594, -1252.8516845703, -167.96875)

impulse.Config.APCSpawn = Vector(-11258.426757813, 287.59600830078, 8192.03125)
impulse.Config.HCSpawn = Vector(-10748.7265625, -303.71423339844, 8615.7607421875)
impulse.Config.DropshipSpawn = Vector(-11258.426757813, 287.59600830078, 8192.03125)



impulse.Config.NoCollideZones = {
    { --spawn
        Vector(-4589.0844726563, 2435.9165039063, 791.65179443359),
        Vector(-1747.9808349609, 3326.6455078125, 336.25393676758)
    },
    { --metabase nocollide zone
        Vector(3450.8505859375, -1363.8334960938, -40.650173187256),
        Vector(3262.8950195313, -1170.9945068359, -203.34521484375)
    },
}

impulse.Config.NexusSpawnPicture = "dg2/spawns/i17_nexus.png"
impulse.Config.FOBSpawnPicture   = "dg2/spawns/i17_fob.png"
impulse.Config.OZSpawnPicture    = "dg2/spawns/i17_oz.png"

impulse.Config.MapType = "Woodland"

impulse.Config.CityCode = "C17"
impulse.Config.OverwatchCode = "S17"

impulse.Config.OverworldPortalPos = Vector(-3469.5261230469, 6366.1162109375, -4179.6337890625)
impulse.Config.OverworldPortalAng = Angle(90,0,0)
impulse.Config.OverworldPortalModel = "models/effects/intro_vortshield.mdl"
impulse.Config.OverworldPortalScale = 10

impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.XenContaminationZones = {
    "Storm System 1",
    "Storm System 2",
    "Storm System 3",
}

impulse.Config.SporeClusters = {
	Vector(6469.130859375, 3088.8254394531, 223.61917114258),
	Vector(4240.03125, 2308.4914550781, 200.03125),
	Vector(5232.03125, 2651.4697265625, 472.03125),
	Vector(4242.7758789063, 3563.4204101563, 200.03125),
	Vector(-10838.443359375, 1728.8970947266, 7959.6137695313),
	Vector(2899.1650390625, -644.34289550781, 8202.6357421875),
	Vector(8697.8427734375, 1687.2349853516, 7944.1044921875),
	Vector(6797.384765625, -2235.3752441406, 8210.4833984375),
	Vector(6741.90234375, 2250.0412597656, 569.30401611328),
	Vector(7122.31640625, 1919.0509033203, 1000.03125),
	Vector(-1275.7271728516, -7526.107421875, 8353.7744140625),
    Vector(2692.2341308594, -6982.8159179688, 8218.6240234375),
    Vector(2048.4572753906, -128.5348815918, 8226.3173828125),
    Vector(-8768.4365234375, -578.298828125, 8216.2412109375),
    Vector(-11984.234375, 1731.6384277344, 7968.7583007813),
    Vector(5593.021484375, 1953.8530273438, 7976.9072265625)
}

impulse.Config.vortPortalSpawnPos = {
    Vector(1719.32421875, -545.81408691406, 8227.7080078125),
    Vector(1057.431640625, -477.53225708008, 8227.5185546875),
    Vector(1012.9373168945, -148.38540649414, 8240.017578125),
    Vector(-263.95303344727, 643.00689697266, 8238.1337890625),
    Vector(-1702.9522705078, -1659.1693115234, 8246.515625),
    Vector(-3019.5947265625, -599.85046386719, 8320.03125),
    Vector(-823.18786621094, 1928.1096191406, 8191.4829101563),
    Vector(154.09188842773, -5490.3276367188, 8244.740234375),
    Vector(2181.9372558594, -6087.017578125, 8230.919921875),
    Vector(1591.0562744141, -6953.8540039063, 7963.1586914063),
    Vector(1883.1727294922, -6923.5737304688, 7964.287109375),
    Vector(1771.6861572266, -6403.4028320313, 7966.1284179688),
    Vector(1328.7543945313, -6363.99609375, 7954.7719726563),
    Vector(1060.9747314453, -5649.478515625, 7739.369140625),
    Vector(944.65020751953, -5606.4677734375, 7744.9497070313),
    Vector(796.54248046875, -5572.921875, 7738.4301757813),
    Vector(620.87677001953, -5527.2421875, 7778.72265625),
    Vector(480.78240966797, -5494.390625, 7793.18359375),
    Vector(428.80508422852, -5371.8481445313, 7793.9770507813),
    Vector(292.47174072266, -5372.2255859375, 7793.7563476563),
    Vector(299.6686706543, -5529.3012695313, 7798.9560546875),
    Vector(485.31353759766, -5661.78125, 7827.392578125),
    Vector(-708.55963134766, -8060.4638671875, 8208.3779296875),
    Vector(-2857.8637695313, -7018.3857421875, 8205.791015625),
    Vector(-2479.4436035156, -5276.1630859375, 8346.9228515625),
    Vector(-2366.173828125, -4971.0927734375, 8466.791015625),
    Vector(-1703.1075439453, -4244.1235351563, 8307.447265625),
    Vector(590.38507080078, -4247.1025390625, 8206.58984375),
    Vector(7211.6987304688, -543.92407226563, 8229.6875),
    Vector(7351.091796875, -327.99658203125, 8277.0498046875),
    Vector(7192.5356445313, -159.06304931641, 8285.9033203125),
    Vector(10698.163085938, 674.87670898438, 8215.931640625),
    Vector(10867.790039063, 570.11785888672, 8241.1806640625),
    Vector(9366.8486328125, -2040.1151123047, 8199.595703125),
    Vector(9202.7119140625, -2041.7202148438, 8199.67578125),
    Vector(8933.2021484375, -2163.5297851563, 8227.154296875)
}

impulse.Config.CitizenSpawnLocations = {
    Vector(-4550.4345703125, 3001.5100097656, 464.03125),
    Vector(-4554.3774414063, 2907.6274414063, 464.03125),
    Vector(-4557.6376953125, 2781.2258300781, 464.03125),
    Vector(-4434.1723632813, 2775.5244140625, 464.03125),
    Vector(-4426.154296875, 2876.9916992188, 464.03125),
    Vector(-4423.701171875, 2972.1066894531, 464.03125),
    Vector(-4282.37890625, 2970.8627929688, 464.03125),
    Vector(-4284.0571289063, 2896.9147949219, 464.03125),
    Vector(-4287.0610351563, 2780.4294433594, 464.03125),
    Vector(-4170.0747070313, 2774.9702148438, 464.03125),
    Vector(-4165.5502929688, 2877.4226074219, 464.03128051758),
    Vector(-4162.7202148438, 2987.16015625, 464.03125),
    Vector(-4043.0795898438, 2984.7036132813, 464.03125),
    Vector(-4041.5715332031, 2876.0153808594, 464.03125),
    Vector(-4044.3347167969, 2768.685546875, 464.03125),
    Vector(-3913.3342285156, 2767.603515625, 464.03125),
    Vector(-3902.5734863281, 2872.2448730469, 464.03121948242),
    Vector(-3899.7250976563, 2982.8835449219, 464.03125),
    Vector(-3778.9287109375, 2982.1525878906, 464.03125),
    Vector(-3778.7692871094, 2864.3723144531, 464.03125),
    Vector(-3781.2971191406, 2766.1860351563, 464.03125),
    Vector(-3652.4790039063, 2760.8930664063, 464.03125),
    Vector(-3639.3283691406, 2869.640625, 464.03125),
    Vector(-3637.4072265625, 2933.3850097656, 464.03125),
    Vector(-3524.3090820313, 2919.3198242188, 464.03125),
    Vector(-3526.6450195313, 2828.5979003906, 464.03125),
    Vector(-3528.5776367188, 2752.8425292969, 464.03125),
    Vector(-3437.4191894531, 2750.4956054688, 464.03125),
    Vector(-3432.0856933594, 2849.73046875, 464.03125),
    Vector(-3264.0473632813, 2984.0625, 464.03125),
    Vector(-3266.5866699219, 2885.4248046875, 464.03125),
    Vector(-3269.4423828125, 2774.5102539063, 464.03125),
    Vector(-3185.6613769531, 2784.0375976563, 464.03125),
    Vector(-3141.6435546875, 2874.640625, 464.03125),
    Vector(-3139.2329101563, 2968.220703125, 464.03125),
    Vector(-2998.8815917969, 2972.9440917969, 464.03125),
    Vector(-2997.9833984375, 2866.9575195313, 464.03125),
    Vector(-3000.7189941406, 2763.267578125, 464.03121948242),
    Vector(-2885.3190917969, 2755.0549316406, 464.03125),
    Vector(-2879.1293945313, 2863.6552734375, 464.03125),
    Vector(-2876.4851074219, 2966.3522949219, 464.03125),
    Vector(-2768.302734375, 2965.0454101563, 464.03125),
    Vector(-2770.4814453125, 2849.8833007813, 464.03125),
    Vector(-2772.2255859375, 2782.1428222656, 464.03125),
    Vector(-2628.8110351563, 2778.4582519531, 464.03125),
    Vector(-2620.2634277344, 2885.2133789063, 464.03125),
    Vector(-2617.701171875, 2984.7214355469, 464.03125),
    Vector(-2447.0112304688, 2981.3549804688, 464.03125),
    Vector(-2449.1784667969, 2865.7468261719, 464.03125),
    Vector(-2450.5720214844, 2738.9108886719, 464.03125),
    Vector(-2318.4450683594, 2758.7717285156, 464.03128051758),
    Vector(-2314.9392089844, 2880.7036132813, 464.03125),
    Vector(-2312.3405761719, 2981.6345214844, 464.03125),
    Vector(-2179.724609375, 2978.2153320313, 464.03125),
    Vector(-2181.8618164063, 2861.6147460938, 464.03125),
    Vector(-2184.2763671875, 2767.8154296875, 464.03125),
    Vector(-2098.7087402344, 2765.375, 464.03125),
    Vector(-2092.2458496094, 2885.5427246094, 464.03125),
}


impulse.Config.Zones = {
	{name = "Transit Block 1", pos1 = Vector(-1430.1629638672, 3852.6853027344, 1396.4609375), pos2 = Vector(-4958.4423828125, 2319.4990234375, 285.93347167969), dispatch = {
		"npc/overwatch/radiovoice/transitblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},

	--Politi-Control Section
	{name = "Politi-Control Section 1", pos1 = Vector(722.43969726563, 4724.8642578125, 1383.71484375), pos2 = Vector(2430.4912109375, 3073.2673339844, 120.54026031494), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Politi-Control Section 2", pos1 = Vector(720.03912353516, 3766.9677734375, 770.2958984375), pos2 = Vector(-400.27896118164, 3159.4372558594, 102.44743347168), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Politi-Control Section 3", pos1 = Vector(-495.06716918945, 2393.5327148438, 78.705032348633), pos2 = Vector(-1206.76171875, 3862.1860351563, 1430.8989257813), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Politi-Control Section 4", pos1 = Vector(2170.2209472656, 3049.2565917969, 391.8610534668), pos2 = Vector(1787.9787597656, 2377.9262695313, 103.69382476807), dispatch = {
		"npc/overwatch/radiovoice/controlsection.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},


	--Residential Block
	{name = "Residential Block 1", pos1 = Vector(-354.58343505859, 4672.5639648438, 1135.3695068359), pos2 = Vector(552.44476318359, 3922.341796875, 109.15989685059), dispatch = {
		"npc/overwatch/radiovoice/residentialblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Residential Block 2", pos1 = Vector(3902.0622558594, 2556.3735351563, 1215.9638671875), pos2 = Vector(3610.7233886719, 1742.609375, 3.6063334941864), dispatch = {
		"npc/overwatch/radiovoice/deservicedarea.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},

	--Production Block
	{name = "Production Block 1", pos1 = Vector(3964.3664550781, 5645.154296875, 967.75732421875), pos2 = Vector(3461.2404785156, 4096.537109375, 294.43478393555), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Production Block 2", pos1 = Vector(3586.7553710938, 1149.9997558594, 1179.0739746094), pos2 = Vector(3064.1667480469, 2566.6694335938, 135.55764770508), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Production Block 3", pos1 = Vector(-1005.2476806641, 2365.6574707031, 707.35083007813), pos2 = Vector(2944.7836914063, 1985.60546875, 131.60545349121), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Production Block 4", pos1 = Vector(-969.46356201172, 898.09436035156, 552.98431396484), pos2 = Vector(746.61004638672, 1861.2332763672, -479.36846923828), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Production Block 4", pos1 = Vector(72.936424255371, 3094.3312988281, 102.06623077393), pos2 = Vector(-486.07901000977, 2550.1560058594, 467.6842956543), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Production Block 5", pos1 = Vector(3972.4770507813, 4726.8598632813, 908.97686767578), pos2 = Vector(5775.0522460938, 4481.4462890625, 272.92810058594), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},
	{name = "Production Block 5", pos1 = Vector(3386.8393554688, 5142.6025390625, 998.31317138672), pos2 = Vector(2761.6416015625, 6005.9067382813, 255.42822265625), dispatch = {
		"npc/overwatch/radiovoice/productionblock.wav",
		"npc/overwatch/radiovoice/five.wav"
	}},

	--Distributions Block	
	{name = "Distributions Block 1", pos1 = Vector(790.70037841797, 1899.3322753906, 310.92437744141), pos2 = Vector(1640.4722900391, 481.14428710938, 35.838199615479), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},	
	{name = "Distributions Block 2", pos1 = Vector(2042.4051513672, 5128.0571289063, 1184.6356201172), pos2 = Vector(3427.3110351563, 4871.5439453125, 290.74411010742), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Distributions Block 3", pos1 = Vector(2502.1926269531, 4786.0283203125, 629.04852294922), pos2 = Vector(3388.9965820313, 4308.9208984375, 292.66928100586), dispatch = {
		"npc/overwatch/radiovoice/distributionblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},

	-- Shell Beach
	{name = "External Jurisdiction 1", pos1 = Vector(-3570.6948242188, 8023.0341796875, 2758.775390625), pos2 = Vector(16129.291015625, 16128.91015625, -656.92224121094), dispatch = {
		"npc/overwatch/radiovoice/externaljurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Outlands Tunnel", pos1 = Vector(3848.3168945313, 5651.4560546875, 498.14172363281), pos2 = Vector(3582.0480957031, 7901.4018554688, 292.72424316406), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/nine.wav"
	}},
	
	--Repurposed Area, 1 is bar and 2 is theater
	{name = "Repurposed Area 1", pos1 = Vector(5120.1020507813, 4774.0395507813, 669.40881347656), pos2 = Vector(6424.37109375, 5520.15234375, 260.62817382813), dispatch = {
		"npc/overwatch/radiovoice/repurposedarea.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Repurposed Area 6", pos1 = Vector(3042.0732421875, 1846.4735107422, 84.627540588379), pos2 = Vector(2185.6701660156, 552.33581542969, 561.56567382813), dispatch = {
		"npc/overwatch/radiovoice/repurposedarea.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},


	--Nexus
	{name = "High Priority Region 1", pos1 = Vector(2494.0302734375, 4295.9614257813, 1056.0299072266), pos2 = Vector(3069.5178222656, 2586.4875488281, 38.227142333984), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "High Priority Region 2", pos1 = Vector(697.07946777344, 4507.560546875, -675.19787597656), pos2 = Vector(3171.7204589844, 1780.3907470703, -366.50933837891), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	
	{name = "High Priority Region 3", pos1 = Vector(2545.8649902344, 2583.7351074219, 1476.9350585938), pos2 = Vector(3106.1884765625, 4088.427734375, 5257.8002929688), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "High Priority Region 4", pos1 = Vector(1705.3116455078, 6458.8603515625, 303.36569213867), pos2 = Vector(1300.3034667969, 4757.7431640625, 176.52156066895), dispatch = {
		"npc/overwatch/radiovoice/highpriorityregion.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},

	--Restricted Block
	{name = "Restricted Block 1", pos1 = Vector(5014.912109375, 4147.701171875, 517.17614746094), pos2 = Vector(4226.6259765625, 3597.2658691406, 225.07489013672), dispatch = {
		"npc/overwatch/radiovoice/deservicedarea.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	
	{name = "Restricted Block 2", pos1 = Vector(4276.1806640625, 1440.9912109375, 179.46832275391), pos2 = Vector(6644.6567382813, 3190.8598632813, 1869.3879394531), dispatch = {
		"npc/overwatch/radiovoice/deservicedarea.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},

	--Storm System
	{name = "Storm System 1", pos1 = Vector(6969.4638671875, 639.02795410156, 79.737464904785), pos2 = Vector(3448.8718261719, 4842.5927734375, -135.47499084473), dispatch = {
		"npc/overwatch/radiovoice/stormsystem.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Storm System 2", pos1 = Vector(3751.1030273438, 1661.2915039063, -251.18135070801), pos2 = Vector(7332.9799804688, -411.33575439453, 27.127868652344), dispatch = {
		"npc/overwatch/radiovoice/stormsystem.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Storm System 3", pos1 = Vector(1761.7663574219, -1838.5847167969, 554.47509765625), pos2 = Vector(3470.4421386719, 531.71875, -180.70111083984), dispatch = {
		"npc/overwatch/radiovoice/stormsystem.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},

	-- Outlands
	{name = "Stabilization Jurisdiction 1", pos1 = Vector(-10410.905273438, 11.682598114014, 8737.279296875), pos2 = Vector(-11953.028320313, -2149.7631835938, 8139.68359375), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Stabilization Jurisdiction 2", pos1 = Vector(-1257.9465332031, 3708.4028320313, 281.94729614258), pos2 = Vector(-1820.3475341797, 3454.1655273438, 108.08744049072), dispatch = {
		"npc/overwatch/radiovoice/stabilizationjurisdiction.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Outland Zone 1", pos1 = Vector(-10331.71484375, -2221.4020996094, 8697.8671875), pos2 = Vector(-5136.0249023438, 2430.2751464844, 8169.6401367188), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Outland Zone 1", pos1 = Vector(-11950.150390625, 19.293464660645, 8740.1025390625), pos2 = Vector(-10338.13671875, 2438.3837890625, 8197.708984375), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Outland Zone 2", pos1 = Vector(-3287.2895507813, 3085.9448242188, 9320.93359375), pos2 = Vector(3535.5637207031, -2260.1206054688, 8171.9750976563), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Outland Zone 3", pos1 = Vector(4998.2778320313, 3001.6960449219, 9549.560546875), pos2 = Vector(11254.059570313, -2271.5852050781, 8117.6000976563), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Outland Zone 4", pos1 = Vector(3523.1423339844, -3715.4138183594, 9774.1259765625), pos2 = Vector(-3082.9396972656, -8159.4096679688, 8150.1997070313), dispatch = {
		"npc/overwatch/radiovoice/outlandzone.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
	{name = "Canal Block 1", pos1 = Vector(-12035.891601563, 1788.7338867188, 8144.4013671875), pos2 = Vector(-3419.7521972656, 1027.1517333984, 7938.38671875), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/one.wav"
	}},
	{name = "Canal Block 2", pos1 = Vector(-3389.7326660156, -1456.7364501953, 8135.1186523438), pos2 = Vector(3385.2822265625, 1738.3218994141, 7913.9580078125), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/two.wav"
	}},
	{name = "Canal Block 3", pos1 = Vector(3543.2338867188, 2828.2897949219, 8087.3295898438), pos2 = Vector(13402.875976563, -2095.5720214844, 7100.8916015625), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/three.wav"
	}},
	{name = "Canal Block 4", pos1 = Vector(3073.1772460938, -4039.6303710938, 8115.7504882813), pos2 = Vector(-2889.1196289063, -8171.357421875, 7742.9697265625), dispatch = {
		"npc/overwatch/radiovoice/canalblock.wav",
		"npc/overwatch/radiovoice/four.wav"
	}},
}

impulse.Config.BulkCrateSpawn = Vector(-279.53720092773, 3037.5583496094, 136.03125)

impulse.Config.ScannerSpawnPos = Vector(2800.5541992188, 2820.4968261719, 656.65924072266)

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
	{pos = Vector(4199.96875, 1758.4018554688, -135.96817016602), ang = Angle(17.125595092773, 178.60559082031, 0)},
	{pos = Vector(2648.0607910156, -236.86372375488, -167.96875), ang = Angle(2.4075756072998, -12.470540046692, 0)},
	{pos = Vector(2291.4392089844, -1522.7099609375, -167.96875), ang = Angle(7.4895973205566, 86.432998657227, 0)},
	{pos = Vector(12087.018554688, 1297.1854248047, 6924.03125), ang = Angle(38.905864715576, 46.142684936523, 0)},
	{pos = Vector(1551.2738037109, 11363.068359375, 320.03125), ang = Angle(13.033759117126, -65.168891906738, 0)},
}

impulse.Config.FishermanPos = Vector(-160.00315856934, 13528.423828125, 314.41363525391)
impulse.Config.FishermanAng = Angle(0, 0, 0)


impulse.Config.PrisonAngle = Angle(1.8799510002136, -177.92010498047, 0)
impulse.Config.PrisonCells = {
    Vector(2969.314453125, 3730.1843261719, 52.03125),
	Vector(3175.0009765625, 3581.2702636719, 52.03125),
	Vector(3193.1875, 3498.583984375, 52.03125),
	Vector(3079.7795410156, 3352.03125, 89.428901672363)
}

--impulse.Config.JWButtonPos = Vector(3181.96875, 4005, 3449)
--0impulse.Config.JWOffButtonPos = Vector(3182, 3991, 3449)
--impulse.Config.AJButtonPos = Vector(6881.28125, 1899, -349.46875)
--impulse.Config.AJOffButtonPos = Vector(6881.28125, 1869, -349.46875)

impulse.Config.Buttons = {
	{
		desc = "Turn on Autonomous Judgement",
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)

			return false
		end
	},
	{
		desc = "Turn off Autonomous Judgement",
		pos = impulse.Config.JWOffButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Close Sewer Gate",
		pos = Vector(4472, 7954, 362),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Open Hardpoint Gate",
		pos = Vector(-11343.5, -36, 8312),
		customCheck = function(ply)
			return true
		end
	},
	{
		desc = "Open Outlands Gate",
		pos = Vector(3131.5, 4062.96875, 3450),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Toggle Propaganda Broadcasts",
		pos = Vector(5375.5, -1632, -4726),
		customCheck = function(ply)
			return ply:IsDeveloper()
		end
	},
	{
		pos = Vector(5375.5, -2896, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(5375.5, -2928, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(5312, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(5184, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(5056, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Toggle Nexus Lockdown",
		pos = Vector(4928, -3103.5, -4726),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		pos = Vector(4800, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(4672, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(4544, -3103.5, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(4480.5, -2912, -4726),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Toggle Broadcast Camera",
		pos = Vector(2742, 4030, 3448),
		customCheck = function(ply)
			return (ply:Team() == TEAM_CA)
		end
	},
	{
		desc = "Open Rations",
		pos = Vector(2809, 4249, 430),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Close Rations",
		pos = Vector(2827, 4249, 430),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Workers announcement",
		pos = Vector(-580, 1184, 176),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Workers announcement",
		pos = Vector(-660, 1184, 176),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Open Shell Beach Gate",
		pos = Vector(3180.96875, 3875, 3447),
		doorgroup = 1
	},
	{
		desc = "Workers announcement",
		pos = Vector(4980, 4062, 418),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		pos = Vector(3170, 804, 130.96875),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(3170, 795, 130.96875),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(3170, 776, 130.96875),
		customCheck = function(ply)
			return false
		end
	},
	{
		pos = Vector(3960, 1730, -82),
		doorgroup = 6
	}
	
	
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

	for v,k in pairs(ents.FindByClass("npc_turret_ceiling")) do
		if k:MapCreationID() != -1 then
			k:Remove()
		end
	end

	local autoLockDoors = {
		1882, 
		2063,
		2307,
		4032,
		4794,
		2739,
		2935,
		2936,
		2937,
		2128,
		2218,
		5213,
		5219,
		2366,
		9356,
		2193,

	}
	for v,k in pairs(autoLockDoors) do
		local door = ents.GetMapCreatedEntity(k)

		if not IsValid(door) or not door:IsDoor() then
			continue
		end
		
		door:Fire("unlock")
		door:Fire("close")

		timer.Simple(2, function()
			if IsValid(door) then
				door:Fire("lock")
			end
		end)
	end

	local removeOnStart = {
        2184,
        9245,
        7061,
        9336,
        9337,
        5481,

    }

    for _, id in pairs(removeOnStart) do
        local ent = ents.GetMapCreatedEntity(id)
        if IsValid(ent) then ent:Remove() end
    end
end

impulse.Config.CPSpawnLocations = {
    Nexus = {
        Vector(2122.5451660156, 2701.2983398438, -543.96875),
		Vector(3184.7907714844, 3268.984375, 392.03125),
		Vector(1568.03125, 2479.96875, -607.96875),
		Vector(3383.5893554688, 4014.484375, 392.02871704102),
		Vector(2640.03125, 3999.9677734375, 256.03143310547),
		Vector(1927.96875, 2101.0012207031, -607.96875),
		Vector(2883.9177246094, 3872.1481933594, 392.03125),
		Vector(2031.96875, 3408.03125, -543.96875),
		Vector(2823.96875, 2902.2351074219, 256.03125),
    },
    FOB = {
        Vector(4013.4516601563, 4152.314453125, 376.03125),
        Vector(4016.8278808594, 4455.96875, 376.03125),
        Vector(4148.8969726563, 4319.8671875, 376.03125),
    },
    OZ = {
        Vector(-11246.87890625, -1110.0057373047, 8192.03125),
		Vector(-11125.334960938, -1121.0834960938, 8192.03125),
		Vector(-10965.041992188, -1135.6927490234, 8192.03125),
		Vector(-10822.734375, -1148.6629638672, 8192.03125),
		Vector(-10686.622070313, -1319.96875, 8192.03125),
		Vector(-10851.657226563, -1319.96875, 8192.03125),
		Vector(-11008.330078125, -1313.8959960938, 8192.03125),
		Vector(-11167.107421875, -1307.7413330078, 8192.03125),
		Vector(-11262.248046875, -1304.0538330078, 8192.03125),
		Vector(-10682.099609375, -1053.5335693359, 8320.03125),
		Vector(-10947.384765625, -1247.8615722656, 8320.03125),
		Vector(-11231.092773438, -1224.9061279297, 8320.03125),
		Vector(-11234.98828125, -1049.7443847656, 8320.03125),
    },
}

impulse.Config.OTASpawnLocations = {
    Nexus = {
        Vector(2703.37890625, 3451.8056640625, 1408.8146972656),
		Vector(3088.326171875, 4025.53515625, 528.03125),
		Vector(3274.0573730469, 3992.5393066406, 528.03125),
		Vector(2588.1059570313, 3526.0925292969, 828.03125),
		Vector(2797.3200683594, 4752.9619140625, 832.03125),
		Vector(3196.9196777344, 4191.6303710938, 832.52545166016),
		Vector(2895.1396484375, 2648.5419921875, 1408.03125),
		Vector(2667.2150878906, 2709.2526855469, 1408.03125),
    },
    OZ = {
        Vector(-11246.87890625, -1110.0057373047, 8192.03125),
		Vector(-11125.334960938, -1121.0834960938, 8192.03125),
		Vector(-10965.041992188, -1135.6927490234, 8192.03125),
		Vector(-10822.734375, -1148.6629638672, 8192.03125),
		Vector(-10686.622070313, -1319.96875, 8192.03125),
		Vector(-10851.657226563, -1319.96875, 8192.03125),
		Vector(-11008.330078125, -1313.8959960938, 8192.03125),
		Vector(-11167.107421875, -1307.7413330078, 8192.03125),
		Vector(-11262.248046875, -1304.0538330078, 8192.03125),
		Vector(-10682.099609375, -1053.5335693359, 8320.03125),
		Vector(-10947.384765625, -1247.8615722656, 8320.03125),
		Vector(-11231.092773438, -1224.9061279297, 8320.03125),
		Vector(-11234.98828125, -1049.7443847656, 8320.03125),
    },
}

impulse.Config.CASpawnLocations = {Vector(2597.3569335938, 2651.3076171875, 528.03125),
Vector(2564.5866699219, 4079.96875, 528.03125),
Vector(3327.1540527344, 3788.7448730469, 400.03125),
Vector(2582.8791503906, 3486.5576171875, 832.03125),
Vector(3265.9543457031, 4049.3796386719, 1408.03125),
Vector(3174.3178710938, 3229.7731933594, 528.03125),
Vector(3103.6762695313, 2917.7551269531, 392.03125),
Vector(3121.6674804688, 3431.6276855469, 592.03240966797)
}

impulse.Config.ZombieSpawnLocations = {Vector(12172.78515625, 1860.1761474609, 6807.8608398438),
Vector(16.03125, -3475.5927734375, 7968.03125),
Vector(-2660.6437988281, -231.75721740723, 7976.03125),
Vector(-8071.1547851563, 218.77635192871, 8008.03125),
Vector(-7635.5302734375, -4076.9196777344, 7936.03125),
Vector(-5162.5639648438, -7051.79296875, 7936.03125),
Vector(-2366.9296875, -7743.8134765625, 8267.3505859375),
Vector(8668.4033203125, -1833.6085205078, 8064.03125)
}

impulse.Config.StalkerSpawnLocations = {Vector(3028.3254394531, 3731.0737304688, -303.96875),
Vector(2527.6389160156, 4432.1484375, -303.96875),
Vector(3103.8054199219, 4575.0546875, -303.96875),
Vector(3065.1179199219, 4532.9594726563, 1408.03125),
}

impulse.Config.CrematorSpawnLocations = {
	Vector(2625.3688964844, 2592.03125, 128.03125),
	Vector(2698.4118652344, 3055.96875, 64.03125)
}

local gates = {
	["SHELL BEACH GATE"] = {
		near = Vector(3776, 5654, 400),
		doorName = "outerbulkhead"
	},
	["OUTLANDS GATE"] = {
		near = Vector(-1246.000000, 3520.010010, 220.000000),
		doorName = "canaldoor"
	},
	["GARAGE"] = {
		near = Vector(1448.000000, 4115.000000, 288.000000),
		doorName = "nexus_garagedoor1"
	},
}

local cooldowns = {}
local howCloseYouNeedToBe = 300^2
local doorCloseEnough = 512^2

local function distToSqr2D(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	return dx*dx + dy*dy
end

impulse.RegisterChatCommand("/combinegate", {
	description = "Opens the closest Combine Bulkhead. (Combine only)",
	requiesAlive = true,
	onRun = function(ply)
		if not ((ply:Team() == TEAM_OTA) or (ply:Team() == TEAM_CP and ply:GetTeamRank() >= RANK_OFC)) then
			ply:Notify("You must be a member of the OTA or CP RL+ to use this.")
			return
		end

		local gateName, gateData
		local bestDist = math.huge
		local plyPos = ply:GetPos()

		for name, data in pairs(gates) do
			local dist = distToSqr2D(data.near, plyPos) -- 2D selection
			if dist < howCloseYouNeedToBe and dist < bestDist then
				bestDist = dist
				gateName = name
				gateData = data
			end
		end

		if not gateData then
			ply:Notify("You aren't near a large Combine door.")
			return
		end

		local cooldown = cooldowns[gateName] or 0
		if CurTime() < cooldown then
			ply:Notify(("This gate can open in %i seconds."):format(math.floor(cooldown - CurTime())))
			return
		end

		local opened = {}

		if gateData.doorName then
			for _, door in ipairs(ents.FindByClass("func_door")) do
				if door:GetName() == gateData.doorName then
					door:Fire("unlock", "", 0.6)
					door:Fire("open", "", 0.6)
					opened[#opened + 1] = door
				end
			end
			for _, door in ipairs(ents.FindByClass("func_door_rotating")) do
				if door:GetName() == gateData.doorName then
					door:Fire("open", "", 0.6)
					opened[#opened + 1] = door
				end
			end
		end

		if #opened == 0 then
			ply:Notify("Couldn't find any doors for that gate.")
			return
		end

		local time = (gateName == "STORMSYSTEM GATE") and 40 or 20

		timer.Simple(time, function()
			for _, door in ipairs(opened) do
				if IsValid(door) then door:Fire("close", "", 0.6) end
			end
		end)

		cooldowns[gateName] = CurTime() + time + 10
		ply:Notify("You have opened the gate.")
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
	end
})

local outlandsgateCommand = {
    description = "Opens the Outlands Gate. (Combine only)",
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:Team() != TEAM_OTA and ply:Team() != TEAM_CP then
            ply:Notify("You must be a member of the OTA or CP i1+ to use this.")
            return
        elseif ply:Team() == TEAM_CP and ply:GetTeamRank() <= RANK_I1 then
            ply:Notify("You must be a member of the OTA or CP i1+ to use this.")
            return
        end
        if (ply:GetPos() - Vector(-1144.7131347656, 3583.7971191406, 128.03125)):LengthSqr() > (800 ^ 2) then
            ply:Notify("You are not near the outlands gate.")
            return
        end
        if timer.Exists("ozgatecooldown") then
            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
            return
        end

        local door1 = ents.GetMapCreatedEntity(6120)
        local door2 = ents.GetMapCreatedEntity(6119)

        if not IsValid(door1) and not IsValid(door2) then
            ply:Notify("Could not find the outlands gate doors.")
            return
        end

        if IsValid(door1) then
		    door1:Fire("Unlock", "", 0)
		    door1:Fire("Open", "", 0.2)
		end
		if IsValid(door2) then
		    door2:Fire("Unlock", "", 0)
		    door2:Fire("Open", "", 0.2)
		end

        timer.Simple(20, function()
		    if IsValid(door1) then
		        door1:Fire("Close", "", 0)
		        door1:Fire("Lock", "", 0.3)
		    end
		    if IsValid(door2) then
		        door2:Fire("Close", "", 0)
		        door2:Fire("Lock", "", 0.3)
		    end
		end)
        for _, v in pairs(player.GetAll()) do
            if v:IsCP() then
                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE OUTLANDS GATE.", Color(0, 100, 0))
            end
        end

        timer.Simple(20, function()
            for _, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("THE OUTLANDS GATE HAS CLOSED.", Color(0, 100, 0))
                end
            end
        end)

        timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
        ply:Notify("You have opened the outlands gate.")
    end
}
impulse.RegisterChatCommand("/ozg", outlandsgateCommand)

local shellbeachCommand = {
    description = "Opens the Shell Beach Gate. (Combine only)",
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:Team() != TEAM_OTA and ply:Team() != TEAM_CP then
            ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
            return
        elseif ply:Team() == TEAM_CP and ply:GetTeamRank() <= RANK_OFC then
            ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
            return
        end
        if (ply:GetPos() - Vector(3715.5456542969, 5655.2045898438, 320.03125)):LengthSqr() > (800 ^ 2) then
            ply:Notify("You are not near the beach gate.")
            return
        end
        if timer.Exists("ozgatecooldown") then
            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("ozgatecooldown")) .. " seconds before using this command.")
            return
        end

        local door1 = ents.GetMapCreatedEntity(5339)
        local door2 = ents.GetMapCreatedEntity(5338)

        if not IsValid(door1) and not IsValid(door2) then
            ply:Notify("Could not find the beach gate doors.")
            return
        end

        if IsValid(door1) then door1:Fire("Open") end
        if IsValid(door2) then door2:Fire("Open") end

        timer.Simple(20, function()
            if IsValid(door1) then door1:Fire("Close") end
            if IsValid(door2) then door2:Fire("Close") end
        end)

        for _, v in pairs(player.GetAll()) do
            if v:IsCP() then
                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE EJ-1 GATE.", Color(0, 100, 0))
            end
        end

        timer.Simple(20, function()
            for _, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("THE EJ-1 GATE HAS CLOSED.", Color(0, 100, 0))
                end
            end
        end)

        timer.Create("ozgatecooldown", 30, 1, function() timer.Remove("ozgatecooldown") end)
        ply:Notify("You have opened the beach gate.")
    end
}
impulse.RegisterChatCommand("/beachgate", shellbeachCommand)

local apcgarageCommand = {
    description = "Opens the APC Garage door. (Combine only)",
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:Team() != TEAM_OTA and ply:Team() != TEAM_CP then
            ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
            return
        elseif ply:Team() == TEAM_CP and ply:GetTeamRank() <= RANK_OFC then
            ply:Notify("You must be a member of the OTA or CP Supervisor to use this.")
            return
        end
        if (ply:GetPos() - Vector(1538.256714, 3756.728760, 192.031250)):LengthSqr() > (800 ^ 2) then
            ply:Notify("You are not near the APC Garage.")
            return
        end
        if timer.Exists("apcgatecooldown") then
            ply:Notify("You must wait " .. math.floor(timer.TimeLeft("apcgatecooldown")) .. " seconds before using this command.")
            return
        end

        local door = ents.GetMapCreatedEntity(3145)
        if not IsValid(door) then
            ply:Notify("Could not find the APC Garage door.")
            return
        end

        door:Fire("Open")
        timer.Simple(20, function()
            if IsValid(door) then
                door:Fire("Close")
            end
        end)

        for _, v in pairs(player.GetAll()) do
            if v:IsCP() then
                v:SendCombineMessage(ply:Name() .. " HAS OPENED THE APC GARAGE.", Color(0, 100, 0))
            end
        end

        timer.Simple(20, function()
            for _, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("THE APC GARAGE DOOR HAS CLOSED.", Color(0, 100, 0))
                end
            end
        end)

        timer.Create("apcgatecooldown", 30, 1, function() timer.Remove("apcgatecooldown") end)
        ply:Notify("You have opened the APC Garage.")
    end
}
impulse.RegisterChatCommand("/apcgarage", apcgarageCommand)




--[[
if SERVER then

end
]]--