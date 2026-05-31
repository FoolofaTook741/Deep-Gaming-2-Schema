ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Metabase Entrance"
ENT.Author			= "Johnny Roast Beef"
ENT.Purpose			= "Transport From LF to Subs"
ENT.Instructions	= "Reality -> L0"
ENT.Category        = "Deep Gaming"

ENT.Spawnable = true

ENT.HUDName = "Secure Door"
ENT.HUDDesc = "A special secure door that disallows Combine from entering."

if SERVER then
    util.AddNetworkString("impulseMBBeginUse")
    util.AddNetworkString("impulseMBCompleteUse")
    util.AddNetworkString("impulseMBCancelUse")
end