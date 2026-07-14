if SERVER then
    AddCSLuaFile("voice/sh_voice_core.lua")
    AddCSLuaFile("voice/sh_voice_citizen.lua")
    AddCSLuaFile("voice/sh_voice_zombie_vort.lua")
    AddCSLuaFile("voice/sh_voice_apf_1.lua")
    AddCSLuaFile("voice/sh_voice_apf_2.lua")
    AddCSLuaFile("voice/sh_voice_grunt_1.lua")
    AddCSLuaFile("voice/sh_voice_grunt_2.lua")
	AddCSLuaFile("voice/sh_voice_ordinal.lua")
	AddCSLuaFile("voice/sh_voice_wallhammer.lua")
end

include("voice/sh_voice_core.lua")
include("voice/sh_voice_citizen.lua")
include("voice/sh_voice_zombie_vort.lua")
include("voice/sh_voice_apf_1.lua")
include("voice/sh_voice_apf_2.lua")
include("voice/sh_voice_grunt_1.lua")
include("voice/sh_voice_grunt_2.lua")
include("voice/sh_voice_ordinal.lua")
include("voice/sh_voice_wallhammer.lua")

impulse.Voice.Register("hunter", "ALERT1", "[[CODEX/STATE/ALERT]]", "npc/ministrider/hunter_alert1.wav")
impulse.Voice.Register("hunter", "ALERT2", "[[CODEX/STATE/ALERT]]", "npc/ministrider/hunter_alert2.wav")
impulse.Voice.Register("hunter", "ALERT3", "[[CODEX/STATE/ALERT]]", "npc/ministrider/hunter_alert3.wav")
impulse.Voice.Register("hunter", "ANGER1", "[[CODEX/STATE/ANGERED]]", "npc/ministrider/hunter_angry1.wav")
impulse.Voice.Register("hunter", "ANGER2", "[[CODEX/STATE/ANGERED]]", "npc/ministrider/hunter_angry2.wav")
impulse.Voice.Register("hunter", "ANGER3", "[[CODEX/STATE/ANGERED]]", "npc/ministrider/hunter_angry3.wav")
impulse.Voice.Register("hunter", "CHARGE1", "[[CODEX/ACTION/CHARGING]]", "npc/ministrider/hunter_charge3.wav")
impulse.Voice.Register("hunter", "CHARGE2", "[[CODEX/ACTION/CHARGING]]", "npc/ministrider/hunter_charge4.wav")
impulse.Voice.Register("hunter", "DEFENSIVE1", "[[CODEX/ACTION/DEFENSIVE]]", "npc/ministrider/hunter_defendstrider1.wav")
impulse.Voice.Register("hunter", "DEFENSIVE2", "[[CODEX/ACTION/DEFENSIVE]]", "npc/ministrider/hunter_defendstrider2.wav")
impulse.Voice.Register("hunter", "DEFENSIVE3", "[[CODEX/ACTION/DEFENSIVE]]", "npc/ministrider/hunter_defendstrider3.wav")
impulse.Voice.Register("hunter", "AFFIRMATIVE", "[[CODEX/RESPONSE/AFFIRMATIVE]]", "npc/ministrider/hunter_flank_announce1.wav")
impulse.Voice.Register("hunter", "NEGATIVE", "[[CODEX/RESPONSE/NEGATIVE]]", "npc/ministrider/hunter_flank_announce2.wav")
impulse.Voice.Register("hunter", "SPOTTEDENEMY1", "[[CODEX/ACTION/SPOTTED_TARGET]]", "npc/ministrider/hunter_foundenemy1.wav")
impulse.Voice.Register("hunter", "SPOTTEDENEMY2", "[[CODEX/ACTION/SPOTTED_TARGET]]", "npc/ministrider/hunter_foundenemy2.wav")
impulse.Voice.Register("hunter", "SPOTTEDENEMY2", "[[CODEX/ACTION/SPOTTED_TARGET]]", "npc/ministrider/hunter_foundenemy3.wav")
impulse.Voice.Register("hunter", "PURSUINGENEMY1", "[[CODEX/ACTION/PURSUING_TARGET]]", "npc/ministrider/hunter_foundenemy_ack1.wav")
impulse.Voice.Register("hunter", "PURSUINGENEMY2", "[[CODEX/ACTION/PURSUING_TARGET]]", "npc/ministrider/hunter_foundenemy_ack2.wav")
impulse.Voice.Register("hunter", "PURSUINGENEMY3", "[[CODEX/ACTION/PURSUING_TARGET]]", "npc/ministrider/hunter_foundenemy_ack3.wav")
impulse.Voice.Register("hunter", "IDLE1", "[[CODEX/STATE/IDLE]]", "npc/ministrider/hunter_idle1.wav")
impulse.Voice.Register("hunter", "IDLE2", "[[CODEX/STATE/IDLE]]", "npc/ministrider/hunter_idle2.wav")
impulse.Voice.Register("hunter", "IDLE3", "[[CODEX/STATE/IDLE]]", "npc/ministrider/hunter_idle3.wav")
impulse.Voice.Register("hunter", "LAUGH1", "[[CODEX/RESPONSE/LAUGH]]", "npc/ministrider/hunter_laugh1.wav")
impulse.Voice.Register("hunter", "LAUGH2", "[[CODEX/RESPONSE/LAUGH]]", "npc/ministrider/hunter_laugh2.wav")
impulse.Voice.Register("hunter", "LAUGH3", "[[CODEX/RESPONSE/LAUGH]]", "npc/ministrider/hunter_laugh3.wav")
impulse.Voice.Register("hunter", "LAUGH4", "[[CODEX/RESPONSE/LAUGH]]", "npc/ministrider/hunter_laugh4.wav")
impulse.Voice.Register("hunter", "LAUGH5", "[[CODEX/RESPONSE/LAUGH]]", "npc/ministrider/hunter_laugh5.wav")
impulse.Voice.Register("hunter", "PAIN1", "[[CODEX/STATE/PAIN]]", "npc/ministrider/hunter_pain2.wav")
impulse.Voice.Register("hunter", "PAIN2", "[[CODEX/STATE/PAIN]]", "npc/ministrider/hunter_pain4.wav")
impulse.Voice.Register("hunter", "SEARCHING1", "[[CODEX/ACTION/SEARCHING]]", "npc/ministrider/hunter_scan1.wav")
impulse.Voice.Register("hunter", "SEARCHING2", "[[CODEX/ACTION/SEARCHING]]", "npc/ministrider/hunter_scan2.wav")
impulse.Voice.Register("hunter", "SEARCHING3", "[[CODEX/ACTION/SEARCHING]]", "npc/ministrider/hunter_scan3.wav")
impulse.Voice.Register("hunter", "SEARCHING4", "[[CODEX/ACTION/SEARCHING]]", "npc/ministrider/hunter_scan4.wav")

impulse.Voice.Register("stalker", "ALERT1", "*Growls*", "npc/stalker/stalker_alert1b.wav")
impulse.Voice.Register("stalker", "ALERT2", "*Growls*", "npc/stalker/stalker_alert2b.wav")
impulse.Voice.Register("stalker", "ALERT3", "*Growls*", "npc/stalker/stalker_alert3b.wav")
impulse.Voice.Register("stalker", "AMBIENT", "*Growls*", "npc/stalker/stalker_ambient01.wav")
impulse.Voice.Register("stalker", "SCREAM1", "*Screams*", "npc/stalker/stalker_scream1.wav")
impulse.Voice.Register("stalker", "SCREAM2", "*Screams*", "npc/stalker/stalker_scream2.wav")
impulse.Voice.Register("stalker", "SCREAM3", "*Screams*", "npc/stalker/stalker_scream3.wav")
impulse.Voice.Register("stalker", "SCREAM4", "*Screams*", "npc/stalker/stalker_scream4.wav")
impulse.Voice.Register("stalker", "SCREAM5", "*Screams*", "npc/stalker/go_alert2.wav")
impulse.Voice.Register("stalker", "LOUDSCREAM", "*Screams Loudly*", "npc/stalker/go_alert2a.wav")
impulse.Voice.Register("stalker", "BREATHE", "*Breathes Heavily*", "npc/stalker/breathing3.wav")


if CLIENT then
    concommand.Add("impulse_hl2rp_printvcs", function(ply, cmd, args)
        if not args[1] then
            return impulse.debugPrint("Enter class as argument 1. (E.G. 'metrocop', 'overwatch', 'vort', 'ordinal', 'citizen_male', 'citizen_female', 'wallhammer', 'scar', 'apf', 'grunt', 'hunter')")
        end

        local classToPrint = string.lower(args[1])

        if not impulse.Voice.List[classToPrint] then
            return impulse.debugPrint("Class invalid.")
        end

        local sortedKeys = {}
        for key, data in pairs(impulse.Voice.List[classToPrint]) do
            table.insert(sortedKeys, key)
        end
        
        table.sort(sortedKeys)

        for _, key in ipairs(sortedKeys) do
            print(tostring(key):upper())
        end
    end)
end

