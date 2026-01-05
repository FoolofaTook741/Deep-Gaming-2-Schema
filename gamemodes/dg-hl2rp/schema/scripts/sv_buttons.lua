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



DG_PMWH = "https://discord.com/api/webhooks/1159996458972499988/OvTyBknBZEEifLRyeWtgvRbBt__dVcLh_6MRLJU9J9g_38qTb1cDBpkVi4PbLPEHo1lS"
DG_DMWH = "https://discord.com/api/webhooks/1203089430936559696/KKRcHVug8GWoubSMamBB3DffT5PDgAKt23pGKPsqaqMhDSgYUMopcJl-Ub_-icnQG7aH"
DG_BLWH = "https://discord.com/api/webhooks/1203097421106651147/YdZN9LDAyjMIzxClfLRFHcJMAAjLPRNtweuqXFQXYq7i4Kc3BLipX7k34706ZZnA84yt"
DG_CWWH = "https://discord.com/api/webhooks/1203099421508902962/1sEB5_UfBwgIZQj6WqFMWfH8msSCXVbxqSft0J4SvhvSzFO0SRZOu9kdDcN4e7Nu7jwv"
DG_LYL = "https://discord.com/api/webhooks/1247629943924588585/9vql58qSybNayIqnllyWQpHBr5Pvyzwxj_dWVNQDglqmThhtVsW0feq-e7ozfKrUiZtf"
DG_CAL = "https://discord.com/api/webhooks/1247629445909708851/UxrJRp3pWUjDxprGltRK5F-0NyHYwU0MPXqozs1N4lqmJMLZytOsadVDBY2EJxWaerJv"
DG_MER = "https://discord.com/api/webhooks/1247634795907911732/pQy3cLFZk77A2N3PLTj8Bd-POqrGtyerSHwosnN3drXIYg6OCzhvXsmGq19_SLjRvKRd"
DG_DMER = "https://discord.com/api/webhooks/1247635821515903078/cn_3A5dyWUg840o9JyYCvfoX3G30ZJuA7AHA4457CerTqsQ4Px7HGTfkqSYtKHav0IPk"
DG_TMER = "https://discord.com/api/webhooks/1247636395854397533/dX01bkoPPe6pFf8JD1lX3W1bapq0zBsvKXegdrneRvxPhYGaT0UxckZuheWaiMcvI3dW"
DG_SENT = "https://discord.com/api/webhooks/1367885548093702304/GtYRqAWKSQbgZGPLhQ2i_qEYhP5aBUUIClwTbSbCg4yDLb4UY7u_6d4isfQEA-nbiuXh"
DG_NME = "https://discord.com/api/webhooks/1367888169332375623/CLYp7f0yuQ9nKU9dLspxWmtDhf4ll8uZFCtb7TQbesLEqVUnxWVMYJbOpA9EQ-GwMEeL"
DG_OPS = "https://discord.com/api/webhooks/1367887892105396264/33qOBE3i7qj6pO_PZWX6VN9IvwhaL1gxjy6j2S-ShK-4b7mHo4-KY3m63zcD2V-j4HBQ"
DG_LUA = "https://discord.com/api/webhooks/1367886516894040115/8npPfOqwyzJ6ieeaHzHbyv9XCTobs79O3sBNQlsT9x9vuYlXU_GYHcSNn8AnC-R0Fw3y"
DG_WATCH = "https://discord.com/api/webhooks/1367887059552829530/MC3jGKDvqAav5296Jn0bmoOVWSwCkQaZDtlZjA3hcvYx_CIzLWRifP253cGGQcq8T5w2"
PG_STAFFLOGS = "https://discord.com/api/webhooks/1428443025801085089/5yNImKMMp3F9bFFw-eYOp6hd7MxCn5sprHZwHRSDZcPX_1AtSdbmgEN4rAAzaZstSVeM"
PG_HIGHVALUE = "https://discord.com/api/webhooks/1437649244084502610/OAZ8o9Yp1x8NJsigGR-IngbCxG8h0HTWljWbvVoKTIUovWWXZps-XX4FKB978lApPnZW"
PG_DIVISIONAL_WHITELIST = "https://discord.com/api/webhooks/1438128879087648889/ZGn1yHjTQfi2-27z3mxRTVU_gKDGkr2iH1I-noCzj8IZ0ZgmvAAly3wU8v_uWyG88tYb"
DG_E2 = "https://discord.com/api/webhooks/1386971706329010206/9PbUJBaXIrdNfJWJoa3SUNWZntC1c378MrPmWuw7CYnfH99tzIr6w9EgWE86EFPeKZXO"
