//********************************//
//     Minecraft Sign Entity      //
//			 (c) McKay			  //
//********************************//

include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "MinecraftSignFont", {
	font = "Terminal",
	size = 13, //8
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
} )

function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function ENT:Draw()
	self:DrawModel()
	
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis( ang:Right(), -90)
	ang:RotateAroundAxis( ang:Up(), 90)
 
	cam.Start3D2D( self:GetPos() + ang:Up()*1.6+ ang:Right()*-39.7, ang, 0.3 )
	//cam.Start3D2D( self:GetPos() + ang:Up()*1.6+ ang:Right()*-39.5, ang, 0.405 ) //0.405
		render.PushFilterMin( TEXFILTER.NONE )
		render.PushFilterMag( TEXFILTER.NONE )
			draw.DrawText(self:GetText(), "MinecraftSignFont", 0, 3, Color(0,0,0,255), TEXT_ALIGN_CENTER)
			--[[
			local rows = lines(self:GetText())
			for k, v in pairs(rows) do
				local down = 2;
				if (k == 2) then down = 12 end
				if (k == 3) then down = 22 end
				if (k == 4) then down = 33 end
				draw.DrawText(v, "MinecraftSignFont", 0, down, Color(0,0,0,255), TEXT_ALIGN_CENTER)
			end
			]]--
		render.PopFilterMag()
		render.PopFilterMin()
	cam.End3D2D()
end

local function RecvMinecraftSignTextMenuUmsg( data )

	local sign = data:ReadEntity()
	
	local textLengthLimit = 15

	//create main frame
	local mc_frame = vgui.Create( "DFrame" )
	mc_frame:SetMouseInputEnabled( true )
	mc_frame:SetKeyboardInputEnabled( true )
	mc_frame:SetSize( 175, 210 )
	mc_frame:SetSizable(false)
	//mc_frame:SetBackgroundBlur(true)
		
	mc_frame:SetTitle( "Edit Sign Text" )
	mc_frame:SetDeleteOnClose( true )
	
	local width, height = mc_frame:GetSize()
	
	local line1 = vgui.Create( "DTextEntry", mc_frame )
	local line2 = vgui.Create( "DTextEntry", mc_frame )
	local line3 = vgui.Create( "DTextEntry", mc_frame )
	local line4 = vgui.Create( "DTextEntry", mc_frame )
	
	local line1Info = vgui.Create( "DLabel", mc_frame )
	local line2Info = vgui.Create( "DLabel", mc_frame )
	local line3Info = vgui.Create( "DLabel", mc_frame )
	local line4Info = vgui.Create( "DLabel", mc_frame )
	
	line1:SetPos( width/2 - 95/2 - 10, 45 )
	line1:SetFont( "MinecraftSignFont" )
	line1:SetMultiline(false)
	line1:SetTall( 25 )
	line1:SetWide( 95 )
	line1:SetEnterAllowed( true )
	line1.OnEnter = function()
		line2:RequestFocus()
	end
	line1.OnTextChanged = function( obj )
		local len = string.len(line1:GetValue())
		if (len > textLengthLimit) then
			line1Info:SetTextColor(Color(255,0,0,255))
		else
			line1Info:SetTextColor(Color(0,255,0,255))
		end
		line1Info:SetText( textLengthLimit-len )
	end
	
	line2:SetPos( width/2 - 95/2 - 10, 45 + 25 )
	line2:SetFont( "MinecraftSignFont" )
	line2:SetMultiline(false)
	line2:SetTall( 25 )
	line2:SetWide( 95 )
	line2:SetEnterAllowed( true )
	line2.OnEnter = function()
		line3:RequestFocus()
	end
	line2.OnTextChanged = function( obj )
		local len = string.len(line2:GetValue())
		if (len > textLengthLimit) then
			line2Info:SetTextColor(Color(255,0,0,255))
		else
			line2Info:SetTextColor(Color(0,255,0,255))
		end
		line2Info:SetText( textLengthLimit-len )
	end
	
	line3:SetPos( width/2 - 95/2 - 10, 45 + 25*2 )
	line3:SetFont( "MinecraftSignFont" )
	line3:SetMultiline(false)
	line3:SetTall( 25 )
	line3:SetWide( 95 )
	line3:SetEnterAllowed( true )
	line3.OnEnter = function()
		line4:RequestFocus()
	end
	line3.OnTextChanged = function( obj )
		local len = string.len(line3:GetValue())
		if (len > textLengthLimit) then
			line3Info:SetTextColor(Color(255,0,0,255))
		else
			line3Info:SetTextColor(Color(0,255,0,255))
		end
		line3Info:SetText( textLengthLimit-len )
	end
	
	line4:SetPos( width/2 - 95/2 - 10, 45 + 25*3 )
	line4:SetFont( "MinecraftSignFont" )
	line4:SetMultiline(false)
	line4:SetTall( 25 )
	line4:SetWide( 95 )
	line4:SetEnterAllowed( true )
	line4.OnEnter = function()
		line1:RequestFocus()
	end
	line4.OnTextChanged = function( obj )
		local len = string.len(line4:GetValue())
		if (len > textLengthLimit) then
			line4Info:SetTextColor(Color(255,0,0,255))
		else
			line4Info:SetTextColor(Color(0,255,0,255))
		end
		line4Info:SetText( textLengthLimit-len )
	end
	
	local applyButton = vgui.Create( "DButton", mc_frame )
	applyButton:SetPos( width/2 - 130/2, 45 + 120)
	applyButton:SetSize( 130, 30 )
	applyButton:SetText( "Apply" )
	applyButton.DoClick = function()
		net.Start("MinecraftSignTextChange")
			net.WriteEntity( sign )
			net.WriteString(string.sub(line1:GetValue(),0,textLengthLimit).."\n"..string.sub(line2:GetValue(),0,textLengthLimit).."\n"..string.sub(line3:GetValue(),0,textLengthLimit).."\n"..string.sub(line4:GetValue(),0,textLengthLimit))
		net.SendToServer()
		mc_frame:Close()
	end
	
	local x,y = line1:GetPos()
	x = x + line1:GetWide() + 6
	line1Info:SetPos( x, y )
	line1Info:SetColor(Color(0,255,0,255))
	line1Info:SetSize( 20, line1:GetTall() )
	line1Info:SetText( tostring(textLengthLimit) )
	
	x,y = line2:GetPos()
	x = x + line2:GetWide() + 6
	line2Info:SetPos( x, y )
	line2Info:SetColor(Color(0,255,0,255))
	line2Info:SetSize( 20, line2:GetTall() )
	line2Info:SetText( tostring(textLengthLimit) )
	
	x,y = line3:GetPos()
	x = x + line3:GetWide() + 6
	line3Info:SetPos( x, y )
	line3Info:SetColor(Color(0,255,0,255))
	line3Info:SetSize( 20, line3:GetTall() )
	line3Info:SetText( tostring(textLengthLimit) )
	
	x,y = line4:GetPos()
	x = x + line4:GetWide() + 6
	line4Info:SetPos( x, y )
	line4Info:SetColor(Color(0,255,0,255))
	line4Info:SetSize( 20, line4:GetTall() )
	line4Info:SetText( tostring(textLengthLimit) )
	
	//open
	line1:RequestFocus()
	mc_frame:SetVisible( true )
	mc_frame:Center()
	mc_frame:MakePopup()
end
usermessage.Hook( "MinecraftSignTextMenu", RecvMinecraftSignTextMenuUmsg)
