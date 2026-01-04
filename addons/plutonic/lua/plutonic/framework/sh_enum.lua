--- Enumerations used throughout Plutonic.
-- @module Enum
Plutonic.Enum = Plutonic.Enum or {}
Plutonic.Enum.WeaponType = {
	SubmachineGun = 1,
	AutomaticRifle = 2,
	MarksmanRifle = 3,
	Pistol = 5,
	Sniper = 6,
	Shotgun = 7
}

--- The different types of weaponry.
-- @realm shared
-- @field SubmachineGun
-- @field AutomaticRifle
-- @field MarksmanRifle
-- @field Pistol
-- @field Sniper
-- @field Shotgun
-- @table WeaponType
Plutonic.Enum.BarrelLength = {
	Short = 5.04,
	Medium = 10.16,
	Long = 15.24,
	Custom = function(len) return len end
}

-- we do this cus it looks cool
--- The different barrel lengths. Generally use Custom.
-- @realm shared
-- @field Short
-- @field Medium
-- @field Long
-- @field Custom
-- @table BarrelLength
Plutonic.Enum.Modification = {
	BarrelExtension = "barrel_ext",
	Barrel = "barrel",
	Stock = "stock",
	Optic = "sight",
	Handguard = "handguard",
	Foregrip = "grip",
	Rail = "att",
	Trigger = "trigger"
}

--- The different types of modifications.
-- @realm shared
-- @field BarrelExtension
-- @field Barrel
-- @field Stock
-- @field Optic
-- @field Handguard
-- @field Foregrip
-- @field Rail
-- @field Trigger
-- @table Modification
Plutonic.Enum.Sound = {
	GunShot = 140,
	GunShotSilence = 85,
	Generic = 60
}

Plutonic.Enum.FireMode = {Safety, Semi, Burst, Auto}
Plutonic.Enum.ANIMATION_PROCEDURAL = 0
Plutonic.Enum.ANIMATION_ACTIVITY = 1
Plutonic.Enum.ANIMATION_SEQUENCE = 2
Plutonic.Enum.ANIMATION_TYPE = {
	Procedural = Plutonic.Enum.ANIMATION_PROCEDURAL,
	Activity = Plutonic.Enum.ANIMATION_ACTIVITY,
	Sequence = Plutonic.Enum.ANIMATION_SEQUENCE
}

Plutonic.Enum.Value = 0x1
Plutonic.Enum.ValueIfEmpty = 0x2
Plutonic.Enum.ValueIfForegrip = 0x3
Plutonic.Enum.ValueIfForegripAndEmpty = 0x4
VECTOR_UP = Angle():Up()
VECTOR_RIGHT = Angle():Right()
VECTOR_FORWARD = Angle():Forward()