local config = {} -- do not touch

-- USE YOUR OWN WEBSITE INSTEAD OF THE DEFAULT ONE, PLS
-- Example: http://example.com/epic/leyscreencap
-- other example: http://leyscreencap.local:69
config.website = "https://abardenservers.com/pg_dev/screenshot"

-- If you want, you can change this Key. If you do, USE THAT SAME KEY FOR config/settings.php
config.serverkey =  "f152339b822694d6a3748855a52ee9c68987084c8fcb9682068fc2c6ead81b4d"

-- interval in seconds to send server info to the website
config.sendServerInfo_interval = 30

-- interval in seconds to query the website for players to screenshot
config.checkWebCaps_interval = 1

-- enable if screenshots aren't working, will print out data from web requests serverside, client has own enable_debug flag in clientside file
config.enable_debug = false


return config -- do not touch
