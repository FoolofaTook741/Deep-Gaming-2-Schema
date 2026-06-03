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

	local turrets = {}

	function ENT:RefreshPlayerRelationship(plr)
		local owner = self:GetOwner()
		local ownerTeam

		if !IsValid(owner) then 
			ownerTeam = TEAM_CP
		else 
			ownerTeam = owner:Team()
		end

		local plyTeam = plr:Team()
		local disp = D_HT

		-- this is yucky but seems too fragile to refactor
		if guardTeams[ownerTeam] then
			if guardTeams[plyTeam] and plr.IsRogue then
				disp = D_HT
					
			elseif guardTeams[plyTeam] and not plr.IsRogue then
				disp = D_LI
			end
		elseif civTeams[ownerTeam] then
			if civTeams[plyTeam] then
				disp = D_LI
			elseif plyTeam == TEAM_CP and plr.IsRogue == true then
				disp = D_LI
			end
		end

		self.turret:AddEntityRelationship(plr, disp, 100)
	end

    function ENT:RefreshRelationships()
		if not IsValid(self.turret) then return end
		self.turret:SetEnemy(nil)

		for _, ply in player.Iterator() do
			self:RefreshPlayerRelationship(ply)
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

		self.turret.hp = 200
		self.turretId = table.insert(turrets, self)

		timer.Simple(0, function()
			if !IsValid(self) then return end -- swapped to nil-guard, nesting was an eyesore

			self:RefreshRelationships()
		end)

		-- also yucky but ??
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
    end

    function ENT:OnRemove()
		table.remove(turrets, self.turretId)

        if IsValid(self.turret) then
			self.turret:Remove() 
		end
    end

	hook.Add("EntityTakeDamage", "dispatchTurretHurt", function(targ, dmginfo)
		if targ:GetClass() == "npc_turret_floor" && targ.hp then 
			local hp = targ.hp - dmginfo:GetDamage()

			if hp <= 0 and not targ.destroyed then 
				targ.destroyed = true 
				targ:Fire("SelfDestruct")
			end 

			targ.hp = hp

			dmginfo:SetDamage(0)
		end 
	end)

	local function updatePlr(p)
		for i, v in ipairs(turrets) do
			if not IsValid(v) then 
				table.remove(turrets, i)
			end

			v:RefreshPlayerRelationship(p) 
		end 
	end 

	hook.Add("PlayerInitialSpawnLoaded", "TurretRel_Init", updatePlr)
    hook.Add("PlayerDisconnected", "TurretRel_Discon", updatePlr)
    hook.Add("OnRogueDeclare", "TurretRel_Rogue", updatePlr)
	hook.Add("PlayerChangedTeam", "TurretRel_Team", function(plr)
		for i, v in ipairs(turrets) do
			if not IsValid(v) then 
				table.remove(turrets, i)
				return 
			end

			if v:GetOwner() == plr then 
				v:Remove()
				return 
			end 

			-- thanks, glua!
			timer.Simple(0, function() v:RefreshPlayerRelationship(plr) end)
		end 
	end)
end