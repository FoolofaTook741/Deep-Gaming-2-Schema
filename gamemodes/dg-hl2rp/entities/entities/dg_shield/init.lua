AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
    self:SetModel("models/hunter/tubes/circle4x4.mdl")
    self:SetModelScale(0.55, 0)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetCollisionGroup(COLLISION_GROUP_NONE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Wake()
    end

    self.Hitpoints = 450
end

sound.Add({
	name = "CUST.OSIHS.Shield",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = SNDLVL_GUNFIRE,
	pitch = {65, 145},
	sound = {"weapons/hla_vc/charger/shield_dmg/npc_charger_shield_01.wav"}
})

function ENT:OnTakeDamage(dmginfo) 
	local id = self:GetCreationID()
	local ply 
	if self:CPPIGetOwner() then
		ply = self:CPPIGetOwner()
	end
	if !timer.Exists(id.."shielddmgcd") then
		self:EmitSound(Sound("CUST.OSIHS.Shield"))
		timer.Create(id.."shielddmgcd", 0.1, 1, function() return end)
	end
	if self.Hitpoints < 0 then
		self:Remove()
		ply:TakeInventoryItemClass("att_assault_shield")
		ply.ShieldActive = false
		ply.shield = nil
		return
	else
		self.Hitpoints = self.Hitpoints - dmginfo:GetDamage()
	end
end