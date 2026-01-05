AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSkin(1)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
        phys:EnableMotion(true) -- Allow the crate to move!
    end
end
local function TableIsReallyEmpty(tbl)
    for _, _ in pairs(tbl) do
        return false
    end
    return true
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
	local displayName = self:GetNWString("CrateDisplayName", "Order Crate")
	if activator:Nick() ~= displayName then
		return activator:Notify("This is not your supply crate!")
	end
    local contents = self:GetContents()
    for item, data in pairs(contents) do
        if data.count and data.count > 0 then
            activator:GiveInventoryItem(item)

            data.count = data.count - 1
            self.CrateContents[item] = data

            if data.count <= 0 then
                self.CrateContents[item] = nil
            end

            if activator.Notify then
                activator:Notify("You took 1 " .. item .. " from the crate.")
            end

            if TableIsReallyEmpty(self.CrateContents) then
                self:Remove()
            end

            return 
        end
    end

    if activator.Notify then
        activator:Notify("The crate is empty.")
        self:Remove()
    end
end

function ENT:SetContents(tbl)
    self.CrateContents = tbl
end

function ENT:GetContents()
    return self.CrateContents or {}
end
