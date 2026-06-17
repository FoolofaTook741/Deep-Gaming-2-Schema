include("shared.lua")

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
    self:SetAutomaticFrameAdvance(true)
    self:DoAnimation(self:GetIdleSequence())
end

hook.Add("OnEntityCreated", "VendorNPC.AnimStart", function(ent)
    if not IsValid(ent) or ent:GetClass() ~= "impulse_vendor" then return end
    timer.Simple(0.5, function()
        if IsValid(ent) and ent.SetAutomaticFrameAdvance then
            ent:SetAutomaticFrameAdvance(true)
            ent:DoAnimation(ent.GetIdleSequence and ent:GetIdleSequence() or nil)
        end
    end)
end)

hook.Add("NotifyShouldTransmit", "VendorNPC.PVSReentry", function(ent, shouldTransmit)
    if not IsValid(ent) or ent:GetClass() ~= "impulse_vendor" then return end
    if not shouldTransmit then return end

    timer.Simple(0, function()
        if not IsValid(ent) or not ent.SetAutomaticFrameAdvance then return end

        ent:SetAutomaticFrameAdvance(true)
        local idleSeq = ent.GetIdleSequence and ent:GetIdleSequence() or nil
        ent:DoAnimation(idleSeq)
        ent.nextAnimCheck = CurTime() + 25
    end)
end)

function ENT:GetVendorUID()
    return self._vendorUID or (self.GetVendor and self:GetVendor()) or ""
end

function ENT:Think()
    self:FrameAdvance(FrameTime())

    if self._appliedSeqID and self:GetSequence() ~= self._appliedSeqID then
        self:SetSequence(self._appliedSeqID)
        self:SetPlaybackRate(1)
        self:SetCycle(0)
        self:ResetSequenceInfo()
    end

    if (self.nextAnimCheck or 0) < CurTime() then
        self:DoAnimation(self:GetIdleSequence())
        self.nextAnimCheck = CurTime() + 25
    end

    if (self.nextSyncCheck or 0) < CurTime() then
        self.nextSyncCheck = CurTime() + 1

        local uid = self:GetVendorUID()
        if uid ~= "" and uid ~= self.curVendor then
            local vendorData = (impulse.Vendor.LiveData and impulse.Vendor.LiveData[uid])
                            or (impulse.Vendor.Data     and impulse.Vendor.Data[uid])
            if vendorData then
                self.Vendor  = vendorData
                self.HUDName = vendorData.HUDName or vendorData.Name or self:GetHUDNameNet()
                self.HUDDesc = vendorData.HUDDesc or self:GetHUDDescNet()
            else
                self.HUDName = self:GetHUDNameNet()
                self.HUDDesc = self:GetHUDDescNet()
            end
            self.curVendor = uid
        end

        if self.GetHUDNameNet and self:GetHUDNameNet() ~= "" then
            self.HUDName = self:GetHUDNameNet()
        end
        if self.GetHUDDescNet and self:GetHUDDescNet() ~= "" then
            self.HUDDesc = self:GetHUDDescNet()
        end
    end

    self:SetNextClientThink(CurTime())
    return true
end