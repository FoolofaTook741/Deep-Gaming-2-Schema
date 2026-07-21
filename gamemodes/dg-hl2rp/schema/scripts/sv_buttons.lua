--[[
CreateConVar( "buttondebugmode", "0", FCVAR_NOTIFY, "Sets the use hook to debug mode.", 0, 1 )

--elseif statement, timer for hacking does not return true after timer ends, but instead as soon as the use key is hit on the button

hook.Add("PlayerUse", "buttontest", function(ply, ent)
    level1cracktime = 3
    level2cracktime = 6
    level3cracktime = 9
    level4cracktime = 12
    level5cracktime = 15
    level6cracktime = 18
    level1buttons = { --sulfurasv2
        [1555] = true,
    }
    level2buttons = {
        --[] = true,
    }
    level3buttons = {
        --[] = true,
    }
    level4buttons = {
        --[] = true,
    }
    level5buttons = { 
        --[] = true,
    }
    level6buttons = {
        --[] = true,
    }
    if ent:GetClass() == "func_button" then
        if level1buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard1") or ply:HasInventoryItem("ditem_keycard2") or ply:HasInventoryItem("ditem_keycard3") or ply:HasInventoryItem("ditem_keycard4") or ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
                if !timer.Exists(ent:EntIndex() .. "crack") then
                    timer.Create(ent:EntIndex() .. "crack", level1cracktime, 0, function()
                        ent:EmitSound("buttons/button17.wav")
                        timer.Remove(ent:EntIndex() .. "crack")
                        return true
                    end)
                end
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        elseif level2buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard2") or ply:HasInventoryItem("ditem_keycard3") or ply:HasInventoryItem("ditem_keycard4") or ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				timer.Simple(level2cracktime, function()
					ply:Notify("Override sequence completed.")
					ent:EmitSound("buttons/button17.wav")
					return true
				end)
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        elseif level3buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard3") or ply:HasInventoryItem("ditem_keycard4") or ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				timer.Simple(level3cracktime, function()
					ply:Notify("Override sequence completed.")
					ent:EmitSound("buttons/button17.wav")
					return true
				end)
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        elseif level4buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard4") or ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				timer.Simple(level4cracktime, function()
					ply:Notify("Override sequence completed.")
					ent:EmitSound("buttons/button17.wav")
					return true
				end)
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        elseif level5buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard5") or ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				timer.Simple(level5cracktime, function()
					ply:Notify("Override sequence completed.")
					ent:EmitSound("buttons/button17.wav")
					return true
				end)
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        elseif level6buttons[ent:EntIndex()] then
            if ply:HasInventoryItem("ditem_keycard6") then
                ent:EmitSound("buttons/button14.wav")
                return true
            elseif ply:HasInventoryItem("ditem_hackingkeycard") then
				ent:EmitSound("ambient/levels/canals/headcrab_canister_open1.wav")
				timer.Simple(level1cracktime, function()
					ply:Notify("Override sequence completed.")
					ent:EmitSound("buttons/button17.wav")
					return true
				end)
            else
                if !timer.Exists(ply:SteamID64() .. "buttoncd") then
                    ply:Notify("You do not have proper clearance to use this door.")
                    ent:EmitSound("buttons/button8.wav")
                    timer.Create(ply:SteamID64() .. "buttoncd", 0.25, 0, function()
                        timer.Remove(ply:SteamID64() .. "buttoncd")
                    end)
                end
                return false
            end
        end
    end
    if GetConVarNumber("buttondebugmode") == 1 then
        if ent:GetClass() == "func_button" then
            impulse.debugPrint("Button - Index: " .. ent:EntIndex())
            impulse.debugPrint("Debug mode enabled, to disable use 'buttondebugmode 0' in the server's console.")
        else
            impulse.debugPrint("Not a valid Button")
            impulse.debugPrint("Debug mode enabled, to disable use 'buttondebugmode 0' in the server's console.")
        end
    end
end) 
--]]
function FetchSteamName(steamid, callback)
    local steam64 = util.SteamIDTo64(steamid)
    local url = "https://steamcommunity.com/profiles/" .. steam64 .. "/?xml=1"
    http.Fetch(url,
        function(body, len, headers, code)
            local name = body:match("<steamID><!%[CDATA%[(.-)%]%]></steamID>")
            if name then
                callback(name)
            else
                callback(nil, "Unknown")
            end
        end
    )
end



DG_PMWH = "https://discord.com/api/webhooks/1473703432035631176/2wywjuUOBwsPyBH6ggAdAm1az_U6wG35KQPP07rc0Tka0oy5FHR4-FkCsXOMDDL9EBpZ" -- Promotions
DG_DMWH = "https://discord.com/api/webhooks/1473703572150550648/T229z82u4B3mnh6wp9z2pF8nkyaWkA9tcAEQVMoX2A9USOhMxNx8r5zwcnInCtIYGV6H" -- Demotions
DG_BLWH = "https://discord.com/api/webhooks/1473703704820584570/NR44xA9hBZ2jLaVIE5MAsR-4LAU4IBDxFJrWcwnTKMpCZEQ3F7wNiF56TFwrtXUmXkXP" -- Blacklists
DG_CWWH = "https://discord.com/api/webhooks/1473703873767018607/5EmSsE3-OXLqBmtW0OzLoasednW9yDeh0bHd1Uh3NxApQ2IboocsYcUgCAQ46uI3QomF" -- CW Rank changes
DG_LYL = "https://discord.com/api/webhooks/1473704316094124186/Gn5JIXOSYNnxp_aZj-IOBy36XFwwmmuMRzo6OBmEQE6c3j1l0DYxrDJzWuuEKkjubREb" -- Loyalist Levels
DG_CAL = "https://discord.com/api/webhooks/1473700636766769371/Xm8oiCUaqKl3NPyeg0Ug7RMvZ0fSr1XBb9GWzsbymt8NjLk8w5IHtvJWn8Mm4IooGy06" -- City Code status
DG_MER = "https://discord.com/api/webhooks/1473704515050934405/ZFkfBb1OHmnblUlKlEz1lCUfTV1SvAm5XShFbmGh0rfbOYkClmIylTNvK61JRfAaFs8E" -- Supervisory Merits
DG_DMER = "https://discord.com/api/webhooks/1473704693816365302/e4f0HA3bsAa5yVBtI69QxJhpmCz9eAE2XYi30ZIthDg3KaY1NIoVEyoTSD7vlRlk-x5c" -- Supervisory Demerits
DG_TMER = "https://discord.com/api/webhooks/1473705106909434030/mz6Muh4wbelBqm-kM7LIrfb1DanGrP6yHIopjT6hTM4c974UVx6PbFtViyTBL6ZRSM5S" -- Training Merits
DG_SENT = "https://discord.com/api/webhooks/1471356433634427021/nJ2kWPNoHyHjbNJhCpdGZH0gjNzj3LR__HBQr_KtHZT2kUoELHxAeAdbjyVQgPEMkfos"
DG_NME = "https://discord.com/api/webhooks/1471356717475434536/AfWQpUWUQfGiiV3e9xNCtM2xIdYN_9GmMXepHPZMNSR0l6sS4c8jqYzVdjJOQ8lnvpri"
DG_OPS = "https://discord.com/api/webhooks/1471356832277598251/23yavNPNxs5a837E0WP2n5JP4VnDRSQB2wsGsGaAUeJDf8kXjlKbUrqQOmNhedk6D9rN"
DG_LUA = "https://discord.com/api/webhooks/1471356930902720684/8Mzip3Ak0QqFSMXhbcXRxp_fORq6jICYgA8qSBqpe8ZutIizraec5l3n3SM9ZNABMBGR"
PG_STAFFLOGS = "https://discord.com/api/webhooks/1471357087421566997/Dm2E-4T1bf8BC-DBYdw41YjlaOYYPua96-hyGgCjVQDWZURMvuPuE1GJL-f-50N4Bu31"
PG_HIGHVALUE = "https://discord.com/api/webhooks/1471357239024554114/_oxqoQ3shquqdFipQv1dbymcwd1soxFAw2jchZyRrTi-p53bta3Nc8AYoYj_vhp0RM0z"
PG_DIVISIONAL_WHITELIST = "https://discord.com/api/webhooks/1473702072594464790/fAVaEmzChBoVh0S2wXBSrXiYw5hKSSaom6qhJxnofe7COxswYtPnak--Mtm-NQLKcpWf" -- Self Explanatory
DG_E2 = "https://discord.com/api/webhooks/1511635343806435348/5OltFOimvvf37PS7ZHcDI8DySH_vqK7YiRBK_Xa6yEr79Yxzcc77C642zFsQ-pPMx9wj"
DG_CVMERITS = "https://discord.com/api/webhooks/1528197213682143402/cQaKQ6YmONskR7ML8XtgWi-jxeG6ydDOVuJ1XKwDmgeV0TQFKwTjYkCm7Au0hpdEaKZb" -- Civic Merits
DG_BANS = "https://discord.com/api/webhooks/1529325691219214366/89fj-9QooTWVjlvKL0YbX2kphu7OY_ApoPiMfpiwJB7U1I0aTxSeB3m1gXC8EZMfjx1R"
DG_WARNS = "https://discord.com/api/webhooks/1529325929740898356/BPxyRxgks6MsGM0dlfwrkyOZce1ICCfRCvtDRdyQLzuXJNpdcwjnDtgzjEwKPbIkUmuV"
