-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- sv_handcuffs.lua         SERVER --
--                                 --
-- Server-side handcuff stuff.     --
-------------------------------------

if CLIENT then return end

util.AddNetworkString( "Cuffs_GagPlayer" )
util.AddNetworkString( "Cuffs_BlindPlayer" )
util.AddNetworkString( "Cuffs_FreePlayer" )
util.AddNetworkString( "Cuffs_DragPlayer" )

util.AddNetworkString( "Cuffs_TiePlayers" )
util.AddNetworkString( "Cuffs_UntiePlayers" )

local function GetTrace( ply )
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
		local cuffed,wep = tr.Entity:IsHandcuffed()
		if cuffed then return tr,wep end
	end
end

// Convars //
CreateConVar( "cuffs_restrictvehicle", 0, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED} )

CreateConVar( "cuffs_restrictsuicide", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )
CreateConVar( "cuffs_restrictteams", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

CreateConVar( "cuffs_restrictwarrant", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED} )
CreateConVar( "cuffs_autoarrest", 0, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )
CreateConVar( "cuffs_restrictarrest", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

// Standard hooks //
hook.Add( "CanPlayerSuicide", "Cuffs RestrictSuicide", function( ply )
	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictsuicide") then return false end
end)
hook.Add( "PlayerCanJoinTeam", "Cuffs RestrictTeam", function( ply )
	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictteams") then return false end
end)
hook.Add( "PlayerCanSeePlayersChat", "Cuffs ChatGag", function( _,_,_, ply )
	if not IsValid(ply) then return end
	
	local cuffed,wep = ply:IsHandcuffed()
	if cuffed and wep:GetIsGagged() then return false end
end)
hook.Add( "PlayerCanHearPlayersVoice", "Cuffs VoiceGag", function( _, ply )
	if not IsValid(ply) then return end
	
	local cuffed,wep = ply:IsHandcuffed()
	if cuffed and wep:GetIsGagged() then return false end
end)

// Sandbox //
hook.Add( "PlayerSpawnProp", "Cuffs PreventPropSpawn", function( ply, mdl )
	if IsValid(ply) and ply:IsHandcuffed() then
		return false
	end
end)


// DarkRP //
hook.Add( "canRequestWarrant", "Cuffs PreventWarrant", function( crim, cop, reason ) if cvars.Bool("cuffs_restrictwarrant") and cop:IsHandcuffed() then return false,"You can't issue warrants when restrained!" end end)
hook.Add( "canWanted", "Cuffs PreventWarrant", function( crim, cop, reason ) if cvars.Bool("cuffs_restrictwarrant") and cop:IsHandcuffed() then return false,"You can't issue warrants when restrained!" end end)

hook.Add( "canArrest", "Cuffs RestrictArrest", function( cop, crim ) // DarkRP Arrest hook
	if IsValid(crim) and cvars.Bool("cuffs_restrictarrest") then
		local cuffed, wep = crim:IsHandcuffed()
		
		if not cuffed then
			return false,"You must handcuff a suspect to arrest them!"
		elseif not wep.CuffsArrestable then
			return false,"These are not police handcuffs! You must handcuff a suspect to arrest them."
		end
	end
end)
hook.Add( "playerCanChangeTeam", "Cuffs RestrictTeam", function( ply, tm, force )
	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictteams") and not force then return false,"You can't change jobs when restrained!" end
end)
hook.Add( "CanChangeRPName", "Cuffs RestrictName", function( ply )
	if ply:IsHandcuffed() then return false,"You can't change your name when restrained!" end
end)


// Cuffed player interaction //
net.Receive( "Cuffs_GagPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetCanGag()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldGag = net.ReadBit()==1
	cuffs:SetIsGagged( shouldGag )
	hook.Call( shouldGag and "OnHandcuffGag" or "OnHandcuffUnGag", GAMEMODE, ply, target, cuffs )
end)
net.Receive( "Cuffs_BlindPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetCanBlind()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldBlind = net.ReadBit()==1
	cuffs:SetIsBlind( shouldBlind )
	hook.Call( shouldBlind and "OnHandcuffBlindfold" or "OnHandcuffUnBlindfold", GAMEMODE, ply, target, cuffs )
end)
net.Receive( "Cuffs_FreePlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs)) then return end
	if IsValid(cuffs:GetFriendBreaking()) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	cuffs:SetFriendBreaking( ply )
end)
net.Receive( "Cuffs_DragPlayer", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local target = net.ReadEntity()
	if (not IsValid(target)) or target==ply then return end
	
	local cuffed, cuffs = target:IsHandcuffed()
	if not (cuffed and IsValid(cuffs) and cuffs:GetRopeLength()>0) then return end
	
	local tr = GetTrace(ply)
	if not (tr and tr.Entity==target) then return end
	
	local shouldDrag = net.ReadBit()==1
	if shouldDrag then
		if not (IsValid(cuffs:GetKidnapper())) then
			cuffs:SetKidnapper( ply )
			hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, target, cuffs )
		end
	else
		if ply==cuffs:GetKidnapper() then
			cuffs:SetKidnapper( nil )
			hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, target, cuffs )
		end
	end
end)

local HookModel = Model("models/props_c17/TrapPropeller_Lever.mdl")
net.Receive( "Cuffs_TiePlayers", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local DraggedCuffs = {}
	for _,c in pairs(ents.FindByClass("weapon_handcuffed")) do
		if c:GetRopeLength()>0 and c:GetKidnapper()==ply then
			table.insert( DraggedCuffs, c )
		end
	end
	if #DraggedCuffs<=0 then return end
	
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if not tr.Hit then return end
	
	if IsValid(tr.Entity) then // Pass to another player
		if tr.Entity:IsPlayer() then
			for i=1,#DraggedCuffs do
				if DraggedCuffs[i].Owner==tr.Entity then
					DraggedCuffs[i]:SetKidnapper(nil)
					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				else
					DraggedCuffs[i]:SetKidnapper(tr.Entity)
					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
					hook.Call( "OnHandcuffStartDragging", GAMEMODE, tr.Entity, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				end
			end
			return
		elseif tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then
			for i=1,#DraggedCuffs do
				DraggedCuffs[i]:SetKidnapper(tr.Entity)
				table.insert( tr.Entity.TiedHandcuffs, DraggedCuffs[i] )
				hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
				hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], tr.Entity )
			end
			return
		end
	end
	
	local hk = ents.Create("prop_physics")
	hk:SetPos( tr.HitPos + tr.HitNormal )
	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis( ang:Up(), -90 )
	hk:SetAngles( ang )
	hk:SetModel( HookModel )
	hk:Spawn()
	
	-- hk:SetMoveType( MOVETYPE_NONE )
	if IsValid(tr.Entity) then
		hk:SetParent( tr.Entity )
		hk:SetMoveType( MOVETYPE_VPHYSICS )
	else
		hk:SetMoveType( MOVETYPE_NONE )
	end
	hk:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	hk:SetNWBool("Cuffs_TieHook", true)
	hk.IsHandcuffHook = true
	hk.TiedHandcuffs = {}
	
	hk.cuffsNextThink = CurTime() + 2
	hook.Add( "Think", hk, function(self)
		if CurTime()<self.cuffsNextThink then return end
		if not self.TiedHandcuffs then self:Remove() return end
		
		for i=#self.TiedHandcuffs,1,-1 do
			if not IsValid(self.TiedHandcuffs[i]) then
				table.remove( self.TiedHandcuffs, i )
			end
			
			if #self.TiedHandcuffs<=0 then
				self:Remove()
			end
		end
		self.cuffsNextThink = CurTime() + 2
	end)
	
	for i=1,#DraggedCuffs do
		DraggedCuffs[i]:SetKidnapper( hk )
		table.insert( hk.TiedHandcuffs, DraggedCuffs[i] )
		hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )
		hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], hk )
	end
end)

local function DoUntie( ply, ent )
	for i=1,#ent.TiedHandcuffs do
		if not IsValid(ent.TiedHandcuffs[i]) then continue end
		
		ent.TiedHandcuffs[i]:SetKidnapper( ply )
		hook.Call( "OnHandcuffUnTied", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i], ent )
		hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i] )
	end
	
	ent:Remove()
end
net.Receive( "Cuffs_UntiePlayers", function(_,ply)
	if (not IsValid(ply)) or ply:IsHandcuffed() then return end
	if ply:GetObserverMode()~=OBS_MODE_NONE then return end
	
	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )
	if IsValid(tr.Entity) and tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then
		DoUntie( ply, tr.Entity )
	end
end)
hook.Add( "AllowPlayerPickup", "Cuffs UntieHook", function(ply,ent)
	if IsValid(ent) and ent.IsHandcuffHook and ent.TiedHandcuffs then
		if (not IsValid(ply)) or ply:IsHandcuffed() then return end
		
		DoUntie( ply, ent )
		return false
	end
end)


// Admin Uncuff //
local UncuffCommands = {
	["!uncuff"] = true, ["/uncuff"] = true,
}
hook.Add( "PlayerSay", "Cuffs AdminUncuff", function( ply, str )
	if not (IsValid(ply) and ply:IsAdmin()) then return end
	
	if UncuffCommands[ str:lower():Trim() ] then
		local isCuffed, cuffs = ply:IsHandcuffed()
		if not IsValid(cuffs) then return end
		
		ServerLog( "[Cuffs] Player '" .. tostring( ply:Nick() ) .. "' ["..tostring(ply:SteamID()).."] used the Uncuff command.\n" )
		
		cuffs:Uncuff()
	end
end)

// Anti-Physgun //
local function killTie(ent)
	local eff = EffectData()
	eff:SetOrigin( ent:GetPos() )
	eff:SetStart( ent:GetPos() )
	eff:SetScale( 1 )
	eff:SetRadius( 1 )
	eff:SetMagnitude( 1 )
	eff:SetNormal( ent:GetRight() )
	
	util.Effect( "Sparks", eff, true, true )
	
	ent:Remove()
end
hook.Add( "PhysgunPickup", "Cuffs AntiPhysgunTies", function( ply, ent )
	if not IsValid(ent) then return end
	if ent.IsHandcuffHook then
		killTie(ent)
		return false
	end
	
	local const = constraint.GetAllConstrainedEntities( ent )
	for _,constrainedEnt in pairs(const) do
		for _,v in pairs(constrainedEnt:GetChildren()) do
			if IsValid(v) and v.IsHandcuffHook then
				killTie(v)
			end
		end
	end
end)


// GmodDayZ support //
// Created by and added with permission of Phoenix129 ( http://steamcommunity.com/profiles/76561198039440140/ )
hook.Add("OnHandcuffed", "DayZCuffs RemoveInventoryItem", function(ply, cuffedply, handcuffs)
	if engine.ActiveGamemode() == "dayz" then
		ply:TakeCharItem( handcuffs.CuffType )
	end
end)
 
hook.Add("OnHandcuffBreak", "DayZCuffs GiveInventoryItemIfFriend", function(cuffedply, handcuffs, friend)
	if engine.ActiveGamemode() == "dayz" then
		if IsValid(friend) and handcuffs.CuffType and handcuffs.CuffType~="" then
			friend:GiveItem(handcuffs.CuffType, 1)
		end
	end
end)

hook.Add( "CuffsCanHandcuff", "DayZCuffs SafezoneProtectCuffs", function( ply, target )
	if engine.ActiveGamemode() == "dayz" then
		if target:GetSafeZone() or target:GetSafeZoneEdge() or target.Loading or !target.Ready then
			return false
		end
	end
end)
hook.Add("PlayerDisconnected", "DayZCuffs DieHandcuffs", function(ply)
	if engine.ActiveGamemode() == "dayz" then
		if ply:IsHandcuffed() then ply:Kill() end
	end
end)
