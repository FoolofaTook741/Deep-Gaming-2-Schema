impulse.Ops = impulse.Ops or {}
impulse.Ops.AutoMod = impulse.Ops.AutoMod or {}
impulse.Ops.AutoMod.AllowedFights = {}

local function runCommand(ply,arg,text)
    if not ply:IsSuperAdmin() then return end
    local groupString = string.Split(text, "\"")
    print(#groupString)
    if #groupString < 5 then return ply:Notify("Detected invalid arguments - are you using quotation marks?") end
    local team1, team2, time = groupString[2], groupString[4], isnumber(groupString[#groupString]) and tonumber(groupString[#groupString]) or nil
    if not team1 or not team2 then return ply:Notify("Please provide the arguments of (group1, group2, [duration])") end
    -- Callback is as callback does
    impulse.Group.IsNameUnique(team1, function(team1Invalid)
        if team1Invalid then return ply:Notify("Could not find the first group specified!") end
        impulse.Group.IsNameUnique(team2, function(team2Invalid)
            if team2Invalid then return ply:Notify("Could not find the first group specified!") end
            impulse.Ops.AutoMod.AllowedFights[team1] = time and CurTime() + time or nil
            impulse.Ops.AutoMod.AllowedFights[team2] = time and CurTime() + time or nil
            if time then
                return ply:Notify("You have enabled fighting between " .. team1 .. " and " .. team2 .. ".")
            else
                return ply:Notify("You have disabled fighting between " .. team1 .. " and " .. team2 .. ".")
            end
        end)
    end)    
end

local allowFightCommand = {
    description = "Allow infighting amongst two groups (\"group1\", \"group2\", [duration]) (MUST ENCLOSE GROUP NAMES WITH QUOTATIONS!!!!)",
    leadAdminOnly = true,
    onRun = runCommand
}

impulse.RegisterChatCommand("/allowfights", allowFightCommand)