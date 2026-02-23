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
DG_BLWH = "https://discord.com/api/webhooks/1471354974410772574/P6iCRjKu21CBuiu676kndmdEMonMX_JI6BCrYj0C67UQgDltXRpTl8MrUbtzRND21TXw"
DG_CWWH = "https://discord.com/api/webhooks/1471355156179321023/Jf1gEJonVbTdTmwVyjRbN6udHkDE7f0GUsYO-4D8a2tzrvX6Nk9qRwLQu40VtJNkliHM"
DG_LYL = "https://discord.com/api/webhooks/1471355421188030587/XFSWDj6FAzB_MJjp6l-kDRNi8jeQK0lwsd0I3rbQEElPL3qzTlexQZv1h-l8WJzNmKkp"
DG_CAL = "https://discord.com/api/webhooks/1471355586741403871/kpja8xz-Pot9VwzTz5_ywf3xj2SP7rNSKt8UFMvPzp49j_jI-Hz_F-fkgFEaIwF05W9V"
DG_MER = "https://discord.com/api/webhooks/1471355775841730560/HgR-XHQrPmzLXfxUP0gatBPUQ-7piJlG_-cEwXWtaCvdhu7vjqydzqK0On7JRWEupyzF"
DG_DMER = "https://discord.com/api/webhooks/1471355972130963518/CTj_rQW_oJ91OSFTnKOBaxu6ZSPJqCOlVEPqzHlrLSXJH_H-D6rChAABGZacsnNAq3aW"
DG_TMER = "https://discord.com/api/webhooks/1471356174107672669/ShqEcxw5zdVkDZM85jpSMTefIDp3gQuaD8xkCnBnKlB54a2yA0iTFD-Ok70Z_cjpFLGS"
DG_SENT = "https://discord.com/api/webhooks/1471356433634427021/nJ2kWPNoHyHjbNJhCpdGZH0gjNzj3LR__HBQr_KtHZT2kUoELHxAeAdbjyVQgPEMkfos"
DG_NME = "https://discord.com/api/webhooks/1471356717475434536/AfWQpUWUQfGiiV3e9xNCtM2xIdYN_9GmMXepHPZMNSR0l6sS4c8jqYzVdjJOQ8lnvpri"
DG_OPS = "https://discord.com/api/webhooks/1471356832277598251/23yavNPNxs5a837E0WP2n5JP4VnDRSQB2wsGsGaAUeJDf8kXjlKbUrqQOmNhedk6D9rN"
DG_LUA = "https://discord.com/api/webhooks/1471356930902720684/8Mzip3Ak0QqFSMXhbcXRxp_fORq6jICYgA8qSBqpe8ZutIizraec5l3n3SM9ZNABMBGR"
PG_STAFFLOGS = "https://discord.com/api/webhooks/1471357087421566997/Dm2E-4T1bf8BC-DBYdw41YjlaOYYPua96-hyGgCjVQDWZURMvuPuE1GJL-f-50N4Bu31"
PG_HIGHVALUE = "https://discord.com/api/webhooks/1471357239024554114/_oxqoQ3shquqdFipQv1dbymcwd1soxFAw2jchZyRrTi-p53bta3Nc8AYoYj_vhp0RM0z"
PG_DIVISIONAL_WHITELIST = "https://discord.com/api/webhooks/1471357412102373500/YYG6c8tTJrMzp3VvBi6rXSsdck5oCgnZH1CvqIqWhV84vO35cffM8KFqKQE3_i_MbVJh"
DG_E2 = "https://discord.com/api/webhooks/1471357515391570100/Pp3e6FMqiP3pOl5ZogoLmZW8HJcDD-dVbGD9xcgtYBHybiUZU69vDy0g3ANGUKQdtwEy"
