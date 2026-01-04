-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_handcuffed.lua    SHARED --
--                                 --
-- Handcuffed. Limits what         --
-- equipping player can do.        --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = ""

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false

SWEP.Slot = 4
SWEP.PrintName = "Handcuffed"

SWEP.ViewModelFOV = 60
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.UseHands = true
SWEP.IsAlwaysRaised = true

SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipMax = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipMax = -1
SWEP.IsAlwaysRaised = true

SWEP.DeploySpeed = 1.5

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.HoldType = "duel"

SWEP.IsHandcuffs = true
SWEP.CuffType = ""
local LEASH = {}

CreateConVar( "cuffs_allowbreakout", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED,FCVAR_NOTIFY} )

// For anything that might try to drop this
SWEP.CanDrop = false
SWEP.PreventDrop = true
-- Missing anything?

//
// DataTables
function SWEP:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Kidnapper" )
	self:NetworkVar( "Entity", 1, "FriendBreaking" )
	
	self:NetworkVar( "Float", 0, "RopeLength" )
	self:NetworkVar( "Float", 1, "CuffBroken" )
	self:NetworkVar( "Float", 2, "CuffStrength" )
	self:NetworkVar( "Float", 3, "CuffRegen" )
	
	self:NetworkVar( "String", 0, "RopeMaterial" )
	self:NetworkVar( "String", 1, "CuffMaterial" )
	
	self:NetworkVar( "Bool", 0, "CanGag" )
	self:NetworkVar( "Bool", 1, "IsGagged" )
	
	self:NetworkVar( "Bool", 2, "CanBlind" )
	self:NetworkVar( "Bool", 3, "IsBlind" )
	self:NetworkVar( "Bool", 4, "IsLeash" )
	
	self:NetworkVar( "Bool", 5, "IsUnbreakable" )
end

//
// Initialize
function SWEP:Initialize()
	hook.Add( "canDropWeapon", self, function(self, ply, wep) if wep==self then return false end end) // Thank you DarkRP, your code is terrible
	
	if SERVER then
		hook.Add( "Think", self, self.BreakThink )
	end
	if CLIENT then
		hook.Add( "HUDPaint", self, self.CuffsHUD )
		hook.Add( "HUDPaintBackground", self, self.BlindHUDBackground )
	end
	
	if self:GetCuffStrength()<=0 then self:SetCuffStrength(1) end
	if self:GetCuffRegen()<=0 then self:SetCuffRegen(1) end
	self:SetCuffBroken( 0 )
	
	self:SetHoldType( self.HoldType )
end

//
// Standard SWEP functions
function SWEP:PrimaryAttack()
	if SERVER then self:AttemptBreak() end
end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end

//
// Equip and Holster
function SWEP:Equip( newOwner )
	newOwner:SelectWeapon( self:GetClass() )
	
	timer.Simple( 0.1, function() // Fucking FA:S
		if IsValid(self) and  IsValid(newOwner) and newOwner:GetActiveWeapon()~=self then
			local wep = newOwner:GetActiveWeapon()
			if not IsValid(wep) then return end
			
			local oHolster = wep.Holster
			wep.Holster = function() return true end
			newOwner:SelectWeapon( self:GetClass() )
			wep.Holster = oHolster
		end
	end)
	
	return true
end
function SWEP:Holster()
	return self:GetIsLeash()
end

//
// Deploy
function SWEP:Deploy()
	local viewModel = self.Owner:GetViewModel()
	viewModel:SendViewModelMatchingSequence( viewModel:LookupSequence("fists_idle_01") )
	
	if self:GetIsLeash() then self:SetHoldType( LEASH.HoldType or "normal" ) end
	
	return true
end
function SWEP:PreDrawViewModel( viewModel ) // Fixes visible base hands
	viewModel:SetMaterial( "engine/occlusionproxy" )
end
if CLIENT then
	local HadCuffs
	hook.Add( "PreDrawOpaqueRenderables", "Cuffs FixViewModel", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		
		local HasCuffs = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()=="weapon_handcuffed"
		if HadCuffs and not HasCuffs then
			local vm = ply:GetViewModel()
			if IsValid(vm) then
				vm:SetMaterial( "" )
			end
		end
		
		HadCuffs = HasCuffs
	end)
end

function SWEP:OnRemove() // Fixes invisible other weapons
	if IsValid(self.Owner) then
		local viewModel = self.Owner:GetViewModel()
		if IsValid(viewModel) then viewModel:SetMaterial("") end
	end
	if IsValid( self.cmdl_LeftCuff ) then self.cmdl_LeftCuff:Remove() end
	if IsValid( self.cmdl_RightCuff ) then self.cmdl_RightCuff:Remove() end
	return true
end

//
// Release
function SWEP:Uncuff()
	local ply = IsValid(self.Owner) and self.Owner
	
	self:Remove()
	
	if ply then ply:ConCommand( "lastinv" ) end
end

//
// Breakout
if SERVER then
	local BreakSound = Sound( "physics/metal/metal_barrel_impact_soft4.wav" )
	local ResistSounds = {
		Sound( "physics/metal/metal_box_strain1.wav" ), Sound( "physics/metal/metal_box_strain2.wav" ),
		Sound( "physics/metal/metal_box_strain3.wav" ), Sound( "physics/metal/metal_box_strain4.wav" ),
	}
	local ReleaseSounds = {
		Sound( "physics/cardboard/cardboard_box_impact_soft1.wav" ), Sound( "physics/cardboard/cardboard_box_impact_soft2.wav" ),
		Sound( "physics/cardboard/cardboard_box_impact_soft3.wav" ), Sound( "physics/cardboard/cardboard_box_impact_soft4.wav" ),
		Sound( "physics/cardboard/cardboard_box_impact_soft5.wav" ), Sound( "physics/cardboard/cardboard_box_impact_soft6.wav" ),
	}
	function SWEP:Breakout()
		if IsValid(self.Owner) then
			sound.Play( BreakSound, self.Owner:GetShootPos(), 75, 100, 1 )
			if IsValid( self:GetFriendBreaking() ) then
				hook.Call( "OnHandcuffBreak", GAMEMODE, self.Owner, self, self:GetFriendBreaking() )
			else
				hook.Call( "OnHandcuffBreak", GAMEMODE, self.Owner, self )
			end
		end
		
		self:Uncuff()
	end
	function SWEP:AttemptBreak()
		if not cvars.Bool( "cuffs_allowbreakout" ) then return end
		if self:GetIsUnbreakable() then return end
		
		self:SetCuffBroken( self:GetCuffBroken() + math.abs(4/self:GetCuffStrength()) )
		
		if self:GetCuffBroken()>=100 then
			self:Breakout()
		end
		
		if CurTime()>(self.NextResistSound or 0) then
			sound.Play( table.Random( ResistSounds ), self.Owner:GetShootPos(), 75, 100, math.Clamp((self:GetCuffStrength()-0.5)/2, 0.1, 1) )
			self.NextResistSound = CurTime()+0.5
		end
	end
	
	local function GetTrace( ply )
		local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
		if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			local cuffed,wep = tr.Entity:IsHandcuffed()
			if cuffed then return tr,wep end
		end
	end
	function SWEP:BreakThink()
		if (self.NextRegen or 0)<=CurTime() then
			local regen = self:GetCuffRegen()
			local friend = self:GetFriendBreaking()
			if IsValid(friend) and friend:IsPlayer() then
				local tr = GetTrace(friend)
				if tr and tr.Entity==self.Owner then
					regen = (regen*0.5) - (2/self:GetCuffStrength())
				else
					self:SetFriendBreaking( nil )
				end
				
				if CurTime()>(self.NextReleaseSound or 0) then
					sound.Play( table.Random( ReleaseSounds ), self.Owner:GetShootPos(), 75, 100, self:GetCuffStrength()/1.5 )
					self.NextReleaseSound = CurTime()+0.25
				end
			end
			
			self:SetCuffBroken( math.Approach( self:GetCuffBroken(), regen<0 and 100 or 0, math.abs(regen) ) )
			self.NextRegen = CurTime()+0.05
			
			if self:GetCuffBroken()>=100 then self:Breakout() end
		end
		if IsValid(self:GetKidnapper()) and (self:GetKidnapper():IsPlayer() and not self:GetKidnapper():Alive()) then
			self:SetKidnapper( nil )
		end
		if IsValid(self.Owner) then
			self.Owner.KnockoutTimer = CurTime()+10 // Fucking DarkRP
		end
	end
end

//
// UI
if CLIENT then
	surface.CreateFont( "HandcuffsText", {
		font = "Arial",
		size = 20,
		weight = 700,
	})
	local Col = {
		Text = Color(255,255,255), TextShadow = Color(0,0,0),
		
		BoxOutline = Color(0,0,0), BoxBackground = Color(255,255,255,20), BoxLeft = Color(255,0,0), BoxRight = Color(0,255,0),
		
		Blind = Color(0,0,0, 253), Blind2 = Color(0,0,0, 255),
	}
	local matGrad = Material( "gui/gradient" )
	function SWEP:CuffsHUD()
		if self.Owner~=LocalPlayer() then return end
		local w,h = (ScrW()/2), (ScrH()/2)
		
		local TextPos = h+30
		local str = string.format( "Your hands are bound%s",
			((self:GetCuffStrength()>1.2) and " tightly") or ((self:GetCuffStrength()<0.8) and " loosely") or ""
		)
		if self:GetCuffRegen()>1.2 or self:GetCuffRegen()<0.8 then
			str = str.. string.format( " with a %s material", ((self:GetCuffRegen()>1.2) and "sturdy") or "flimsy" )
		end
		
		draw.SimpleText( str, "HandcuffsText", w+1, TextPos+1, Col.TextShadow, TEXT_ALIGN_CENTER )
		draw.SimpleText( str, "HandcuffsText", w, TextPos, Col.Text, TEXT_ALIGN_CENTER )
		
		if self:GetIsBlind() then
			TextPos = TextPos+20
			draw.SimpleText( "You have been bindfolded", "HandcuffsText", w+1, TextPos+1, Col.TextShadow, TEXT_ALIGN_CENTER )
			draw.SimpleText( "You have been bindfolded", "HandcuffsText", w, TextPos, Col.Text, TEXT_ALIGN_CENTER )
		end
		if self:GetIsGagged() then
			TextPos = TextPos+20
			draw.SimpleText( "You have been gagged", "HandcuffsText", w+1, TextPos+1, Col.TextShadow, TEXT_ALIGN_CENTER )
			draw.SimpleText( "You have been gagged", "HandcuffsText", w, TextPos, Col.Text, TEXT_ALIGN_CENTER )
		end
		
		if cvars.Bool( "cuffs_allowbreakout" ) and not self:GetIsUnbreakable() then
			TextPos = TextPos+20
			
			if self.Owner:GetActiveWeapon()==self then
				str = string.format("%s to struggle", (input.LookupBinding("+attack") or "[Primary Fire]"):upper())
			else
				str = "Switch to ".. self.PrintName .." to break out"
			end
			draw.SimpleText( str, "HandcuffsText", w+1, TextPos+1, Col.TextShadow, TEXT_ALIGN_CENTER )
			draw.SimpleText( str, "HandcuffsText", w, TextPos, Col.Text, TEXT_ALIGN_CENTER )
		end
		
		TextPos = TextPos+25
		surface.SetDrawColor( Col.BoxOutline )
		surface.DrawOutlinedRect( w-101, TextPos-1, 202, 22 )
		surface.SetDrawColor( Col.BoxBackground )
		surface.DrawRect( w-100, TextPos, 200, 20 )
		
		render.SetScissorRect( w-100, TextPos, (w-100)+((self:GetCuffBroken()/100)*200), TextPos+20, true )
			surface.SetDrawColor( Col.BoxRight )
			surface.DrawRect( w-100,TextPos, 200,20 )
			
			surface.SetMaterial( matGrad )
			surface.SetDrawColor( Col.BoxLeft )
			surface.DrawTexturedRect( w-100,TextPos, 200,20 )
		render.SetScissorRect( 0,0,0,0, false )
	end
	function SWEP:BlindHUDBackground()
		if self.Owner~=LocalPlayer() then return end
		if self:GetIsBlind() then
			surface.SetDrawColor( Col.Blind )
			surface.DrawRect( 0,0, ScrW(), ScrH() )
			
			surface.SetDrawColor( Col.Blind2 )
			for i=1,ScrH(),5 do
				surface.DrawRect( 0,i, ScrW(), 4 )
			end
			for i=1,ScrW(),5 do
				surface.DrawRect( i,0, 4,ScrH() )
			end
		end
	end
end

//
// Rendering
local renderpos = {
	left = {bone = "ValveBiped.Bip01_L_Wrist", pos=Vector(0.4,-0.15,-0.45), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.015)},
	right = {bone = "ValveBiped.Bip01_R_Wrist", pos=Vector(0.2,-0.15,0.35), ang=Angle(100,0,0), scale = Vector(0.035,0.035,0.015)},
	rope = {l = Vector(-0.2,1.3,-0.25), r = Vector(0.4,1.4,-0.2)},
}
local CuffMdl = "models/hunter/tubes/tube2x2x1.mdl"
local DefaultRope = "cable/cable2"
local RopeCol = Color(255,255,255)
function SWEP:ViewModelDrawn( vm )
	if self:GetIsLeash() then
		self.ViewModelDrawn = LEASH.ViewModelDrawn
		self.PrintName = "Leash"
		
		return
	end
	if not IsValid(vm) then return end
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_LeftCuff ) then return end // What
		self.cmdl_LeftCuff:SetNoDraw( true )
		self.cmdl_LeftCuff:SetParent( vm )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_RightCuff ) then return end
		self.cmdl_RightCuff:SetNoDraw( true )
		self.cmdl_RightCuff:SetParent( vm )
	end
	
	local lpos, lang = self:GetBonePos( renderpos.left.bone, vm )
	local rpos, rang = self:GetBonePos( renderpos.right.bone, vm )
	if not (lpos and rpos and lang and rang) then return end
	
	// Left
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*renderpos.left.pos.x) + (lang:Right()*renderpos.left.pos.y) + (lang:Up()*renderpos.left.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() // Prevents moving axes
	lang:RotateAroundAxis( u, renderpos.left.ang.y )
	lang:RotateAroundAxis( r, renderpos.left.ang.p )
	lang:RotateAroundAxis( f, renderpos.left.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )
	
	local matrix = Matrix()
	matrix:Scale( renderpos.left.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()
	
	// Right
	self.cmdl_RightCuff:SetPos( rpos + (rang:Forward()*renderpos.right.pos.x) + (rang:Right()*renderpos.right.pos.y) + (rang:Up()*renderpos.right.pos.z) )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, renderpos.right.ang.y )
	rang:RotateAroundAxis( r, renderpos.right.ang.p )
	rang:RotateAroundAxis( f, renderpos.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( renderpos.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_RightCuff:DrawModel()
	
	// Rope
	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end
	
	render.SetMaterial( self.RopeMat )
	render.DrawBeam( lpos + (lang:Forward()*renderpos.rope.l.x) + (lang:Right()*renderpos.rope.l.y) + (lang:Up()*renderpos.rope.l.z),
		rpos + (rang:Forward()*renderpos.rope.r.x) + (rang:Right()*renderpos.rope.r.y) + (rang:Up()*renderpos.rope.r.z),
		0.7, 0, 5, RopeCol )
end

local wrender = {
	left = {bone = "ValveBiped.Bip01_L_Hand", pos=Vector(0,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	right = {bone = "ValveBiped.Bip01_R_Hand", pos=Vector(0.2,0,0), ang=Angle(90,0,0), scale = Vector(0.035,0.035,0.035)},
	rope = {l = Vector(-0.2,1.3,-0.25), r = Vector(0.4,1.4,-0.2)},
}
function SWEP:DrawWorldModel()
	if self:GetIsLeash() then
		-- self.DrawWorldModel = LEASH.DrawWorldModel
		self.DrawWorldModel = function() end
		hook.Add( "PostDrawOpaqueRenderables", self, LEASH.DrawWorldModel )
		self.PrintName = "Leash"
		
		return
	end
	if not IsValid(self.Owner) then return end
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_LeftCuff ) then return end
		self.cmdl_LeftCuff:SetNoDraw( true )
		-- self.cmdl_LeftCuff:SetParent( vm )
	end
	if not IsValid(self.cmdl_RightCuff) then
		self.cmdl_RightCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_RightCuff ) then return end
		self.cmdl_RightCuff:SetNoDraw( true )
		-- self.cmdl_RightCuff:SetParent( vm )
	end
	
	local lpos, lang = self:GetBonePos( wrender.left.bone, self.Owner )
	local rpos, rang = self:GetBonePos( wrender.right.bone, self.Owner )
	if not (lpos and rpos and lang and rang) then return end
	
	// Left
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*wrender.left.pos.x) + (lang:Right()*wrender.left.pos.y) + (lang:Up()*wrender.left.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() // Prevents moving axes
	lang:RotateAroundAxis( u, wrender.left.ang.y )
	lang:RotateAroundAxis( r, wrender.left.ang.p )
	lang:RotateAroundAxis( f, wrender.left.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.left.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()
	
	// Right
	self.cmdl_RightCuff:SetPos( rpos + (rang:Forward()*wrender.right.pos.x) + (rang:Right()*wrender.right.pos.y) + (rang:Up()*wrender.right.pos.z) )
	local u,r,f = rang:Up(), rang:Right(), rang:Forward() // Prevents moving axes
	rang:RotateAroundAxis( u, wrender.right.ang.y )
	rang:RotateAroundAxis( r, wrender.right.ang.p )
	rang:RotateAroundAxis( f, wrender.right.ang.r )
	self.cmdl_RightCuff:SetAngles( rang )
	
	local matrix = Matrix()
	matrix:Scale( wrender.right.scale )
	self.cmdl_RightCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_RightCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_RightCuff:DrawModel()
	
	// Rope
	if (lpos.x==0 and lpos.y==0 and lpos.z==0) or (rpos.x==0 and rpos.y==0 and rpos.z==0) then return end // Rope accross half the map...
	
	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end
	
	render.SetMaterial( self.RopeMat )
	render.DrawBeam( lpos + (lang:Forward()*wrender.rope.l.x) + (lang:Right()*wrender.rope.l.y) + (lang:Up()*wrender.rope.l.z),
		rpos + (rang:Forward()*wrender.rope.r.x) + (rang:Right()*wrender.rope.r.y) + (rang:Up()*wrender.rope.r.z),
		0.7, 0, 5, RopeCol )
end

//
// Bones
function SWEP:GetBonePos( bonename, vm )
	local bone = vm:LookupBone( bonename )
	if not bone then return end
	
	local pos,ang = Vector(0,0,0),Angle(0,0,0)
	local matrix = vm:GetBoneMatrix( bone )
	if matrix then
		pos = matrix:GetTranslation()
		ang = matrix:GetAngles()
	end
	
	if self.ViewModelFlip then ang.r = -ang.r end
	
	-- if pos.x==0 and pos.y==0 and pos.z==0 then print( bonename, vm ) end
	return pos, ang
end

//
// Leash
LEASH.HoldType = "normal"

//
// Rendering
local vrender = {
	bone = "ValveBiped.Bip01_L_Wrist",
	pos=Vector(0,0,-1.5),
	ang=Angle(0,0,0),
	scale = Vector(0.01,0.01,0.02),
}
function LEASH:ViewModelDrawn( vm )
	self.UseHands = false
	if not (IsValid(self) and IsValid(self.Owner)) then return end
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_LeftCuff ) then return end
		self.cmdl_LeftCuff:SetNoDraw( true )
		-- self.cmdl_LeftCuff:SetParent( vm )
	end
	
	local lpos, lang = self:GetBonePos( vrender.bone, self.Owner )
	if not (lpos and lang) then return end
	
	-- lpos = self.Owner:GetPos() + self.Owner:GetCurrentViewOffset()
	-- lang = Angle(0,0,0)
	
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*vrender.pos.x) + (lang:Right()*vrender.pos.y) + (lang:Up()*vrender.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() // Prevents moving axes
	lang:RotateAroundAxis( u, vrender.ang.y )
	lang:RotateAroundAxis( r, vrender.ang.p )
	lang:RotateAroundAxis( f, vrender.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )
	
	local matrix = Matrix()
	matrix:Scale( vrender.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()
	
	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end
end

local lrender = {
	normal = {
		bone = "ValveBiped.Bip01_Neck1",
		pos=Vector(2,1.8,0),
		ang=Angle(70,90,90),
		scale = Vector(0.06,0.06,0.05),
	},
	alt = { // Eeveelotions models
		bone = "Neck",
		pos=Vector(1,0.5,-0.2),
		ang=Angle(100,90,90),
		scale = Vector(0.082,0.082,0.082),
	},
}
function LEASH.DrawWorldModel(self)
	if not (IsValid(self) and IsValid(self.Owner)) then return end
	if self.Owner==LocalPlayer() and not hook.Call("ShouldDrawLocalPlayer", GAMEMODE, self.Owner) then
		return
	end
	if self.Owner==LocalPlayer():GetObserverTarget() and LocalPlayer:GetObserverMode()~=OBS_MODE_NONE and LocalPlayer:GetObserverMode()~=OBS_MODE_IN_EYE then return end
	
	if not IsValid(self.cmdl_LeftCuff) then
		self.cmdl_LeftCuff = ClientsideModel( CuffMdl, RENDER_GROUP_VIEW_MODEL_OPAQUE )
		if not IsValid( self.cmdl_LeftCuff ) then return end
		self.cmdl_LeftCuff:SetNoDraw( true )
		-- self.cmdl_LeftCuff:SetParent( vm )
	end
	
	local tbl = lrender.normal
	local lpos, lang = self:GetBonePos( tbl.bone, self.Owner )
	if not (lpos) then
		tbl = lrender.alt
		lpos, lang = self:GetBonePos( tbl.bone, self.Owner )
		if not (lpos) then return end
	end
	
	self.cmdl_LeftCuff:SetPos( lpos + (lang:Forward()*tbl.pos.x) + (lang:Right()*tbl.pos.y) + (lang:Up()*tbl.pos.z) )
	local u,r,f = lang:Up(), lang:Right(), lang:Forward() // Prevents moving axes
	lang:RotateAroundAxis( u, tbl.ang.y )
	lang:RotateAroundAxis( r, tbl.ang.p )
	lang:RotateAroundAxis( f, tbl.ang.r )
	self.cmdl_LeftCuff:SetAngles( lang )
	
	local matrix = Matrix()
	matrix:Scale( tbl.scale )
	self.cmdl_LeftCuff:EnableMatrix( "RenderMultiply", matrix )
	
	self.cmdl_LeftCuff:SetMaterial( self:GetCuffMaterial() or "" )
	self.cmdl_LeftCuff:DrawModel()
	
	if self:GetRopeMaterial()~=self.LastMatStr then
		self.RopeMat = Material( self:GetRopeMaterial() )
		self.LastMatStr = self:GetRopeMaterial()
	end
	if not self.RopeMat then self.RopeMat = Material(DefaultRope) end
end
