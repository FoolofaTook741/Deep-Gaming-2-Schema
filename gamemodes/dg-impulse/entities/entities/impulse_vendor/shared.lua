ENT.Type      = "anim"
ENT.PrintName = "Vendor"
ENT.Author    = "vin / dg"
ENT.Category  = "impulse"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Vendor"
ENT.HUDDesc = "Press E to interact."

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Vendor")
    self:NetworkVar("String", 1, "IdleSequence")
    self:NetworkVar("String", 2, "HUDNameNet")
    self:NetworkVar("String", 3, "HUDDescNet")
end

function ENT:DoAnimation(custom)
    if (not custom or custom == "") and self._lastGoodIdleSeq then
        custom = self._lastGoodIdleSeq
    elseif custom and custom ~= "" then
        self._lastGoodIdleSeq = custom
    end

    local seq = nil

    if custom and custom ~= "" then
        local names = {}
        for name in custom:gmatch("[^,]+") do
            name = name:match("^%s*(.-)%s*$")
            if name ~= "" then names[#names+1] = name end
        end

        if #names == 1 then
            seq = names[1]
        elseif #names > 1 then
            self._idleCycleIdx = (self._idleCycleIdx or 0) % #names + 1
            seq = names[self._idleCycleIdx]
        end
    end

    local seqID = seq and self:LookupSequence(seq) or 4
    if not seqID or seqID < 0 then seqID = 4 end

    self._appliedSeqID = seqID

    self:SetSequence(seqID)
    self:SetPlaybackRate(1)
    self:SetCycle(0)
    self:ResetSequenceInfo()
end