AddCSLuaFile()

ENT.Type      = "anim"
ENT.Base      = "base_anim"
ENT.PrintName = "Deployable Turret"
ENT.Author    = "Abarden"
ENT.Spawnable = false

if SERVER then
    local guardTeams = {
        [TEAM_CP]      = true,
        [TEAM_OTA]     = true,
        [TEAM_CA]      = true,
        [TEAM_STALKER] = true,
    }
    local civTeams = {
        [TEAM_CITIZEN] = true,
        [TEAM_CWU]     = true,
        [TEAM_VORT]    = true,
    }

    function ENT:RefreshRelationships()
		if not IsValid(self.turret) then return end
		local owner = self:GetOwner()
		if not IsValid(owner) then return end

		local id = self:EntIndex()
		local ownerTeam = owner:Team()

		--print(string.format("[Turret %d] RefreshRelationships called (owner team=%d)", id, ownerTeam))

		self.turret:SetEnemy(nil)

		for _, ply in ipairs(player.GetAll()) do
			local plyTeam = ply:Team()
			local disp = D_HT
			--print(ply.IsRogue)

			if guardTeams[ownerTeam] then
				if guardTeams[plyTeam] and ply.IsRogue then
					disp = D_HT
					
				elseif guardTeams[plyTeam] and not ply.IsRogue then
					disp = D_LI
				end
			elseif civTeams[ownerTeam] then
				if civTeams[plyTeam] then
					disp = D_LI
				elseif plyTeam == TEAM_CP and ply.IsRogue == true then
					disp = D_LI
				end
			end

			local dispName = (disp == D_LI and "D_LI") or (disp == D_HT and "D_HT") or tostring(disp)
			--print(string.format("[Turret %d] Setting relationship for player %s (team %d) -> %s", id, ply:Nick(), plyTeam, dispName))
			self.turret:AddEntityRelationship(ply, disp, 100)
		end
	end

    function ENT:Initialize()
        self:SetModel("models/mmod/mmod_weapons/weapons/shell.mdl")
        self:DrawShadow(false)
        self:SetNoDraw(true)

        self.turret = ents.Create("npc_turret_floor")
        if not IsValid(self.turret) then return end
        self.turret:SetPos(self:GetPos())
        self.turret:SetAngles(self:GetAngles())
		self.turret:SetMoveType( MOVETYPE_NONE )
		self.turret:SetSolid( SOLID_VPHYSICS )
        self.turret:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
		self.turret:Spawn()
		self.turret:Activate()
		self.turret:SetOwner(self:GetOwner())
		self.NextFreezeTime = 0
		self.turret:SetMaxHealth(200)
		self.turret:SetHealth(200)
		self._takeDamageHook = "TurretTakeDamage_"..self:EntIndex()
		hook.Add("EntityTakeDamage", self._takeDamageHook, function(target, dmginfo)
			if target ~= self.turret then return end
			local hp = target:Health() - dmginfo:GetDamage()
			target:SetHealth(hp)
			if hp <= 0 then
				target:Remove()
			end
			dmginfo:SetDamage(0)
		end)
		timer.Simple(0, function()
			if IsValid(self) then
				self:RefreshRelationships()
			end
		end)
		timer.Simple(1, function()
			if IsValid (self.turret) then
				self.turret:EmitSound("light.wav", 100, 100)
				local FlashBase = ents.Create("env_projectedtexture")
				local Pos,Ang=self.turret:GetBonePosition(1) --head
				local Right=Ang:Right()
				local Up=Ang:Up()
				local Forward=Ang:Forward()
				FlashBase:LookupBone(6)
				FlashBase:SetParent(self.turret)
				FlashBase:SetPos(Pos-Forward*0+Right*-20+Up*0)
				FlashBase:SetKeyValue('lightcolor', "147 226 240")
				FlashBase:SetKeyValue('lightfov', '50')
				FlashBase:SetKeyValue('farz', '1024')
				Ang:RotateAroundAxis(Up,0)
				Ang:RotateAroundAxis(Right,90)
				Ang:RotateAroundAxis(Forward,0)
				Ang:RotateAroundAxis(Ang:Right(),0)
				FlashBase:SetAngles(Ang)
				FlashBase:Spawn()
				FlashBase:Activate()
			end
		end)
        local id = self:EntIndex()
        

        hook.Add("PlayerInitialSpawnLoaded",  "TurretRel_Init_"..id,      function() if IsValid(self) then self:RefreshRelationships() end end)
        hook.Add("PlayerDisconnected","TurretRel_Discon_"..id,  function() if IsValid(self) then self:RefreshRelationships() end end)
        hook.Add("OnRogueDeclare",      "TurretRel_Rogue_"..id,   function() if IsValid(self) then self:RefreshRelationships() end end)
		hook.Add("PlayerChangedTeam", "TurretRel_Team_"..id, function(ply, oldTeam, newTeam)
			if not IsValid(self) then return end
			if ply == self:GetOwner() then
				self:Remove()
			else
				timer.Simple(0,function() self:RefreshRelationships() end)
			end
		end)
    end

    function ENT:OnRemove()
        local id = self:EntIndex()
        hook.Remove("PlayerInitialSpawnLoaded",  "TurretRel_Init_"..id)
        hook.Remove("PlayerDisconnected","TurretRel_Discon_"..id)
        hook.Remove("PlayerChangedTeam", "TurretRel_Team_"..id)
        hook.Remove("OnRogueDeclare",      "TurretRel_Rogue_"..id)
        timer.Remove("TurretRel_Timer_"..id)
        if IsValid(self.turret) then 
			self.turret:Remove() 
		end
    end
	
	function ENT:Think()
		if not IsValid(self.turret) then return end
		if CurTime() >= self.NextFreezeTime then
			self.NextFreezeTime = CurTime() + 1

			local fx = EffectData()
			fx:SetStart( self.turret:GetPos() )
			fx:SetOrigin( self.turret:GetPos() )
			fx:SetMagnitude( 0 )
			fx:SetEntity( self.turret )
			util.Effect( "phys_freeze", fx )
		end

		self:NextThink( CurTime() )
		return true
	end
end
