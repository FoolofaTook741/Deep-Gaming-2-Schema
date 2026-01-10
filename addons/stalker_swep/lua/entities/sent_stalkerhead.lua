AddCSLuaFile( )
DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Stalker Head"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Author = "Hds46"
ENT.Category = "Other"
ENT.Rendergroup = RENDERGROUP_BOTH

ENT.HighDamage = 8
ENT.Radius = 100

ENT.NextUse = 0
ENT.NextShake = 0
ENT.NextShake2 = 0
ENT.AmmoTime = 0
ENT.PainDelay = 0
ENT.EntHealth = 50

if SERVER then
CreateConVar("sh_entity_breakable","1",{FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("sh_entity_painsound","1",{FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("sh_entity_gibs","1",{FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE})
CreateConVar("sh_entity_useable","1",{FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE})
end

if CLIENT then
language.Add("sent_stalkerhead","Stalker Head")
local function STALKERHEADEnt_Menu(panel)
    panel:AddControl("CheckBox", {Label = "Breakable", Command = "sh_entity_breakable"})
	panel:AddControl("CheckBox", {Label = "Useable", Command = "sh_entity_useable"})
	panel:AddControl("CheckBox", {Label = "Gibs", Command = "sh_entity_gibs"})
	panel:AddControl("CheckBox", {Label = "Pain sounds", Command = "sh_entity_painsound"})
end

hook.Add("PopulateToolMenu","STALKERHEADEnt_Menu", function()
	spawnmenu.AddToolMenuOption("Utilities","Scripts","Stalker Head(Entity)","Stalker Head(Entity)","","",STALKERHEADEnt_Menu)
end)
end

StalkerHeadGibs = {}

table.insert( StalkerHeadGibs, "models/gibs/antlion_gib_medium_2.mdl" )
table.insert( StalkerHeadGibs, "models/gibs/HGIBS.mdl" )
table.insert( StalkerHeadGibs, "models/gibs/HGIBS_spine.mdl" )

local PropClasses = {"prop_physics","prop_physics_multiplayer","prop_physics_override","prop_physics_respawnable","prop_ragdoll","prop_ragdoll_attached"}

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 18
    pAngle = ply:GetAngles()
	pAngle.pitch = 0
	pAngle.roll = pAngle.roll
	pAngle.yaw = pAngle.yaw
    local ent = ents.Create( ClassName )
    ent:SetPos( tr.HitPos + Vector(0,0,20) )
	ent:SetAngles( pAngle )
    ent:Spawn( )
    ent:SetNWBool("StalkerAttack",true)
	if !ent.High then
	ent.High = CreateSound(ent,"ambient/levels/citadel/zapper_loop2.wav")
	ent.High:Play()
	end
    return ent
end

function ENT:Initialize( )
    if SERVER then
		self.Entity:SetModel("models/props_lab/jar01b.mdl")
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self:SetNWInt("blood_amount",GetConVar("sh_bloodamount"):GetInt())

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
		phys:Wake()
		phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
		end
		if self:GetNWBool("StalkerAttack") then
			if !self.High then
				self.High = CreateSound(self,"ambient/levels/citadel/zapper_loop2.wav")
				self.High:Play()
			end
		end
	end
	self:SetNWBool("IsStalkerHead",true)
	self.ChargeFrac = 1
	self.NextHitEffect = CurTime()
	self.NextHitEffect2 = CurTime()
	self.HighLaser_Time = 0
	self.PropDissolveTime = 0
	self.NextBlood = 0
end


function ENT:PhysicsCollide(data, physobj)
	if (data.Speed > 80 and data.DeltaTime > 0.2) then
		self.Entity:EmitSound("Flesh_Bloody.ImpactHard")
	end
end

if CLIENT then
function ENT:Draw()
end
local LaserMaterial = Material( "cable/redlaser" );

local MuzzleMaterial = CreateMaterial( "LaserGunMuzzle2", "UnlitGeneric",
{
    ["$basetexture"] = "sprites/redglow1",
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
    ["$additive"] = 1
} );
local MuzzleMaterial2 = CreateMaterial( "LaserGunMuzzle3", "UnlitGeneric",
{
    ["$basetexture"] = "sprites/yellowflare",
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
    ["$additive"] = 1
} );

local MuzzleColor = Color( 255, 255, 255 );

    function ENT:CreateLight(pos,size,numb)
        local dlight = DynamicLight( self:EntIndex()+numb)
        if ( dlight ) then
			dlight.Pos =  pos
            dlight.r = 255
            dlight.g = 91
            dlight.b = 91
            dlight.Brightness = 4
            dlight.Size = size
            dlight.Decay = size*5
            dlight.DieTime = CurTime() + 0.2
        end
    end
	
	function ENT:DoHitEffects( tr )
	if !GetConVar("sh_beam_decal"):GetBool() then return end
    util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
	end
	
	function ENT:DoHitEffects2( tr )
	if !tr.HitWorld then return end
	if tr.HitSky then return end
	if !GetConVar("sh_beam_impactparticles"):GetBool() then return end
	for i=1,math.random(1,3) do
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos + tr.HitNormal*2 )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetStart( self:GetForward()*-1 )
		util.Effect( "stalker_beam_impact", effectdata )
	end
    local emitter = ParticleEmitter( self:GetPos() );
        for i = 1, math.random(2,5) do
            
            local velocity = ( tr.HitNormal + VectorRand() ):GetNormalized();
            velocity:Mul( math.Rand( 100, 125 ) );
            
            local p = emitter:Add( "effects/spark", tr.HitPos );
            p:SetVelocity( velocity );
            p:SetDieTime( 2 );
            p:SetStartSize( math.Rand( 3, 5 ) );
            p:SetEndSize( 2 );
            p:SetStartAlpha( 200 );
            p:SetEndAlpha( 0 );
            p:SetStartLength( 7 );
            p:SetEndLength( 5 );
            p:SetGravity( physenv.GetGravity() );
            p:SetCollide( true );
            p:SetBounce( 0.4 );
			p:SetColor(255,200,200)
            
        end
		emitter:Finish()
	end
	
local function DrawStalkerModel()
for k,self in pairs(ents.GetAll()) do 
if IsValid(self) and self:GetNWBool("IsStalkerHead") then
	if self.NextBloodDrop == nil then
	self.NextBloodDrop = 0
	end
	if self.NextBloodDrop < CurTime() then
	if IsValid(self) and self:GetNWInt("blood_amount") > 0 and GetConVar("sh_blooddrop"):GetBool() then
    local pos = self:GetPos()
	
	local LightColor = render.GetLightColor( pos ) * 255
	LightColor.r = math.Clamp( LightColor.r, 70, 255 )
	
	
	local emitter = ParticleEmitter( pos )
	for i=1, math.random(3,5) do
	local mat
	if math.random(0,10) >= 5 then
	//mat = "particle/water/waterdrop_001a"
	else
	//mat = "effects/slime1"
	end
	local particle = emitter:Add( "effects/blood_drop", pos + Vector(math.random(-4,4),math.random(-4,4),0) + self:GetUp()*-5)
	particle:SetVelocity(Vector(0,0,0))
	particle:SetDieTime( 1.5 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 255 )
	local size = math.Rand( 2, 4 )
	particle:SetStartSize( size )
	particle:SetEndSize( size )
	particle:SetRoll( 0 )
	local size2 = math.Rand( 6, 9 )
	particle:SetStartLength( size2 )
	particle:SetEndLength( size2 )
	particle:SetColor( LightColor.r*0.5, 0, 0 )
	particle:SetGravity( Vector( 0, 0, -100 ) )
	particle:SetCollide( true )
	particle:SetBounce( 0 )
	particle:SetAirResistance( 5 )
    end            
	emitter:Finish()
	
	if math.random(0,10) >= 8 then
	local traceworld = {}
    traceworld.start = self:GetPos() + Vector(math.Rand(-10,10),math.Rand(-10,10),0)
    traceworld.endpos = traceworld.start - Vector(0,0,100)
	traceworld.fliter = {self}
	traceworld.mask = MASK_NPCWORLDSTATIC
    local trw = util.TraceLine(traceworld)
    local worldpos1 = trw.HitPos - trw.HitNormal
    local worldpos2 = trw.HitPos + trw.HitNormal
	util.Decal("blood",worldpos1,worldpos2)
	end
	end
	self.NextBloodDrop = CurTime() + math.Rand(1,1.5)
	end
	local traceworld = {}
    traceworld.start = self:GetPos() + self:GetForward()*10
    traceworld.endpos = traceworld.start + self:GetForward()*9000000
	traceworld.fliter = function(obj) if obj != self then return false end end
    local tr = util.TraceLine(traceworld)
    
    MuzzleColor.a = self.ChargeFrac * 255;
    
    local muzzleSize = 16 + math.Rand( -self.ChargeFrac, self.ChargeFrac );
    muzzleSize = muzzleSize * 2;
    
    local muzzlePos = self:GetPos() + self:GetForward()*5
    
    if IsValid(self) and self:GetNWBool("StalkerAttack") then
	if GetConVar("sh_dynamiclight"):GetBool() then
	self:CreateLight(muzzlePos,100,0);
    self:CreateLight(tr.HitPos,150,1);
	end
        
		    render.SetMaterial( MuzzleMaterial );
    render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
    render.DrawSprite( muzzlePos, muzzleSize, muzzleSize, MuzzleColor );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,64), math.random(16,64), color_white );
		render.SetMaterial( MuzzleMaterial2 );
		render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
        render.DrawSprite( tr.HitPos, math.random(16,32), math.random(16,32), color_white );
		    render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
            render.DrawSprite( muzzlePos, muzzleSize/2, muzzleSize/2, MuzzleColor );
        
        render.SetMaterial( LaserMaterial );
        render.DrawBeam( muzzlePos, tr.HitPos, math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        render.DrawBeam( muzzlePos, tr.HitPos,  math.random(10,20), CurTime()*200, CurTime()*200, color_white );
        
        local increment = tr.HitPos - muzzlePos;
        local distance = increment:Length();
        local num = math.Clamp( math.floor( distance / 40 ), 8, 100 );
        
        increment:Normalize();
        increment:Mul( distance / num );
        
        render.StartBeam( num + 1 );
            
            // don't add a wiggle to the first cp
            render.AddBeam( muzzlePos, 5, 1 );
            
            for i = 1, num do
                
                local vectorRand = VectorRand();
                vectorRand:Mul( 1.1 );
                
                muzzlePos:Add( increment );
                render.AddBeam( muzzlePos + vectorRand, 5, 1 );
                
            end
            
        render.EndBeam();
        
        if( CurTime() > self.NextHitEffect ) then
            
            self:DoHitEffects( tr );
            self.NextHitEffect = CurTime() + 0.05;
            
        end
		
		if( CurTime() > self.NextHitEffect2 ) then
            
            self:DoHitEffects2( tr );
            self.NextHitEffect2 = CurTime() + math.Rand(0.1,0.2);
            
        end
        
    end
	
    if !IsValid(self.CSWorldModel) then
	local inticworldmodel = ClientsideModel("models/stalker.mdl")
	inticworldmodel:SetPos(self:GetPos())
	inticworldmodel:SetAngles(self:GetAngles())
	inticworldmodel:SetNoDraw(true)
	inticworldmodel:SetMaterial("models/flesh")
	self.CSWorldModel = inticworldmodel
	else
	pos, ang = self:GetPos(), self:GetAngles()
	
	local CSWModelAng
	local CSWModelPos
    CSWModelPos = Vector(1, 0, -70)
	CSWModelAng = Angle(0, 0, 0)
		
	pos = pos + ang:Forward() * CSWModelPos.x + ang:Right() * CSWModelPos.y + ang:Up() * CSWModelPos.z
	ang:RotateAroundAxis(ang:Up()		, CSWModelAng.y)
	ang:RotateAroundAxis(ang:Right()	, CSWModelAng.p)
	ang:RotateAroundAxis(ang:Forward()	, CSWModelAng.r)
	self.CSWorldModel:SetPos(pos)
	self.CSWorldModel:SetAngles(ang)
	local normal = self:GetUp()
    local position = normal:Dot( self:GetPos() + self:GetUp()*-6 )
    local oldEC = render.EnableClipping( true )
    render.PushCustomClipPlane( normal, position )
    self.CSWorldModel:DrawModel()
    render.PopCustomClipPlane()
	render.EnableClipping( oldEC )
	end
	if !IsValid(self.CSWorldModel2) then
	local inticworldmodel = ClientsideModel("models/stalker.mdl")
	inticworldmodel:SetPos(self:GetPos())
	inticworldmodel:SetAngles(self:GetAngles())
	inticworldmodel:SetNoDraw(true)
	self.CSWorldModel2 = inticworldmodel
	else
	pos, ang = self:GetPos(), self:GetAngles()
	
	local CSWModelAng
	local CSWModelPos
    CSWModelPos = Vector(1, 0, -70)
	CSWModelAng = Angle(0, 0, 0)
		
	pos = pos + ang:Forward() * CSWModelPos.x + ang:Right() * CSWModelPos.y + ang:Up() * CSWModelPos.z
	ang:RotateAroundAxis(ang:Up()		, CSWModelAng.y)
	ang:RotateAroundAxis(ang:Right()	, CSWModelAng.p)
	ang:RotateAroundAxis(ang:Forward()	, CSWModelAng.r)
	self.CSWorldModel2:SetPos(pos)
	self.CSWorldModel2:SetAngles(ang)
	local normal = self:GetUp()
	local position = normal:Dot( self:GetPos() + self:GetUp()*-5 )
	local oldEC = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, position )
	self.CSWorldModel2:DrawModel()
	render.PopCustomClipPlane()
	render.EnableClipping( oldEC )
	local normal = self:GetUp()
	local position = normal:Dot( self:GetPos() + self:GetUp()*-5 )
	local oldEC2 = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, position )
	self.CSWorldModel2:DrawModel()
	render.PopCustomClipPlane()
	render.EnableClipping( oldEC2 )
	end
end
end
end
hook.Add("PostDrawOpaqueRenderables", "DrawStalkerModel", DrawStalkerModel)
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
	if !dmginfo:IsDamageType( DMG_CRUSH ) and GetConVar("sh_entity_breakable"):GetBool() then
		self.EntHealth = self.EntHealth - dmginfo:GetDamage()
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		effectdata:SetStart( dmginfo:GetDamagePosition())
		util.Effect( "BloodImpact", effectdata)
		self:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav",80,100,1)
		if math.random(0,10) >= 7 and self.PainDelay < CurTime() and GetConVar("sh_entity_painsound"):GetBool() then
			self:EmitSound("stalker/stalker_pain" .. math.random(1,3) .. ".wav",80,100,1)
			self.PainDelay = CurTime() + 1.5
		end
	end
	if self.EntHealth <= 0 then
		self:EmitSound("physics/flesh/flesh_bloody_break.wav",80,100,1)
		for i=1,2 do
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() + VectorRand()*math.random(-10,10) )
			effectdata:SetStart( self:GetPos() + VectorRand()*math.random(-10,10))
			util.Effect( "BloodImpact", effectdata)
		end
		if GetConVar("sh_entity_gibs"):GetBool() then
			for i=math.random(10,20),math.random(20,30) do
				local effectdata = EffectData()
				effectdata:SetOrigin( self:GetPos() + VectorRand()*math.Rand(-10,10) )
				effectdata:SetScale( self:OBBMaxs().z/2 )
				util.Effect( "stalker_gib", effectdata )
			end
		end
		local traceworld = {}
		traceworld.start = self:GetPos() + Vector(math.Rand(-10,10),math.Rand(-10,10),0)
		traceworld.endpos = traceworld.start - Vector(0,0,10)
		traceworld.fliter = {self}
		traceworld.mask = MASK_NPCWORLDSTATIC
		local trw = util.TraceLine(traceworld)
		local worldpos1 = trw.HitPos - trw.HitNormal
		local worldpos2 = trw.HitPos + trw.HitNormal
		util.Decal("blood",worldpos1,worldpos2)
		self:Remove()
	end
end

function ENT:Use(activator)
	if !GetConVar("sh_entity_useable"):GetBool() then return end
	if self.NextUse < CurTime() then
	if self:GetNWBool("HasAmmo") and self:GetNWInt("StalkerBeamEnergy") <= 0 then return end
	if self:GetNWBool("StalkerAttack") then
	if ( self.High ) then self.High:ChangeVolume( 0, 0.02 ) self.High:Stop() self.High = nil end
	if IsValid(self.SoundEntBeam) then
	if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
	self.SoundEntBeam:Remove()
	end
	self:SetNWBool("StalkerAttack",false)
	self:SetNWBool("IsThrowedByPlayer",false)
	else
	if !self.High then
	self.High = CreateSound(self,"ambient/levels/citadel/zapper_loop2.wav")
	self.High:Play()
	end
	self:SetNWBool("StalkerAttack",true)
	end
	self.NextUse = CurTime() + 1.5
	end
end

function ENT:OnRemove()
	if ( self.High ) then self.High:ChangeVolume( 0, 0.02 ) self.High:Stop() self.High = nil end
	if IsValid(self.SoundEntBeam) then
	if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
	self.SoundEntBeam:Remove()
	end
end

function ENT:DissolveEntity(ent,type)
	local entnametodissolve = "entname" .. ent:EntIndex()
	ent:SetKeyValue("targetname",entnametodissolve)
	local dissolver = ents.Create("env_entity_dissolver")
	dissolver:SetPos(ent:GetPos())
	dissolver:SetKeyValue("target", entnametodissolve)
	dissolver:Spawn()
	dissolver:SetOwner(self)
	dissolver:SetPhysicsAttacker(self)
	dissolver:SetKeyValue("dissolvetype",tonumber(type))
	dissolver:Fire("Dissolve", entnametodissolve, 0)
	dissolver:Fire("kill", "", 0.1)
end

function ENT:Think()
	if SERVER then
		if self.NextBlood < CurTime() then
			self:SetNWInt("blood_amount",self:GetNWInt("blood_amount") - 1)
			self.NextBlood = CurTime() + 1
		end
		if self:GetNWBool("IsThrowedByPlayer") and self.NextShake2 < CurTime() then
			self:GetPhysicsObject():ApplyForceCenter(Vector(0,0,math.random(10,20)*10))
			self.NextShake2 = CurTime() + 0.5
		end
		if self:GetNWBool("IsThrowedByPlayer") and self.NextShake < CurTime() then
			self:GetPhysicsObject():AddAngleVelocity( Vector(math.random(50,100)*2,math.random(50,100)*2,math.random(50,100)*2) )
			self.NextShake = CurTime() + math.Rand(0.05,0.2)
		end
		if self:GetNWBool("HasAmmo") and self:GetNWInt("StalkerBeamEnergy") > 0 and self.AmmoTime < CurTime() then
			self:SetNWInt("StalkerBeamEnergy",self:GetNWInt("StalkerBeamEnergy") - 1)
			self.AmmoTime = CurTime() + 0.08
		end
		if self:GetNWBool("HasAmmo") and self:GetNWInt("StalkerBeamEnergy") <= 0 then
			self:SetNWBool("StalkerAttack",false)
			self:SetNWBool("IsThrowedByPlayer",false)
			if ( self.High ) then self.High:ChangeVolume( 0, 0.02 ) self.High:Stop() self.High = nil end
			if IsValid(self.SoundEntBeam) then
				if ( self.SoundEntBeam.High ) then self.SoundEntBeam.High:ChangeVolume( 0, 0.02 ) self.SoundEntBeam.High:Stop() self.SoundEntBeam.High = nil end
				self.SoundEntBeam:Remove()
			end
			if self.NoEnergy == nil then
				self.NoEnergy = true
			end
			if self.NoEnergy and !self:GetNWBool("NoAmmo") then
				self:EmitSound("npc/stalker/breathing3.wav",80,100,1)
				self.NoEnergy = false
			end
		end
		
		if self:GetNWBool("StalkerAttack") then
			local traceworld = {}
			traceworld.start = self:GetPos() + self:GetForward()*10 + self:GetUp()*2
			traceworld.endpos = traceworld.start + self:GetForward()*9000000
			traceworld.fliter = function(obj) if obj != self then return false end end
			traceworld.mins = Vector( -2, -2, -2 )
			traceworld.maxs = Vector( 2, 2, 2 )
			traceworld.mask = MASK_SHOT_HULL
			local tr = util.TraceHull(traceworld)
			if IsValid(self.SoundEntBeam) then
				self.SoundEntBeam:SetPos(tr.HitPos)
			end
			if !IsValid(self.SoundEntBeam) then
				self.SoundEntBeam = ents.Create("base_anim")
				self.SoundEntBeam:SetModel("models/weapons/w_pistol.mdl")
				self.SoundEntBeam:SetPos(tr.HitPos)
				self.SoundEntBeam:Spawn()
				self.SoundEntBeam:SetNoDraw(true)
				self.SoundEntBeam:SetNotSolid(true)
				self.SoundEntBeam:Activate()
				if !self.SoundEntBeam.High then
					self.SoundEntBeam.High = CreateSound(self.SoundEntBeam,"ambient/energy/force_field_loop1.wav")
					self.SoundEntBeam.High:PlayEx( 1, 90 )
				end
			end
			if IsValid(tr.Entity) and tr.Entity and tr.Entity != self and SERVER and self.HighLaser_Time < CurTime() then
				if IsValid(tr.Entity:GetPhysicsObject()) then
					tr.Entity:GetPhysicsObject():ApplyForceCenter(self:GetForward()*8016)
					if !tr.Entity:IsNPC() and !tr.Entity:IsPlayer() and !tr.Entity:IsNextBot() then
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( self )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageType( DMG_ENERGYBEAM )
						dmginfo:SetDamage( GetConVar("sh_damage"):GetInt() )
						tr.Entity:TakeDamageInfo( dmginfo )
					end
					if !GetConVar("sh_propvaporizer"):GetBool() and GetConVar("sh_ignite"):GetBool() then
						tr.Entity:Ignite(3,5)
					end
					for i=1,#PropClasses,1 do
						if string.find(tr.Entity:GetClass(),PropClasses[i]) and GetConVar("sh_propvaporizer"):GetBool() then
							self:DissolveEntity(tr.Entity,3)
						end
					end
				end
				self.HighLaser_Time = CurTime() + 0.08
			end
			if SERVER and self.PropDissolveTime < CurTime() then
				for k,v in pairs(ents.FindInSphere(tr.HitPos,self.Radius)) do
					if IsValid(v) and IsValid(tr.Entity) and v == tr.Entity and (v:IsNPC() or v:IsNextBot() or (v:IsPlayer() and v:Alive()) or (v:IsPlayer())) and tr.Entity != self then
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( self )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamageType( DMG_ENERGYBEAM )
						dmginfo:SetDamage( GetConVar("sh_damage"):GetInt() )
						dmginfo:SetDamageForce( self:GetForward()*(1000*math.Clamp(GetConVar("sh_damage"):GetInt()/100,1,10000)) + Vector(math.random(-400,400)*math.Clamp(GetConVar("sh_damage"):GetInt()/100,1,GetConVar("sh_damage"):GetInt()),math.random(-400,400)*math.Clamp(GetConVar("sh_damage"):GetInt()/100,1,GetConVar("sh_damage"):GetInt()),math.random(100,500)*math.Clamp(GetConVar("sh_damage"):GetInt()/100,1,GetConVar("sh_damage"):GetInt())) )
						if GetConVar("sh_corpsedissolve"):GetBool() then
							v:SetNWBool("instadissolve_damage", true)
							v:SetShouldServerRagdoll( true )
							timer.Create("fix_instdissolve" .. v:EntIndex(),0.2,1,function()
							if IsValid(v) then
								v:SetNWBool("instadissolve_damage", false)
								if v:IsPlayer() then
									v:SetShouldServerRagdoll( false )
								end
								end
							end)
						end
						v:TakeDamageInfo( dmginfo )
						if GetConVar("sh_ignite"):GetBool() then
							v:Ignite(3,5)
						end
						if v:IsPlayer() and v:Alive() and GetConVar("sh_screenflash"):GetBool() and SERVER then
							v:ScreenFade(bit.bor(SCREENFADE.IN,SCREENFADE.PURGE),Color(255,255,255,150),0.2,0)
						end
						if string.find(v:GetClass(),"npc_strider") or string.find(v:GetClass(),"npc_combinegunship") or string.find(v:GetClass(),"npc_helicopter") or string.find(v:GetClass(),"npc_combinedropship") then
							v:SetHealth(v:Health() - GetConVar("sh_damage"):GetInt())
						end
					end
				end
				self.PropDissolveTime = CurTime() + 0.08
			end
		end
	end
	self:NextThink( CurTime() )
	return true
end
