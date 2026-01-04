function EFFECT:Init(data)
    local pos = data:GetOrigin()
    local wpn = data:GetEntity()
    if not IsValid(wpn) then return end
    local muzzle = wpn.MuzzleEffect or wpn.IronsightsMuzzleFlash
    
    -- FIX: Proper attachment fallback
    local att = data:GetAttachment()
    if not att or att == 0 then
        att = 1
    end
    
    local wm = false
    local Owner = wpn:GetOwner()
    
    -- Check if developer mode is enabled
    local devMode = GetConVar("developer"):GetInt() and GetConVar("plutonic_debug"):GetInt() >= 1
    
    if devMode then
        print("=== MUZZLE FLASH DEBUG ===")
        print("Weapon: " .. tostring(wpn))
        print("Attachment: " .. att)
    end
    
    if (LocalPlayer():ShouldDrawLocalPlayer() or Owner ~= LocalPlayer()) and not wpn.AlwaysWM then
        wm = true
        att = 1
        if devMode then
            print("Using WORLD MODEL (3rd person)")
        end
    else
        if devMode then
            print("Using VIEW MODEL (1st person)")
        end
    end

    local attachmentData = wpn:GetAttachment(att)
    if attachmentData then
        pos = attachmentData.Pos
        ang = attachmentData.Ang
    else
        if devMode then
            print("ATTACHMENT " .. att .. " NOT FOUND - TRYING ATTACHMENT 1")
        end
        attachmentData = wpn:GetAttachment(1)
        if attachmentData then
            pos = attachmentData.Pos
            ang = attachmentData.Ang
            att = 1
        end
    end

    if devMode then
        print("Position: " .. tostring(pos))
        print("Angle: " .. tostring(ang))
    end
    
    if gmmuzzle then
        if muzzle and wm then
            if not pos then 
                if devMode then
                    print("NO POSITION - RETURNING")
                end
                return 
            end
            local fx = EffectData()
            fx:SetOrigin(pos)
            fx:SetEntity(wpn)
            fx:SetAttachment(att)
            fx:SetNormal((ang or Angle(0, 0, 0)):Forward())
            fx:SetStart(pos)
            fx:SetScale(self.IronsightsMuzzleFlashScale or 0.1)
            util.Effect(muzzle, fx)
            if devMode then
                print("Spawned LEGACY muzzle effect: " .. tostring(muzzle))
            end
        else
            if devMode then
                print("No legacy muzzle effect - muzzle: " .. tostring(muzzle) .. ", wm: " .. tostring(wm))
            end
        end
    else
        if muzzle and wm then
            ParticleEffectAttach(muzzle, PATTACH_POINT_FOLLOW, wpn, att)
            if devMode then
                print("Spawned PARTICLE muzzle effect: " .. tostring(muzzle))
            end
        else
            if devMode then
                print("No particle muzzle effect - muzzle: " .. tostring(muzzle) .. ", wm: " .. tostring(wm))
            end
        end
    end

    if not pos then 
        if devMode then
            print("NO POSITION - SKIPPING LIGHT")
        end
        return 
    end
    
    local light = DynamicLight(self:EntIndex())
    local clr = wpn.MuzzleFlashColor or Color(244, 209, 66)
    
    if devMode then
        print("--- DYNAMIC LIGHT SETTINGS ---")
        print("Light created: " .. tostring(light ~= nil))
    end
    
    if light then
        light.Pos = pos
        light.r = clr.r
        light.g = clr.g
        light.b = clr.b
        light.Brightness = wpn.MuzzleFlashBrightness or 4
        light.Decay = 5000
        
        local isFirstPerson = (Owner == LocalPlayer())
        local lightSize
        if isFirstPerson then
            lightSize = wpn.MuzzleFlashLocalSize or wpn.MuzzleFlashSize or 128
            if devMode then
                print("Using 1st PERSON light size: " .. lightSize)
            end
        else
            lightSize = wpn.MuzzleFlashSize or 128
            if devMode then
                print("Using 3rd PERSON light size: " .. lightSize)
            end
        end
        light.Size = lightSize
        
        light.DieTime = CurTime() + 0.1
        
        if devMode then
            -- FIXED: Safe DieTime printing
            print("Light will die at: " .. tostring(light.DieTime or "NO DIETIME"))
            
            debugoverlay.Cross(pos, 5, 0.5, Color(255, 0, 0), false)
            debugoverlay.Text(pos, "MUZZLEFLASH D LIGHT", 0.5, false)
            
            -- DEBUG: Test if light is actually visible
            print("Light properties set - checking visibility...")
        end
    else
        if devMode then
            print("FAILED TO CREATE DYNAMIC LIGHT!")
        end
    end
    
    if devMode then
        print("=== DEBUG END ===")
    end
end

function EFFECT:Think()
    -- Remove the debug thinking to prevent errors
    return false
end

function EFFECT:Render()
    return false
end