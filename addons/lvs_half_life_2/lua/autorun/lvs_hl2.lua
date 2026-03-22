local function Initialize()
    if ( !tobool(LVS) ) then
        print("[LVS] - Unable to load Half Life 2 Vehicles, LVS not found.")
        return
    end

    list.Set("ContentCategoryIcons", "[LVS] - Half Life 2", "icon16/lvs_resistance.png")
    list.Set("ContentCategoryIcons", "[LVS] - Half Life 2 - Civilian", "icon16/lvs_civilian.png")
    list.Set("ContentCategoryIcons", "[LVS] - Half Life 2 - Combine", "icon16/lvs_combine.png")
    list.Set("ContentCategoryIcons", "[LVS] - Half Life 2 - Resistance", "icon16/lvs_resistance.png")

    CreateConVar("lvs_car_hl2_combineapc_damage", 10, nil, "Controls the damage of the main gun from the Combine APC.")
    CreateConVar("lvs_car_hl2_combineapc_rocketdamage", 1000, nil, "Controls the damage of the Missle from the Combine APC.")
    CreateConVar("lvs_car_hl2_combineapc_rocketradius", 384, nil, "Controls the splash radius of the Missle from the Combine APC.")
    CreateConVar("lvs_car_hl2_combineapc_rocketspeed", 500, nil, "Controls the speed of the Missle from the Combine APC.")
    CreateConVar("lvs_car_hl2_combineapc_health", 1600, nil, "Controls the health of the Combine APC.")
    CreateConVar("lvs_car_hl2_combineapc_spread", 0.05, nil, "Controls the spread of the main gun from the Combine APC.")

    CreateConVar("lvs_car_hl2_combinetransport_health", 1800, nil, "Controls the health of the Combine Transport.")

    print("[LVS] - Half Life 2 Vehicles loaded.")
end

timer.Simple(5, Initialize)

hook.Add("InitPostEntity", "LVS.HL2", function()
    Initialize()
end)

local combineAPCs = {
    ["lvs_wheeldrive_hl2_combine_apc"] = true,
    ["lvs_wheeldrive_hl2_combine_apc_armed"] = true,
    ["lvs_wheeldrive_hl2_combine_transport"] = true,
}

hook.Add("PrePlayerDraw", "LVS.HL2", function(client)
    if ( !tobool(LVS) ) then return end
    if ( !IsValid(client) or !client:Alive() ) then return end

    local vehicle = client:lvsGetVehicle()
    if ( !IsValid(vehicle) ) then return end

    if ( combineAPCs[vehicle:GetClass():lower()] ) then
        local driver = vehicle:GetDriver()
        local localPlayer = LocalPlayer()

        if ( driver == client ) then return end

        local seat = localPlayer:GetVehicle()
        if ( IsValid(seat) and seat:GetThirdPersonMode() ) then return true end

        if ( localPlayer:lvsGetVehicle() == vehicle ) then return end

        if ( IsValid(seat) ) then return end

        return true
    end
end)
