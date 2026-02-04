-- Framework related
impulse.Config.SchemaName = "Half Life 2: Roleplay"
impulse.Config.SchemaVersion = 2.0
impulse.Config.SchemaCredits = [[Developed by
<font=Impulse-Elements23>vin
aLoneWitness
sophie
Bassilisk
2igames
Cooki3z
Sprite Cran
Justin
And the rest of the impulse team</font>


With the help of
<font=Impulse-Elements23>Astro
Rend
Jim Wakelin</font>

Powered by
<font=Impulse-Elements23>vin + sophie - Longsword2 weapon base</font>

Special thanks
<font=Impulse-Elements23>nutscript - great examples of HL2:RP systems
zepla - Enhanced Citizens v4
DPotatoman - Metropolice pack
Lokachop - Extensive debugging and exploit finding</font>
aindrigo - Longsword2 + Support
mage.tearz - Development Support
Thrawn - Development Support
zachun - Development Support
JRB - Deep Gaming Development
Abarden - Development and Web Services
Matters - Development
Maximus - Development
Synapse - Great examples of HL2:RP systems
bueberries - Level Design
Ragismier - Level Design
SteveB - Push Script

Deep Gaming
Abarden - Development of web and game systems.
Matters - Development
JRB - Directing the Deep Gaming Community for 8 Years
Zachun - Lead Developer on the Deep Gaming Project

Deep Gaming takes no credit for the development of the impulse framework.
All credit of this framework lies in the hands of vin and the 2iGames subsidiary.
Some modifications have been made by Deep Gaming]]


impulse.Config.MainColour = Color(3, 98, 252)
impulse.Config.InteractColour = Color(251, 197, 49)

impulse.Config.UserSlots = 90 -- any other slots will be donator slots

impulse.Config.SignalsUpdateTime = 2

impulse.Config.WalkSpeed = 100
impulse.Config.JogSpeed = 200
impulse.Config.SlowWalkRatio = 0.6

impulse.Config.ScannerSpawnPos = Vector(714.04583740234, 139.04724121094, 1216.03125)

impulse.Config.TalkDistance = 300
impulse.Config.WhisperDistance = 90
impulse.Config.YellDistance = 550
impulse.Config.VoiceDistance = 550

impulse.Config.OOCLimit = 40
impulse.Config.OOCLimitVIP = 300

impulse.Config.PropLimit = 90
impulse.Config.PropLimitDonator = 200

impulse.Config.BuyableSpawnLimit = 12
impulse.Config.DroppedItemsLimit = 30
impulse.Config.DroppedMoneyLimit = 10
impulse.Config.E2Limit = 25
impulse.Config.ChairsLimit = 3

impulse.Config.StartingMoney = 50
impulse.Config.StartingBankMoney = 1000
impulse.Config.CurrencyPrefix = "C"
impulse.Config.CurrencyName = "credits"
impulse.Config.ATMModel = "models/props_combine/combine_intwallunit.mdl"

impulse.Config.XPTime = 600
impulse.Config.XPGet = 5 -- double xp (normal: 5)
impulse.Config.XPGetVIP = 10 -- double xp (normal: 10)

impulse.Config.RationTime = 3600

impulse.Config.AFKTime = 600 -- 10 mins
impulse.Config.AFKKickRatio = 0.9

impulse.Config.TeamChangeTime = 60
impulse.Config.TeamChangeTimeDonator = 30

impulse.Config.ClassChangeTime = 5
impulse.Config.QuizWaitTime = 60 -- in mins

impulse.Config.RespawnTime = 30
impulse.Config.RespawnTimeDonator = 10

impulse.Config.BodyDeSpawnTime = 360 -- 6 mins

impulse.Config.BrokenLegsHealTime = 300 -- 5 mins

impulse.Config.PropPrice = 2
impulse.Config.PropPriceDonator = 0

impulse.Config.RPNameChangePrice = 50

impulse.Config.CosmeticGenderPrice = 25
impulse.Config.CosmeticModelSkinPrice = 25

impulse.Config.MaxLetters = 3

impulse.Config.MaxRadios = 2
impulse.Config.MaxSigns = 10

impulse.Config.HungerTime = 60
impulse.Config.HungerHealTime = 25

impulse.Config.DefaultFemaleHealth = 90
impulse.Config.DefaultMaleHealth = 100

impulse.Config.InventoryMaxWeight = 25 -- in kg
impulse.Config.InventoryStorageMaxWeight = 200
impulse.Config.InventoryStorageMaxWeightVIP = 400
impulse.Config.InventoryItemDeSpawnTime = 300
impulse.Config.InventoryStorageModel = "models/props/CS_militia/footlocker01_closed.mdl"
impulse.Config.InventoryStoragePublicModel = "models/props_c17/lockers001a.mdl"

impulse.Config.GroupMakeCost = 2500
impulse.Config.GroupXPRequirement = 250
impulse.Config.GroupMaxMembers = 50
impulse.Config.GroupMaxMembersVIP = 100
impulse.Config.GroupMaxRanks = 10
impulse.Config.GroupMaxRanksVIP = 20

impulse.Config.DiscordLeadModRoleID = "917454069256310824"
impulse.Config.AutoModCooldown = 130
impulse.Config.AutoModMaxRisk = 15

impulse.Config.MaxPillPresses = 4

impulse.Config.PreWarCacheTime = 210

impulse.Config.CommunityURL = "https://deepgaming2.com/news"
impulse.Config.PanelURL = "https://deepgaming2.com/news"
impulse.Config.DonateURL = "https://deepgaming2.com/shop"
impulse.Config.DiscordURL = "https://discord.gg/ftM9jcztCt"
impulse.Config.SupportURL = "https://deepgaming2.com/news" -- this can just be the forum url

impulse.Config.RulesURL = "https://deepgaming2.com/news"
impulse.Config.TutorialURL = "https://deepgaming2.com/news"

impulse.Config.WordPressURL = "https://deepgaming2.com/news"
impulse.Config.DefaultWordPressImage = "https://deepgaming2.com/news"

impulse.Config.DisabledPlugins = {
	["season_xmas"] = true,
	["season_halloween"] = true,
	["changelog"] = true,
	["season_aprilfools"] = true,
	["ending"] = true,
	["properties"] = true,
	["quests"] = true
}

impulse.Config.DoorPrice = 15
impulse.Config.DoorGroups = {
	[1] = "Civic Workforce",
	[2] = "Combine Level 1",
	[3] = "Combine Level 2",
	[4] = "Combine Level 3",
	[5] = "Combine Level 4",
	[6] = "Loyalist Block",
	[7] = "Research & Development",
}

impulse.Config.RankColours = {
	["superadmin"] = Color(201, 15, 12),
	["communitymanager"] = Color(84, 204, 5),
	["leadadmin"] = Color(0, 200, 0),
	["admin"] = Color(34, 88, 216),
	["seniorgamemaster"] = Color(104, 159, 56),
	["gamemaster"] = Color(255, 97, 0),
	["developer"] = Color(255, 229, 0),
	["leaddeveloper"] = Color(125, 0, 0),
	["mapper"] = Color(255, 229, 0),
	["donator"] = Color(150, 50, 200)
}

impulse.Config.SaveableAmmo = {
	["Pistol"] = true,
	["SniperPenetratedRound"] = true,
	["SMG1"] = true,
	["357"] = true,
	["Buckshot"] = true,
	["AR2"] = true,
	["Rifle"] = true
}

impulse.Config.Achievements = {
	["ach_apt"] = {
		Name = "Home Sweet Home",
		Desc = "Purchase your first home",
		Icon = Material("impulse/icons/house-128.png")
	},
	["ach_fromthegrave"] = {
		Name = "From The Grave",
		Desc = "Kill a player while dead (or kill yourself :/).",
		Icon = Material("impulse/icons/toxic-256.png")
	},
	["ach_greatescape"] = {
		Name = "The Great Escape",
		Desc = "Break out of C.P. Custody.",
		Icon = Material("impulse/icons/exit-128.png")
	},
	["ach_deadweight"] = {
		Name = "Weight Loss",
		Desc = "Lose 15+ kilograms of items on death",
		Icon = Material("impulse/icons/weight-128.png")
	},
	["ach_jackofalltrades"] = {
		Name = "Jack Of All Trades",
		Desc = "You're really good at every skill",
		Icon = Material("impulse/icons/bar-chart-5-128.png"),
		OnJoin = true,
		Check = function(ply)
			for v,k in pairs(impulse.Skills.Skills) do
				if ply:GetSkillXP(v) < 4500 then
					return false
				end
			end

			return true
		end
	},
		["ach_masterofalltrades"] = {
		Name = "Master Of All Trades",
		Desc = "Master every skill",
		Icon = Material("impulse/icons/bar-chart-5-128.png"),
		OnJoin = true,
		Check = function(ply)
			for v,k in pairs(impulse.Skills.Skills) do
				if ply:GetSkillXP(v) < 5500 then
					return false
				end
			end

			return true
		end
	},
	["ach_dayone"] = {
		Name = "Blast Off",
		Desc = "Play the server on the initial launch.",
		Icon = Material("impulse/icons/star-128.png"),
		OnJoin = true,
		Check = function(ply)
			if ply.impulseFirstJoin and ply.impulseFirstJoin < 1695998271 then -- unix epoch of 07/14/2023 (release first 30ish hours)
				return true
			end
		end
	},
	["ach_party"] = {
		Name = "Party",
		Desc = "Dance with 15 other players",
		Icon = Material("impulse/icons/party-hat-3-256.png"),
		Points = 20
	},
	["ach_quickshot"] = {
		Name = "Marksman",
		Desc = "Kill a player that is 100 meters or more away",
		Icon = Material("impulse/icons/gun-2-128.png"),
		Points = 20,
	},
	["ach_donator"] = {
		Name = "Supporter",
		Desc = "Donate to the server",
		Icon = Material("impulse/icons/heart-128.png"),
		Points = 20,
		OnJoin = true,
		Check = function(ply)
			if ply:IsDonator() then
				return true
			end
		end
	},
	["ach_costlydeath"] = {
		Name = "Costly Death",
		Desc = "Die to a player with 20000 credits on you",
		Icon = Material("impulse/icons/banknotes-128.png"),
		Points = 20
	},
	["ach_bambikiller"] = {
		Name = "Bully",
		Desc = "Kill a player with less than 30XP",
		Icon = Material("impulse/icons/sad.png"),
		Points = 20
	},
	["ach_closeshave"] = {
		Name = "Superiority",
		Desc = "Kill a C.T.A. member when you have only 1 HP left",
		Icon = Material("impulse/icons/clenched-fist-256.png"),
		Points = 20
	},
	["ach_axe"] = {
		Name = "Gotta Start Somewhere...",
		Desc = "Craft an Axe",
		Icon = Material("impulse/icons/cog-128.png"),
		Points = 20
	},
	["ach_addict"] = {
		Name = "Veteran",
		Desc = "Earn over 25000XP",
		Icon = Material("impulse/icons/stop-3-256.png"),
		OnJoin = true,
		Check = function(ply)
			if ply:GetXP() > 25000 then
				return true
			end
		end
	},
	["ach_insane"] = {
		Name = "The Voices...",
		Desc = "Go insane",
		Icon = Material("impulse/icons/brain-3-256.png")
	},
	["ach_vin"] = {
		Name = "The Butcher",
		Desc = "Defeat Thrawn in battle.",
		Icon = Material("effects/tp_eyefx/tpeye"),
		Points = 100
	},
	["ach_gay"] = {
		Name = "Homophobic",
		Desc = "Killed Jake, because he is gay.",
		Icon = Material("materials/materials/achievements/gay.png"),
		Points = 100
	},
	["ach_kuma"] = {
		Name = "Don Mafioso",
		Desc = "Killed Kumazaki, The Deep Gaming 2 Connoisseur",
		Icon = Material("roleicons/donatordeep.png"),
		Points = 100
	},
	["ach_sd"] = {
		Name = "Decapitation",
		Desc = "Kill the Server Director or Deputy Community Director.",
		Icon = Material("sprites/orangecore2_gmod"),
		Points = 100
	},
	["ach_entity"] = {
		Name = "Infectious Encounter",
		Desc = "Kill a zombie.",
		Icon = Material("decals/eye_model"),
		Points = 100
	},
	["ach_clobberer"] = {
		Name = "Titan",
		Desc = "Defeat a C.T.A. member with a pickaxe as a civilian.",
		Icon = Material("decals/cross_model"),
		Points = 100
	},
	["ach_unknownkiller"] = {
		Name = "Cop Killer",
		Desc = "Kill a Metro Police Force member.",
		Icon = Material("sprites/grip_hover"),
		Points = 100
	},
	["ach_pickupthatcan"] = {
		Name = "Pick Up That Can",
		Desc = "Complete the Impulse Framework 'Pick Up That Can' Mini Game",
		Icon = Material("impulse/icons/check-mark-128.png"),
		Points = 20
	},
	["ach_kingpin"] = {
		Name = "Kingpin",
		Desc = "Assassinate the Metro Police Force commander.",
		Icon = Material("cable/physbeam"),
		Points = 20
	},
	["ach_takeover"] = {
		Name = "Hostile Takeover",
		Desc = "Assassinate the Combine Transhuman Arm Commander.",
		Icon = Material("vgui/steam/games/icon_cg"),
		Points = 20
	},
	["ach_pickupthatcan"] = {
		Name = "Pick Up That Can",
		Desc = "Complete the Impulse Framework 'Pick Up That Can' Mini Game",
		Icon = Material("impulse/icons/check-mark-128.png"),
		Points = 20
	},
	["ach_severance"] = {
		Name = "Severance",
		Desc = "Liberate the Industrial District of City 17.",
		Icon = Material("sprites/light_ignorez"),
		Points = 20
	},
	["ach_industrializedrevolution"] = {
		Name = "Industrialized Revolution",
		Desc = "Assist Henry Walker within the Conquest of Industrial 24.",
		Icon = Material("sprites/light_ignorez"),
		Points = 20
	},
	["ach_city18"] = {
		Name = "Demolition",
		Desc = "Reclaim City 18 from the Combine.",
		Icon = Material("widgets/disc.png"),
		Points = 20
	},
	["ach_scar"] = {
		Name = "Transhuman Imposter",
		Desc = "Kill an augmented Metrocop.",
		Icon = Material("vgui/servers/icon_password"),
		Points = 20
	},
	["ach_tau"] = {
		Name = "Unlimited Power",
		Desc = "Unleash the power of the Tau Particle Accelerator.",
		Icon = Material("gamepadui/game_logo"),
		Points = 20
	},
	["ach_haunted"] = {
		Name = "Paranormal Activity",
		Desc = "Get haunted by a powerful entity.",
		Icon = Material("perftest/gman/gman_suittop2"),
		Points = 20
	},
	["ach_teaparty"] = {
		Name = "Witch Tea Party",
		Desc = "Receive an invitation from a witch to attend her tea party.",
		Icon = Material("engine/lightsprite"),
		Points = 20
	},
	["ach_elite"] = {
		Name = "Cyclops Down",
		Desc = "Defeat a Combine Elite in battle.",
		Icon = Material("effects/redflare"),
		Points = 20
	},
	["ach_vort"] = {
		Name = "Power Down",
		Desc = "Defeat an enriched Vortigaunt in battle as a Combine operative.",
		Icon = Material("effects/exit1"),
		Points = 20
	},
	["ach_drill"] = {
		Name = "There's No Going Back Now",
		Desc = "Drill into a Combine ammo crate.",
		Icon = Material("effects/fire_cloud2"),
		Points = 20
	},
	["ach_cache"] = {
		Name = "Taking Back What's Ours",
		Desc = "Plant a C4 explosive on a Pre-War Cache.",
		Icon = Material("hud/scoreboard_bomb"),
		Points = 20
	},
	["ach_contraband"] = {
		Name = "High Tier Contraband",
		Desc = "Confiscate an elite vest, tau cannon, AR-1C, or Particle Accelerator Core.",
		Icon = Material("vgui/gfx/vgui/helmet"),
		Points = 20
	},
	["ach_ammosmith"] = {
		Name = "Ammo Smith",
		Desc = "Create ammo in a Bullet Press.",
		Icon = Material("vgui/gfx/vgui/bullet"),
		Points = 20
	},
	["ach_headcrab"] = {
		Name = "Pest Control",
		Desc = "Catch a Headcrab as an Infestation Control Team Member.",
		Icon = Material("vgui/hud/icon_locked"),
		Points = 20
	},
	["ach_rationraid"] = {
		Name = "Funds Siphoning",
		Desc = "Hack into a ration center to steal some money.",
		Icon = Material("vgui/gfx/vgui/last_match_miscellaneous"),
		Points = 20
	},
	["ach_cpgod"] = {
		Name = "Elite Metrocop",
		Desc = "Defeat a rebel with Tier 5 armor as a metrocop.",
		Icon = Material("gamepadui/achievements/hl2_hit_cancop_withcan_bw"),
		Points = 20
	},
	["ach_chadi5"] = {
		Name = "Chad i4",
		Desc = "Defeat a rebel with Tier 5 armor as an i4 with a stun baton.",
		Icon = Material("gamepadui/easy"),
		Points = 20
	},
	["ach_blackout"] = {
		Name = "Radio Blackout",
		Desc = "Disable the Combine comms network with an Electromagnetic Shock Tool.",
		Icon = Material("lights/fluorescentcool001a"),
		Points = 20
	},
	["ach_minge"] = {
		Name = "DarkRP",
		Desc = "Participate in the 2024 April Fools Event.",
		Icon = Material("voice/icntlk_local"),
		Points = 20
	},
	["ach_city24"] = {
		Name = "Operation Shooting Star",
		Desc = "Liberate the commercial district of City 24.",
		Icon = Material("gamepadui/achievements/hl2_beat_toxictunnel"),
		Points = 20
	},
	["ach_city26"] = {
		Name = "Operation Stronghold",
		Desc = "Liberate the 12th District of City 26.",
		Icon = Material("vgui/icons/icon_buster"),
		Points = 20
	},
	["ach_city18retake"] = {
		Name = "659",
		Desc = "Complete Combine Strategic Order 659.",
		Icon = Material("overlays/overlay_dwhiteforest"),
		Points = 20
	},
	["ach_stiletto"] = {
		Name = "Rogue",
		Desc = "Using a stiletto dagger, conduct an Execution on a Combine Operative.",
		Icon = Material("vgui/achievements/win_knife_fights_low"),
		Points = 20
	},
	["ach_stiletto2"] = {
		Name = "True Assassin",
		Desc = "Using a stiletto dagger, conduct an Execution on a PAYBACK Unit.",
		Icon = Material("vgui/gfx/vgui/sas"),
		Points = 20
	},
	["ach_ca"] = {
		Name = "Strung Puppet",
		Desc = "Assassinate the City Administrator.",
		Icon = Material("models/breen/breen_face"),
		Points = 20
	},
	["ach_research"] = {
		Name = "Unforseen Consequences",
		Desc = "Accidentally start the Xenpocalypse as a C.W. Researcher.",
		Icon = Material("gamepadui/achievements/hl2_break_miniteleporter"),
		Points = 20
	},
	["ach_city8nuke"] = {
		Name = "Operation Armageddon",
		Desc = "Take part in the Nuclear Warhead Detonation of City 8 by Colonel Takeda.",
		Icon = Material("materials/materials/achievements/city8_event_achievement.png"),
		Points = 20
	},
	["ach_city20shiftingtide"] = {
		Name = "Shifting Tides",
		Desc = "Take part in the City 20 map change event.",
		Icon = Material("materials/materials/achievements/city20_event_achievement.png"),
		Points = 20
	},
	["ach_city18turningpoint"] = {
		Name = "Turning point",
		Desc = "Join forces with the MPF and end the corruption of the OCALA in City 18",
		Icon = Material("materials/materials/achievements/city18_event achievement.png"),
		Points = 20
	},
}

impulse.Config.ModQuickReplies = {
	"Your report has been received, but we need more details to proceed. Please provide additional info (e.g., player name, time of incident).",
	"Unfortunately we can not help with this type of issue. If you have any issues with rule-breakers feel free to send another report.",
	"We cannot accommodate refund requests unless this ticket pertains to your last death. Please submit a request on https://deepgaming2.com",
	"Do you have a clip available? Witness testimony will not be deemed credible unless supported by a verifiable clip.",
	"We have decided to not grant you rogue permission, please do not make another request for at least 1 hour.",
	"You have been granted rogue permission. Please remember, you may only be an i4 or i5. Furthermore, you may only kill in absolute self-defense situations.",
	"Apologies for the delay in responding to this report.",
	"Thank you for your report.",
	"Unfortunately I will have to close this report as it is too old to be dealt with. Feel free to submit a ban request at https://deepgaming2.com",
	"False arrest reports can be submitted through the Combine Discord. Staff are unable to assist unless this involves job abuse.",
	"This report seems to duplicate an existing case. We’re already looking into it. Thanks for your patience!",
	"We’ve reviewed your report but couldn’t find sufficient evidence. Please let us know if the issue persists."
}

impulse.Config.AutoModDict = {
	{
		Terms = {"E2", "HELP"},
		TermsTogether = true,
		IgnorePunc = true,
		RequestClose = true,
		Reply = "Hey there! We can't provide any specific assistance with how to use E2. To learn about E2 take a look at the tutorials here: https://github.com/wiremod/wire/wiki/Expression-2#Tutorials"
	},
	{
		Terms = {"E2", "HOW"},
		TermsTogether = true,
		IgnorePunc = true,
		RequestClose = true,
		Reply = "Hey there! We can't provide any specific assistance with how to use E2. To learn about E2 take a look at the tutorials here: https://github.com/wiremod/wire/wiki/Expression-2#Tutorials"
	},
	{
		Terms = {"STUCK"},
		IgnorePunc = true,
		RequestClose = true,
		Reply = "I've tried to get you un-stuck. This automated system might not always work, however. You can activate this by typing /unstuck in chat. If you are still stuck, just hang in there and we'll be with you shortly!",
		Command = "say /unstuck"
	}
}

impulse.Config.TrashSpawns = {}

impulse.Config.DefaultTeam = TEAM_CITIZEN

impulse.Config.DefaultMaleModels = {
	Model("models/willardnetworks_custom/citizens/male01.mdl"),
	Model("models/willardnetworks_custom/citizens/male02.mdl"),
	Model("models/willardnetworks_custom/citizens/male03.mdl"),
	Model("models/willardnetworks_custom/citizens/male04.mdl"),
	Model("models/willardnetworks_custom/citizens/male05.mdl"),
	Model("models/willardnetworks_custom/citizens/male06.mdl"),
	Model("models/willardnetworks_custom/citizens/male07.mdl"),
	Model("models/willardnetworks_custom/citizens/male08.mdl"),
	Model("models/willardnetworks_custom/citizens/male09.mdl"),
	Model("models/willardnetworks_custom/citizens/male10.mdl"),
}

impulse.Config.DefaultFemaleModels = {
	Model("models/willardnetworks_custom/citizens/female_01.mdl"),
	Model("models/willardnetworks_custom/citizens/female_02.mdl"),
	Model("models/willardnetworks_custom/citizens/female_03.mdl"),
	Model("models/willardnetworks_custom/citizens/female_04.mdl"),
	--Model("models/willardnetworks_custom/citizens/female_05.mdl"),
	Model("models/willardnetworks_custom/citizens/female_06.mdl"),
	Model("models/willardnetworks_custom/citizens/female_07.mdl"),
}

impulse.Config.DefaultSkinBlacklist = {
}

--
-- Half Life 2: Roleplay Schema:
--

impulse.Config.ArrestCharges = {
	{name = "10-103m, disturbance by mentally unfit", severity = 3, sound = "npc/overwatch/radiovoice/disturbancemental10-103m.wav"},
	{name = "27, attempted crime", severity = 2, sound = "npc/overwatch/radiovoice/attemptedcrime27.wav"},
	{name = "51, non-sanctioned arson", severity = 5, sound = "npc/overwatch/radiovoice/nonsanctionedarson51.wav"},
	{name = "51B, threat to property", severity = 3, sound = "npc/overwatch/radiovoice/threattoproperty51b.wav"},
	{name = "63, criminal trespass", severity = 5, sound = "npc/overwatch/radiovoice/criminaltrespass63.wav"},
	{name = "69, possession of (contraband) resources", severity = 3, sound = "npc/overwatch/radiovoice/posession69.wav"},
	{name = "94, weapon", severity = 8, sound = "npc/overwatch/radiovoice/weapon94.wav"},
	{name = "17f, fugitive detachment", severity = 5, sound = "npc/overwatch/radiovoice/fugitive17f.wav"},
	{name = "95, illegal carrying", severity = 6, sound = "npc/overwatch/radiovoice/illegalcarrying95.wav"},
	{name = "99, reckless operation", severity = 2, sound = "npc/overwatch/radiovoice/recklessoperation99.wav"},
	{name = "148, resisting arrest", severity = 4, sound = "npc/overwatch/radiovoice/resistingpacification148.wav"},
	{name = "243, assault on protection team", severity = 9, sound = "npc/overwatch/radiovoice/assault243.wav"},
	{name = "404, riot", severity = 4, sound = "npc/overwatch/radiovoice/riot404.wav"},
	{name = "507, public non-compliance", severity = 2, sound = "npc/overwatch/radiovoice/publicnoncompliance507.wav"},
	{name = "603, unlawful entry", severity = 4, sound = "npc/overwatch/radiovoice/unlawfulentry603.wav"},
	{name = "Disassociation from the civic populous", severity = 7, sound = "npc/overwatch/radiovoice/disassociationfromcivic.wav"},
	{name = "Promoting communal unrest", severity = 7, sound = "npc/overwatch/radiovoice/promotingcommunalunrest.wav"},
	{name = "Level 5 Anti-civil activity", severity = 15, sound = "npc/overwatch/radiovoice/level5anticivilactivity.wav"},
	{name = "Divisive sociocidal counter-obeyance", severity = 8, sound = "npc/overwatch/radiovoice/devisivesociocidal.wav"},
	{name = "Capital malcompliance", severity = 6, sound = "npc/overwatch/radiovoice/capitalmalcompliance.wav"},
	{name = "Destruction of corporal social protection units", severity = 12, sound = "npc/overwatch/radiovoice/destrutionofcpt.wav"},
	{name = "415, civic disunity", severity = 5, sound = "npc/overwatch/radiovoice/disturbingunity415.wav"},
}
impulse.Config.DispatchLines = {
    {name = "Anti-citizen reported in this community", text = "Attention, ground-units: Anti-citizen reported in this community. Code: LOCK, CAUTERIZE, STABILIZE.", sound = "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav", volume = 80},
    {name = "Anti-civil activity level 1", text = "You are charged with anti-civil activity level: ONE. Protection-unit prosecution code: DUTY, SWORD, OPERATE.", sound = "npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav", volume = 85},
	{name = "Block search", text = "Attention, residents: This blocks contains potential civil infection. INFORM, CO-OPERATE, ASSEMBLE.", sound = "npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav", volume = 90},
	{name = "Inspection positions", text = "Attention, please: All citizens in local residential block, assume your inspection-positions.", sound = "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav", volume = 90},
	{name = "Unidentified person of interest", text="Attention please. Unidentified person of interest, confirm your civil status with local protection team immediately.", sound = "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav", volume = 75},
	{name = "Status evasion in progress", text="Attention, protection-team, status evasion in progress in this community. RESPOND, ISOLATE, INQUIRE.", sound="npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav", volume = 85},
	{name = "Anti-civil evidence", text = "Protection team alert: Evidence of anti-civil activity in this community. Code: ASSEMBLE, CLAMP, CONTAIN.", sound = "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav", volume = 85},
	{name = "Socio-endangerment level 5", text = "Individual, you are now charged with Socio-Endangerment level: FIVE. Cease evasion immediately, receive your verdict.", sound = "npc/overwatch/cityvoice/f_ceaseevasionlevelfive_spkr.wav", volume = 85},
	{name = "Mission Failure", text = "Attention ground units. Mission failure will result in permanent off-world assignment. Code reminder: SACRIFICE, COAGULATE, CLAMP.", sound = "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav", volume = 85},
	{name = "Rations Deducted", text = "Attention occupants: your block is now charged with permissive inactive coercion. Five ration units deducted.", sound = "npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav", volume = 85},

	{name = "Block access is not permitted.", text = "Attention please, access to this block is not permitted, to recieve this message is to be in civil code violation.", sound = "overwatch/citywide/overwatch_accessblockcivilcodeviolation.mp3", volume = 85},
	{name = "Level 5 Anti Civil Activity.", text = "Individual, you are now charged with multiple Level-5 Anti-Civil activity violations. Please cooperate with Ground Protection Team, Ground Protection Team ALERT CODE: ENGAGE, ISOLATE, NEUTRALIZE", sound = "voices/dispatch/level5_anticivil.wav", volume = 85},
	{name = "Response Code", text = "RESPONSE CODE: SHIELD, KEY, MIGRATE", sound = "voices/dispatch/responsecode_shield.wav", volume = 85},
	{name = "Civil Insurrection", text = "SECURITY ALERT: Critical Civil Insurrection. Deploy Technician Teams to blocks 49, 64, 77. Maintain Priority.", sound = "voices/dispatch/civil_insurrection.wav", volume = 85},
	{name = "Concurrent Deployment", text = "FULL SYSTEM ALERT: Operation Engagement : 5 1 2 9 : Immediate Concurrent Deployment : 5 1 2 9", sound = "voices/dispatch/concurrent_deployment.wav", volume = 85},

	{name = "Incident Response Required", text = "Ground Protection Teams: Alert - Incident response deployment required. 9 2 1 2.", sound = "overwatch/citywide/overwatch_incidentsresponsedeployment.mp3", volume = 85},
	{name = "Invasive Operation", text = "Alert ground units - Invasive operation of anti-citizen origin. Response Code: Engage, Quell, Inqure.", sound = "overwatch/citywide/overwatch_invasiveoperation.mp3", volume = 85},
	{name = "Overlook Protocol", text = "Alert Response team - Overlook protocol: Angle. Cauterize. Flash. Angle. Cauterize. Flash.", sound = "overwatch/citywide/overwatch_responseteams.mp3", volume = 85},
	{name = "Citizen Reminder", text = "Citizen Reminder: A civilized society demands swift and targeted oversight. Prohibit fellow citizens from threatening the community.", sound = "overwatch/citywide/overwatch_citizenreminder.mp3", volume = 85},
	{name = "Response Code", text = "Responce Code: Shield. Key. Migrate.", sound = "overwatch/citywide/overwatch_responsecodeshieldkeymigrate.mp3", volume = 85},
}

-- 	{name = "Name", text = "text", sound = "path", volume = 85}

impulse.Config.MaxJailTime = 1800
impulse.Config.MaxJailTimeGrunt = 1800
impulse.Config.MinJailTime = 60
impulse.Config.MaxArrestCharges = 5

impulse.Config.DefaultBOLTime = 2700

impulse.Config.CameraRepairTime = 2400

impulse.Config.ManhackTime = 160

impulse.Config.MaxSquadsCP = 15
impulse.Config.MaxSquadsOTA = 20
impulse.Config.MaxSquadSizeCP = 4
impulse.Config.MaxSquadSizeOTA = 5
impulse.Config.SquadExpiryTime = 1000

impulse.Config.DealerTeleportTimeMin = 1500
impulse.Config.DealerTeleportTimeMax = 1900

impulse.Config.MaxBarrels = 2
impulse.Config.BrewingTime = 900

impulse.Config.FactoryLaundryReward = 20
impulse.Config.VendingRefillReward = 20
impulse.Config.MaxVendingMachines = 1

impulse.Config.ApartmentCost = 15 -- one time purchase amount

impulse.Config.ExplosionDoorRespawnTime = 230

impulse.Config.AmmoDrillTime = 300 -- 5 mins
impulse.Config.SuperAmmoDrillTime = 900 -- 20 min

impulse.Config.VortessenceRange = 1080
impulse.Config.VortessenceTime = 1200

impulse.Config.BeepSounds = {
	[TEAM_CP] = {
		on = {
			"npc/overwatch/radiovoice/on1.wav",
			"npc/overwatch/radiovoice/on3.wav",
			"npc/metropolice/vo/on2.wav"
		},
		off = {
			"npc/metropolice/vo/off1.wav",
			"npc/metropolice/vo/off2.wav",
			"npc/metropolice/vo/off3.wav",
			"npc/metropolice/vo/off4.wav",
			"npc/overwatch/radiovoice/off2.wav",
			"npc/overwatch/radiovoice/off2.wav"
		}
	},

	[TEAM_OTA] = {
		on = {
			"npc/combine_soldier/vo/on1.wav",
			"npc/combine_soldier/vo/on2.wav"
		},
		off = {
			"npc/combine_soldier/vo/off1.wav",
			"npc/combine_soldier/vo/off2.wav",
			"npc/combine_soldier/vo/off3.wav"
		}
	}
}



impulse.Config.TheatreMusic = {
	["CP Violation"] = "music/HL2_song20_submix4.mp3",
	["Triage at Dawn"] = "music/hl2_song23_suitsong3.mp3",
	["Beautiful Creature"] = "industrial17/namtran_beautifulcreature.mp3",
	["Blue Collar Citizen"] = "industrial17/namtran_bluecollarcitizen.mp3",
	["Carpenter Tribute"] = "industrial17/namtran_jctribute.mp3",
	["Metro 5-0"] = "industrial17/namtran_metro.mp3",
	["Rust Belt"] = "industrial17/namtran_rustbelt.mp3"
}

impulse.Config.LootPools = {
	["generic"] = {
		Items = {
			["util_cloth"] = {Rarity = 680, Rep = 2},
			["util_gunpowder"] = {Rarity = 550, Rep = 3},
			["util_metalplate"] = {Rarity = 600, Rep = 2},
			--["util_wood"] = {Rarity = 600, Rep = 2},
			--["util_plastic"] = {Rarity = 900, Rep = 2},
			["util_glue"] = {Rarity = 620, Rep = 4},
			["util_paint"] = {Rarity = 820, Rep = 1},
			["wep_pistol"] = {Rarity = 950, Rep = 1},
			["item_vortessence"] = {Rarity = 910, Rep = 1},
			["util_medicalsupplies"] = {Rarity = 880, Rep = 1},
			["util_rdxcompound"] = {Rarity = 980, Rep = 1},
			["util_xenextract"] = {Rarity = 820, Rep = 1},
			["book_spanish"] = {Rarity = 990, Rep = 1},
			["book_arabic"] = {Rarity = 990, Rep = 1},
			['util_resin'] = {Rarity = 895, Rep = 1}
		},
		MaxRarity = 1700,
		MinItems = 3,
		MaxItems = 7,
		MaxWait = 900,
		MinWait = 75
	},
	["metal"] = {
		Items = {
			["util_metalplate"] = {Rarity = 680, Rep = 4},
			["util_refinedmetalplate"] = {Rarity = 980, Rep = 2},
			["util_pipe"] = {Rarity = 810, Rep = 2},
			["ammo_pistol"] = {Rarity = 930},
			["wep_cz75"] = {Rarity = 980, Rep = 1},
			["util_gear"] = {Rarity = 890}
		},
		MinItems = 3,
		MaxItems = 6,
		MaxWait = 900,
		MinWait = 75
	},
	["electronic"] = {
		Items = {
			--["util_plastic"] = {Rarity = 700, Rep = 3},
			["util_electronics"] = {Rarity = 850, Rep = 2},
			["util_refinedmetalplate"] = {Rarity = 800}
		},
		MaxItems = 3,
		MaxWait = 900,
		MinWait = 75
	},
	["ammobox"] = {
		Items = {
			["bl_ar2e"] = {Rarity = 765, Rep = 2},
			["bl_ar2r"] = {Rarity = 695, Rep = 2},
			["bl_ar2"] = {Rarity = 610, Rep = 1},
			["bl_apf"] = {Rarity = 820, Rep = 1},
			["bl_omr"] = {Rarity = 690, Rep = 3},
			["bl_osiprmk1"] = {Rarity = 740, Rep = 2},
			["util_heavyceramicplate"] = {Rarity = 680, Rep = 2},
			["cos_elitevest"] = {Rarity = 945, Rep = 1},
			["wep_mp7a8"] = {Rarity = 830, Rep = 3},
			["bl_ar3"] = {Rarity = 930, Rep = 1},
			["wep_osiprmk1c"] = {Rarity = 970, Rep = 1},
			["util_energycore"] = {Rarity = 730, Rep = 2},
			["util_particleaccelerator"] = {Rarity = 980, Rep = 1},
			["item_augmentchip"] = {Rarity = 995, Rep = 1},
			["item_ammocrate"] = {Rarity = 600, Rep = 3},
		},
		MaxItems = 20,
		MinItems = 12
	},
	["hardpointammobox"] = {
		Items = {
			["wep_shotgun"] = {Rarity = 600},
			["bl_ar2e"] = {Rarity = 765, Rep = 2},
			["bl_ar2"] = {Rarity = 620, Rep = 1},
			["bl_apf"] = {Rarity = 820, Rep = 1},
			["bl_omr"] = {Rarity = 690, Rep = 3},
			["bl_osiprmk1"] = {Rarity = 980, Rep = 2},
			["util_heavyceramicplate"] = {Rarity = 680, Rep = 2},
			["cos_elitevest"] = {Rarity = 945, Rep = 1},
			["wep_mp7a8"] = {Rarity = 860, Rep = 3},
			["bl_ar3"] = {Rarity = 930, Rep = 1},
			["util_energycore"] = {Rarity = 730, Rep = 6},
			["item_ammocrate"] = {Rarity = 600, Rep = 5},
		},
		MaxItems = 18,
		MinItems = 9
	},

	--[[
	["superammobox"] = {
		Items = {
			["wep_ar2e_eq"] = {Rarity = 880, Rep = 2},
			["wep_ar2r_eq"] = {Rarity = 800, Rep = 2},
			["wep_ar2"] = {Rarity = 620, Rep = 2},
			["wep_apf_eq"] = {Rarity = 820, Rep = 2},
			["wep_omr_eq"] = {Rarity = 690, Rep = 3},
			["wep_osiprmk1_eq"] = {Rarity = 740, Rep = 2},
			["util_heavyceramicplate"] = {Rarity = 680, Rep = 2},
			["cos_elitevest"] = {Rarity = 900, Rep = 3},
			["wep_ar3_eq"] = {Rarity = 930, Rep = 1},
			["wep_osiprmk1c_eq"] = {Rarity = 990, Rep = 2},
			["util_particleaccelerator"] = {Rarity = 920, Rep = 1},
			["wep_osiprmk1c_eq"] = {Rarity = 999, Rep = 1}
		},
		MaxItems = 14,
		MinItems = 9
	},
	]]

	["prewarcache"] = {
		Items = {
			["ammo_rifle"] = {Rarity = 300, Rep = 1},
			["ammo_54r"] = {Rarity = 500, Rep = 1},
			["wep_357"] = {Rarity = 400, Rep = 2},
			["wep_mp7"] = {Rarity = 500, Rep = 1},
			["wep_scarh"] = {Rarity = 900, Rep = 1},
			["wep_famas"] = {Rarity = 830, Rep = 1},
			["wep_m4a1"] = {Rarity = 640, Rep = 4},
			["wep_shotgun"] = {Rarity = 780, Rep = 3},
			["item_drill"] = {Rarity = 720, Rep = 1},
			["wep_ak47"] = {Rarity = 630, Rep = 3},
			["wep_m60"] = {Rarity = 900, Rep = 1},
			["wep_mg34"] = {Rarity = 840, Rep = 1},
			["util_heavyceramicplate"] = {Rarity = 500, Rep = 1},
			["item_ammocrate"] = {Rarity = 820, Rep = 3},
			["wep_mini14"] = {Rarity = 820, Rep = 2},
			["util_ceramicplate"] = {Rarity = 820, Rep = 2},
			["att_dragonsbreath"] = {Rarity = 990, Rep = 1},
		},
		MaxItems = 10,
		MinItems = 6
	},
	["scrapHighBig"] = {
		Items = {
			["util_gear"] = {Rarity = 550, Rep = 2},
			["util_aluminum"] = {Rarity = 200, Rep = 3},
			["util_pipe"] = {Rarity = 300, Rep = 4},
			["util_metalplate"] = {Rarity = 100, Rep = 4},
			["util_reinfedmetal"] = {Rarity = 700, Rep = 1}
		},
		MinItems = 1,
		MaxItems = 7
	},
	["scrapHigh"] = {
		Items = {
			["util_gear"] = {Rarity = 550, Rep = 1},
			["util_aluminum"] = {Rarity = 200, Rep = 3},
			["util_pipe"] = {Rarity = 300, Rep = 2},
			["util_metalplate"] = {Rarity = 100, Rep = 4},
			["util_reinfedmetal"] = {Rarity = 700, Rep = 1}
		},
		MinItems = 1,
		MaxItems = 5
	},
	["scrapMid"] = {
		Items = {
			["util_gear"] = {Rarity = 550, Rep = 1},
			["util_aluminum"] = {Rarity = 200, Rep = 2},
			["util_pipe"] = {Rarity = 300, Rep = 2},
			["util_metalplate"] = {Rarity = 100, Rep = 3}
		},
		MinItems = 1,
		MaxItems = 4
	},
	["scrapLow"] = {
		Items = {
			["util_aluminum"] = {Rarity = 200, Rep = 2},
			["util_pipe"] = {Rarity = 300, Rep = 1},
			["util_metalplate"] = {Rarity = 100, Rep = 3}
		},
		MinItems = 1,
		MaxItems = 3
	},
	["emptycan"] = {
		Items = {
			["util_plastic"] = {Rarity = 100, Rep = 3},
			["util_aluminum"] = {Rarity = 250, Rep = 1},
			["util_metalplate"] = {Rarity = 930, Rep = 1}
		},
		MinItems = 1,
		MaxItems = 2
	},
	["ar2"] = {
		Items = {
			["util_metalplate"] = {Rarity = 100, Rep = 4},
			["util_darkenergy"] = {Rarity = 440, Rep = 1},
			["util_refinedmetalplate"] = {Rarity = 200, Rep = 4},
			["util_gear"] = {Rarity = 500, Rep = 2},
			["util_electronics"] = {Rarity = 400, Rep = 3}
		},
		MinItems = 3,
		MaxItems = 6
	}
}

--
-- Plugins
--

impulse.Config.PassiveMusic = {
	{"music/passive/passivemusic_01.mp3", 39},
	{"music/passive/passivemusic_02.mp3", 98},
	{"music/passive/passivemusic_03.mp3", 29},
	{"music/passive/passivemusic_04.mp3", 53},
	{"music/passive/passivemusic_05.mp3", 61},
	{"music/passive/passivemusic_06.mp3", 115},
	{"music/passive/passivemusic_07.mp3", 69},
	{"music/passive/passivemusic_08.mp3", 90},
    {"music/passive/passivemusic_09.mp3", 84},
    {"music/passive/passivemusic_10.mp3", 59}
}

impulse.Config.CombatMusic = {
	{"music/action/a1_intro_trek2.mp3", 73},
	{"music/HL2_song14.mp3", 159},
	{"music/HL2_song15.mp3", 69},
	{"music/HL2_song16.mp3", 170},
	{"music/HL2_song20_submix0.mp3", 103},
	{"music/action/a1_intro_trek2.mp3", 139},
	{"music/HL2_song29.mp3", 135},
	{"music/HL2_song3.mp3", 90},
	{"music/HL2_song31.mp3", 98},
	{"music/action/a1_intro_trek3.mp3", 65},
	{"music/HL2_song6.mp3", 45}
}

impulse.Config.DeathSounds = {
}

impulse.Config.PainSounds = {
}


impulse.Config.Chairs = {}

