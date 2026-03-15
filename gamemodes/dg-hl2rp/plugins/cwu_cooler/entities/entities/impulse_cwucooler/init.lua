AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local function GetItemData(class)
    for _, itemData in pairs(impulse.Inventory.Items) do
        if itemData.UniqueID == class then
            return itemData
        end
    end
end

function ENT:Initialize()
    self:SetModel("models/props_c17/display_cooler01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    for i = 1, 9 do
        self:SetNWString("Slot_" .. i .. "_Item", "")
        self:SetNWInt("Slot_" .. i .. "_Price", 0)
    end

    self:SetNWInt("CombineDiscount", 0)
    self:SetNWString("OwnerSID", "")
end

function ENT:SpawnFunction(ply, tr, ClassName)
    if not tr.Hit then return end
    if ply.CoolerCount and ply.CoolerCount >= 1 then
        ply:Notify("You already have a cooler placed.")
        return
    end
    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos + tr.HitNormal * 16)
    ent:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
    ent:Spawn()
    ent:Activate()
    ent:SetNWString("OwnerSID", ply:SteamID())
    ply.CoolerCount = 1
    return ent
end

function ENT:IsOwner(ply)
    return self:GetNWString("OwnerSID", "") == ply:SteamID()
end

function ENT:OnRemove()
    local ownerSID = self:GetNWString("OwnerSID", "")
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == ownerSID then
            ply.CoolerCount = 0
            break
        end
    end
end

function ENT:IsCombine(ply)
    local t = ply:Team()
    return t == TEAM_OTA or t == TEAM_CP or t == TEAM_CA
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    if self:IsOwner(activator) then
        net.Start("CWUCooler_OpenOwner")
            net.WriteEntity(self)
        net.Send(activator)
    else
        net.Start("CWUCooler_OpenBuyer")
            net.WriteEntity(self)
            net.WriteBool(self:IsCombine(activator))
        net.Send(activator)
    end
end

util.AddNetworkString("CWUCooler_OpenOwner")
util.AddNetworkString("CWUCooler_OpenBuyer")
util.AddNetworkString("CWUCooler_SetSlot")
util.AddNetworkString("CWUCooler_SetPrice")
util.AddNetworkString("CWUCooler_SetDiscount")
util.AddNetworkString("CWUCooler_ClearSlot")
util.AddNetworkString("CWUCooler_Purchase")

net.Receive("CWUCooler_SetSlot", function(len, ply)
    local ent    = net.ReadEntity()
    local slot   = net.ReadUInt(4)
    local class  = net.ReadString()
    local invKey = net.ReadUInt(16)

    if not IsValid(ent) or not ent:IsOwner(ply) then return end
    if slot < 1 or slot > 9 then return end

    local invData = ply:GetInventory(1)
    if not invData then
        ply:Notify("Could not read your inventory.")
        return
    end

    local entry = invData[invKey]
    if not entry then
        ply:Notify("Item not found in your inventory.")
        return
    end

    local itemData = GetItemData(class)
    if not itemData then
        ply:Notify("Invalid item data.")
        return
    end

    if itemData.UniqueID ~= class then
        ply:Notify("Item mismatch. Please close and reopen the cooler.")
        return
    end

    if entry.restricted then
        ply:Notify("You cannot place a restricted item in the cooler.")
        return
    end

    ply:TakeInventoryItem(invKey, 1)

    local existing = ent:GetNWString("Slot_" .. slot .. "_Item", "")
    if existing ~= "" then
        ply:GiveInventoryItem(existing, 1)
    end

    ent:SetNWString("Slot_" .. slot .. "_Item", class)
    ply:Notify("Slot " .. slot .. " set to " .. itemData.Name .. ".")
end)

net.Receive("CWUCooler_SetPrice", function(len, ply)
    local ent   = net.ReadEntity()
    local slot  = net.ReadUInt(4)
    local price = net.ReadUInt(16)

    if not IsValid(ent) or not ent:IsOwner(ply) then return end
    if slot < 1 or slot > 9 then return end

    ent:SetNWInt("Slot_" .. slot .. "_Price", math.Clamp(price, 0, 65535))
end)

net.Receive("CWUCooler_SetDiscount", function(len, ply)
    local ent      = net.ReadEntity()
    local discount = net.ReadUInt(7)

    if not IsValid(ent) or not ent:IsOwner(ply) then return end

    ent:SetNWInt("CombineDiscount", math.Clamp(discount, 0, 100))
    ply:Notify("Combine discount set to " .. discount .. "%.")
end)

net.Receive("CWUCooler_ClearSlot", function(len, ply)
    local ent  = net.ReadEntity()
    local slot = net.ReadUInt(4)

    if not IsValid(ent) or not ent:IsOwner(ply) then return end
    if slot < 1 or slot > 9 then return end

    local existing = ent:GetNWString("Slot_" .. slot .. "_Item", "")
    if existing ~= "" then
        ply:GiveInventoryItem(existing, 1)
        ent:SetNWString("Slot_" .. slot .. "_Item", "")
        ent:SetNWInt("Slot_" .. slot .. "_Price", 0)
        ply:Notify("Slot " .. slot .. " cleared. Item returned to your inventory.")
    end
end)

net.Receive("CWUCooler_Purchase", function(len, ply)
    local ent  = net.ReadEntity()
    local slot = net.ReadUInt(4)

    if not IsValid(ent) then return end
    if slot < 1 or slot > 9 then return end

    local class = ent:GetNWString("Slot_" .. slot .. "_Item", "")
    if class == "" then
        ply:Notify("That slot is empty.")
        return
    end

    local price    = ent:GetNWInt("Slot_" .. slot .. "_Price", 0)
    local discount = ent:GetNWInt("CombineDiscount", 0)

    if ent:IsCombine(ply) and discount > 0 then
        price = math.floor(price * ((100 - discount) / 100))
    end

    if ply:GetMoney() < price then
        ply:Notify("You cannot afford this. Cost: " .. price .. " credits.")
        return
    end

    ply:TakeMoney(price)

    local ownerSID = ent:GetNWString("OwnerSID", "")
    local owner = nil
    for _, p in ipairs(player.GetAll()) do
        if p:SteamID() == ownerSID then
            owner = p
            break
        end
    end

    if IsValid(owner) then
        owner:GiveBankMoney(price)
        local soldData = GetItemData(class)
        owner:Notify("Your cooler sold " .. (soldData and soldData.Name or class) .. " for " .. price .. " credits.")
    else
        if impulse.Inventory and impulse.Inventory.AddOfflineWallet then
            impulse.Inventory.AddOfflineWallet(ownerSID, price)
        end
    end

    ply:GiveInventoryItem(class, 1)

    ent:SetNWString("Slot_" .. slot .. "_Item", "")
    ent:SetNWInt("Slot_" .. slot .. "_Price", 0)

    local soldData = GetItemData(class)
    local itemName = soldData and soldData.Name or class
    ply:Notify("Purchased " .. itemName .. " for " .. price .. " credits.")
end)

local function ReturnCoolerItems(ply)
    if not ply.CoolerCount or ply.CoolerCount < 1 then return end
    local sid = ply:SteamID()
    for _, ent in ipairs(ents.FindByClass("impulse_cwucooler")) do
        if IsValid(ent) and ent:GetNWString("OwnerSID", "") == sid then
            for i = 1, 9 do
                local class = ent:GetNWString("Slot_" .. i .. "_Item", "")
                if class ~= "" then
                    ply:GiveInventoryItem(class, INV_STORAGE)
                    ent:SetNWString("Slot_" .. i .. "_Item", "")
                    ent:SetNWInt("Slot_" .. i .. "_Price", 0)
                end
            end
            ent:Remove()
            break
        end
    end
end

hook.Add("PlayerDeath", "CWUCooler_ReturnOnDeath", function(ply)
    ReturnCoolerItems(ply)
end)

hook.Add("PlayerChangedTeam", "CWUCooler_ReturnOnTeamChange", function(ply, oldTeam, newTeam)
    ReturnCoolerItems(ply)
end)