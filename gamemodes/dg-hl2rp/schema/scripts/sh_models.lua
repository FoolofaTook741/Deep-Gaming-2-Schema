impulse.Anim.ca = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_ANGRY, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN}
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_RANGE_ATTACK_PISTOL},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_ATTACK_PISTOL_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		reload = ACT_RELOAD_PISTOL
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1
	},
	ar2 = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_SMG1,
		reload = ACT_GESTURE_RELOAD_SMG1
	},
	shotgun = { 
		[ACT_MP_STAND_IDLE] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		attack = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_RANGE_AIM_SMG1_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_RIFLE_STIMULATED},
		attack = ACT_RANGE_ATTACK_THROW
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		[ACT_MP_CROUCH_IDLE] = {ACT_COVER_LOW, ACT_COVER_LOW},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		attack = ACT_MELEE_ATTACK_SWING
	},
	glide = ACT_GLIDE,
	vehicle = {
		["prop_vehicle_prisoner_pod"] = {"podpose", Vector(-3, 0, 0)},
		["prop_vehicle_jeep"] = {ACT_BUSY_SIT_CHAIR, Vector(14, 0, -14)},
		["prop_vehicle_airboat"] = {ACT_BUSY_SIT_CHAIR, Vector(8, 0, -20)},
		chair = {ACT_BUSY_SIT_CHAIR, Vector(1, 0, -23)}
	},
}

impulse.Anim.stalker = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle01", "idle01"},
		[ACT_MP_CROUCH_IDLE] = {"console_work_loop", "console_work_loop"},
		[ACT_MP_WALK] = {"walk_all", "walk_all"},
		[ACT_MP_CROUCHWALK] = {"walk_all", "walk_all"},
		[ACT_MP_RUN] = {"walk_all", "walk_all"}
	},

}

impulse.Anim.advisor = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle01", "idle01"},
		[ACT_MP_CROUCH_IDLE] = {"idle01", "idle01"},
		[ACT_MP_WALK] = {"back", "back"},
		[ACT_MP_CROUCHWALK] = {"back", "back"},
		[ACT_MP_RUN] = {"back", "back"},
	},
}

impulse.Anim.hunter = {
	normal = {
		[ACT_MP_STAND_IDLE] = {"idle1", "idle2"},
		[ACT_MP_CROUCH_IDLE] = {"idle1", "idle2"},
		[ACT_MP_WALK] = {"walk_all", "walk_all"},
		[ACT_MP_CROUCHWALK] = {"walk_all", "walk_all"},
		[ACT_MP_RUN] = {"canter_all", "canter_all"},
		[ACT_LAND] = {"jump_land", "jump_land"},
		[ACT_JUMP] = {"jump", "jump"}
	},
}

hook.Add("LoadAnimationClasses", "impulseHL2RPAnimClasses", function()
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/hdpolice.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/civil_medic.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/hl2beta_police.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/retrocop.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/elite_police.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/phoenix_police.mdl", "metrocop") -- 
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/police_bt.mdl", "metrocop") 
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/policetrench.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/hl2concept.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/blacop.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_coordinator_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_urban_shotgunner_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_border_patrol_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_h.mdl","overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_elite_h.mdl","overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_recon_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/cfe_ragdoll/cfe_female_ragdoll/cfe_female_01_ragdoll.mdl","metrocop")
	impulse.Anim.SetModelClass("models/cfe_ragdoll/cfe_male_ragdoll/cfe_male_01_ragdoll.mdl","metrocop")
	impulse.Anim.SetModelClass("models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl","overwatch")
	impulse.Anim.SetModelClass("models/vortiblue1.mdl", "vort")
	impulse.Anim.SetModelClass("models/willardnetworks/vortigaunt.mdl", "vort")
	impulse.Anim.SetModelClass("models/jq/hlvr/characters/combine/combine_captain/combine_captain_hlvr_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/jq/hlvr/characters/combine_soldier/combine_soldier_new_content_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/jq/hlvr/characters/combine_soldier/combine_soldier_new_content_super_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/jq/theparrygod/transition_period_overwatch_soldier_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/hlvr/human/corpse/zombie/zombie_common_2.mdl", "zombie")
	impulse.Anim.SetModelClass("models/wn/ordinal.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/humans/suitfem/female_02.mdl","ca")
	impulse.Anim.SetModelClass("models/taggart/gallahan.mdl","ca")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_01.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_02.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_03.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_04.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_05.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_06.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_07.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_08.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_09.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/male_10.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn7new/metropolice/female_01.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/earlbolat_customs/npc/vlk_male_1.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_recon_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_elite_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_urban_shotgunner_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_urban_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_coordinator_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/wn/suppressor.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/wn/soldier.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/jq/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/wn/ota_elite_summit.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_elite_wpu_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/theparrygod/transition_shotgunner_npc.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/cultist/hl_a/combine_grunt/npc/combine_grunt.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/cultist/hl_a/combine_commander/npc/combine_commander.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/dpfilms/metropolice/resistance_police.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/wn/dg/ordinal.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/nemez/combine_soldiers/combine_soldier_nova_h.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/hlvr/characters/combine_captain_night/combine_captain_night.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/wn/wallhammer.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/stalker.mdl", "stalker")
	impulse.Anim.SetModelClass("models/renderng_regression_test_hunter.mdl", "hunter")
	impulse.Anim.SetModelClass("models/hunter.mdl", "hunter")
	impulse.Anim.SetModelClass("models/advisor.mdl", "advisor")
	impulse.Anim.SetModelClass("models/transition/soldiers/ordinal-eow/ordinal-eow.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/transition/soldiers/suppressor-eow/suppressor-eow.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/transition/soldiers/transition-suppressor/transition-suppressor.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/transition/soldiers/transition-wallhammer/transition-wallhammer.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/transition/soldiers/wallhammer-eow/wallhammer-eow.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/transition/soldiers/transition-ordinal/transition-ordinal.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/ma/hla/terranovapolice.mdl", "metrocop")
	impulse.Anim.SetModelClass("models/willardupgrades/civilprotection.mdl", "metrocop")
end)