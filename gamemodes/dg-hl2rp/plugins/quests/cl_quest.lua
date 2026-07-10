--[[

net.Receive("impulseQuestUpdate", function()
    local id = net.ReadInt(8)
    local quest = net.ReadTable()
    LocalPlayer().CurrentQuest = quest
end)

-- Watcher

hook.Add("Think", "ZoneUpdate-Quests", function()
    local zone = LocalPlayer():GetZoneName()
    if zone == impulse.Config.Zone404Name then
        net.Start("ImpulseHL2RPQuests404Zone")
			net.WritePlayer(LocalPlayer())
		net.SendToServer()
    end
end)

net.Receive("impulseCompleteQuest", function()
    local questTitle = net.ReadString()
    local pnl = vgui.Create("impulseQuestCompleted")
    pnl:SetQuestTitle(questTitle)
end)

]]--