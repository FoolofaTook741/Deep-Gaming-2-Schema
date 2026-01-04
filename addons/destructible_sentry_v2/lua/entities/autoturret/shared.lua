ENT.Type = "ai"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Automatic Sentry"
ENT.Spawnable = true
ENT.Category = "dSentries"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Editable = true

local classes = {
    CLASS_ZOMBIE, CLASS_COMBINE,CLASS_CITIZEN_REBEL,CLASS_EARTH_FAUNA,CLASS_PLAYER
}

local decals = {
"combine_turrets/ground_turret",
"atSkin1/turretskin2",
"atSkin2/turretskin2",
"atSkin4/turretskin2",
"atSkin5/turretskin2"
}


function ENT:Notify(name, old, new)
    if(name == "Filters") then
        self.Filters = {}
        local filters = string.Explode(";", new)

        for i = 1, #filters do
            local str = string.lower(string.Trim(filters[i]))

            if(str != "") then
                self.Filters[i] = str
            end
        end
    elseif(name == "PreciseShooting") then
        if new == true then
            self.PSNumber = 99999999
            else self.PSNumber = 10
        end
    elseif(name == "FireSpeed") then
        self.FireSpeat = math.Clamp(new, 0.1, 2.1)
        self.Bulletdmg = Lerp((self.FireSpeat - 0.1) * 0.5, 3, 50)
        self.Sprd = Lerp((self.FireSpeat - 0.1) * 0.5, 0.03, 0.010)
    elseif(name == "Decals") then
        self:SetMaterial(decals[new])
    elseif(name == "SentryType") then
        self.m_iClass = classes[new]
        AccessorFunc( self, "m_iClass", "NPCClass" )
    elseif(name == "FireSound") && self.Sounds != nil then
      	self.ShootSound = self.Sounds[new]
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"TargetOwner",{KeyName = "3q2dhj"})
    self:NetworkVar("Bool",1,"TargetNPCs",{KeyName = "3q3ggdhj"})
    self:NetworkVar("Bool",2,"PreciseShooting",{KeyName = "asdidj235"})
    self:NetworkVar("Bool",4,"TargetClosest",{KeyName = "bdy60sdbrdfg"})
    self:NetworkVar("Int",1, "SearchRadius", {KeyName = "9i234u"})
    self:NetworkVar("Int", 2, "SentryType", {KeyName = "key"})
    self:NetworkVar("String",0, "Filters", {KeyName = "smutnyfantom"})
    self:NetworkVar("Int",3, "FireSound", {KeyName = "smutnyfantom1"})
    self:NetworkVar("Int",4, "MuzzleFlash", {KeyName = "9i234u33"})
    self:NetworkVar("Int",5, "Tracer", {KeyName = "9i2534u333"})
     self:NetworkVar("Int",6, "Decals", {KeyName = "k0m4wewzjfij9"})  
    
    self:NetworkVar("Vector",0, "LaserColor", {KeyName = "cnjeiuwasoj540l"})
    self:NetworkVar("Float",0, "FireSpeed", {KeyName = "9i234u12312"})
    
    if(SERVER) then
        self:NetworkVarNotify("PreciseShooting",self.Notify)
        self:NetworkVarNotify("Decals",self.Notify)
        self:NetworkVarNotify("Filters", self.Notify)
        self:NetworkVarNotify("FireSpeed", self.Notify)
        self:NetworkVarNotify("SentryType", self.Notify)
        self:NetworkVarNotify("FireSound", self.Notify)
    end
end
