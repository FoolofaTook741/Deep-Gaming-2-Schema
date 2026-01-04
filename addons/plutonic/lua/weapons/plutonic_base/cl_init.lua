-- [ Shared Files Load First ] --
include("shared/base.lua")
include("shared/datatables.lua")
include("shared/anim.lua")
include("shared/attachment.lua")
include("shared/spread.lua")
include("shared/firemode.lua")
include("shared/think.lua")
include("shared/worldmodel.lua")
include("shared/reload.lua")
-- [ Now Load Client Specific Files ] --
include("client/viewmodel.lua")
include("client/sound.lua")
include("client/fov.lua")
include("client/replacement.lua")
include("client/debug.lua")
include("client/crosshair.lua")
include("client/ammoindicator.lua")
include("client/attachment.lua")
Plutonic.Constants.Logo = [[////////////////////////////////////////////////////////
  _____  _     _    _ _______ ____  _   _ _____ _____ 
 |  __ \| |   | |  | |__   __/ __ \| \ | |_   _/ ____|
 | |__) | |   | |  | |  | | | |  | |  \| | | || |     
 |  ___/| |   | |  | |  | | | |  | | . ` | | || |     
 | |    | |___| |__| |  | | | |__| | |\  |_| || |____ 
 |_|    |______\____/   |_|  \____/|_| \_|_____\_____|
                                                      
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun)
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