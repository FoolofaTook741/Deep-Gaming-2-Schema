AddCSLuaFile()
--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
-- We cannot Link, we have to copy the code. --
-- Shared Files (for Server)
include("shared/base.lua")
include("shared/datatables.lua")
include("shared/anim.lua")
include("shared/attachment.lua")
include("shared/spread.lua")
include("shared/firemode.lua")
include("shared/think.lua")
include("shared/worldmodel.lua")
include("shared/reload.lua")
-- ServerSide Files
include("server/sound.lua")
include("server/echo.lua")
include("server/attachments.lua")
-- Shared Files (for Client)
AddCSLuaFile("shared/base.lua")
AddCSLuaFile("shared/datatables.lua")
AddCSLuaFile("shared/anim.lua")
AddCSLuaFile("shared/attachment.lua")
AddCSLuaFile("shared/spread.lua")
AddCSLuaFile("shared/firemode.lua")
AddCSLuaFile("shared/think.lua")
AddCSLuaFile("shared/worldmodel.lua")
AddCSLuaFile("shared/reload.lua")
-- ClientSide Files
AddCSLuaFile("client/attachment.lua")
AddCSLuaFile("client/viewmodel.lua")
AddCSLuaFile("client/sound.lua")
AddCSLuaFile("client/fov.lua")
AddCSLuaFile("client/replacement.lua")
AddCSLuaFile("client/debug.lua")
AddCSLuaFile("client/crosshair.lua")
AddCSLuaFile("client/echo.lua")
AddCSLuaFile("client/ammoindicator.lua")
Plutonic.Constants.Logo = [[
////////////////////[ Powered By ]//////////////////////
  _____  _     _    _ _______ ____  _   _ _____ _____ 
 |  __ \| |   | |  | |__   __/ __ \| \ | |_   _/ ____|
 | |__) | |   | |  | |  | | | |  | |  \| | | || |     
 |  ___/| |   | |  | |  | | | |  | | . ` | | || |     
 | |    | |___| |__| |  | | | |__| | |\  |_| || |____ 
 |_|    |______\____/   |_|  \____/|_| \_|_____\_____|
                                                      
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun).
Version: 1.2.0
Build: 365

////////////////////////////////////////////////////////]]
Plutonic.Constants.LogoColor = Color(10, 120, 255)
Plutonic.Constants.LogoTextColor = Color(255, 200, 0)
for i, line in ipairs(string.Explode("\n", Plutonic.Constants.Logo)) do
	if i >= 10 and i <= 13 then
		MsgC(Plutonic.Constants.LogoTextColor, line .. "\n")
	else
		MsgC(Plutonic.Constants.LogoColor, line .. "\n")
	end
end