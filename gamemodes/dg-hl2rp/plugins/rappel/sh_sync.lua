function PLUGIN:SetupSyncVars()
	SYNC_RAPPELLING = impulse.Sync.RegisterVar(SYNC_BOOL)
	SYNC_RAPPEL_ANCHOR = impulse.Sync.RegisterVar(SYNC_VECTOR)
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

	function meta:GetRappelAnchor()
		return self:GetSyncVar(SYNC_RAPPEL_ANCHOR, Vector())
	end
end