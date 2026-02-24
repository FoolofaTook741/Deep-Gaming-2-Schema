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

	--Citizen Anims
	for i = 1, 10 do
		impulse.Anim.SetModelClass((i != 10 and "models/willardnetworks/citizens/male_0" .. i or "models/willardnetworks/citizens/male_10") .. ".mdl", "citizen_male")
		impulse.Anim.SetModelClass(i != 10 and "models/willardnetworks/conscripts/male_0" .. i .. ".mdl" or "models/willardnetworks/conscripts/male_10" .. ".mdl", "citizen_male")
	end

	for i = 1, 6 do
		impulse.Anim.SetModelClass("models/willardnetworks/citizens/female_0" .. i .. ".mdl", "citizen_female")
		impulse.Anim.SetModelClass("models/willardnetworks/conscripts/female_0" .. i .. ".mdl", "citizen_female")
	end

	--CTA Anims
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_grunt/combine_grunt.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_etl/dg_etl.mdl", "overwatch")

	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier_coordinator.mdl", "overwatch")
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_mace/dg_combine_mace.mdl", "overwatch") 
	impulse.Anim.SetModelClass("models/DG_models/DG_combinepack/DG_ranger/dg_combine_ranger.mdl", "overwatch")

	--MPF Anims
	for i = 1, 9 do
		impulse.Anim.SetModelClass("models/wn7new/metropolice/male_0" .. i .. ".mdl", "metrocop")
	end

	--MISC ANIMS
	impulse.Anim.SetModelClass("models/hunter.mdl", "hunter")
	impulse.Anim.SetModelClass("models/advisor.mdl", "advisor")

	--Vort Anims
	impulse.Anim.SetModelClass("models/willardnetworks/vortigaunt.mdl", "vort")
end)