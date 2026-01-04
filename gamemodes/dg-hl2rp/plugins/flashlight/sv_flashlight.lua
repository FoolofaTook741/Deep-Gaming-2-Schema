hook.Add("PlayerSwitchFlashlight", "DynamicFlashlight.Switch", function(ply, state)
    --if ply:IsScanner() then return end
    --print(ply:GetNWBool("IsNVGEquipped"))
    if (ply:GetNWBool("IsNVGEquipped") == true) then
        if ply:Health() > 0 and ply:CanUseFlashlight() == true and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
            ply:SetNWBool("DynamicFlashlight", not ply:GetNWBool("DynamicFlashlight"))
        elseif ply:Health() <= 0 then
            ply:SetNWBool("DynamicFlashlight", false)
        else
            ply:SetNWBool("DynamicFlashlight", false)
        end
    end

    if ply:GetNWBool("IsNVGEquipped") == true then return false end 
    if ply:GetMoveType() == MOVETYPE_NOCLIP then return false end
end)