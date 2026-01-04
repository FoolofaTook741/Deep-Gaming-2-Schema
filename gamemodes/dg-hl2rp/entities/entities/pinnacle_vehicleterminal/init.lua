AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("PinnaclePurchaseVehicle")
net.Receive("PinnaclePurchaseVehicle", function()
	local cost = net.ReadInt(16)
	local ent_class = net.ReadString()
	local spawn_vec = net.ReadVector()
	local ply = net.ReadPlayer()

	if OCAAB_CUR_FUNDS < cost then return ply:Notify("You do not have enough OCAAB for this.") end
	OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - cost

	ply:Notify("You have spawned the vehicle!")

    net.Start("DeepAdjustFunds")
    net.WriteInt(OCAAB_CUR_FUNDS, 16)
    net.Broadcast()

	local ent = ents.Create(ent_class)
	ent:SetPos(spawn_vec) 
	ent:Spawn()
end)

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSkin(1)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
end

util.AddNetworkString("PinnacleVehicleTerminalOpen")

function ENT:OnTakeDamage(dmg) 
	return false
end

function ENT:Use(activator, caller)
	if activator:IsCP() and (activator:Team() == TEAM_CA or activator:GetTeamClass()) then
		if not self.User then
			self:EmitBudgetSound("ambient/machines/keyboard_slow_1second.wav")
			net.Start("PinnacleVehicleTerminalOpen")
			net.Send(activator)
		else
			activator:Notify("Terminal already in use.")
		end
	else
		self:EmitBudgetSound("buttons/combine_button_locked.wav")
		activator:Notify("You cannot access this terminal.")
	end
	self.nextTry = CurTime() + 1.5
end

local useSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle4.wav"
}

function ENT:EmitUseSound()
	self:EmitSound(useSounds[math.random(1, #useSounds)])
end