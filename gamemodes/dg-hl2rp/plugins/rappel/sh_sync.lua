function PLUGIN:SetupSyncVars()
	SYNC_RAPPELLING = impulse.Sync.RegisterVar(SYNC_BOOL)
end

if SERVER then
	function meta:IsRappelling()
		return self.Rappel
	end

	function meta:GetRappelAnchor()
		return self.Rappel.Anchor
	end
else
	function meta:IsRappelling()
		return self:GetSyncVar(SYNC_RAPPELLING, false)
	end
end