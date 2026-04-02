crashmenu.Config = {} -- Don't touch this

-- Do NOT touch this. Assigned directly upon download of the add-on.
crashmenu.Config.ChatRoomID = '83437533-c456-43ab-abfa-f9d3f15c9e7a' -- Chat room which will be used to discuss about the server crash
crashmenu.Config.LogoURL = "https://imgur.com/a/cFtFISG" -- Must be a direct link to an image
crashmenu.Config.Gradient = true -- Turn on gradient or not?
crashmenu.Config.Color1 = Color(1, 163, 164, 127) -- Customize the color of the border and background here.
crashmenu.Config.BigFont = "Roboto Bk" -- Font for the header.
crashmenu.Config.Font = "Roboto" -- Font for the buttons and help text
crashmenu.Config.FontShadows = true
crashmenu.Config.CrashSound = "common/bugreporter_failed.wav" -- Sound path that will be played when the panel shows up. Comment this line or set it to nil to disable the sound.

crashmenu.Config.Title = "Deep Gaming crashed?"
crashmenu.Config.SubTitle = [[
No need to disconnect, you'll be automatically reconnected to the server once it is up again
In the mean time, feel free to chat with the other players using the chatbox below.
On average, the server takes between 3 and 7 minutes to start back up.
]]

-- This table is useful for adding other buttons to the screen.
-- Adding a button with an "IP" field will redirect clients to another server upon clicking it.
-- Adding a button with an "URL" field will open a page in the Steam overlay for the client upon clicking it.
-- DON'T make a button with both, "IP" will take priority over "URL".
crashmenu.Config.Servers = { -- Examples below
    {
        Name = "Content Pack",
        URL = "https://steamcommunity.com/sharedfiles/filedetails/?id=3690442796"
    },
    {
        Name = "Discord",
        URL = "https://discord.gg/9cYGqqEKYy"
    },
    {
        Name = "Forums",
        URL = ""
    },
}