-- Curr Languages: 0 = None, 1 = Spanish, 2 = Italian, 3 = German, 4 = Russian, 5 = Chinese, 6 = Japanese, 7 = French, 8 = Arabic

local spanishCommand = {
    description = "Sends a standard message but in Spanish.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_SPANISH) == false or ply.language != LANG_SPANISH then
            ply:Notify("You tried to speak but you could not remember the words in Spanish.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_SPANISH))
                net.WriteString("Spanish")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/spanish", spanishCommand)

local italianCommand = {
    description = "Sends a standard message but in Italian.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_ITALIAN) == false or ply.language != LANG_ITALIAN then
            ply:Notify("You tried to speak but you could not remember the words in Italian.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_ITALIAN))
                net.WriteString("Italian")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/italian", italianCommand)

local germanCommand = {
    description = "Sends a standard message but in German.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_GERMAN) == false or ply.language != LANG_GERMAN then
            ply:Notify("You tried to speak but you could not remember the words in German.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_GERMAN))
                net.WriteString("German")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/german", germanCommand)

local russianCommand = {
    description = "Sends a standard message but in Russian.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_RUSSIAN) == false or ply.language != LANG_RUSSIAN then
            ply:Notify("You tried to speak but you could not remember the words in Russian.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_RUSSIAN))
                net.WriteString("Russian")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/russian", russianCommand)

local chineseCommand = {
    description = "Sends a standard message but in Chinese.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_CHINESE) == false or ply.language != LANG_CHINESE then
            ply:Notify("You tried to speak but you could not remember the words in Chinese.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_CHINESE))
                net.WriteString("Chinese")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/chinese", chineseCommand)

local japaneseCommand = {
    description = "Sends a standard message but in Japanese.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_JAPANESE) == false or ply.language != LANG_JAPANESE then
            ply:Notify("You tried to speak but you could not remember the words in Japanese.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_JAPANESE))
                net.WriteString("Japanese")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/japanese", japaneseCommand)

local arabicCommand = {
    description = "Sends a standard message but in Arabic.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_ARABIC) == false or ply.language != LANG_ARABIC then
            ply:Notify("You tried to speak but you could not remember the words in Arabic.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_ARABIC))
                net.WriteString("Arabic")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/arabic", arabicCommand)

local frenchCommand = {
    description = "Sends a standard message but in French.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_FRENCH) == false or ply.language != LANG_FRENCH then
            ply:Notify("You tried to speak but you could not remember the words in French.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_FRENCH))
                net.WriteString("French")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/french", frenchCommand)

local vortigeseCommand = {
    description = "Sends a standard message but in Vortigese.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:Team() ~= TEAM_VORT and ply:SteamID() ~= "STEAM_0:0:64940229" then
            ply:Notify("You tried to speak but you could not remember the words in Vortigese.")
            return
        end

        for k, v in pairs(player.GetAll()) do
            local canunderstand = false
            if v:Team() == TEAM_VORT or v.SnooperMode == true or v:SteamID() == "STEAM_0:0:64940229" then
                canunderstand = true
            end
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(canunderstand)
                net.WriteString("Vortigese")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/vortigese", vortigeseCommand)

local hebrewCommand = {
    description = "Sends a standard message but in Hebrew.",
    requiresArg = true,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        if ply:CanUnderstandLanguage(LANG_HEBREW) == false or ply.language != LANG_HEBREW then
            ply:Notify("You tried to speak but you could not remember the words in Hebrew.")
            return
        end
        for k,v in pairs(player.GetAll()) do
            if v:GetPos():Distance(ply:GetPos()) < 400 or v.SnooperMode == true then
                net.Start("DeepLanguageMessage")
                net.WriteString(rawText)
                net.WriteBool(v:CanUnderstandLanguage(LANG_HEBREW))
                net.WriteString("Hebrew")
                net.WriteEntity(ply)
                net.Send(v)
            end
        end
    end
}

impulse.RegisterChatCommand("/hebrew", hebrewCommand)