local V = {
	-- Required information
	Name = "City24 Combine Prisoner Transporter",
	Model = "models/ctvehicles/hla/prisoner24_transport.mdl",
	Class = "prop_vehicle_jeep",
	Category = "Optica's Modified Vehicles",

	-- Optional information
	Author = "Optica and CTV",
	Information = "Model edits by Optica, vehicle base by CTV",

	KeyValues = {
		vehiclescript = "scripts/vehicles/ctvehicles/ctv_c24_prisoner_transport.txt"
	}
}
list.Set( "Vehicles", "ctv_c24_prisoner_transport", V )