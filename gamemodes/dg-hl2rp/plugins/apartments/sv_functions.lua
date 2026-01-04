util.AddNetworkString("impulseHL2RPBuyApartment")
util.AddNetworkString("impulseHL2RPLeaveApartment")

util.AddNetworkString("impulseHL2RPAptAddInhabitant")
util.AddNetworkString("impulseHL2RPAptRemoveInhabitant")

function meta:JoinApartment(blockIndex, aptIndex)
    if not IsValid(self) then return end
    if not self:IsPlayer() then return end
    if self:HasApartment() then return end

    local apt = impulse.ApartmentBlocks[blockIndex].apartments[aptIndex]
    if not apt then return end
    apt:AddInhabitant(self)

    self:SetSyncVar(SYNC_APT_BLOCKKEY, blockIndex, true)
    self:SetSyncVar(SYNC_APT_APTKEY, aptIndex, true)
end

function meta:BuyApartment(blockIndex, aptIndex)
    if not IsValid(self) then return end
    if not self:IsPlayer() then return end
    if self:HasApartment() then return end

    local apt = impulse.ApartmentBlocks[blockIndex].apartments[aptIndex]
    if not apt then return end

    if #apt.inhabitants == 0 then
        if self:CanAfford(impulse.Config.ApartmentCost) then
            self:TakeMoney(impulse.Config.ApartmentCost)
            apt:SetApartmentOwner(self)

            self:SetSyncVar(SYNC_APT_BLOCKKEY, blockIndex, true)
            self:SetSyncVar(SYNC_APT_APTKEY, aptIndex, true)

            self:AchievementGive("ach_apt")
        else
            self:Notify("You have insufficient funds. (".. impulse.Config.ApartmentCost .. impulse.Config.CurrencyPrefix .. ")")
        end
    else
        self:Notify("This apartment is no longer avaiable to be purchased.")
    end
end

net.Receive("impulseHL2RPBuyApartment", function(len, ply)
    if (ply.nextBuyApartment or 0) > CurTime() then return end
    ply.nextBuyApartment = CurTime() + 1

    local blockIndex, aptIndex = net.ReadInt(8), net.ReadInt(8)
    
    ply:BuyApartment(blockIndex, aptIndex)
end)

function meta:LeaveApartment()
    if !IsValid(self) or not self:IsPlayer() or not self:HasApartment() then return end

    local apt = self:GetApartment()
    if self:GetSyncVar(SYNC_APT_ISOWNER, false) == true then
        self:SetSyncVar(SYNC_APT_ISOWNER, nil, true)
        self:Notify("You have sold "..apt:ToString())
        
        for v,k in pairs(apt:GetAllInhabitants()) do
            k:SetSyncVar(SYNC_APT_BLOCKKEY, nil, true)
            k:SetSyncVar(SYNC_APT_APTKEY, nil, true)
        end

        apt:PurgeInhabitants()

        apt:RemoveApartmentOwner()
    else
        apt:RemoveInhabitant(self)
    end

    self:SetSyncVar(SYNC_APT_BLOCKKEY, nil, true)
    self:SetSyncVar(SYNC_APT_APTKEY, nil, true)
end

net.Receive("impulseHL2RPLeaveApartment", function(_, ply)
    if (ply.nextLeaveApartment or 0) > CurTime() then return end
    ply.nextLeaveApartment = CurTime() + 1
    ply:LeaveApartment()
end)


net.Receive("impulseHL2RPAptAddInhabitant", function(_, ply)
    if (ply.nextAddInhab or 0) > CurTime() then return end
    ply.nextAddInhab = CurTime() + 1

    if not ply:HasApartment() then return end
    local inhabitant = net.ReadEntity()
    if not IsValid(inhabitant) or not inhabitant:IsPlayer() then return end
    if inhabitant:HasApartment() or inhabitant:IsCP() then return end
    local apt = ply:GetApartment()

    inhabitant:Notify("You have been granted keys to " .. apt:ToString() .. " by " .. ply:Nick())

    local aptIndex, blockIndex 
    for v,k in pairs(impulse.ApartmentBlocks) do
        for a,b in pairs(k.apartments) do
            if b == apt then
                aptIndex = a
                blockIndex = v
                break
            end
        end
    end
    
    inhabitant:JoinApartment(blockIndex, aptIndex)

    ply:Notify("You have added " .. inhabitant:Nick() .. " to your apartment.")
end)

net.Receive("impulseHL2RPAptRemoveInhabitant", function(_, ply)
    if (ply.nextRemoveInhab or 0) > CurTime() then return end
    ply.nextRemoveInhab = CurTime() + 1

    if not ply:HasApartment() then return end
    local inhabitant = net.ReadEntity()
    if not IsValid(inhabitant) or not inhabitant:IsPlayer() then return end
    local apt = inhabitant:GetApartment()
    if ply:GetApartment() != apt then return end

    inhabitant:Notify("Your keys to " .. apt:ToString() .. " has been revoked by " .. ply:Nick())

    inhabitant:LeaveApartment()

    ply:Notify("You have removed " .. inhabitant:Nick() .. " from your apartment.")
end)