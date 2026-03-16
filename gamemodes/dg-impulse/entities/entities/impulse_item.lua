AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Category = "impulse"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemID")
end

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)  
		self:SetMoveType(MOVETYPE_VPHYSICS)  
		self:SetSolid(SOLID_VPHYSICS)   
		self:SetUseType(SIMPLE_USE)

    	local physObj = self:GetPhysicsObject()
    	self.nodupe = true

    	if IsValid(physObj) then
			physObj:Wake()
		end
		
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetCustomCollisionCheck(true)
		self:CollisionRulesChanged()
		self.UseDelay = CurTime() + 1
	end

	function ENT:SetItem(itemclass, owner)
		local item = impulse.Inventory.Items[itemclass]
		self:SetItemID(itemclass)
		self:SetModel(item.DropModel or item.Model)
		self:SetSkin(item.Skin or 0)
		self.Item = item
		
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		
        timer.Simple(0, function()
            if not IsValid(self) then return end
            self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            self:SetCustomCollisionCheck(true)
        end)

		if item.Material then
			self:SetMaterial(item.Material)
		end

		if item.ItemColour then
			self:SetColor(item.ItemColour)
		end

		if owner and IsValid(owner) then
			--self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self.ItemOwner = owner
		end
		
		if item.Mass and IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():SetMass(item.Mass)
		end
	end
	

	local classItem = "impulse_item"
	hook.Add("ShouldCollide", "itemCollideStop", function(ent1, ent2)
		local class1, class2 = ent1:GetClass(), ent2:GetClass()
		
		if class1 == classItem and class2 == classItem then
			return false -- explicitly stop collisions between items
		end
		-- Avoid explicitly returning true unless absolutely necessary
	end)

	function ENT:Use(activator)
		if self.UseDelay > CurTime() then
			return
		end

		if activator:IsPlayer() then
			if self.Item.Illegal and activator:IsCP() then
				if activator:GetTeamRank() then
					activator.ConfiscatingItem = self
					net.Start("impulseConfiscateCheck")
					net.WriteEntity(self)
					net.Send(activator)	
				end			
			elseif activator:CanHoldItem(self.Item.UniqueID) then

				if activator:IsCP() and not activator:GetTeamRank() then
					activator:Notify("You cannot interact with items unless you have a rank.")
					return
				end

				if self.BannedUser and self.BannedUser == activator then
					return activator:Notify("You are not allowed to pick up this item.")
				end

				if not activator:Alive() or activator:GetSyncVar(SYNC_ARRESTED, false) then
					return activator:Notify("You are not allowed to pick up items while arrested.")
				end

				local canUse = hook.Run("CanUseInventory", activator)

				if canUse != nil and canUse == false then
					return
				end

				local itemUniqueID = self.Item.UniqueID
				local itemDef = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(itemUniqueID)]
				if itemDef and itemDef.CanStack then
				    for v,k in pairs(impulse.Inventory.Data[activator.impulseID][1]) do
				        if k.class == itemUniqueID and k.restricted then
				            return activator:Notify("You cannot pick up this item currently.")
				        end
				    end
				end

				self:Remove()

				if self.ItemClip then
					activator:GiveInventoryItem(self.Item.UniqueID, nil, nil, nil, nil, self.ItemClip) -- kinda messy ik
				else
					activator:GiveInventoryItem(self.Item.UniqueID, nil, self.IsRestrictedItem or false)
				end
				
				--activator:Notify("You have picked up a "..self.Item.Name..".") grammatical problems + not really needed

				hook.Run("PlayerPickupItem", activator, self.Item.UniqueID)
			else
				activator:Notify("This item is too heavy to pick up.")
			end
		end
	end

	function ENT:Think()
		if self.RemoveIn and CurTime() > self.RemoveIn then
			self:Remove()
			return
		end
		self:NextThink(CurTime() + 0.3)
		return true
	end

	function ENT:OnRemove()
		local owner = self.ItemOwner

		if owner and IsValid(owner) and owner.DroppedItems then
			owner.DroppedItemsC = math.Clamp((owner.DroppedItemsC or 0) - 1, 0, impulse.Config.DroppedItemsLimit)
			owner.DroppedItems[self.DropIndex] = nil
		end
	end
	

else
	function ENT:Think()
		local itemid = self:GetItemID()

		if itemid and itemid != (self.lastItemID or -1) then
			local item = impulse.Inventory.Items[itemid]
			
			if item then
				self.HUDName = item.Name or "Unknown Item"
				self.HUDDesc = item.Desc or ""
				self.lastItemID = itemid
			end
		end
	end
end