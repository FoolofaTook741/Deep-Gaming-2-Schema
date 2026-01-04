AddCSLuaFile()

ENT.Type          = "anim"
ENT.Base          = "base_anim"
ENT.PrintName     = "Deployable Energy Conduit"
ENT.Author        = "Abarden"
ENT.Information   = ""
ENT.Category      = ""

ENT.Spawnable     = false
ENT.AdminOnly     = false

sound.Add({
    name    = "Dispenser.Play",
    channel = CHAN_STATIC,
    volume  = 1.0,
    level   = 60,
    pitch   = {100, 100},
    sound   = "ambient/machines/combine_shield_loop3.wav"
})

local NonSweps = {
    "weapon_357", "weapon_ar2", "weapon_crossbow", "weapon_frag",
    "weapon_pistol", "weapon_rpg", "weapon_shotgun", "weapon_slam",
    "weapon_smg1"
}

local NonSwepsMags = {
    ["weapon_357"]      = 6,
    ["weapon_ar2"]      = 30,
    ["weapon_crossbow"] = 1,
    ["weapon_frag"]     = 1,
    ["weapon_pistol"]   = 18,
    ["weapon_rpg"]      = 1,
    ["weapon_shotgun"]  = 6,
    ["weapon_slam"]     = 1,
    ["weapon_smg1"]     = 45
}

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_light001a.mdl")
        self:SetNoDraw(false)
        self:DrawShadow(true)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetHealth(100)
        self:SetMaxHealth(self:Health())

        self.GiveAmmo      = false
        self.GiveArmor     = false
        self.GiveHealth    = false
        self.GiveHealthNPC = false
        self.NoAmmo        = false
        self.NoLag         = false

        self:EmitSound("ambient/machines/catapult_throw.wav", 100, 100)
        self:EmitSound("Dispenser.Play", 100, 100)

        local self_name = "engidispenser" .. self:EntIndex()
        self:SetKeyValue("targetname", self_name)

        self.lighteffect = ents.Create("light_dynamic")
        self.lighteffect:SetPos(self:GetPos())
        self.lighteffect:SetOwner(self:GetOwner())
        self.lighteffect:SetParent(self)
        self.lighteffect:Spawn()
        self.lighteffect:SetKeyValue("_light", "147 226 240 255")
        self.lighteffect:SetKeyValue("distance", "200")
    end

    local suitsMarker = GetConVar("suits_ally_marker")
    function ENT:Think()
        local pos = self:GetPos()
        for _, v in ipairs(ents.GetAll()) do
            if v:GetPos():Distance(pos) < 220 then
                self:HealAlly(v)
                self:GiveAmmoTo(v)
                self:GiveArmorTo(v)
            end
        end

        if suitsMarker == 1 and not self.NoLag then
            self.NoLag = true
            local effect = EffectData()
            effect:SetOrigin(pos)
            effect:SetEntity(self)
            util.Effect("phys_freeze", effect)
            timer.Simple(1, function()
                if IsValid(self) then
                    self.NoLag = false
                end
            end)
        end
    end

    function ENT:OnTakeDamage(dmginfo)
        self:TakePhysicsDamage(dmginfo)
        self:SetHealth(self:Health() - dmginfo:GetDamage())
    end

    function ENT:HealAlly(ent)
        if not IsValid(ent) then return end
        if (ent:IsPlayer() or ent:IsNPC()) and
           (ent.CombineSuitUser or string.match(ent:GetClass(), "npc_")) and
           ent:Health() < ent:GetMaxHealth() and not self.GiveHealth then

            self.GiveHealth = true
            local need = math.min(ent:GetMaxHealth() - ent:Health(), 5)
            ent:SetHealth(ent:Health() + need)
            if ent.Juggernaut then
                ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + 15))
            end
            ent:EmitSound("DispenserHealth.CUP")
            local fx = EffectData()
            fx:SetOrigin(ent:GetPos())
            fx:SetEntity(ent)
            util.Effect("phys_unfreeze", fx)
            timer.Simple(0.7, function()
                if IsValid(self) then self.GiveHealth = false end
            end)
        end
    end

    function ENT:GiveAmmoTo(ent)
        if not ent:IsPlayer() or not ent:Alive() or not ent.CombineSuitUser then return end
        local wep = ent:GetActiveWeapon()
        if not IsValid(wep) then return end

        local class = wep:GetClass()
        if wep.Primary and wep.Primary.ClipSize then
            if not self.GiveAmmo then
                self.GiveAmmo = true
                local give = wep.Primary.ClipSize
                local ammoType = wep:GetPrimaryAmmoType()
                if ent:GetAmmoCount(ammoType) < give * 5 then
                    ent:GiveAmmo(give, ammoType)
                    ent:EmitSound("DispenserAmmo.CUP")
                end
                timer.Simple(1, function() if IsValid(self) then self.GiveAmmo = false end end)
            end
        elseif table.HasValue(NonSweps, class) then
            if not self.GiveAmmo then
                self.GiveAmmo = true
                local ammoType = wep:GetPrimaryAmmoType()
                local mag = NonSwepsMags[class]
                if ent:GetAmmoCount(ammoType) < mag * 5 then
                    ent:GiveAmmo(mag, ammoType)
                    ent:EmitSound("DispenserAmmo.CUP")
                end
                timer.Simple(1, function() if IsValid(self) then self.GiveAmmo = false end end)
            end
        end
    end

    function ENT:GiveArmorTo(ent)
        if not ent:IsPlayer() or not ent:Alive() or not ent.CombineSuitUser then return end
        if ent:Armor() >= ent:GetMaxArmor() or self.GiveArmor then return end

        self.GiveArmor = true
        local give = math.random(5, 10)
        ent:SetArmor(math.min(ent:GetMaxArmor(), ent:Armor() + give))
        ent:EmitSound("DispenserArmor.CUP")
        timer.Simple(1, function() if IsValid(self) then self.GiveArmor = false end end)
    end

    function ENT:OnRemove()
        if IsValid(self.lighteffect) then
            self.lighteffect:Fire("Kill", 1, 0)
        end
        self:StopSound("Dispenser.Play")
        self:EmitSound("ambient/energy/power_off1.wav", 100, 100)
    end

end
