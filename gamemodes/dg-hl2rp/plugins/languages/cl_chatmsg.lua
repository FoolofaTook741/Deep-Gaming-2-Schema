local saycol = Color(230, 230, 80)

net.Receive("DeepLanguageMessage", function()
    local message = net.ReadString()
    local canunderstand = net.ReadBool()
    local language = net.ReadString()
    local speaker = net.ReadEntity()
    if canunderstand == true then
        chat.AddText(team.GetColor(LocalPlayer():Team()), speaker:Name(), saycol, " says in " .. language ..": " .. message)
    else
        chat.AddText(team.GetColor(LocalPlayer():Team()), speaker:Name(), saycol, " says something in " .. language .. ".")
    end
end)