function SWEP:ToggleFireMode()
    if not self.FireModes or #self.FireModes == 1 or (self.NextFMToggle or 0) > CurTime() or self:GetReloading() then return end
    self.NextFMToggle = CurTime() + 1
    local index = self.FireMode or 1
    if index >= #self.FireModes then
        index = 1
    else
        index = index + 1
    end

    local old = self.FireModes[self.FireMode or 1]

    self.FireMode = index
    local data = self.FireModes[index]

    old.Off(self)
    data.On(self)

    if SERVER then
        self:GetOwner():Notify("Changed firemode to " .. data.Name .. ".")
    end
 
    self:PlayAnim(ACT_VM_FIREMODE)
    self:QueueIdle()
end