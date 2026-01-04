impulse.Config.MapWorkshopID = "2798566826"

impulse.Config.MenuCamPos = Vector(-1635.5034179688, 4621.431640625, -205.96875)
impulse.Config.MenuCamAng = Angle(0.52789759635925, 179.77165222168, 0)

impulse.Config.BroadcastPos = Vector(1127.15625, 147.5, -135.09375)

impulse.Config.SpawnPos1 = Vector(13320.12109375, 4846.4643554688, -474.96875)
impulse.Config.SpawnPos2 = Vector(13309.483398438, 4402.20703125, -474.96875)

impulse.Config.BroadcastDistance = 600

impulse.Config.BlacklistEnts = {
	["game_text"] = true,
	["lua_run"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true,
	["trigger_weapon_strip"] = true,
	["npc_turret_ceiling"] = true
}

impulse.Config.OTASpawnLocations = {
Vector(-714.080261, 436.637604, -12166.115234),
}

impulse.Config.CPSpawnLocations = {
	Vector(-460.401978, 538.434082, -12223.968750),
}

impulse.Config.Zones = {
	{name = "Reality", pos1 = Vector(-834.66735839844, -4540.7431640625, 5248.224609375), pos2 = Vector(5956.25390625, 234.69934082031, 4097.60546875)},
	{name = "Level 0", pos1 = Vector(-7538.76171875, 3373.3149414063, 4964.8251953125), pos2 = Vector(-3237.568359375, -2348.8940429688, 4360.484375)},
	{name = "Level 188", pos1 = Vector(-782.29547119141, -2850.494140625, 2105.6618652344), pos2 = Vector(2656.4270019531, 9.4547119140625, 980.47546386719)},
	{name = "Red Room", pos1 = Vector(-1477.8345947266, 3395.1772460938, -2662.8200683594), pos2 = Vector(2610.8159179688, 5459.7861328125, -3146.3251953125)},
	{name = "Toxic Forest", pos1 = Vector(-2181.3950195313, -4011.9714355469, -1759.5257568359), pos2 = Vector(-11891.606445313, 9107.5830078125, -2745.8166503906)},
	{name = "Level 7", pos1 = Vector(-8899.0029296875, 738.69848632813, 8045.3564453125), pos2 = Vector(7551.53515625, 14129.553710938, 6342.4794921875)},
	{name = "Level 9", pos1 = Vector(-120.09670257568, -6189.8237304688, 4959.5927734375), pos2 = Vector(-10116.142578125, -11073.065429688, 3865.6437988281)},
	{name = "Parking Garage", pos1 = Vector(-3280.5932617188, -10115.463867188, 1537.3544921875), pos2 = Vector(-234.07328796387, -4689.3881835938, 787.33282470703)},
	{name = "Level 37", pos1 = Vector(-3507.857421875, 5238.8120117188, 1665.7683105469), pos2 = Vector(6855.2529296875, 947.02642822266, 1048.3918457031)},
	{name = "The Hub", pos1 = Vector(467.51019287109, 7239.3872070313, 878.50329589844), pos2 = Vector(1598.2022705078, 12516.017578125, 296.08605957031)},
	{name = "The End", pos1 = Vector(1321.4069824219, 1449.8435058594, -4191.4624023438), pos2 = Vector(-2912.5363769531, -937.09783935547, -4956.3525390625)},
	{name = "Level 0-A", pos1 = Vector(2852.5756835938, -5902.568359375, -459.81518554688), pos2 = Vector(-280.61032104492, -7901.9301757813, -961.79150390625)},
	{name = "Level 403", pos1 = Vector(10072.549804688, -5411.5322265625, -3119.6696777344), pos2 = Vector(2660.5439453125, 1604.8923339844, -3831.41015625)},
	{name = "Level 587", pos1 = Vector(-1168.9085693359, 1965.0294189453, 3221.1059570313), pos2 = Vector(2797.5715332031, -1369.3751220703, 2559.0808105469)}
}

impulse.Config.IntroScenes = {
	
	{
	    pos = Vector(-135.80726623535, -627.07495117188, 5139.3081054688),
		endpos = Vector(-131.66758728027, -2888.9777832031, 5139.3081054688),
		ang = Angle(20.921728134155, 0.10485827177763, 0),
		endang = Angle(20.921728134155, 0.10485827177763, 0),
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "It has been a long time since you've seen the real world.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(-5361.1655273438, 2464.6359863281, 4658.7983398438),
		endpos = Vector(-5372.3852539063, 1345.6765136719, 4651.037109375),
		ang = Angle(0.26379385590553, -90.117500305176, 0),
		endang = Angle(0.46179381012917, -90.447471618652, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "Days turn to weeks, weeks turn to months, months turn to years.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(-10613.484375, 306.46127319336, -1999.6162109375),
		endpos = Vector(-8870.294921875, -167.76223754883, -2102.5754394531),
		ang = Angle(4.1904516220093, -16.395360946655, 0),
		endang = Angle(3.1674518585205, -15.009350776672, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "The environment you've been stuck in has many dangers.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(1542.5106201172, 303.30947875977, 5968.59375),
		endpos = Vector(515.10772705078, 317.25146484375, 5979.6811523438),
		ang = Angle(-3.5320675373077, 178.41963195801, 0),
		endang = Angle(0.29593163728714, 179.54177856445, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "This realm is inhabited with various creatures and threats, including humans.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(-9528.439453125, -1365.4670410156, -3386.6271972656),
		endpos = Vector(-7570.4853515625, -1342.7611083984, -3378.0185546875),
		ang = Angle(1.9804983139038, 48.935741424561, 0),
		endang = Angle(9.3064966201782, 130.3794708252, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "Roam the various areas and find materials to defend yourself and build a shelter.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(2224.26953125, 61.829170227051, 2814.4340820313),
		endpos = Vector(867.16931152344, 69.205474853516, 2807.1506347656),
		ang = Angle(0.65948724746704, 179.7320098877, 0),
		endang = Angle(0.19748735427856, 179.86402893066, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "You can choose to work alone or work with others.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(-1022.8553466797, 4120.9013671875, -3008.4030761719),
		endpos = Vector(-95.009002685547, 4090.8376464844, -3029.4030761719),
		ang = Angle(1.3194522857666, -1.8638677597046, 0),
		endang = Angle(1.1874523162842, -1.7978677749634, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "Or even align yourself with the major factions of the Backrooms.",
	    static = true,
	    fadeIn = true,
	},
	{
		pos = Vector(-1180.1875, 678.34234619141, -4721.7568359375),
		endpos = Vector(-1180.1875, 678.34234619141, -4721.7568359375),
		ang = Angle(0.92340469360352, 57.571887969971, 0),
		endang = Angle(0.92340469360352, 57.505886077881, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "Fate is yours to determine.",
	    static = true,
	    fadeIn = true,
	},
	
	{
		pos = Vector(-3651.6623535156, 2831.5227050781, 7323.9248046875),
		endpos = Vector(-2449.2824707031, 4428.1298828125, 7255.5751953125),
		ang = Angle(2.8880996704102, 53.128009796143, 0),
		endang = Angle(1.3701000213623, 52.731998443604, 0),
		fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 8,
	    text = "Good luck traveler. Welcome to Deep Gaming Backrooms Roleplay.",
	    static = true,
	    fadeIn = true,
	},
}

impulse.Config.DealerLocations = {
	{pos = Vector(4347.0825195313, 1713.1811523438, 1248.03125), ang = Angle(10.494157791138, 88.860008239746, 0)},
	{pos = Vector(736.97052001953, 3571.0786132813, -3130.96875), ang = Angle(3.3660640716553, 42.461906433105, 0)},
	{pos = Vector(-9299.6455078125, 242.5751953125, -2531.96875), ang = Angle(16.632019042969, 129.31851196289, 0)},
	{pos = Vector(-1514.6397705078, -5908.6108398438, 885.03125), ang = Angle(7.1279172897339, 176.64033508301, 0)},
	{pos = Vector(-5018.7734375, -7458.7094726563, 3921.03125), ang = Angle(7.3259134292603, -67.397735595703, 0)},
}

impulse.Config.FishermanPos = Vector(103.80268859863, -7611.5708007813, -672.96875)	
impulse.Config.FishermanAng = Angle(7.7879638671875, 44.196029663086, 0)

impulse.Config.PrisonAngle = Angle(12.209716796875, -152.81684875488, 0)
impulse.Config.PrisonCells = {
	Vector(2054.0415039063, -5839.9370117188, -672.96875),
}

impulse.Config.ScannerSpawnPos = Vector(-37.103764, 71.900337, -12129.845703)

impulse.Config.Buttons = {
	{
		desc = "Level 1",
		pos = Vector(-7041.5, -558, -2132.5625),
		doorgroup = 5,
		customCheck = function(ply, button)
			if ply:HasInventoryItem("ditem_keycard1") or ply:HasInventoryItem("ditem_keycard2") or ply:HasInventoryItem("ditem_keycard3") or ply:HasInventoryItem("ditem_keycard4") or ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then 
				button:EmitSound("buttons/button14.wav")
				ply:Notify("The scanner reads: 'ACCESS GRANTED.'")
				return true 
			elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				button:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				ply:Notify("Override sequence initiated.")
				timer.Simple(5, function()
					ply:Notify("Override sequence completed.")
					button:EmitSound("buttons/button17.wav")
					return true
				end)
			else
				button:EmitSound("buttons/button8.wav")
				ply:Notify("You do not have the proper clearance to use this button.")
				return false
			end
		end
	},
	{
		desc = "Warehouse 3 Announcement",
		pos = Vector(-3207.90625, 6852, -40),
		doorgroup = 1
	},
}

impulse.Config.ApartmentBlocks = {

}

impulse.Config.LoadScript = function()
end

