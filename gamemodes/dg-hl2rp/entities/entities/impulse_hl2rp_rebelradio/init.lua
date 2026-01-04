/*
** Copyright (c) 2019 Sander van Dinteren (aLoneWitness)
** This file is private and may not be shared, downloaded, used or sold.
*/

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

local badRadioStrings = {
	"?",
	"%",
	"{",
	"*",
	"#",
	"_"
}

function ENT:Initialize()
	self:SetModel( "models/props_lab/citizenradio.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.previousPosition = self:GetPos()
	self.connectivityTable = {}

	for v,k in pairs(ents.FindByClass('impulse_hl2rp_rebelradio')) do
		k:UpdateConnectivity()
	end
end

function ENT:Use( caller, activator )
	local button = self:GetNearestButton(activator)
	local oldfrequency = math.Round(self:GetFrequency(), 1)

	if button == 1 then
		self:EmitBudgetSound("buttons/button9.wav", 600, 50, 90)
		self:SetFrequency(math.Clamp(math.Round((oldfrequency - 1.1), 1), 80.2, 120.9))
	elseif button == 2 then
		self:EmitBudgetSound("buttons/button9.wav", 600, 50, 110)
		self:SetFrequency(math.Clamp(math.Round((oldfrequency + 1.1), 1), 80.2, 120.9))
	end
end

function ENT:Transmit(ply, rawText)
	local freq = self:GetFrequency()
	local rfreq = math.Round(freq, 1)

	local ieds = impulse.IEDS or {}
	for v,k in pairs(ieds) do
		if IsValid(k) then
			if k.Freq == rfreq then
				k:Kaboom()
			end
		else
			impulse.IEDS[v] = nil
		end
	end

	self:EmitBudgetSound("ambient/levels/prison/radio_random11.wav")
	ply:SendChatClassMessage(8, rawText, ply)

	for v,k in pairs(ents.FindByClass('impulse_hl2rp_rebelradio')) do
		if k == self then
			continue
		end

		if freq < (k:GetFrequency() + 1) and freq > (k:GetFrequency() - 1) then
			k:Receive(rawText, self, ply)
		end
	end
end

function ENT:Receive(rawText, sender, ply)
	local clarity = self.connectivityTable[sender:EntIndex()]

	self:EmitBudgetSound("ambient/levels/prison/radio_random10.wav")

	if clarity != 5 then
		for v,k in pairs(string.ToTable(rawText)) do
			if k != " " and math.random(1, clarity) == clarity then
				rawText = string.SetChar(rawText, v, table.Random( badRadioStrings))
			end
		end
	end

	for v,k in pairs(player.GetAll()) do
		if k:GetPos():DistToSqr(self:GetPos()) < (impulse.Config.TalkDistance ^ 2) then
			k:SendChatClassMessage(8, rawText, ply)
		end
	end
end

function ENT:Think()
	if self:GetPos():DistToSqr(self.previousPosition) > 50 then
		self:UpdateConnectivity()
	end

	self.previousPosition = self:GetPos()
	self:NextThink(CurTime() + 5)
	return true
end

function ENT:UpdateConnectivity()
	local pos = self:GetPos()
	self.connectivityTable = {}

	for v,k in pairs(ents.FindByClass('impulse_hl2rp_rebelradio')) do
		if k == self then continue end
    	local dist = math.floor(pos:DistToSqr(k:GetPos()) / 100000)

		if dist < 550 then
			self.connectivityTable[k:EntIndex()] = 5 // 0% distortion
		elseif dist < 700 then
			self.connectivityTable[k:EntIndex()] = 4
		elseif dist < 800 then
			self.connectivityTable[k:EntIndex()] = 3
		elseif dist < 1000 then
			self.connectivityTable[k:EntIndex()] = 2
		else
			self.connectivityTable[k:EntIndex()] = 1 // 100% distortion
		end

		k.connectivityTable[self:EntIndex()] = self.connectivityTable[k:EntIndex()]
	end
end
