hook.Add("RenderScreenspaceEffects", "impulse_PortableCam_GrayScale", function()
    local ply = LocalPlayer()
    if ply.CamView then
        local tab = {}
        tab[ "$pp_colour_addr" ] = 0
        tab[ "$pp_colour_addg" ] = 0
        tab[ "$pp_colour_addb" ] = 0
        tab[ "$pp_colour_brightness" ] = 0
        tab[ "$pp_colour_contrast" ] = 1
        tab[ "$pp_colour_colour" ] = 0
        tab[ "$pp_colour_mulr" ] = 0
        tab[ "$pp_colour_mulg" ] = 0
        tab[ "$pp_colour_mulb" ] = 0

        DrawColorModify(tab)
    end
end)