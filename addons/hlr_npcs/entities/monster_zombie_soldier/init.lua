AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_zombie_soldier")
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_zombie_soldier")
ENT.sModel = "models/opfor/zombie_soldier.mdl"