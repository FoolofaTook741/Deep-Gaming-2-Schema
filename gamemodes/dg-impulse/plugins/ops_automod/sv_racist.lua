local slurs = {
    "nigger",
    "nigga",
    "faggot",
    "nogga",
    "nogger",
--   fag removed because automod fuckups
    "f@g",
    "f@ggot",
    "fagg0t",
    "f@gg0t",
    "f4ggot",
    "f4gg0t",
    "n1gga",
    "n1gg@",
    "nigg@",
    "n0gga",
    "nogg@",
    "n0gg@",
    "n1gger",
    "n1gg3r",
    "n1gg4",
    "n1gg4r",
    "niggar",
    "UCh-VCHMsVcb-AppRsF2c2Rw",
    "sC8199W90t8",
    "nGBP2LlS2bY",
    "P_lh60aLP8c",
    "9WpptQzpmWs",
    "UCrPd2ZDrxGG2yinfoya9AEw",
    "UCz7lYPf2xyB8IG6Tve7hbzw",
    "RfVHapVJ_vg",
    "PQ2-nRbZVdk",
    "aLkHm0xkspQ",
    "skibidi",
    "sk1b1d1",
    "skib1d1",
    "skibid1",
    "sk1bid1",
    "sk!b!d!",
    "sk!bid!"
}

local replacements = {
    ["¡"] = "i",
    ["é"] = "e",
    ["è"] = "e",
    ["ê"] = "e",
    ["ë"] = "e",
    ["ç"] = "c",
    ["ñ"] = "n",
    ["ø"] = "o",
    ["ð"] = "d",
    ["å"] = "a",
    ["æ"] = "ae",
    ["ē"] = "e",
    ["č"] = "c",
    ["ŭ"] = "u",
    ["ï"] = "i",
    ["Ï"] = "i",
    ["Ñ"] = "n",
    ["ó"] = "o",
    ["Ó"] = "o",
    ["ò"] = "o",
    ["Ò"] = "o",
    ["ô"] = "o",
    ["Ô"] = "o",
    ["ö"] = "o",
    ["ո"] = "n",
    ["о"] = "o",
    ["ο"] = "o",
    ["օ"] = "o",
    ["е"] = "e",
    ["ԁ"] = "d",
    ["һ"] = "h"
}

function impulse.Ops.AutoMod.FilterMessage(ply, text)
	local risk = 0
    local i
    local str = text:lower():Replace(" ","") -- remove whitespace to prevent bypass by doing "F A G G O T"
    for mat, rep in pairs(replacements) do
        str = str:Replace(mat,rep)
    end
    for code, slur in ipairs(slurs) do
        local _,ptn = str:gsub(slur,slur) 
        if ptn > 0 then
            --ptn = {ptn} -- #ptn
            risk = risk + (8*ptn)
            i = code
        end
    end
    if risk > 0 then
        if risk == 8 then
            if (ply.OPS_AM_HasBeenWarned or false) then
                impulse.Ops.AutoMod.Ban(
					ply,
					"Blacklisted Words",
					tostring(risk),
					ply:NameID() .. " says " .. text,
					tostring(10080*(risk/8))
				)
                return true
            else
                ply.OPS_AM_HasBeenWarned = true
                ply:Notify("Hello! It appears you have tried to say something that is not tolerated on our services, please refrain from using derogatory words within our server. An automatic punishment has been added to your record.")
                if GExtension then GExtension:Warn(ply:SteamID64(), "AutoMod | Blacklisted Words | Word: " .. slurs[i],0) end
                return true
            end
        end
        impulse.Ops.AutoMod.Ban(ply,"Blacklisted Words",tostring(risk),ply:NameID() .. " says " .. text,tostring(10080*(risk/8)))
        return true
    end
end

function PLUGIN:PlayerSay(ply,text)
    if text:sub(1, 7) == "/report" then return end -- allows people to say it in F3
    local risk = 0
    local i
    local str = text .. "" -- dont store reference
    str = str:lower() -- How the FUCK did I forget this!??!?!?
    str = str:Replace(" ","") -- remove whitespace to prevent bypass by doing "F A G G O T"
    for mat, rep in pairs(replacements) do
        str = str:Replace(mat,rep)
    end
    for code, slur in ipairs(slurs) do
        local _,ptn = str:gsub(slur,slur) 
        if str:find(slur) then
            --ptn = {ptn} -- #ptn
            risk = risk + (8*ptn)
            i = code
        end
    end
    if risk > 0 then
        if risk == 8 then
            if (ply.OPS_AM_HasBeenWarned or false) then
                impulse.Ops.AutoMod.Ban(
					ply,
					"Blacklisted Words",
					tostring(risk),
					ply:NameID() .. " says " .. text,
					tostring(10080*(risk/8))
				)
                return ""
            else
                ply.OPS_AM_HasBeenWarned = true
                ply:Notify("Hello! It appears you have tried to say something that is not tolerated on our services, please refrain from using derogatory words within our server. An automatic punishment has been added to your record.")
                if GExtension then GExtension:Warn(ply:SteamID64(), "AutoMod | Blacklisted Words | Word: " .. slurs[i],0) end
                return ""
            end
        end
        impulse.Ops.AutoMod.Ban(ply,"Blacklisted Words",tostring(risk),ply:NameID() .. " says " .. text,tostring(10080*(risk/8)))
        return ""
    end
end
