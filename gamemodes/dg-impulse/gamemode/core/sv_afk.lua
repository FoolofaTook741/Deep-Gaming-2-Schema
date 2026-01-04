function meta:MakeAFK()
    if self.AFKImmune then
        return
    end

    self.AFKState = true
    self:Notify("You have been marked as AFK due to inactivity.")

    local playercount = player.GetCount()
    local maxcount = impulse.Config.UserSlots or game.MaxPlayers()
    local limit = impulse.Config.AFKKickRatio * maxcount
    local shouldKick = playercount >= limit and (impulse.Ops.EventManager.GetEventMode() or not self:IsDonator()) and not self:IsAdmin()
    local afkDuration = 300
    local warningTime = afkDuration - 60
    local timerID = "AFKTimer_" .. self:SteamID64()

    timer.Create(timerID .. "_Warning", warningTime, 1, function()
        if not IsValid(self) or not self.AFKState then return end
        if shouldKick then
            self:Notify("Warning: You will be kicked in 1 minute due to inactivity on a busy server.")
        else
            self:Notify("Warning: You will be demoted from your current team in 1 minute due to inactivity.")
        end
    end)

    timer.Create(timerID, afkDuration, 1, function()
        if not IsValid(self) or not self.AFKState then return end
        if shouldKick then
            self:Kick("You have been kicked for inactivity on a busy server. See you again soon!")
        elseif not self:IsAdmin() and self:Team() != impulse.Config.DefaultTeam then
            self:SetTeam(impulse.Config.DefaultTeam, true)
            self:Notify("As a result of inactivity, you have been demoted from your current team.")
        end
    end)
end

function meta:UnMakeAFK()
    self.AFKState = false
    self:Notify("You have returned from being AFK.")
    local timerID = "AFKTimer_" .. self:SteamID64()
    timer.Remove(timerID)
    timer.Remove(timerID .. "_Warning")
end

function meta:IsAFK()
    return self.AFKState or false
end