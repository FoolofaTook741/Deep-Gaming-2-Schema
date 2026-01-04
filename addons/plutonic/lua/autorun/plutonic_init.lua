--- The core level functionality of Plutonic.
-- @module Framework

AddCSLuaFile()

Plutonic = Plutonic or {
	IsServer = SERVER, -- Saves interpreter instruction!
	IsClient = CLIENT  -- Saves interpreter instruction!
} -- Creates the Plutonic table if it doesn't exist.
Plutonic.Enum = Plutonic.Enum or {} -- Creates the Plutonic Enum table if it doesn't exist.
Plutonic.Framework = Plutonic.Framework or {} -- Creates the Plutonic Framework table if it doesn't exist.
Plutonic.Constants = Plutonic.Constants or {} -- Creates the Plutonic Constants table if it doesn't exist.
Plutonic.Interpolation = Plutonic.Interpolation or {} -- Creates the Plutonic Interpolation table if it doesn't exist.
Plutonic.Hooks = Plutonic.Hooks or {} -- Creates the Plutonic Hooks table if it doesn't exist.
Plutonic.FireRate = Plutonic.FireRate or {} -- Creates the Plutonic FireRate table if it doesn't exist.
_Plutonic = _Plutonic or {} -- Creates the _Plutonic table if it doesn't exist. This houses the private data

--- Does a fancy print to the console.
-- @realm shared
-- @string text The text to print.
function Plutonic.Framework.Print(text)
	if Plutonic.IsServer then
		MsgC(Color(10, 120, 255), "[Plutonic] ", Color(255, 200, 0), text .. "\n")
	end
end

function RPM(rpm)
	return 60 / rpm
end

game.AddParticles( "particles/muzzleflashes_test.pcf" )
game.AddParticles( "particles/muzzleflashes_test_b.pcf" )
PrecacheParticleSystem( "muzzleflash_smg" )
PrecacheParticleSystem( "muzzleflash_smg_bizon" )
PrecacheParticleSystem( "muzzleflash_shotgun" )
PrecacheParticleSystem( "muzzleflash_slug" )
PrecacheParticleSystem( "muzzleflash_slug_flame" )
PrecacheParticleSystem( "muzzleflash_pistol" )
PrecacheParticleSystem( "muzzleflash_pistol_cleric" )
PrecacheParticleSystem( "muzzleflash_pistol_deagle" )
PrecacheParticleSystem( "muzzleflash_suppressed" )
PrecacheParticleSystem( "muzzleflash_mp5" )
PrecacheParticleSystem( "muzzleflash_MINIMI" )
PrecacheParticleSystem( "muzzleflash_m79" )
PrecacheParticleSystem( "muzzleflash_m14" )
PrecacheParticleSystem( "muzzleflash_ak47" )
PrecacheParticleSystem( "muzzleflash_ak74" )
PrecacheParticleSystem( "muzzleflash_m82" )
PrecacheParticleSystem( "muzzleflash_m3" )
PrecacheParticleSystem( "muzzleflash_famas" )
PrecacheParticleSystem( "muzzleflash_g3" )
PrecacheParticleSystem( "muzzleflash_1" )
PrecacheParticleSystem( "muzzleflash_3" )
PrecacheParticleSystem( "muzzleflash_4" )
PrecacheParticleSystem( "muzzleflash_5" )
PrecacheParticleSystem( "muzzleflash_6" )

--- Builds our module loader.
-- @realm shared
-- @string path The path to the module.
function Plutonic.Framework.Link(path)
	Plutonic.Framework.Print("Loading " .. path .. "...")

	local files, directories = file.Find(path .. "/*", "LUA")

	for _, directory in pairs(directories) do
		Plutonic.Framework.Link(path .. "/" .. directory)
	end

	for _, f in pairs(files) do
		if string.sub(f, 1, 3) == "cl_" then
			if Plutonic.IsClient then
				include(path .. "/" .. f)
			else
				AddCSLuaFile(path .. "/" .. f)
			end
		elseif string.sub(f, 1, 3) == "sv_" then
			if Plutonic.IsServer then
				include(path .. "/" .. f)
			end
		elseif string.sub(f, 1, 3) == "sh_" then
			include(path .. "/" .. f)

			if Plutonic.IsServer then
				AddCSLuaFile(path .. "/" .. f)
			end
		end
	end
end

--- Builds our module loader. But this one targets specific realms.
-- @realm shared
-- @string path The path to the module.
-- @string realm The realm to target.
function Plutonic.Framework.LinkByRealm(path, realm)

	Plutonic.Framework.Print("Loading " .. path .. "...")

	local files, directories = file.Find(path .. "/*", "LUA")

	for _, directory in pairs(directories) do
		Plutonic.Framework.LinkByRealm(path .. "/" .. directory, realm)
	end
 
	for _, f in pairs(files) do
		Plutonic.Framework.Print("Including " .. f .. "...")
		if realm == "CLIENT" then
			if Plutonic.IsClient then
				include(path .. "/" .. f)
			else
				AddCSLuaFile(path .. "/" .. f)
			end
		elseif realm == "SERVER" then
			if Plutonic.IsServer then
				include(path .. "/" .. f)
			end
		elseif realm == "SHARED" then
			include(path .. "/" .. f)

			if Plutonic.IsServer then
				AddCSLuaFile(path .. "/" .. f)
			end
		end
	end
end

AddCSLuaFile("plutonic/framework/sh_hooks.lua")
include("plutonic/framework/sh_hooks.lua")
Plutonic.Framework.Link("plutonic/framework")
Plutonic.Framework.Link("plutonic/modules")

sound.Add({
	name = "Weapon_357.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapon/357/357_fire_player_01.wav",
		"weapon/357/357_fire_player_02.wav",
		"weapon/357/357_fire_player_03.wav",
		"weapon/357/357_fire_player_04.wav",
		"weapon/357/357_fire_player_05.wav",
		"weapon/357/357_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_357.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/357/357_fire_player_01.wav",
		")weapon/357/357_fire_player_02.wav",
		")weapon/357/357_fire_player_03.wav",
		")weapon/357/357_fire_player_04.wav",
		")weapon/357/357_fire_player_05.wav",
		")weapon/357/357_fire_player_06.wav"
	}
})

sound.Add({
	name = "Weapon_357.Cylinder_Open",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/357/handling/357_cylinder_open_01.wav"
})
sound.Add({
	name = "Weapon_357.Cylinder_Unload",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapon/357/handling/357_cylinder_unload_01.wav",
		"weapon/357/handling/357_cylinder_unload_02.wav",
		"weapon/357/handling/357_cylinder_unload_03.wav"
	}
})
sound.Add({
	name = "Weapon_357.Cylinder_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = {
		"weapon/357/handling/357_cylinder_load_01.wav",
		"weapon/357/handling/357_cylinder_load_02.wav",
		"weapon/357/handling/357_cylinder_load_03.wav"
	}
})
sound.Add({
	name = "Weapon_357.Cylinder_Close",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/357/handling/357_cylinder_close_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Fire",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/akm/akm_fire_player_01.wav",
		"weapon/akm/akm_fire_player_02.wav",
		"weapon/akm/akm_fire_player_03.wav",
		"weapon/akm/akm_fire_player_04.wav",
		"weapon/akm/akm_fire_player_05.wav",
		"weapon/akm/akm_fire_player_06.wav",
		"weapon/akm/akm_fire_player_07.wav",
		"weapon/akm/akm_fire_player_08.wav",
		"weapon/akm/akm_fire_player_09.wav",
		"weapon/akm/akm_fire_player_10.wav",
		"weapon/akm/akm_fire_player_11.wav",
		"weapon/akm/akm_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/akm/akm_fire_player_01.wav",
		")weapon/akm/akm_fire_player_02.wav",
		")weapon/akm/akm_fire_player_03.wav",
		")weapon/akm/akm_fire_player_04.wav",
		")weapon/akm/akm_fire_player_05.wav",
		")weapon/akm/akm_fire_player_06.wav",
		")weapon/akm/akm_fire_player_07.wav",
		")weapon/akm/akm_fire_player_08.wav",
		")weapon/akm/akm_fire_player_09.wav",
		")weapon/akm/akm_fire_player_10.wav",
		")weapon/akm/akm_fire_player_11.wav",
		")weapon/akm/akm_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_AKM.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_AKM.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/akm/handling/akm_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Fire",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapon/hmg/hmg_fire_player_01.wav",
		"weapon/hmg/hmg_fire_player_02.wav",
		"weapon/hmg/hmg_fire_player_03.wav",
		"weapon/hmg/hmg_fire_player_04.wav",
		"weapon/hmg/hmg_fire_player_05.wav",
		"weapon/hmg/hmg_fire_player_06.wav",
		"weapon/hmg/hmg_fire_player_07.wav",
		"weapon/hmg/hmg_fire_player_08.wav",
		"weapon/hmg/hmg_fire_player_09.wav",
		"weapon/hmg/hmg_fire_player_10.wav",
		"weapon/hmg/hmg_fire_player_11.wav",
		"weapon/hmg/hmg_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_HMG.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/hmg/hmg_fire_player_01.wav",
		")weapon/hmg/hmg_fire_player_02.wav",
		")weapon/hmg/hmg_fire_player_03.wav",
		")weapon/hmg/hmg_fire_player_04.wav",
		")weapon/hmg/hmg_fire_player_05.wav",
		")weapon/hmg/hmg_fire_player_06.wav",
		")weapon/hmg/hmg_fire_player_07.wav",
		")weapon/hmg/hmg_fire_player_08.wav",
		")weapon/hmg/hmg_fire_player_09.wav",
		")weapon/hmg/hmg_fire_player_10.wav",
		")weapon/hmg/hmg_fire_player_11.wav",
		")weapon/hmg/hmg_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_HMG.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Bolt_Slap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_bolt_slap_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_HMG.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/hmg/handling/hmg_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_fire_player_01.wav",
		"weapon/oicw/oicw_fire_player_02.wav",
		"weapon/oicw/oicw_fire_player_03.wav",
		"weapon/oicw/oicw_fire_player_04.wav",
		"weapon/oicw/oicw_fire_player_05.wav",
		"weapon/oicw/oicw_fire_player_06.wav",
		"weapon/oicw/oicw_fire_player_07.wav",
		"weapon/oicw/oicw_fire_player_08.wav",
		"weapon/oicw/oicw_fire_player_09.wav",
		"weapon/oicw/oicw_fire_player_10.wav",
		"weapon/oicw/oicw_fire_player_11.wav",
		"weapon/oicw/oicw_fire_player_12.wav"
	}
})
sound.Add({
	name = "Weapon_OICW.Fire_Alt",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 80,
	pitch = {97, 103},
	sound = {
		"weapon/oicw/oicw_20mm_fire1.wav",
		"weapon/oicw/oicw_20mm_fire2.wav",
		"weapon/oicw/oicw_20mm_fire3.wav"
	}
})

sound.Add({
	name = "Weapon_OICW.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/oicw/oicw_fire_player_01.wav",
		")weapon/oicw/oicw_fire_player_02.wav",
		")weapon/oicw/oicw_fire_player_03.wav",
		")weapon/oicw/oicw_fire_player_04.wav",
		")weapon/oicw/oicw_fire_player_05.wav",
		")weapon/oicw/oicw_fire_player_06.wav",
		")weapon/oicw/oicw_fire_player_07.wav",
		")weapon/oicw/oicw_fire_player_08.wav",
		")weapon/oicw/oicw_fire_player_09.wav",
		")weapon/oicw/oicw_fire_player_10.wav",
		")weapon/oicw/oicw_fire_player_11.wav",
		")weapon/oicw/oicw_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_OICW.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Mag_Slap",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_mag_slap_01.wav"
})
sound.Add({
	name = "Weapon_OICW.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	sound = "weapon/oicw/handling/oicw_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_Pistol.Fire",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 79,
	pitch = {98, 102},
	sound = {
		"weapon/pistol/pistol_fire_player_01.wav",
		"weapon/pistol/pistol_fire_player_02.wav",
		"weapon/pistol/pistol_fire_player_03.wav",
		"weapon/pistol/pistol_fire_player_04.wav",
		"weapon/pistol/pistol_fire_player_05.wav",
		"weapon/pistol/pistol_fire_player_06.wav",
	}
})

sound.Add({
	name = "Weapon_Pistol.NPC_Fire",
	channel = CHAN_WEAPON,
	level = SNDLVL_GUNFIRE,
	pitch = {98, 102},
	sound = {
		"^weapon/pistol/pistol_fire_npc_01.wav",
		"^weapon/pistol/pistol_fire_npc_02.wav",
		"^weapon/pistol/pistol_fire_npc_03.wav",
		"^weapon/pistol/pistol_fire_npc_04.wav",
		"^weapon/pistol/pistol_fire_npc_05.wav",
		"^weapon/pistol/pistol_fire_npc_06.wav"
	}
})

sound.Add({
	name = "Weapon_Pistol.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 60,
	sound = "weapon/pistol/handling/pistol_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_Pistol.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 60,
	sound = "weapon/pistol/handling/pistol_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_Pistol.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 60,
	sound = "weapon/pistol/handling/pistol_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_Pistol.Slide_release",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 60,
	sound = "weapon/pistol/handling/pistol_slide_release_01.wav"
})

sound.Add({
	name = "Weapon_HEV.Pistol_Draw",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 60,
	sound = {
		"fx/hev_suit/hev_draw_pistol_01.wav",
		"fx/hev_suit/hev_draw_pistol_02.wav",
		"fx/hev_suit/hev_draw_pistol_03.wav"
	}
})
sound.Add({
	name = "Weapon_Shotgun.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/shotgun_fire_player_01.wav",
		"weapon/shotgun/shotgun_fire_player_02.wav",
		"weapon/shotgun/shotgun_fire_player_03.wav",
	}
})
sound.Add({
	name = "Weapon_Shotgun.Fire_Alt",
	channel = CHAN_STATIC,
	volume = 0.85,
	level = 79,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/shotgun_fire_alt_player_01.wav",
		"weapon/shotgun/shotgun_fire_alt_player_02.wav",
		"weapon/shotgun/shotgun_fire_alt_player_03.wav"
	}
})

sound.Add({
	name = "Weapon_Shotgun.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/shotgun/shotgun_fire_player_01.wav",
		")weapon/shotgun/shotgun_fire_player_02.wav",
		")weapon/shotgun/shotgun_fire_player_03.wav",
	}
})

sound.Add({
	name = "Weapon_Shotgun.Pump_Back",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/handling/shotgun_bolt_back_01.wav",
		"weapon/shotgun/handling/shotgun_bolt_back_02.wav",
		"weapon/shotgun/handling/shotgun_bolt_back_03.wav"
	}
})
sound.Add({
	name = "Weapon_Shotgun.Pump_Forward",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/handling/shotgun_bolt_forward_01.wav",
		"weapon/shotgun/handling/shotgun_bolt_forward_02.wav",
		"weapon/shotgun/handling/shotgun_bolt_forward_03.wav"
	}
})
sound.Add({
	name = "Weapon_Shotgun.Shell_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/handling/shotgun_shell_futz_01.wav",
		"weapon/shotgun/handling/shotgun_shell_futz_02.wav",
		"weapon/shotgun/handling/shotgun_shell_futz_03.wav",
		"weapon/shotgun/handling/shotgun_shell_futz_04.wav",
		"weapon/shotgun/handling/shotgun_shell_futz_05.wav",
		"weapon/shotgun/handling/shotgun_shell_futz_06.wav"
	}
})
sound.Add({
	name = "Weapon_Shotgun.Shell_Load",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/shotgun/handling/shotgun_shell_load_01.wav",
		"weapon/shotgun/handling/shotgun_shell_load_02.wav",
		"weapon/shotgun/handling/shotgun_shell_load_03.wav"
	}
})
sound.Add({
	name = "Weapon_SMG1.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 60,
	pitch = {97, 103},
	sound = {
		"weapon/smg1/smg1_fire_player_01.wav",
		"weapon/smg1/smg1_fire_player_02.wav",
		"weapon/smg1/smg1_fire_player_03.wav",
		"weapon/smg1/smg1_fire_player_04.wav",
		"weapon/smg1/smg1_fire_player_05.wav",
		"weapon/smg1/smg1_fire_player_06.wav",
		"weapon/smg1/smg1_fire_player_07.wav",
		"weapon/smg1/smg1_fire_player_08.wav",
		"weapon/smg1/smg1_fire_player_09.wav",
		"weapon/smg1/smg1_fire_player_10.wav",
		"weapon/smg1/smg1_fire_player_11.wav",
		"weapon/smg1/smg1_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_SMG1.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {97, 103},
	sound = {
		")weapon/smg1/smg1_fire_player_01.wav",
		")weapon/smg1/smg1_fire_player_02.wav",
		")weapon/smg1/smg1_fire_player_03.wav",
		")weapon/smg1/smg1_fire_player_04.wav",
		")weapon/smg1/smg1_fire_player_05.wav",
		")weapon/smg1/smg1_fire_player_06.wav",
		")weapon/smg1/smg1_fire_player_07.wav",
		")weapon/smg1/smg1_fire_player_08.wav",
		")weapon/smg1/smg1_fire_player_09.wav",
		")weapon/smg1/smg1_fire_player_10.wav",
		")weapon/smg1/smg1_fire_player_11.wav",
		")weapon/smg1/smg1_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_SMG1.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon/smg1/handling/smg1_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_SMG1.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon/smg1/handling/smg1_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_SMG1.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon/smg1/handling/smg1_mag_in_01.wav"
})
sound.Add({
	name = "Weapon_SMG1.Grip_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon/smg1/handling/smg1_grip_grab_01.wav"
})

sound.Add({
	name = "Weapon_HEV.SMG_Draw",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 60,
	sound = {
		"fx/hev_suit/hev_draw_smg_01.wav",
		"fx/hev_suit/hev_draw_smg_02.wav",
		"fx/hev_suit/hev_draw_smg_03.wav"
	}
})

sound.Add({
	name = "Weapon_SMG2.Fire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 60,
	pitch = {142, 148},
	sound = {
		"weapon/hmg/hmg_fire_player_01.wav",
		"weapon/hmg/hmg_fire_player_02.wav",
		"weapon/hmg/hmg_fire_player_03.wav",
		"weapon/hmg/hmg_fire_player_04.wav",
		"weapon/hmg/hmg_fire_player_05.wav",
		"weapon/hmg/hmg_fire_player_06.wav",
		"weapon/hmg/hmg_fire_player_07.wav",
		"weapon/hmg/hmg_fire_player_08.wav",
		"weapon/hmg/hmg_fire_player_09.wav",
		"weapon/hmg/hmg_fire_player_10.wav",
		"weapon/hmg/hmg_fire_player_11.wav",
		"weapon/hmg/hmg_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_SMG2.NPC_Fire",
	channel = CHAN_WEAPON,
	volume = 0.75,
	level = SNDLVL_GUNFIRE,
	pitch = {142, 148},
	sound = {
		")weapon/hmg/hmg_fire_player_01.wav",
		")weapon/hmg/hmg_fire_player_02.wav",
		")weapon/hmg/hmg_fire_player_03.wav",
		")weapon/hmg/hmg_fire_player_04.wav",
		")weapon/hmg/hmg_fire_player_05.wav",
		")weapon/hmg/hmg_fire_player_06.wav",
		")weapon/hmg/hmg_fire_player_07.wav",
		")weapon/hmg/hmg_fire_player_08.wav",
		")weapon/hmg/hmg_fire_player_09.wav",
		")weapon/hmg/hmg_fire_player_10.wav",
		")weapon/hmg/hmg_fire_player_11.wav",
		")weapon/hmg/hmg_fire_player_12.wav"
	}
})

sound.Add({
	name = "Weapon_SMG2.Bolt_Grab",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/hmg/handling/hmg_bolt_grab_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {97, 103},
	sound = "weapon//handling/.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Pull",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/akm/handling/akm_bolt_pull_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Lock",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 130,
	sound = "weapon/hmg/handling/hmg_bolt_lock_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Bolt_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_bolt_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Release",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_release_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Out",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_out_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_Futz",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_futz_01.wav"
})
sound.Add({
	name = "Weapon_SMG2.Mag_In",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = 125,
	sound = "weapon/akm/handling/akm_mag_in_01.wav"
})