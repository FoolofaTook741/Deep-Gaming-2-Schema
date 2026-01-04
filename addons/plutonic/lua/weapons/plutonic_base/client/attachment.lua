function SWEP:Attach(att)
	-- backend
	self.EquippedAttachments[att] = true
	self:AttachmentEquipped(att)
	self.Attachments[att].ModSetup(self)
end

function SWEP:Detach(att)
	-- backend
	self.EquippedAttachments[att] = nil
	self:AttachmentDetached(att)
	self.Attachments[att].ModCleanup(self)

	local attData = self.Attachments[att]
	if attData.Cosmetic and IsValid(self.AttachmentEntCache[att]) then
		self.AttachmentEntCache[att]:Remove()
		self.AttachmentEntCache[att] = nil
	end
end

function SWEP:AttachmentEquipped(att)
end

function SWEP:AttachmentDetached(att)
end