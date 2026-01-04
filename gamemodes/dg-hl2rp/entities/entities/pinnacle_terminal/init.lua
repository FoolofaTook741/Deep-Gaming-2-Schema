AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")

include("shared.lua")

tbl = {}

--local ENT = ents.Create("testprocessor")

function ENT:Initialize()
	self:SetModel("models/willardnetworks/props_combine/wn_combine_lock.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end

	tbl[0] = self.item1
	tbl[1] = self.item2
	tbl[2] = self.item3
	tbl[3] = self.item4

	util.AddNetworkString("entInit")
	net.Start("entInit")
		net.WriteEntity(self)
	net.Broadcast()

	util.AddNetworkString("itemUpdate"..self:EntIndex())
	net.Start("itemUpdate"..self:EntIndex())
		net.WriteTable(tbl)
	net.Broadcast()
end


function ENT:Touch(entity)
	local enttest = isentity(entity)
	if enttest == true then 
		if entity.GetClass(entity) == self.item1Class then 
			if self.item1 < 2 and timer.Exists("nexttouch") == false then
				entity.Remove(entity)
				self.item1 = self.item1 + 1
				--print(self.item1)

				timer.Create("nexttouch",0.2,1,function() timer.Remove("nexttouch") end)
			end
		end

		if entity.GetClass(entity) == self.item2Class then 
			if self.item2 < 3 and timer.Exists("nexttouch") == false then
				entity.Remove(entity)
				self.item2 = self.item2 + 1

				timer.Create("nexttouch",0.2,1,function() timer.Remove("nexttouch") end)
			end
		end

		if entity.GetClass(entity) == self.item3Class then 
			if self.item3 < 2 and timer.Exists("nexttouch") == false then
				entity.Remove(entity)
				self.item3 = self.item3 + 1

				timer.Create("nexttouch",0.2,1,function() timer.Remove("nexttouch") end)
			end
		end

		if entity.GetClass(entity) == self.item4Class then  
			if self.item4 < 2 and timer.Exists("nexttouch") == false then
				entity.Remove(entity)
				self.item4 = self.item4 + 1

				timer.Create("nexttouch",0.2,1,function() timer.Remove("nexttouch") end)
			end
		end

		tbl[0] = self.item1
		tbl[1] = self.item2
		tbl[2] = self.item3
		tbl[3] = self.item4
		--print(tbl[0])

		util.AddNetworkString("itemUpdate"..self:EntIndex())
		net.Start("itemUpdate"..self:EntIndex())
			net.WriteTable(tbl)
		net.Broadcast()
	end
end

