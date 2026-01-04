AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_zombie_barney")
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_zombie_barney")
ENT.sModel = "models/opfor/zombie_barney.mdl"