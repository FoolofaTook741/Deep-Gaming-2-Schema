function meta:CanUnderstandLanguage(languageid)
    if self:GetSyncVar(SYNC_LANGUAGE) == languageid or self.SnooperMode == true then
        return true
    else
        return false
    end
end