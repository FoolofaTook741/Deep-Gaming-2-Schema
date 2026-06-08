local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local table     = table
local math      = math

function self:InternalId ()
    return "ChrononLabs:Classifier"
end

function self:Constructor ()
    self.WPClassification = ChrononLabs ["ChrononLabs:PluginLoader"]:GetWeaponClassifications ()
    self.WPFromRange = {}
	
    self.GetWPFromRange = function ()
        self.WPFromRange = {}
		
        for weapon, range in pairs (self.WPClassification) do
            self.WPFromRange [range] = self.WPFromRange [range] or {}
            table.insert (self.WPFromRange [range], weapon)
        end
		
        return self.WPFromRange
    end
	
	self.DistanceClassification = function (distance)
		for class_id, range in ipairs (ChrononLabs ["ChrononLabs:Constants"].DistanceRanges) do
			if distance <= range.max then
				return class_id, range.name
			end
		end
		
		return 4, "long"
	end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())