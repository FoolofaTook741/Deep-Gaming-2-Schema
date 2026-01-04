local FlashlightOTA = {
    ["ECHO"] = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0.055,
        [ "$pp_colour_addb" ] = 0.11,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 0.70,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    },
    ["MACE"] = {
        [ "$pp_colour_addr" ] = 0.16,
        [ "$pp_colour_addg" ] = 0.05,
        [ "$pp_colour_addb" ] = 0.0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 0.70,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    },
    ["RANGER"] = {
        [ "$pp_colour_addr" ] = 0.075,
        [ "$pp_colour_addg" ] = 0.1,
        [ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 0.70,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    },
    ["SPEAR"] = {
        [ "$pp_colour_addr" ] = 0.1,
	    [ "$pp_colour_addg" ] = 0.1,
	    [ "$pp_colour_addb" ] = 0,
	    [ "$pp_colour_brightness" ] = 0,
	    [ "$pp_colour_contrast" ] = 1,
	    [ "$pp_colour_colour" ] = 0.70,
	    [ "$pp_colour_mulr" ] = 0,
	    [ "$pp_colour_mulg" ] = 0,
	    [ "$pp_colour_mulb" ] = 0
    },
    ["SWEEPER"] = {
        [ "$pp_colour_addr" ] = 0.16,
        [ "$pp_colour_addg" ] = 0.05,
        [ "$pp_colour_addb" ] = 0.0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 0.70,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    },
    ["FIST"] = {
        [ "$pp_colour_addr" ] = 0.1,
	    [ "$pp_colour_addg" ] = 0,
	    [ "$pp_colour_addb" ] = 0,
	    [ "$pp_colour_brightness" ] = 0,
	    [ "$pp_colour_contrast" ] = 1,
	    [ "$pp_colour_colour" ] = 0.70,
	    [ "$pp_colour_mulr" ] = 0,
	    [ "$pp_colour_mulg" ] = 0,
	    [ "$pp_colour_mulb" ] = 0
    },
    ["PAYBACK"] = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0.055,
        [ "$pp_colour_addb" ] = 0.11,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 0.70,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    },
    ["NOMAD"] = {
        [ "$pp_colour_addr" ] = 0.1,
	    [ "$pp_colour_addg" ] = 0.1,
	    [ "$pp_colour_addb" ] = 0,
	    [ "$pp_colour_brightness" ] = 0,
	    [ "$pp_colour_contrast" ] = 1,
	    [ "$pp_colour_colour" ] = 0.70,
	    [ "$pp_colour_mulr" ] = 0,
	    [ "$pp_colour_mulg" ] = 0,
	    [ "$pp_colour_mulb" ] = 0
    }
}

local FlashlightCP = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0.1,
	[ "$pp_colour_addb" ] = 0.11,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.70,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local FlashlightCW = {
    [ "$pp_colour_addr" ] = 0.11,
	[ "$pp_colour_addg" ] = 0.1,
	[ "$pp_colour_addb" ] = 0.11,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.70,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local FlashlightCitizen = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0.11,
	[ "$pp_colour_addb" ] = 0.1,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.70,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

    hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
        local target = LocalPlayer()
        local isTP = impulse.GetSetting("view_thirdperson")

        if target:GetNWBool("DynamicFlashlight") and not isTP then
            if target:Team() == TEAM_OTA then
                local classthingy = ""
    
                for v,k in pairs(FlashlightOTA) do
                    if string.find(target:GetTeamClassName(),v) then
                        classthingy = v
                    end
                end

                DrawColorModify( FlashlightOTA[classthingy] )
            elseif target:Team() == TEAM_CP then
                DrawColorModify( FlashlightCP )
            elseif target:Team() == TEAM_CWU then
                DrawColorModify( FlashlightCW )
            else
                DrawColorModify(FlashlightCitizen)
            end
        end
    end )

    hook.Add("Think", "DynamicFlashlight.Rendering", function()
        local target = LocalPlayer()
        local isTP = impulse.GetSetting("view_thirdperson")

        if target:GetNWBool("DynamicFlashlight") and not isTP then
            if target.DynamicFlashlight then
                local position = target:GetPos()

                target.DynamicFlashlight:SetPos(target:EyePos()) --Vector(position[1], position[2], position[3] + 40)) --target:GetForward() * 20
                target.DynamicFlashlight:SetAngles(target:EyeAngles())
                target.DynamicFlashlight:Update()
            else
                target.DynamicFlashlight = ProjectedTexture()
                target.DynamicFlashlight:SetTexture("ez2/effects/ez_metrovision")
                target.DynamicFlashlight:SetFarZ( 1000 )
                target.DynamicFlashlight:SetEnableShadows( false )
                target.DynamicFlashlight:SetFOV( 100 )
                target.DynamicFlashlight:SetBrightness( 0.75 )

                if target:Team() == TEAM_OTA then
                    LocalPlayer():EmitSound( "ez2/nvg/nvg_on.wav", SNDLVL_NORM)
                elseif target:Team() == TEAM_CP then
                    LocalPlayer():EmitSound( "ez2/nvg/ez1_nvg.wav", SNDLVL_NORM)
                end
            end
        else
            if target.DynamicFlashlight then
                target.DynamicFlashlight:Remove()
                target.DynamicFlashlight = nil
                LocalPlayer():EmitSound( "ez2/nvg/nvg_off.wav", SNDLVL_NORM)
            end
        end
    end)
