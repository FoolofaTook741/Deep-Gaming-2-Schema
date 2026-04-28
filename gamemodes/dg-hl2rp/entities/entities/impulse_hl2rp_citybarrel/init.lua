AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local REFINERY_CLASS = "deep_oilrefinery"
local REFINE_TIME    = 30
local ITEMS_FULL     = 2
local ITEMS_CONTAM   = 2

local function WrapRefinery(ent)
	if not IsValid(ent) then return end
	if ent._oilWrapped then return end
	ent._oilWrapped = true

	local entClass = scripted_ents.Get(REFINERY_CLASS)
	local orig = entClass and entClass.Use

	ent.Use = function(self, activator, caller)
		if self.oilRefineReady and IsValid(activator) and activator:IsPlayer() then
			if activator:Team() == TEAM_CWU or activator:Team() == TEAM_CITIZEN then
				local count = self.oilReadyCount or ITEMS_FULL
				for i = 1, count do
					activator:GiveInventoryItem("item_oilcan", 1)
				end
				activator:Notify("[REFINERY] Collected " .. count .. "x Refined Oil. Deposit at the collection point!")
				self.oilRefineReady = false
				self.oilReadyCount  = nil
				self:SetColor(Color(255, 255, 255))
				return
			end
		end
		if orig then orig(self, activator, caller) end
	end
end

hook.Add("InitPostEntity", "OilRefinery_WrapExisting", function()
	for _, ent in ipairs(ents.FindByClass(REFINERY_CLASS)) do
		WrapRefinery(ent)
	end
end)

hook.Add("OnEntityCreated", "OilRefinery_WrapNew", function(ent)
	if ent:GetClass() ~= REFINERY_CLASS then return end
	timer.Simple(0, function() WrapRefinery(ent) end)
end)

function ENT:Initialize()
	self:SetModel("models/static_props/barrel_01_single.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.refining = false
	self.refinery = nil
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end
end

function ENT:StartTouch(other)
	if self.refining then return end
	if not IsValid(other) then return end
	if other:GetClass() ~= REFINERY_CLASS then return end

	local ws = impulse.OilWorkshift
	if not ws or not ws.active then return end
	if other.oilRefining or other.oilRefineReady then return end

	local refPos   = other:GetPos()
	local hasPower = false
	for _, v in ipairs(ents.FindByClass("deep_outlet")) do
		if refPos:Distance(v:GetPos()) < 300 then hasPower = true; break end
	end
	if not hasPower then
		for _, v in ipairs(ents.FindByClass("deep_generator")) do
			if refPos:Distance(v:GetPos()) < 300 and v.powered == true then
				hasPower = true; break
			end
		end
	end

	if not hasPower then
		for _, ply in ipairs(ents.FindInSphere(self:GetPos(), 250)) do
			if ply:IsPlayer() then
				ply:Notify("[REFINERY] No power source detected.")
			end
		end
		return
	end

	self.refining       = true
	other.oilRefining   = true
	self.refinery       = other

	local contaminated  = self:GetNWBool("Contaminated", false)
	local itemCount     = contaminated and ITEMS_CONTAM or ITEMS_FULL

	other.oilReadyCount = itemCount
	other:SetColor(Color(255, 210, 50))
	other:EmitSound("ambient/machines/lab_loop1.wav")

	for _, ply in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
		if ply:IsPlayer() then
			ply:Notify("[REFINERY] Refining underway - " .. REFINE_TIME .. " seconds. Press E when green to collect.")
		end
	end

	self._handedOff = true
	self:Remove()

	local refinery = other
	timer.Create("OilRefine_" .. refinery:EntIndex(), REFINE_TIME, 1, function()
		if not IsValid(refinery) then return end
		refinery:StopSound("ambient/machines/lab_loop1.wav")
		refinery:EmitSound("physics/metal/metal_grate_impact_soft3.wav")
		refinery:SetColor(Color(50, 220, 50))
		refinery.oilRefining    = false
		refinery.oilRefineReady = true

		for _, ply in ipairs(ents.FindInSphere(refinery:GetPos(), 400)) do
			if ply:IsPlayer() then
				ply:Notify("[REFINERY] Refining complete! Press E to collect.")
			end
		end
	end)
end

function ENT:OnRemove()
	if self._handedOff then return end
	if IsValid(self.refinery) then
		timer.Remove("OilRefine_" .. self.refinery:EntIndex())
		self.refinery.oilRefining    = false
		self.refinery.oilRefineReady = false
		self.refinery:SetColor(Color(255, 255, 255))
		self.refinery:StopSound("ambient/machines/lab_loop1.wav")
	end
end
