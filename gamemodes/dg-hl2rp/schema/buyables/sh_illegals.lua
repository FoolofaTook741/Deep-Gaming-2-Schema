impulse.Business.Define("Brewing Barrel", {
    entity = "impulse_hl2rp_brewingbarrel",
    model = "models/props_c17/woodbarrel001.mdl",
    description = "A barrel to brew alcohol.",
    category = "Illegal Activities",
    price = 95,
    refundAdd = 75,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.BarrelCount = (ply.BarrelCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN then
            return false
        end

    	local barrelCount = ply.BarrelCount or 0

    	if barrelCount >= impulse.Config.MaxBarrels then
    		ply:Notify("You have reached the max amount of brewing barrels.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Bullet Press", {
    entity = "deep_bulletpress",
    model = "models/props_lab/reciever_cart.mdl",
    description = "A machine to make bullets.",
    category = "Illegal Activities",
    price = 130,
    refundAdd = 120,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.BPCount = (ply.BPCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU then
            return false
        end

    	local bpcount = ply.BPCount or 0

    	if bpcount >= 2 then
    		ply:Notify("You have reached the max amount of bullet presses.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("De-biolinking Machine", {
    entity = "deep_blremovalstation",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    description = "A machine capable of stripping Combine biomechanical locks from pulse weapons.",
    category = "Illegal Activities",
    price = 90,
    refundAdd = 80,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.DebiolinkCount = (ply.DebiolinkCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU then
            return false
        end

    	local bpcount = ply.DebiolinkCount or 0

    	if bpcount >= 1 then
    		ply:Notify("You have reached the max amount of De-biolinking machines.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Camera Viewer", {
    entity = "pinnacle_portable_cam_viewer",
    model = "models/props_lab/reciever_cart.mdl",
    description = "A machine to view cameras placed by yourself.",
    category = "Espionage",
    price = 60,
    refundAdd = 50,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
    end,
})

impulse.Business.Define("Refinery", {
    entity = "deep_refinery",
    model = "models/props_wasteland/laundry_washer001a.mdl",
    description = "Refines raw metal.",
    category = "Illegal Activities",
    price = 70,
    refundAdd = 60,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.RefineryCount = (ply.RefineryCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU then
            return false
        end

    	local refinerycount = ply.RefineryCount or 0

    	if refinerycount >= 2 then
    		ply:Notify("You have reached the max amount of refineries.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Fishing Cage", {
    entity = "deep_fishing_crate",
    model = "models/props_junk/wood_crate002a.mdl",
    description = "Teach a man to fish, you feed him for life.",
    category = "Business",
    price = 90,
    refundAdd = 80,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.FishCrate = (ply.FishCrate or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU then
            return false
        end

    	local fishcrates = ply.FishCrate or 0

    	if fishcrates >= 2 then
    		ply:Notify("You have reached the max amount of fishing cages.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Generator", {
    entity = "deep_generator",
    model = "models/props_vehicles/generatortrailer01.mdl",
    description = "Uses fuel. Used in place of a power outlet.",
    category = "Business",
    price = 250,
    refundAdd = 200,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.Generator = (ply.Generator or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU then
            return false
        end

    	local generators = ply.Generator or 0

    	if generators >= 1 then
    		ply:Notify("You can only have 1 generator at a time.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Wine Brewery", {
    entity = "deep_winebrew",
    model = "models/props_wasteland/laundry_basket001.mdl",
    description = "Uses electricty. Make some wine.",
    category = "Business",
    price = 60,
    refundAdd = 60,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.Winery = (ply.Winery or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CWU and ply:GetTeamClass() != CLASS_COMMERCE then
            return false
        end

    	local wineries = ply.Winery or 0

    	if wineries >= 2 then
    		ply:Notify("You can only have 2 wineries at a time.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Radio", {
    entity = "deep_radio",
    model = "models/props_lab/citizenradio.mdl",
    description = "A radio that plays any on server music.",
    category = "Donator Items",
    price = 10,
    refundAdd = 10,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.RadioCount = (ply.RadioCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU and ply:Team() != TEAM_VORT then
            return false
        end

        if ply:IsDonator() == false then
            return false
        end

    	local radioCount = ply.RadioCount or 0

    	if radioCount >= impulse.Config.MaxRadios then
    		ply:Notify("You have reached the max amount of radios.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Wall Sign", {
    entity = "minecraft_wall_sign",
    model = "models/mcmodelpack/entities/wallsign.mdl",
    description = "A sign used to write whatever you'd like.",
    category = "Donator Items",
    price = 10,
    refundAdd = 10,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.SignCount = (ply.SignCount or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CITIZEN and ply:Team() != TEAM_CWU and ply:Team() != TEAM_VORT then
            return false
        end

        if ply:IsDonator() == false then
            return false
        end

    	local radioCount = ply.SignCount or 0

    	if radioCount >= impulse.Config.MaxSigns then
    		ply:Notify("You have reached the max amount of signs.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Pill Bottle Machine", {
    entity = "deep_pillpress",
    model = "models/microscope.mdl",
    description = "Molds plastic into pill bottles.",
    category = "Business",
    price = 50,
    refundAdd = 40,
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.PillPresses = (ply.PillPresses or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CWU or ply:GetTeamClass() != CLASS_MEDIC then
            return false
        end

    	local pillpresses = ply.PillPresses or 0

    	if pillpresses >= impulse.Config.MaxPillPresses then
    		ply:Notify("You have reached the max amount of pill bottle machines.")
    		return false
    	else
    		return true
    	end
    end
})

impulse.Business.Define("Vending Machine", {
    entity = "impulse_hl2rp_vendingmachine",
    model = "models/props_interiors/VendingMachineSoda01a.mdl",
    description = "Sells various drinks, a portion of profits go back to you.",
    price = 225,
    refundAdd = 200,
    category = "Business",
    refund = true,
    removeOnTeamSwitch = true,
    postSpawn = function(ent, ply)
        ent.CPPISetOwner(ply)
    	ply.VendingMachines = (ply.VendingMachines or 0) + 1
    end,
    customCheck = function(ply)
        if ply:Team() != TEAM_CWU or ply:GetTeamClass() != CLASS_COMMERCE then
            return false
        end

    	local vendingmachines = ply.VendingMachines or 0

    	if vendingmachines >= impulse.Config.MaxVendingMachines then
    		ply:Notify("You have reached the max amount of vending machines.")
    		return false
    	else
    		return true
    	end
    end
})
