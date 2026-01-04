--HiveHand
sound.Add({
	name = "weapon_hivehand.Burst",
	channel = CHAN_BODY,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/hivehand/bug_impact.wav",
})

sound.Add({
	name = "weapon_hivehand.Empty",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/hivehand/empty.wav",
})

sound.Add({
	name = "weapon_hivehand.Single",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/hivehand/single.wav",
})

sound.Add({
	name = "weapon_hivehand.Buzz",
	channel = CHAN_WEAPON,
    pitch	= math.random(95,105),
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/hivehand/buzz.wav",
})

sound.Add({
	name = "weapon_hivehand.Single_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_85dB,
	sound = "^weapons/hivehand/single.wav",
})

sound.Add({
	name = "weapon_hivehand.Double",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/hivehand/single.wav",
})

sound.Add({
	name = "weapon_hivehand.Double_NPC",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/hivehand/single.wav",
})

sound.Add({
	name = "weapon_hivehand.BackgroundLoop",
	channel = CHAN_VOICE,
	volume = 0.22,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/hivehand/background.wav",
})

sound.Add({
	name = "weapon_hivehand.Pickup",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/hivehand/pickup.wav",
})

--TripMine

sound.Add({
	name = "grenade_tripmine.Activate",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_95dB,
	sound = ")weapons/tripmine/activate.wav",
})

sound.Add({
	name = "grenade_tripmine.WarmUp",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_90dB,
	sound = "^weapons/tripmine/warmup.wav",
})

sound.Add({
	name = "grenade_tripmine.draw_admire01",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/tripmine/draw_admire01.wav",
})

sound.Add({
	name = "grenade_tripmine.idle_fidget01",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/tripmine/idle01.wav",
})


--Satchel

sound.Add({
	name = "weapon_satchel.Double",
	channel = CHAN_WEAPON,
	volume = 0.45,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/satchel/double.wav",
})

sound.Add({
	name = "weapon_satchel.Single",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/satchel/single"..math.random(1,3)..".wav",
})

sound.Add({
	name = "weapon_satchel.Single_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/satchel/single_npc.wav",
})

--Frag grenade

sound.Add({
	name = "weapon_frag.Single",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/grenade/single.wav",
})

sound.Add({
	name = "weapon_frag.Special1",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/grenade/special1.wav",
})

sound.Add({
	name = "weapon_frag.DrawAdmire",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/grenade/draw_admire.wav",
})

sound.Add({
	name = "weapon_frag.Fidget",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/grenade/idle_fidget.wav",
})

--Snark

sound.Add({
	name = "weapon_snark.Single",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/snark/single1.wav",
})

sound.Add({
	name = "weapon_snark.draw_admire01",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/snark/draw_admire01.wav",
})

sound.Add({
	name = "npc_snark.Bite",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	pitch = math.random(95, 140),
	soundlevel = SNDLVL_80dB,
	sound = "npc/snark/bite0"..math.random(1,5)..".wav"
})

sound.Add({
	name = "npc_snark.Deploy",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	pitch = math.random(95, 107),
	soundlevel = SNDLVL_NORM,
	sound = "npc/snark/deploy"..math.random(1,3)..".wav",
})

sound.Add({
	name = "npc_snark.Die",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	pitch = PITCH_NORM,
	soundlevel = SNDLVL_80dB,
	sound = "npc/snark/die0"..math.random(1,4)..".wav"
})

sound.Add({
	name = "npc_snark.Explode",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	pitch = math.random(95, 115),
	soundlevel = SNDLVL_90dB,
	sound = "npc/snark/blast1.wav",
})

sound.Add({
	name = "npc_snark.Hunt",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	pitch = PITCH_NORM,
	soundlevel = SNDLVL_90dB,
	sound = "npc/snark/hunt"..math.random(1,4)..".wav"
})

--RPG

sound.Add({
	name = "grenade_tow.TrailLoop",
	channel = CHAN_WEAPON,
	pitch = 105,
	volume = VOL_NORM,
	soundlevel = 0.3,
	sound = "^weapons/rpg/ignite_trail.wav",
})

sound.Add({
	name = "weapon_rpg.Single2",
	channel = CHAN_WEAPON,
	volume = 0.53,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/rpg/single.wav",
})

sound.Add({
	name = "weapon_rpg.TrailLoop",
	channel = CHAN_WEAPON,
	pitch = PITCH_NORM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_105dB,
	sound = ")weapons/rpg/ignite_trail.wav",
})

sound.Add({
	name = "weapon_rpg.DrawAdmire",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/rpg/draw_admire.wav",
})

sound.Add({
	name = "weapon_rpg.Fidget",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/rpg/idle_fidget.wav",
})

sound.Add({
	name = "weapon_rpg.Reload",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/rpg/reload.wav",
})

--357

sound.Add({
	name = "weapon_357.draw_admire01",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/357/draw_admire01.wav",
})

sound.Add({
	name = "weapon_357.Empty",
	channel = CHAN_STATIC,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/357/empty.wav",
})

sound.Add({
	name = "weapon_357.Single2",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/357/single.wav",
})

sound.Add({
	name = "weapon_357.Double",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/357/single.wav",
})


sound.Add({
	name = "weapon_357.Single_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/357/single_npc.wav",
})

sound.Add({
	name = "weapon_357.Reload",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/357/reload.wav",
})

sound.Add({
	name = "weapon_357.Reload_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/357/reload_npc.wav",
})

--Glock 

sound.Add({
	name = "weapon_glock.Empty",
	channel = CHAN_STATIC,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/glock/empty.wav",
})

sound.Add({
	name = "weapon_glock.Admire",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/glock/draw_admire.wav",
})

sound.Add({
	name = "weapon_glock.Fidget",
	channel = CHAN_ITEM,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/glock/idle_fidget.wav",
})

sound.Add({
	name = "weapon_glock.Reload",
	channel = CHAN_ITEM,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/glock/reload.wav",
})

sound.Add({
	name = "weapon_glock.Reload.chambered",
	channel = CHAN_ITEM,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/glock/reload_roundchambered.wav",
})

sound.Add({
	name = "weapon_glock.Reload_NPC",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "^weapons/glock/reload.wav",
})


sound.Add({
	name = "weapon_glock.Single_Silent",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")npc/assassin/attack1.wav",
})

sound.Add({
	name = "weapon_glock.Single",
	channel = CHAN_WEAPON,
	volume = 0.9,
	pitch = math.random(105, 110),
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/glock/single.wav",
})

sound.Add({
	name = "weapon_glock.Single_NPC",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/glock/single.wav",
})

--MP5 

sound.Add({
	name = "weapon_mp5.Empty",
	channel = CHAN_STATIC,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/mp5/empty.wav",
})

sound.Add({
	name = "weapon_mp5.Double",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/mp5/double.wav",
})

sound.Add({
	name = "weapon_mp5.DrawAdmire",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/mp5/draw_admire.wav",
})

sound.Add({
	name = "weapon_mp5.IdleFidget",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/mp5/idle_fidget.wav",
})

sound.Add({
	name = "weapon_mp5.Reload",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/mp5/reload.wav",
})

sound.Add({
	name = "weapon_mp5.ReloadLong",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/mp5/reload_long.wav",
})

sound.Add({
	name = "weapon_mp5.Reload_NPC",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/mp5/reload_long.wav",
})

sound.Add({
	name = "weapon_mp5.Single",
	channel = CHAN_WEAPON,
	volume = 0.5,
	pitch = math.random(96, 105),
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/mp5/single"..math.random(1, 3)..".wav",
})

sound.Add({
	name = "weapon_mp5.Single_NPC",
	channel = CHAN_WEAPON,
	volume = 0.65,
	pitch = math.random(96, 104),
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/mp5/single_npc.wav",
})

--Shotgun


sound.Add({
	name = "weapon_shotgun.Double2",
	channel = CHAN_WEAPON,
	volume = 0.9,
	pitch = PITCH_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/shotgun/double.wav",
})

sound.Add({
	name = "weapon_shotgun.Double_NPC",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/shotgun/empty.wav",
})

sound.Add({
	name = "weapon_shotgun.draw_admire01",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_GUNFIRE,
	sound = ")weapons/shotgun/draw_admire01.wav",
})

sound.Add({
	name = "weapon_shotgun.Empty",
	channel = CHAN_STATIC,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/shotgun/empty.wav",
})

sound.Add({
	name = "weapon_shotgun.Reload",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/shotgun/reload"..math.random(1, 3)..".wav",
})

sound.Add({
	name = "weapon_shotgun.Reload_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "^weapons/shotgun/reload_npc.wav",
})

sound.Add({
	name = "weapon_shotgun.Single2",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/shotgun/single.wav",
})

sound.Add({
	name = "weapon_shotgun.Reload_NPC",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = "^weapons/shotgun/single_npc.wav",
})

sound.Add({
	name = "weapon_shotgun.Special1",
	channel = CHAN_ITEM,
	volume = 0.40,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/shotgun/pump.wav",
})

--Crowbar
sound.Add({
	name = "weapon_crowbar.Melee_Miss",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	pitch = math.random(95, 110),
	sound = ")weapons/crowbar/melee_miss"..math.random(1,2)..".wav",
})

sound.Add({
	name = "weapon_crowbar.Melee_Hit",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crowbar/melee_hit"..math.random(1,3)..".wav",
})

--Crossbow

sound.Add({
	name = "weapon_crossbow.Empty",
	channel = CHAN_STATIC,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/empty.wav"
})

sound.Add({
	name = "weapon_crossbow.Fidget",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/idle_fidget.wav"
})

sound.Add({
	name = "weapon_crossbow.Reload",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/reload_short.wav"
})

sound.Add({
	name = "weapon_crossbow.ReloadLong",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/reload_long.wav"
})

sound.Add({
	name = "weapon_crossbow.DrawAdmire",
	channel = CHAN_ITEM,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/draw_admire.wav"
})

sound.Add({
	name = "weapon_crossbow.Reload_NPC",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = "^weapons/crossbow/reload_npc.wav"
})

sound.Add({
	name = "weapon_crossbow.Single",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/single.wav"
})

sound.Add({
	name = "weapon_crossbow.SingleScoped",
	channel = CHAN_STATIC,
	volume = 0.8,
	soundlevel = SNDLVL_90db,
	pitch = math.random(90, 110),
	sound = "weapons/crossbow/bolt_skewer1.wav"
})

sound.Add({
	name = "weapon_crossbow.Single_NPC",
	channel = CHAN_WEAPON,
	volume = 0.9,
	soundlevel = SNDLVL_GUNFIRE,
	sound = "^weapons/crossbow/single_npc.wav"
})

sound.Add({
	name = "weapon_crossbow.Special1",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/single_noreload.wav"
})

sound.Add({
	name = "weapon_crossbow.DrawString",
	channel = CHAN_WEAPON,
	volume = VOL_NORM,
	soundlevel = SNDLVL_NORM,
	sound = ")weapons/crossbow/draw_string.wav"
})