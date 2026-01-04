AddCSLuaFile()
local model = "models/ctvehicles/hla/prisoner24_transport.mdl"

local light_table = {
	ems_sounds = {"vehicles/ctvehicles/apc/apc_alarm_loop1.wav"},
}
list.Set( "simfphys_lights", "ctv_prisontrans24", light_table) -- здесь тебе нужно изменить "test" на любое другое название, например "myfirstsimfcar"


local V = {
	Name = "City 24 Prisoner Transporter", -- название машины в меню
	Model = model, -- модель машины (в вкладке дополнения и проп авто)
	Category = "Willi302's Cars", -- категория в которой будет машина

	Members = {
		Mass = 3000, -- масса авто
		
		SpeedoMax = -1, -- какая максималка на спидометре(может работать криво)

		LightsTable = "ctv_prisontrans24", -- название light_table

		AirFriction = -200,

		FrontWheelRadius = 26,--радиус переднего колеса
		RearWheelRadius = 26,--радиус заднего колеса

		CustomMassCenter = Vector(0,0,-1), 

		SeatOffset = Vector(-2,0,-4), -- положение водительского сидения
		SeatPitch = 0,

		PassengerSeats = { -- пассажирские места
			{
				pos = Vector(17,44,58),
				ang = Angle(0,0,0) -- Vector(ширина, длина, высота),
			},
			
			{
				pos = Vector(36,-22,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
			{
				pos = Vector(36,-51,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
			{
				pos = Vector(36,-80,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
			
			{
				pos = Vector(-36,-22,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
			{
				pos = Vector(-36,-51,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
			{
				pos = Vector(-36,-80,55),
				ang = Angle(0,90,0) -- Vector(ширина, длина, высота),
			},
		},
		--[[ExhaustPositions = { -- позиция выхлопа
        	{
                pos = Vector(25,-118,12),
                ang = Angle(90,-90,0),
        	},
        },]]

		StrengthenSuspension = false, -- жесткая подвеска.

		FrontHeight = 12, -- высота передней подвески
		FrontConstant = 50000,
		FrontDamping = 5000,
		FrontRelativeDamping = 5000,

		RearHeight = 12, -- высота задней подвески
		RearConstant = 50000,
		RearDamping = 5000,
		RearRelativeDamping = 5000,

		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 1000,

		TurnSpeed = 4,

		MaxGrip = 75,
		Efficiency = 1.2,
		GripOffset = -3,
		BrakePower = 130, -- сила торможения

		IdleRPM = 100, -- мин. кол-во оборотов
		LimitRPM = 2000, -- макс. кол-во оборотов
		Revlimiter = false, -- Если true - Когда стрелка спидометра доходит до красного обозначения, она не проходит дальше, если false - это игнорируется
		PeakTorque = 3000, -- крутящий момент
		PowerbandStart = 200, -- какие обороты на нейтральной передаче
		PowerbandEnd = 4000, -- ограничение по оборотам
		Turbocharged = false, -- турбо false = нет, true = да
		Supercharged = false, -- супер заряд
		Backfire = false, -- стреляющий выхлоп

		FuelFillPos = Vector(-45,60,35), -- положение заправки
		FuelType = FUELTYPE_ELECTRIC, -- тип топлива
		FuelTankSize = 200, -- размер бака

		PowerBias = 0, -- привод. 1 - задний, 0 - полный, -1 - передний

		EngineSoundPreset = -1,
--
		snd_pitch = 1.5,
		snd_idle = "simulated_vehicles/c_apc/apc_idle.wav",

		snd_low = "vehicles/ctvehicles/apc/apc_cruise_loop3.wav",
		snd_low_revdown = "vehicles/ctvehicles/apc/apc_slowdown_fast_loop5.wav", -- это всё звук
		snd_low_pitch = 0.4,

		snd_mid = "simulated_vehicles/c_apc/apc_mid.wav",
		--snd_mid_gearup = "vehicles/second.wav",
		--snd_mid_geardown = "vehicles/second.wav",
		snd_mid_pitch = 0.4,

		snd_horn = "simulated_vehicles/horn_2.wav",

--
		DifferentialGear = 4,
		Gears = { -0.1, 0, 0.12, 0.2, 0.45, 0.8}, -- кол-во передач и "мощность"
	}
}
list.Set( "simfphys_vehicles", "ctv_c24_prisoner_transport", V )