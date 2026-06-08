local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local IsValid   = IsValid
local CurTime   = CurTime
local math      = math
local type		= type

function self:InternalId ()
    return "ChrononLabs:Mechanics"
end

function self:InitializeModules ()
	self.Operations = ChrononLabs ["ChrononLabs:Operations"]
	self.Plugin		= ChrononLabs ["ChrononLabs:PluginLoader"]
end

function self:Constructor ()
	self:InitializeModules ()

    self.ProcessDamage = function (target, dmg)
		local Operations = self.Operations
		local GaussianNoise = Operations.GaussianNoise
        local attacker = dmg:GetAttacker ()

        if not IsValid (attacker) 	or not attacker:IsPlayer	() 	or type (attacker) 	~= "Player"
		or not IsValid (target) 	or not target:IsPlayer		() 	or type (target) 	~= "Player" then
			return
		end

		if not dmg:IsBulletDamage () then
			return
		end

        local weapon = attacker:GetActiveWeapon ()

        if not IsValid (weapon) then weapon = attacker:GetActiveWeapon () end
        if not IsValid (weapon) then return end

        local classification = self.Plugin:GetWeaponClassifications () [weapon:GetClass ()]
        if classification then return end

        local sequence = attacker.activeSequence
        if not sequence then return end

		local stats = sequence.sequence_stats
		local targetStats = stats.target_stats
        local damage = math.ceil (dmg:GetDamage ())
        stats.total_damage = stats.total_damage + damage

        local currentDuration = GaussianNoise (Operations, CurTime () - sequence.curtime_start, 3)
        if currentDuration > 0 then
            stats.damage_per_second = GaussianNoise (Operations,
                stats.total_damage / currentDuration, 2
            )
        end

        local targetId = target:EntIndex ()
        if targetStats [targetId] then
            targetStats [targetId].total_damage =
                (targetStats [targetId].total_damage or 0) + damage
        end
    end
end

function self:Destructor ()
	hook.Remove ("PostEntityTakeDamage", "ChrononLabs:DamageProcessor")

	self.ProcessDamage = function ()
	end

	ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
