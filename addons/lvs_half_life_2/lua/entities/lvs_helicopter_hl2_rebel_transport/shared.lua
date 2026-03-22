ENT.Base = "lvs_base_helicopter"
ENT.PrintName = "Rebel Transport Helicopter"
ENT.Author = "Luna"
ENT.Information = "Transport Helicopter as seen in Half Life 2 Episode 2"
ENT.Category = "[LVS] - Half Life 2"
ENT.IconOverride = "materials/entities/lvs/hl2/rebel_helicopter_transport.png"

ENT.AITEAM = 2
ENT.AdminSpawnable = false
ENT.ForceAngleDampingMultiplier = 1
ENT.ForceAngleMultiplier = 1
ENT.ForceLinearDampingMultiplier = 1.5
ENT.GibModels = {"models/gibs/helicopter_brokenpiece_01.mdl", "models/gibs/helicopter_brokenpiece_02.mdl", "models/gibs/helicopter_brokenpiece_03.mdl", "models/combine_apc_destroyed_gib02.mdl", "models/combine_apc_destroyed_gib04.mdl", "models/combine_apc_destroyed_gib05.mdl", "models/props_c17/trappropeller_engine.mdl", "models/gibs/airboat_broken_engine.mdl"}
ENT.MDL = "models/blu/helicopter.mdl"
ENT.MaxHealth = 3000
ENT.MaxVelocity = 1500
ENT.Spawnable = true
ENT.ThrottleRateDown = 0.2
ENT.ThrottleRateUp = 0.2
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1
ENT.ThrustUp = 1
ENT.TurnRatePitch = 0.75
ENT.TurnRateRoll = 0.75
ENT.TurnRateYaw = 1
ENT.VehicleCategory = "Half Life 2"
ENT.VehicleSubCategory = "Resistance"

ENT.EngineSounds = {
	{
		sound = "^lvs/vehicles/helicopter/loop_near.wav",
		sound_int = "lvs/vehicles/helicopter/loop_interior.wav",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
	{
		sound = "^lvs/vehicles/helicopter/loop_dist.wav",
		sound_int = "",
		Pitch = 0,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 100,
		Volume = 1,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 125,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT("Entity", "GunnerSeat")
end
