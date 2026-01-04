AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")
AddCSLuaFile("cl_ui3d2d.lua")
AddCSLuaFile("cl_ui3d2d_extras.lua")
include("shared.lua")

util.AddNetworkString("impulseRebelFabricatorChargeSeq")
util.AddNetworkString("impulseRebelFabricator")
util.AddNetworkString("impulseRebelFabricatorBuyWeapon")


net.Receive("impulseRebelFabricatorBuyWeapon", function()
    local ply = net.ReadPlayer()
    local resinWepClass = net.ReadString()
    local cost = net.ReadInt(16)
    local ent = net.ReadEntity()   
    local reqItem = net.ReadString() or nil

    if not ply:HasInventoryItem(reqItem) then
        return ply:Notify("You need the unupgraded varient of this weapon to upgrade this weapon.")
    end

    if not ply:HasInventoryItem("util_resin") then
        return ply:Notify("You need resin to upgrade this weapon.")
    end

    if ply:HasInventoryItem(resinWepClass) then
        return ply:Notify("You already have this upgrade.")
    end

    ply:TakeInventoryItemClass("util_resin")
    ply:TakeInventoryItemClass(reqItem)
    ply:Notify("You have used your weapon and 1 resin to create an upgraded weapon.")

    ent:SetNWBool("IsUseable", false)
    
    ent:ResetSequence(ent:LookupSequence("print_bay_close_and_print"))
    ent:SetPlaybackRate(1)
    ent:EmitSound("combine_tech/upgrade_station/combine_3d_printer_upgrading_01.wav", 75, 100, 0.5)

     timer.Simple(7, function()
        if IsValid(ent) then
            ent:ResetSequence(ent:LookupSequence("print_bay_open"))
            ent:SetPlaybackRate(1)
            ent:EmitSound("combine_tech/upgrade_station/combine_3d_printer_resin_tray_open_01.wav")
            ply:Notify("You have been given your new upgraded weapon.")
        end
        ply:EmitSound("items/ammo_pickup.wav", 75, 100, 0.5)
        ply:GiveInventoryItem(resinWepClass)
    end)
end)

net.Receive("impulseRebelFabricatorChargeSeq", function()
    local ent = net.ReadEntity()
    local ply = net.ReadPlayer()

    if ent:GetNWBool("IsCharging") then
        return ply:Notify("This fabricator is already charging.")
    end

    if IsValid(ent) and ply:Team() == TEAM_CITIZEN then
        
        if ply:HasInventoryItem("util_resin") then
            ply:TakeInventoryItemClass("util_resin")
            ent.IsUseable = true
            ent:EmitSound("combine_tech/upgrade_station/combine_3d_printer_upgrader_open_01.wav", 75, 100, 0.5)

            ent:SetNWBool("IsCharging", true)
            ent:EmitSound("combine_tech/interface/combine_terminal_loop2.wav", 75, 100, 0.5)
            timer.Simple(10, function()
                if IsValid(ent) then
                    ent:SetNWBool("IsCharging", false)
                    ent:StopSound("combine_tech/interface/combine_terminal_loop2.wav")
                    ent:SetNWBool("IsUseable", true)
                    ent:EmitSound("combine_tech/upgrade_station/combine_3d_printer_upgrader_open_01.wav", 75, 100, 0.5)
                    ent:ResetSequence(ent:LookupSequence("resin_tray_deploy_idle"))
                    ent:SetPlaybackRate(1)
                end
            end)
        else
            return ply:Notify("You need resin to charge this fabricator.")
        end
    end
end)

function ENT:Initialize()
    self:SetModel("models/clankert/combine_crafting/combine_crafting.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    self:SetSequence(3)

    self:SetNWBool("IsUseable", false)
end

function ENT:Use(caller, activator)
end


function ENT:Think()
	-- Do stuff

	self:NextThink( CurTime() ) -- Set the next think to run as soon as possible, i.e. the next frame.

	return true -- Apply NextThink call
end
