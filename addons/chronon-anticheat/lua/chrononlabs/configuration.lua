local self 		= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print 	= print
local util 		= util

function self:InternalId ()
    return "ChrononLabs:Configuration"
end

function self:Constructor ()
    local SystemInformation = ChrononLabs ["ChrononLabs:Initializer"]

    self.Configuration = {
		ServerAPIToken		= "0134090c554ce550a4a0b7ccaf9283e91aa33b2c5d2ae1b014ab042c1c479c6876261cff6943aecedb6cd8ebbfe5276d73da2b4ded3ac9d95678948fb2d6745b2fdb05d2534535ad77f2b68485735b25",
		ChrononVersion 		= "1",
    }
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())