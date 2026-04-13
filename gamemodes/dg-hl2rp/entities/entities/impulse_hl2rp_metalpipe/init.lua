AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local SCRAP_MODELS = {
	"models/props_c17/metalPot001a.mdl",
	"models/props_c17/metalPot002a.mdl",
	"models/props_interiors/pot02a.mdl",
	"models/props_interiors/pot01a.mdl",
	"models/props_junk/garbage_metalcan002a.mdl",
	"models/props_junk/garbage_metalcan001a.mdl",
	"models/props_junk/MetalBucket01a.mdl",
	"models/props_interiors/refrigeratordoor02a.mdl",
	"models/props_wasteland/prison_pipefaucet001a.mdl",
	"models/props_c17/utilityconnecter002.mdl",
	"models/props_wasteland/prison_padlock001b.mdl",
	"models/props_c17/grinderclamp01a.mdl",
	"models/synapse/alyxports/kettle_01.mdl",
	"models/synapse/alyxports/pan_1.mdl",
	"models/synapse/alyxports/pan_3.mdl",
	"models/static_props/barrel_01_single.mdl",	
	"models/props_wasteland/controlroom_chair001a.mdl",
	"models/props_lab/powerbox02d.mdl",
	"models/props_lab/powerbox02a.mdl",
	"models/props_borealis/door_wheel001a.mdl",
	"models/props_wasteland/controlroom_filecabinet001a.mdl",
	"models/props_interiors/sinkkitchen01a.mdl",
	"models/props_c17/light_industrialbell01_on.mdl",
	"models/props_c17/traffic_light001a.mdl",
	"models/props_c17/lampfixture01a.mdl",


}

local RECYCLE_MODELS = {
	"models/props_c17/clock01.mdl",
	"models/props_c17/doll01.mdl",
	"models/props_junk/garbage_plasticbottle003a.mdl",
	"models/props_junk/garbage_milkcarton001a.mdl",
	"models/props_junk/garbage_plasticbottle002a.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/props/de_tides/vending_turtle.mdl",
	"models/props_junk/garbage_milkcarton002a.mdl",
	"models/props_lab/clipboard.mdl",
	"models/props_junk/garbage_takeoutcarton001a.mdl",
	"models/props_lab/box01b.mdl",
	"models/props_lab/jar01a.mdl",

}

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.useDelay = 0

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(caller, activator)
	if self.useDelay < CurTime() and caller:Team() == TEAM_CWU then
		self.useDelay = CurTime() + 2

		if not impulse.SmeltingWorkshift or not impulse.SmeltingWorkshift.active then
			caller:Notify("There is no active smelting workshift right now.")
			return
		end

		local scrapCount = 0
		for _, ent in ipairs(ents.GetAll()) do
			if IsValid(ent) and (ent:GetNWBool("IsSmeltingItem", false) or ent:GetNWBool("IsRecycleItem", false)) then
				scrapCount = scrapCount + 1
			end
		end

		if scrapCount > 10 then
			caller:Notify("Please process more scrap before requesting more.")
			return
		end

		self:EmitSound("buttons/lever5.wav")

		local pipe = self
		timer.Simple(0.8, function()
			if not IsValid(pipe) then return end

			local isRecycle = math.random(1, 100) <= 25
			local chosenModel

			if isRecycle then
				chosenModel = RECYCLE_MODELS[math.random(1, #RECYCLE_MODELS)]
			else
				chosenModel = SCRAP_MODELS[math.random(1, #SCRAP_MODELS)]
			end

			local prop = ents.Create("prop_physics")
			prop:SetModel(chosenModel)
			prop:SetPos(pipe:GetPos() + Vector(5, 0, -40))
			prop:Spawn()

			if isRecycle then
				prop:SetNWBool("IsRecycleItem", true)
				prop:SetNWBool("IsTurtleItem", chosenModel == "models/props/de_tides/vending_turtle.mdl")
			else
				prop:SetNWBool("IsSmeltingItem", true)
			end

			local phys = prop:GetPhysicsObject()
			if phys:IsValid() then
				phys:Wake()
			end
		end)
	end
end
