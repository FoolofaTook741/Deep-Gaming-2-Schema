local function AddParticles()
	game.AddParticles("particles/weapon_hgun.pcf") -- idk why its dont work
	game.AddParticles("particles/weapon_tau.pcf")
	game.AddParticles("particles/weapon_egon.pcf")
	game.AddParticles("particles/weapon_hgun.pcf")
	game.AddParticles("particles/weapon_rpg.pcf")
	game.AddParticles("particles/weapon_magnum.pcf")
	game.AddParticles("particles/weapon_glock.pcf")
	game.AddParticles("particles/weapon_mp5.pcf")
	game.AddParticles("particles/weapon_shotgun.pcf")
	game.AddParticles("particles/weapon_tracer.pcf")
	game.AddParticles("particles/grenade_rpg.pcf")
	
	PrecacheParticleSystem("tau_beam")
	PrecacheParticleSystem("tau_beam_balls")
	PrecacheParticleSystem("tau_beam_balls_bounce")
	PrecacheParticleSystem("tau_beam_dis_view")
	PrecacheParticleSystem("tau_beam_fade")
	PrecacheParticleSystem("tau_beam_glow")
	PrecacheParticleSystem("tau_beam_gw")
	PrecacheParticleSystem("tau_beam_gw_view")
	PrecacheParticleSystem("tau_beam_overcharge")
	PrecacheParticleSystem("tau_beam_view")
	PrecacheParticleSystem("tau_beam_view_fade")
	PrecacheParticleSystem("tau_charge")
	PrecacheParticleSystem("tau_charge_big_coil_electric")
	PrecacheParticleSystem("tau_charge_big_coil_glow")
	PrecacheParticleSystem("tau_charge_explode")
	PrecacheParticleSystem("tau_charge_explode_bolts")
	PrecacheParticleSystem("tau_charge_explode_clouds")
	PrecacheParticleSystem("tau_charge_explode_outer")
	PrecacheParticleSystem("tau_charge_fire")
	PrecacheParticleSystem("tau_charge_small_coil_glow")
	PrecacheParticleSystem("tau_charge_smoke")
	PrecacheParticleSystem("tau_fire")
	PrecacheParticleSystem("tau_fully_charged")
	PrecacheParticleSystem("tau_fully_charged_outer_1")
	PrecacheParticleSystem("tau_fully_charged_outer_2")
	PrecacheParticleSystem("tau_fully_charged_outer_3")
	PrecacheParticleSystem("tau_spark")
	PrecacheParticleSystem("tau_spark_2")
	PrecacheParticleSystem("tau_wave")

	PrecacheParticleSystem("gluon_beam_burst")
	PrecacheParticleSystem("gluon_beam_burst_glow")
	PrecacheParticleSystem("gluon_beam_burst_glow_thirdperson")
	PrecacheParticleSystem("gluon_beam_burst_thirdperson")
	PrecacheParticleSystem("gluon_beam_end")
	PrecacheParticleSystem("gluon_beam_end_small_particles_thirdperson")
	PrecacheParticleSystem("gluon_beam_end_thirdperson")
	PrecacheParticleSystem("gluon_beam_fake_ray")
	PrecacheParticleSystem("gluon_beam_fake_ray_thirdperson")
	PrecacheParticleSystem("gluon_beam_forward")
	PrecacheParticleSystem("gluon_beam_forward_thirdperson")
	PrecacheParticleSystem("gluon_beam_magic_flies")
	PrecacheParticleSystem("gluon_beam_magic_flies_thirdperson")
	PrecacheParticleSystem("gluon_beam_startup")
	PrecacheParticleSystem("gluon_beam_startup_glow")
	PrecacheParticleSystem("gluon_beam_startup_glow_bits")
	PrecacheParticleSystem("gluon_beam_startup_glow_bits_thirdperson")
	PrecacheParticleSystem("gluon_beam_startup_glow_thirdperson")
	PrecacheParticleSystem("gluon_beam_startup_sparkle")
	PrecacheParticleSystem("gluon_beam_startup_sparkle_thirdperson")
	PrecacheParticleSystem("gluon_beam_startup_thirdperson")
	PrecacheParticleSystem("gluon_beam_startup_warp")
	PrecacheParticleSystem("gluon_beam_startup_warp_thirdperson")

	PrecacheParticleSystem("weapon_rpg_muzzleflash")
	PrecacheParticleSystem("world_weapon_rpg_muzzleflash")

	PrecacheParticleSystem("grenade_rpg_fire2")
	PrecacheParticleSystem("grenade_rpg_rope_trail")
	PrecacheParticleSystem("grenade_rpg_trail")
	PrecacheParticleSystem("grenade_rpg_trail_fire")
	PrecacheParticleSystem("grenade_rpg_trail_inner2")

	PrecacheParticleSystem("muzle_smoke_2_357")
	PrecacheParticleSystem("muzzle_core_357")
	PrecacheParticleSystem("muzzle_glow_357")
	PrecacheParticleSystem("muzzle_smoke_357")
	PrecacheParticleSystem("weapon_257_muzzle_flash")
	PrecacheParticleSystem("weapon_357_muzzle_spark")
	PrecacheParticleSystem("weapon_357_muzzle_trail")
	PrecacheParticleSystem("weapon_357_muzzleflash")
	PrecacheParticleSystem("wispy_smoke")
	PrecacheParticleSystem("wispy_smoke_orig")
	PrecacheParticleSystem("world_muzzle_357_trail")
	PrecacheParticleSystem("world_muzzle_core_357")
	PrecacheParticleSystem("world_muzzle_glow_357")
	PrecacheParticleSystem("world_muzzle_smoke_357")
	PrecacheParticleSystem("world_weapon_357_muzzleflash")
	PrecacheParticleSystem("world_weapon_357_spark")

	PrecacheParticleSystem("weapon_glock_muzzle")
	PrecacheParticleSystem("weapon_glock_muzzle_glow")
	PrecacheParticleSystem("weapon_glock_muzzle_smoke")
	PrecacheParticleSystem("weapon_glock_muzzleflash")
	PrecacheParticleSystem("weapon_glock_smoke")
	PrecacheParticleSystem("weapon_glock_sparks")
	PrecacheParticleSystem("world_weapon_glock")
	PrecacheParticleSystem("world_weapon_glock_muzzle_glow")
	PrecacheParticleSystem("world_weapon_glock_muzzleflash")
	PrecacheParticleSystem("world_weapon_glock_smoke")
	PrecacheParticleSystem("world_weapon_glock_sparks")

	PrecacheParticleSystem("muzzle_glow_large")
	PrecacheParticleSystem("muzzle_glow_mp5")
	PrecacheParticleSystem("muzzle_inner")
	PrecacheParticleSystem("muzzle_side")
	PrecacheParticleSystem("muzzle_side_glow")
	PrecacheParticleSystem("muzzle_smoke_mp5")
	PrecacheParticleSystem("muzzle_smoke_mp5_dark")
	PrecacheParticleSystem("muzzle_smoke_mp5_flash")
	PrecacheParticleSystem("muzzle_sparks_mp5")
	PrecacheParticleSystem("muzzle_top")
	PrecacheParticleSystem("muzzle_top_glow")
	PrecacheParticleSystem("muzzle_top_left_glow")
	PrecacheParticleSystem("weapon_357_muzzle_spark")
	PrecacheParticleSystem("weapon_mp5_muzzleflash")
	PrecacheParticleSystem("world_muzzle_core_mp5")
	PrecacheParticleSystem("world_muzzle_glow_mp5")
	PrecacheParticleSystem("world_muzzle_smoke_mp5")
	PrecacheParticleSystem("world_muzzle_sparks_mp5")
	PrecacheParticleSystem("world_weapon_mp5_muzzleflash")

	PrecacheParticleSystem("weapon_tracer")--maybe
	PrecacheParticleSystem("weapon_tracer_50cal")
	PrecacheParticleSystem("weapon_tracer_small")

	PrecacheParticleSystem("muzzle_bits_shotgun")
	PrecacheParticleSystem("muzzle_core_shotgun")
	PrecacheParticleSystem("muzzle_glow_shotgun")
	PrecacheParticleSystem("muzzle_inner_shotgun")
	PrecacheParticleSystem("muzzle_smoke_shotgun")
	PrecacheParticleSystem("muzzle_smoke_shotgun_flash")
	PrecacheParticleSystem("muzzle_sparks")
	PrecacheParticleSystem("muzzle_sparks_fly")
	PrecacheParticleSystem("muzzle_sparks_shotgun")
	PrecacheParticleSystem("muzzle_sparks_shotgun2")
	PrecacheParticleSystem("muzzle_sparks_shotgun3")
	PrecacheParticleSystem("weapon_shotgun_muzzleflash")
	PrecacheParticleSystem("world_muzzle_bits_shotgun")
	PrecacheParticleSystem("world_muzzle_core_shotgun")
	PrecacheParticleSystem("world_muzzle_glow_shotgun")
	PrecacheParticleSystem("world_muzzle_smoke_shotgun")
	PrecacheParticleSystem("world_muzzle_sparks_shotgun")
	PrecacheParticleSystem("world_weapon_shotgun_muzzleflash")

	PrecacheParticleSystem("weapon_hgun_vent_rope")
	PrecacheParticleSystem("weapon_hgun_muzzle_sprut")
	PrecacheParticleSystem("weapon_hgun_muzzle_sprut_3d")
	PrecacheParticleSystem("weapon_hgun_muzzleflash")
	PrecacheParticleSystem("weapon_hgun_muzzleflash_3rd")
	PrecacheParticleSystem("weapon_hgun_muzzleflash_light_1")
	PrecacheParticleSystem("weapon_hgun_muzzleflash_light_3d")
	PrecacheParticleSystem("weapon_hgun_smoke")
	PrecacheParticleSystem("weapon_hgun_smoke_3rd")
	PrecacheParticleSystem("weapon_hgun_vent_fire")
	PrecacheParticleSystem("weapon_hgun_vent_light")
	PrecacheParticleSystem("weapon_hgun_vent_spark")

end
pcall(AddParticles)

hook.Add( "Initialize", "AddBMSWalAmmo", function()
	--[[
	game.AddAmmoType({name = "energyammo"})
	game.AddAmmoType({name = "hgun_hornet"})
	game.AddAmmoType({name = "bmsw_tripmine"})
	]]
	game.AddAmmoType({
		name = "energyammo",
		maxcarry = 100
	})
	game.AddAmmoType({
		name = "hgun_hornet",
		maxcarry = 8
	})
	game.AddAmmoType({
		name = "bmsw_tripmine",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_satchel",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_grenade",
		maxcarry = 15
	})
	game.AddAmmoType({
		name = "bmsw_snark",
		maxcarry = 15
	})
	game.AddAmmoType({
		name = "bmsw_rpgmissile",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_357",
		maxcarry = 18
	})
	game.AddAmmoType({
		name = "bmsw_9mm",
		maxcarry = 150
	})
	game.AddAmmoType({
		name = "bmsw_mp5g",
		maxcarry = 10
	})
	game.AddAmmoType({
		name = "bmsw_shotgun",
		maxcarry = 48
	})

	game.AddAmmoType({
		name = "bmsw_crossbow",
		maxcarry = 48
	})
end)

local function AddCustomAmmo()
	game.AddAmmoType({
		name = "energyammo",
		maxcarry = 100
	})
	game.AddAmmoType({
		name = "hgun_hornet",
		maxcarry = 8
	})
	game.AddAmmoType({
		name = "bmsw_tripmine",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_satchel",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_grenade",
		maxcarry = 15
	})
	game.AddAmmoType({
		name = "bmsw_snark",
		maxcarry = 15
	})
	game.AddAmmoType({
		name = "bmsw_rpgmissile",
		maxcarry = 5
	})
	game.AddAmmoType({
		name = "bmsw_357",
		maxcarry = 18
	})
	game.AddAmmoType({
		name = "bmsw_9mm",
		maxcarry = 150
	})
	game.AddAmmoType({
		name = "bmsw_mp5g",
		maxcarry = 10
	})
	game.AddAmmoType({
		name = "bmsw_shotgun",
		maxcarry = 48
	})

	game.AddAmmoType({
		name = "bmsw_crossbow",
		maxcarry = 48
	})
end

timer.Simple(1, function()
	pcall(AddCustomAmmo) -- make sure they added
end)