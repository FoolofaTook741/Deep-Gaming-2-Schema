function PLUGIN:CreateSyncVars()
	SYNC_LANGUAGE = impulse.Sync.RegisterVar(SYNC_HUGEINT)
end
-- Curr Languages: 0 = None, 1 = Spanish, 2 = Italian, 3 = German, 4 = Russian, 5 = Chinese, 6 = Japanese, 7 = French, 8 = Arabic
local langstrings = {"Spanish", "Italian", "German", "Russian", "Chinese", "Japanese", "French", "Arabic"}
LANG_SPANISH = 1
LANG_ITALIAN = 2
LANG_GERMAN = 3
LANG_RUSSIAN = 4
LANG_CHINESE = 5
LANG_JAPANESE = 6
LANG_FRENCH = 7
LANG_ARABIC = 8
function meta:LearnLanguage(languageid)
    local ply = self
    local steamid = self:SteamID()
    local query = mysql:Update("impulse_players")
    query:Where("steamid", steamid)
    query:Update("languages", languageid)
    query:Execute()	
    ply.language = languageid
    ply:SetSyncVar(SYNC_LANGUAGE, languageid, true)
end

function meta:AssignLanguage()
    if self.language then
        self:SetSyncVar(SYNC_LANGUAGE, self.language, true)
    end
end