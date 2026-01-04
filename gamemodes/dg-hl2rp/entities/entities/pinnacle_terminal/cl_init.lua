include("shared.lua")
AddCSLuaFile("imgui.lua")
local imgui = include("imgui.lua")

--entindex = self:EntIndex()
--print(entindex.."init")

local tbl = {}
tbl[0] = 0
tbl[1] = 0
tbl[2] = 0
tbl[3] = 0

local entIndex = 0

net.Receive("entInit", function(len,ply)
	local entData = net.ReadEntity()
	--print(entData:EntIndex().."imentdata")
	entIndex = entData:EntIndex()	
end)

--print(entIndex:EntIndex().."imentdata1")

net.Receive("itemUpdate"..entIndex, function(len, ply)
	tbl = net.ReadTable()
	--print(entIndex)
end)


--local myTargetEntity = LocalPlayer():GetEyeTrace().HitEntity
--local targetIndex = myTargetEntity:EntIndex()

--net.Receive("itemupdate"..targetIndex, function(len, ply)
--	tbl = net.ReadTable()
--end)

local drawCol = Color(23,103,200,125)
local buttonColor = Color(50,200,255,125)
local clickSound = "ui/hls_ui_scroll_click.wav"

local function CycleIcons(table)
	local currentIndex = 1
	return function()
		local icon = table[currentIndex]
		currentIndex = currentIndex + 1
		if currentIndex > #table then
			currentIndex = 1
		end
		return icon
	end
end

local lock_team_icons = {
    [1] = "icons/transhumanarm_logo.png", -- CTA
    [2] = "icons/civilprotection_logo.png", -- MPF
    [3] = "icons/citizen_logo.png", -- Citizen
	[4] = "icons/industrialworkforce_logo.png" -- CW
}

local color_table = {
    [1] = Color(32, 32, 32),    -- CTA
    [2] = Color(0, 124, 200),    -- MPF
    [3] = Color(15, 200, 15),    -- Citizen
    [4] = Color(255, 255, 0),  -- CW
}

function ENT:Initialize()
    self.CurrentColorIndex = 1
	self.CurrentIconIndex = 1
end

function ENT:Draw()
    self:DrawModel()

	    local drawColor = color_table[self.CurrentColorIndex]
        local iconPath = lock_team_icons[self.CurrentIconIndex]

    if not self.CurrentColorIndex then self.CurrentColorIndex = 1 end

    if imgui.Entity3D2D(self, Vector(0,8.5,-3.5), Angle(0,180,90), 0.1) then
        local wasPressed = imgui.xTextButton(" ", "terminal32", 0, 0, 35, 35, 4, drawColor, drawColor, drawColor)

        if wasPressed then
            surface.PlaySound(clickSound)

            self.CurrentColorIndex = self.CurrentColorIndex + 1
            if self.CurrentColorIndex > #color_table then
                self.CurrentColorIndex = 1
            end

			self.CurrentIconIndex = self.CurrentIconIndex + 1
            if self.CurrentIconIndex > #lock_team_icons then
                self.CurrentIconIndex = 1
            end
        end



        if iconPath then
            surface.SetMaterial(Material("icons/player_factions/faction_combinecity.png", "smooth"))
            surface.SetDrawColor(drawColor)
            surface.DrawTexturedRect(5, 5, 25, 25)
        end

        imgui.End3D2D()
	end
end