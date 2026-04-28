AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local MAX_DRUMS    = 4
local PUSH_SPEED   = 80
local LOAD_RADIUS  = 120
local FOLLOW_DIST  = 75
local DEPOSIT_DIST = 200

local BARREL_OFFSETS = {
	Vector(15,  18, -15),
	Vector(15, -18, -15),
	Vector(-15,  18, -15),
	Vector(-15, -18, -15),
}

function ENT:Initialize()
	self:SetModel("models/donald/props_junk/pushcart02a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(80)
		phys:Wake()
	end
	self.drums       = 0
	self.barrelProps = {}
	self.contamFlags = {}
	self.pusher      = nil
	self:SetNWInt("Drums", 0)
	self:SetNWBool("Pushed", false)
end

function ENT:SpawnBarrelProp(slot, contaminated)
	local prop = ents.Create("base_anim")
	if not IsValid(prop) then return end
	prop:SetModel("models/props_c17/oildrum001.mdl")
	prop:SetPos(self:LocalToWorld(BARREL_OFFSETS[slot]))
	prop:SetMoveType(MOVETYPE_NONE)
	prop:SetSolid(SOLID_NONE)
	prop:SetRenderMode(RENDERMODE_NORMAL)
	prop:DrawShadow(false)
	prop:Spawn()
	prop:SetParent(self)
	if contaminated then
		prop:SetColor(Color(165, 100, 40))
	end
	self.barrelProps[slot] = prop
end

function ENT:RemoveBarrelProp(slot)
	if IsValid(self.barrelProps[slot]) then
		self.barrelProps[slot]:Remove()
		self.barrelProps[slot] = nil
	end
	self.contamFlags[slot] = nil
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
		activator:Notify("You cannot interact with this.")
		return
	end

	local ws = impulse.OilWorkshift
	if not ws or not ws.active then
		activator:Notify("No oil workshift is active.")
		return
	end

	if IsValid(self.pusher) and self.pusher ~= activator then
		activator:Notify("Someone else is already pushing this cart.")
		return
	end

	if IsValid(self.pusher) and self.pusher == activator then
		self:ReleasePusher()
		activator:Notify("Cart released.")
		return
	end

	if IsValid(activator.oilCart) then
		activator:Notify("You are already pushing a cart.")
		return
	end

	local nearReservoir = false
	for _, res in ipairs(ents.FindByClass("impulse_hl2rp_crudereservoir")) do
		if self:GetPos():Distance(res:GetPos()) < DEPOSIT_DIST then
			nearReservoir = true
			break
		end
	end

	if nearReservoir and self.drums > 0 then
		self:DepositAll(activator)
		return
	end

	if self.drums < MAX_DRUMS then
		local loaded = self:TryLoadDrums(activator)
		if loaded > 0 then return end
	end

	self.pusher       = activator
	activator.oilCart = self
	self:SetNWBool("Pushed", true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:EnableMotion(false) end

	activator:Notify("Pushing cart (" .. self.drums .. "/" .. MAX_DRUMS .. " drums).")
end

function ENT:TryLoadDrums(activator)
	local loaded = 0
	for _, drum in ipairs(ents.FindByClass("impulse_hl2rp_oildrum")) do
		if self.drums >= MAX_DRUMS then break end
		if drum:GetPos():Distance(self:GetPos()) < LOAD_RADIUS then
			local contaminated = drum:GetNWBool("Contaminated", false)
			self.drums = self.drums + 1
			self.contamFlags[self.drums] = contaminated
			self:SpawnBarrelProp(self.drums, contaminated)
			self:SetNWInt("Drums", self.drums)
			drum:Remove()
			loaded = loaded + 1
		end
	end
	if loaded > 0 then
		self:EmitSound("physics/metal/metal_box_impact_soft1.wav")
		activator:Notify("Loaded " .. loaded .. " drum(s). Cart: " .. self.drums .. "/" .. MAX_DRUMS)
	else
		activator:Notify("No drums nearby to load.")
	end
	return loaded
end

function ENT:DepositAll(activator)
	local ws = impulse.OilWorkshift
	if not ws or not ws.active then return end

	local addLiters = 0
	for i = 1, self.drums do
		if self.contamFlags[i] == "filtering" then
		elseif self.contamFlags[i] then
			addLiters = addLiters + 50
		else
			addLiters = addLiters + 200
		end
	end

	ws.reservoirLiters = math.min(20000, (ws.reservoirLiters or 0) + addLiters)

	for _, res in ipairs(ents.FindByClass("impulse_hl2rp_crudereservoir")) do
		res:SetNWInt("ReservoirLevel", ws.reservoirLiters)
	end

	activator:Notify("[CART] Deposited " .. self.drums .. " drums (" .. addLiters .. "L crude). Reservoir: " .. ws.reservoirLiters .. "L")

	local barrelsNeeded = math.ceil((ws.scaledGoal or 2000) / 40)
	local crudeNeeded   = barrelsNeeded * 200
	local crudeLeft     = math.max(0, crudeNeeded - ws.reservoirLiters)
	local barrelsLeft   = math.ceil(crudeLeft / 200)

	for _, ply in ipairs(player.GetAll()) do
		if ply:SteamID64() == tostring(ws.supervisorID) then
			ply:Notify("[OIL WS] Reservoir: " .. ws.reservoirLiters .. "L | Still needed: " .. barrelsLeft .. " barrels (" .. crudeLeft .. "L)")
			break
		end
	end

	self:EmitSound("physics/liquid/water_impact_hard1.wav")

	for i = 1, MAX_DRUMS do
		self:RemoveBarrelProp(i)
	end
	self.drums       = 0
	self.contamFlags = {}
	self:SetNWInt("Drums", 0)

	if impulse.OilPushUpdate then impulse.OilPushUpdate() end
end

function ENT:TakeContaminatedBarrel()
	for i = 1, self.drums do
		if self.contamFlags[i] then
			self:RemoveBarrelProp(i)
			self.contamFlags[i] = "filtering"
			return i
		end
	end
	return nil
end

function ENT:ReturnCleanBarrel(slot)
	if not slot then return end
	self.contamFlags[slot] = false
	self:SpawnBarrelProp(slot, false)
end

function ENT:CancelFilteredBarrel(slot)
	if not slot then return end
	self.contamFlags[slot] = true
	self:SpawnBarrelProp(slot, true)
end

function ENT:ReleasePusher()
	if IsValid(self.pusher) then
		self.pusher.oilCart = nil
	end
	self.pusher = nil
	self:SetNWBool("Pushed", false)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:EnableMotion(true) end
end

function ENT:Think()
	if not IsValid(self.pusher) then
		self:NextThink(CurTime() + 0.1)
		return true
	end

	if not self.pusher:Alive() then
		self:ReleasePusher()
		self:NextThink(CurTime() + 0.1)
		return true
	end

	local fwd    = self.pusher:GetForward()
	local target = self.pusher:GetPos() + fwd * FOLLOW_DIST + Vector(0, 0, 40)
	self:SetPos(target)
	self:SetAngles(Angle(0, self.pusher:GetAngles().y + 180, 0))

	self:NextThink(CurTime() + 0)
	return true
end

function ENT:OnRemove()
	self:ReleasePusher()
	for i = 1, MAX_DRUMS do
		self:RemoveBarrelProp(i)
	end
end

hook.Add("SetupMove", "OilCart_SlowPusher", function(ply, mv, cmd)
	if IsValid(ply.oilCart) then
		mv:SetMaxClientSpeed(PUSH_SPEED)
		mv:SetMaxSpeed(PUSH_SPEED)
	end
end)