--[[
AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

util.AddNetworkString("OpenFabricatorMenu")
util.AddNetworkString("SelectFabricatorWeapon")

local upgradeCost = 5 -- The cost in kg for upgrades for mpf
 
function ENT:Initialize()
 
	self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local function getID(ply, class, storetype)
    storetype = storetype or 1
    local inv = impulse.Inventory.Data[ply.impulseID][storetype] or {}
    for entryID, data in pairs(inv) do
        if data.class == class then
            return entryID
        end
    end
    return nil
end

function ENT:Use(activator, caller)
    local id = self:GetCreationID()
    local selfpos = self:GetPos()
    local outlets = 0
    local generators = 0

	if !activator:HasInventoryItem("resin_machineready") and !activator:IsCP() then
		activator:Notify("You need Machine Ready Resin and one of the following weapons: AR2, MP7, MP7A8, USP, Stun Baton, SPAS-12, AK-47")
		return
    end
    
    if activator:IsCP() and CWU_RESIN < upgradeCost then
        activator:Notify("There is not enough stockpiled resin ("..upgradeCost.." KG).")
        return
    end

    for _, v in pairs(ents.FindByClass("deep_outlet")) do
        if selfpos:Distance(v:GetPos()) < 300 then
            outlets = 1
        end
    end
    for _, v in pairs(ents.FindByClass("deep_generator")) do
        if selfpos:Distance(v:GetPos()) < 300 and v.powered then
            generators = 1
        end
    end

    if outlets < 1 and generators < 1 then
        activator:Notify("No power source nearby...")
        return
    end

    if timer.Exists(id .. "blstation") then
        activator:Notify("The fabricator is already working.")
        return
    end

    local hasWeapons = {}
    local allowedWeapons = {
        ["wep_ar2"] = "AR2",
        ["wep_mp7"] = "MP7",
        ["wep_mp7a8"] = "MP7A8",
        ["wep_shotgun"] = "Shotgun",
        ["wep_ak47"] = "AK-47",
        ["wep_pistol"] = "USP",
        ["wep_stunstick"] = "Stunstick"
    }

    for class, name in pairs(allowedWeapons) do
        if activator:HasInventoryItem(class) then
			local id = getID(activator, class)
			if id and activator:IsInventoryItemRestricted(id, 1) and !activator:IsCP() then
				activator:Notify("The weapon ".. name .." is restricted and cannot be upgraded.")
			else
				table.insert(hasWeapons, { class = class, name = name })
			end
        end
    end

    if #hasWeapons == 0 then
        activator:Notify("You have no valid weapons to upgrade.")
        return
	elseif #hasWeapons == 1 then
		local id = getID(activator, hasWeapons[1].class)
		if id and activator:IsInventoryItemRestricted(id, 1) and !activator:IsCP() then
			activator:Notify("This weapon upgrade is restricted and cannot be performed.")
			return
		end
			UpgradeWeapon(activator, hasWeapons[1].class, self)
        return
    end

	net.Start("OpenFabricatorMenu")
	net.WriteUInt(#hasWeapons, 4)
	for _, weapon in ipairs(hasWeapons) do
		net.WriteString(weapon.class)
		net.WriteString(weapon.name)
	end
	net.WriteEntity(self)
	net.Send(activator)
end

net.Receive("SelectFabricatorWeapon", function(len, ply)
    local weapon = net.ReadString()
    local ent = net.ReadEntity()

    if not IsValid(ent) or not IsValid(ply) then 
        return 
    end
    if ent:GetClass() ~= "deep_fabricator" then 
        return 
    end

    UpgradeWeapon(ply, weapon, ent)
end)

function UpgradeWeapon(ply, weapon, ent)
    
    local teamCheck = ply:Team()

    if timer.Exists(ent:GetCreationID() .. "blstation") then
        ply:Notify("The fabricator is already working.")
        return
    end

    if ply:IsCP() then
        if CWU_RESIN < upgradeCost then
            ply:Notify("There is not enough stockpiled resin ("..upgradeCost.." KG).")
            return
        end
        CWU_RESIN = CWU_RESIN - upgradeCost
    else
        if not ply:HasInventoryItem("resin_machineready") then
            ply:Notify("You need Machine Ready Resin.")
            return
        end
        ply:TakeInventoryItemClass("resin_machineready")
    end

    ply:TakeInventoryItemClass(weapon)

    local ammo = "resin_" .. string.gsub(weapon, "wep_", "")

    ply:Notify("Upgrading " .. weapon .. "...")

    ent:EmitSound("physics/metal/metal_canister_impact_soft2.wav")
    timer.Simple(2, function()
        ent:EmitSound("ambient/machines/combine_shield_touch_loop1.wav")
    end)

    timer.Create(ent:GetCreationID() .. "blstation", 30, 1, function()
        if ply:Team() == teamCheck then
            ply:GiveInventoryItem(ammo, 1, ply:IsCP())
        else
            ply:Notify("Nice try! You can't dupe items after switching teams.")
        end
		ply:Notify("Fabrication complete!")
		ent:StopSound("ambient/machines/combine_shield_touch_loop1.wav")
		timer.Remove(ent:GetCreationID() .. "blstation")
    end)
end

function ENT:OnRemove()
    timer.Remove(self:EntIndex() .. "blstation")
end
--]]