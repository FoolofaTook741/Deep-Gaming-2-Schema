
--[[
    Copyright (c) 2024; Dylan L.

    Created by mage_tearz@protonmail.com // github.com/mage-tearz

    Made for Pinecrest Project Half-Life 2 Roleplay;
    intended for use with the impulse framework.

    -- TERMS OF USE --
    The 'Code' is defined as any unique code or scripts found within this file which have been created by the author(s).

    You are required to include this entire Copyright notice in all copies of the Code.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute the Code.
    You are required to have prior written authorization from the original author(s) in order to use the Code in a multi-player game server.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute works derived from the Code.
    By using the Code, you agree to the TERMS OF USE.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

    Failiure to comply with the TERMS OF USE is considered Copyright Infringement under 17 U.S. Code § 501.
]]

local net_Receive = net.Receive
local net_ReadString = net.ReadString
local net_ReadUInt = net.ReadUInt
local print = print
local Entity = Entity
local IsValid = IsValid
local cam = cam
local isnumber = isnumber
local draw = draw
local surface = surface
local render = render
local ipairs = ipairs
local GetNoDraw = GetNoDraw
local GetClass = GetClass
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local LocalPlayer = LocalPlayer
local GetPos = GetPos
local Material = Material
local Color = Color
local surface_CreateFont = surface.CreateFont

net_Receive( "Pinecrest.UpdatePropertyData", function( _, ply )
    local Property = net_ReadUInt( 8 )
    local Position = net_ReadString()
    local NewValue = net_ReadString()

    impulse.Properties.PropertyData[ Property ][ Position ] = NewValue
    print( "[Pinecrest] [properties] Doors have been re-cached." )

    -- Force doors to re-calculate names, so that they draw the correct title
    DoorCache = nil
end )

surface_CreateFont("ApartmentDoorFont", {
    font = "BodoniXT",
    size = 60,
    weight = 800,
    outline = false,
    antialias = true,
    shadow = false,
})

surface_CreateFont( 'Pinecrest.HUD-100', {
	font = 'Raju',
	size = 100,
	weight = 200,
	antialias = true,
	shadow = true,
    outline = false
} )

local blur = Material("pp/blurscreen")
local cheapBlur = Color(0,0,0,205)
local BLACK = Color( 0, 0, 0, 200 )
local GRAD_UP = Material( 'vgui/gradient-d' )
local textColor = Color(103, 103, 103)
local wid = 20
local hig = 10

local colorsettings = impulse.GetAdvSetting( 'pinecrest_hudcolor' ) or {
	r = 216,
	g = 177,
	b = 82
}

local WHITE = Color(
	colorsettings.r,
	colorsettings.g,
	colorsettings.b,
	255
)

local function BlurRect(x, y, w, h)
	if not impulse.GetSetting("perf_blur") then
		draw.RoundedBox(0,x,y,w,h, cheapBlur)
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(x,y,w,h)
	else
		local X, Y = 0,0

		surface.SetDrawColor(color_white)
		surface.SetMaterial(blur)

		for i = 1, 2 do
			blur:SetFloat("$blur", (i / 10) * 20)
			blur:Recompute()

			render.UpdateScreenEffectTexture()

			render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end
end

local function PinecrestBox( x, y, w, h )
	--BlurRect( x, y, w, h )

	surface.SetDrawColor( BLACK )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( WHITE )
	surface.DrawRect( x, y, wid, 1 )
	surface.DrawRect( x, y + h, wid, 1 )

	surface.DrawRect( x + (w - wid) - 1, y, wid, 1 )
	surface.DrawRect( x + (w - wid) - 1, y + h, wid, 1 )

	surface.DrawRect( x + w - 1, y, 1, hig )
	surface.DrawRect( x, y, 1, hig )

	surface.DrawRect( x, y + (h - hig), 1, hig )
	surface.DrawRect( x + w - 1, y + (h - hig) + 1, 1, hig )
end

local function DrawCenteredBox( x, y, w, h )
    x = x-(w/2)
    y = y-(h/2)

    PinecrestBox( x, y, w, h )
end


function PLUGIN:PostDrawOpaqueRenderables( _, bDrawingSkybox )
    if bDrawingSkybox then
        return
    end

    if not impulseRegisteredProperties then
        return
    end

    -- DoorCache is a global that gets reset when a door's name is changed.
    if not DoorCache then
        DoorCache = {}

        print( "[Pinecrest] [properties] Doors have been re-cached." )
        for _, Property in ipairs( impulse.Properties.PropertyData ) do
            DoorCache[
                Property.Doors[ 1 ] ] =
                Property.CustomName
                or Property.NiceName
        end
    end

    local drawn = 0

    for Index, Name in pairs( DoorCache ) do

        local door = Entity( Index )

        if not IsValid( door ) or door:GetNoDraw() then
            continue
        end

        if door:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 1048576 then
            continue
        end

        drawn = drawn + 1
        local doorPos = door:GetPos()
        local doorAng = door:GetAngles()

        local pos = door:GetPos()
        local ang = door:GetAngles()

        pos = pos + ang:Forward() * 1.1
        pos = pos + ang:Right() * -23
        pos = pos + ang:Up() * 18

        ang:RotateAroundAxis(doorAng:Up(), 90)
        ang:RotateAroundAxis(doorAng:Right(), -90)

        surface.SetFont( "Pinecrest.HUD-100" )
        local w, h = surface.GetTextSize( Name )
        cam.Start3D2D(pos, ang, 0.05)

            draw_SimpleTextOutlined( Name, 'Pinecrest.HUD-100', 0, 0, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,color_black)
        cam.End3D2D()

        ang:RotateAroundAxis(doorAng.Right(doorAng), 180)
        ang:RotateAroundAxis(doorAng.Forward(doorAng), 180)

        pos = pos + ang:Up() * 2.2

        cam.Start3D2D(pos, ang, 0.05)
            draw_SimpleTextOutlined( Name, 'Pinecrest.HUD-100', 0, 0, color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,color_black)
        cam.End3D2D()
    end
end
