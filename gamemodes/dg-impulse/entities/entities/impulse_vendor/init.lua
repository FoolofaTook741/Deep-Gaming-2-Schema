AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function SafeSet(ent, method, ...)
    if ent[method] then ent[method](ent, ...) end
end

function ENT:Initialize()
    self.impulseSaveKeyValue = self.impulseSaveKeyValue or {}

    local uid = self.impulseSaveKeyValue["vendorUID"] or self.impulseSaveKeyValue["vendor"] or ""

    self._vendorUID = uid
    SafeSet(self, "SetVendor", uid)

    if uid ~= "" then
        local vendorData = (impulse.Vendor.LiveData and impulse.Vendor.LiveData[uid])
                        or (impulse.Vendor.Data     and impulse.Vendor.Data[uid])
        if vendorData then
            self:ApplyVendorData(vendorData)
        else
            timer.Simple(2, function()
                if not IsValid(self) then return end
                local vd = (impulse.Vendor.LiveData and impulse.Vendor.LiveData[uid])
                        or (impulse.Vendor.Data     and impulse.Vendor.Data[uid])
                if vd then self:ApplyVendorData(vd) end
            end)
        end
    end

    if not self.Vendor then
        self:SetModel("models/Humans/Group01/male_02.mdl")
        SafeSet(self, "SetHUDNameNet", "Unconfigured Vendor")
        SafeSet(self, "SetHUDDescNet", "Superadmins: press E to configure.")
        self.HUDName = "Unconfigured Vendor"
        self.HUDDesc = "Superadmins: press E to configure."
    end

    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
    self:DrawShadow(false)

    timer.Simple(1, function()
        if IsValid(self) then
            self:DoAnimation(self:GetIdleSequence())
        end
    end)
end

function ENT:GetVendorUID()
    return self._vendorUID or (self.GetVendor and self:GetVendor()) or ""
end

function ENT:SetVendorUID(uid)
    self._vendorUID = uid
    self.impulseSaveKeyValue = self.impulseSaveKeyValue or {}
    self.impulseSaveKeyValue["vendorUID"] = uid
    SafeSet(self, "SetVendor", uid)
end

function ENT:ApplyVendorData(v)
    self.Vendor = v

    if v.Model then self:SetModel(v.Model) end
    if v.Skin  then self:SetSkin(v.Skin) end
    if v.Bodygroups and v.Bodygroups ~= "" then
        self:SetBodyGroups(v.Bodygroups)
    end
    if v.Sequence and v.Sequence ~= "" then
        self:SetIdleSequence(v.Sequence)
    end

    local hudName = v.HUDName or v.Name or "Vendor"
    local hudDesc = v.HUDDesc or ""
    self.HUDName  = hudName
    self.HUDDesc  = hudDesc
    SafeSet(self, "SetHUDNameNet", hudName)
    SafeSet(self, "SetHUDDescNet", hudDesc)

    if v.Initialize then v.Initialize(self) end
end

function ENT:SpawnFunction(ply, trace, class)
    local angles = (trace.HitPos - ply:GetPos()):Angle()
    angles.r = 0
    angles.p = 0
    angles.y = angles.y + 180
    local entity = ents.Create(class)
    entity:SetPos(trace.HitPos + Vector(0, 0, 10))
    entity:SetAngles(angles)
    entity:Spawn()
    return entity
end

function ENT:Use(activator, caller)
    if not self.Vendor then
        return
    end
    if (activator.nextVendorUse or 0) > CurTime() then return end
    activator.nextVendorUse = CurTime() + 1

    if not self.Vendor then
        if activator:IsSuperAdmin() then
            return activator:Notify("This vendor has not been configured yet. Aim at it and press E.")
        end
        return activator:Notify("This vendor is not yet configured.")
    end

    if self.Vendor.CanUse and self.Vendor.CanUse(self, activator) == false then
        if activator:IsSuperAdmin() and self.Vendor._dbManaged then
            activator:Notify("You do not have access to this vendor, but may edit it.")
            net.Start("impulseVendorForceEdit")
            net.WriteString(self:GetVendorUID())
            net.Send(activator)
            return
        end
        return activator:Notify("You cannot use this vendor.")
    end

    if activator:GetSyncVar(SYNC_ARRESTED, false) or not activator:Alive() then return end

    if self.Vendor._dbManaged or self.Vendor.DownloadTrades then
        local function StripFuncs(tbl)
            local out = {}
            for cls, entry in pairs(tbl or {}) do
                local clean = {}
                for k, v in pairs(entry) do
                    if type(v) ~= "function" then
                        clean[k] = v
                    end
                end
                out[cls] = clean
            end
            return out
        end

        local dBuy  = pon.encode(StripFuncs(self.Vendor.Buy))
        local dSell = pon.encode(StripFuncs(self.Vendor.Sell))
        net.Start("impulseVendorUseDownload")
        net.WriteString(self:GetVendorUID())
        net.WriteUInt(#dBuy,  32)
        net.WriteData(dBuy,  #dBuy)
        net.WriteUInt(#dSell, 32)
        net.WriteData(dSell, #dSell)
        net.Send(activator)
    else
        net.Start("impulseVendorUse")
        net.Send(activator)
    end

    activator.currentVendor = self
end

function ENT:Think()
    if self.Vendor and self.Vendor.Think then
        local result = self.Vendor.Think(self)

        if result == true then
            return true
        end
    end

    self:NextThink(CurTime() + 1)
    return true
end