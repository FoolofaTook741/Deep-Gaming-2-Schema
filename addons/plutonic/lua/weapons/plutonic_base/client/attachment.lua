function SWEP:Attach(att)
	self.EquippedAttachments = self.EquippedAttachments or {}
	self.Attachments = self.Attachments or {}

	local attData = self.Attachments[att]
	if not attData then return end

	self.EquippedAttachments[att] = true
	self:AttachmentEquipped(att)

	if attData.ModSetup then
		attData.ModSetup(self)
	end
end

function SWEP:Detach(att)
	self.EquippedAttachments = self.EquippedAttachments or {}
	self.Attachments = self.Attachments or {}
	self.AttachmentEntCache = self.AttachmentEntCache or {}

	local attData = self.Attachments[att]
	if not attData then
		self.EquippedAttachments[att] = nil
		self:AttachmentDetached(att)
		return
	end

	self.EquippedAttachments[att] = nil
	self:AttachmentDetached(att)

	if attData.ModCleanup then
		attData.ModCleanup(self)
	end

	if attData.Cosmetic and IsValid(self.AttachmentEntCache[att]) then
		self.AttachmentEntCache[att]:Remove()
		self.AttachmentEntCache[att] = nil
	end
end

function SWEP:AttachmentEquipped(att) end
function SWEP:AttachmentDetached(att) end