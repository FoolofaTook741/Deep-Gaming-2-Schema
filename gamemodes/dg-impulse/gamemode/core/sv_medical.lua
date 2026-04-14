impulse.BrokenLegsPlayers = impulse.BrokenLegsPlayers or {}

function meta:BreakLegs()
    self.BrokenLegsTime = CurTime() + impulse.Config.BrokenLegsHealTime
    if impulse.BrokenLegsPlayers[self] then return end

    impulse.BrokenLegsPlayers[self] = true
    self:SetSyncVar(SYNC_BROKENLEGS, true, true)
    self.BrokenLegs = true
    self:EmitSound("impulse/bone"..math.random(1, 3)..".wav")
    self:Notify("You have broken your legs.")
    hook.Run("PlayerLegsBroken", self)
end

function meta:FixLegs()
    impulse.BrokenLegsPlayers[self] = nil
    self:SetSyncVar(SYNC_BROKENLEGS, false, true)
    self.BrokenLegs = false
    self.BrokenLegsTime = nil
end

hook.Add("PlayerDisconnected", "BrokenLegs_Cleanup", function(ply)
    impulse.BrokenLegsPlayers[ply] = nil
end)