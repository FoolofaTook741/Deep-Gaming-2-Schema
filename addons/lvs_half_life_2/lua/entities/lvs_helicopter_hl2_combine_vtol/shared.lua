ENT.Base = "lvs_base_helicopter"
ENT.PrintName = "Combine VTOL"
ENT.Author = "Riggs"
ENT.Information = ""
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/combinevtol.png"

ENT.AITEAM = 1
ENT.AdminSpawnable = false
ENT.DisableBallistics = true
ENT.ForceAngleDampingMultiplier = 1
ENT.ForceAngleMultiplier = 1
ENT.ForceLinearDampingMultiplier = 1.5
ENT.GibModels = {"models/gibs/helicopter_brokenpiece_01.mdl", "models/gibs/helicopter_brokenpiece_02.mdl", "models/gibs/helicopter_brokenpiece_03.mdl", "models/gibs/helicopter_brokenpiece_06_body.mdl", "models/gibs/helicopter_brokenpiece_04_cockpit.mdl", "models/gibs/helicopter_brokenpiece_05_tailfan.mdl"}
ENT.MDL = "models/ludex/mirrors_edge_catalyst/vtol_attack_ragdoll.mdl"
ENT.MaxHealth = 1400
ENT.MaxVelocity = 1500
ENT.Spawnable = file.Exists("models/ludex/mirrors_edge_catalyst/vtol_attack_ragdoll.mdl", "GAME") 
ENT.ThrottleRateDown = 0.1
ENT.ThrottleRateUp = 0.1
ENT.ThrustDown = 0.5
ENT.ThrustRate = 0.5
ENT.ThrustUp = 0.5
ENT.TurnRatePitch = 0.25
ENT.TurnRateRoll = 0.5
ENT.TurnRateYaw = 0.5
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Combine"

ENT.EngineSounds = {
	{
		sound = "^lvs/halflife2/helicopters/rotor_2.wav",
		sound_int = "lvs/halflife2/helicopters/wind_2.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 75,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 100,
		UseDoppler = true,
	},
	{
		sound = "lvs/halflife2/helicopters/wind_2.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 80,
		UseDoppler = true,
	},
}
