local matGradient = Material( "vgui/gradient-u" )
local matGrid = Material( "gui/alpha_grid.png", "nocull" )

local PANEL = {}

function PANEL:Init()
	self.ColorMixer = vgui.Create("DColorMixer", self)
	self.ColorMixer:SetPalette(false)

	self.ColorMixer.HSV.Knob.Paint = nil 
	self.ColorMixer.HSV.PaintOver = function(s,w,h)
		self.GottenRGB = s:GetRGB()
		self.ColorContrast = bVGUI.TextColorContrast(self.GottenRGB)

		local x,y = s.Knob:GetPos()
		local ww,hh = s.Knob:GetSize()
		surface.SetDrawColor(bVGUI.COLOR_DARK_GREY)
		surface.DrawOutlinedRect(0,0,w,h)
		draw.NoTexture()

		surface.DrawPoly({
			{x=x,y=y},
			{x=x+ww,y=y},
			{x=x+math.ceil(ww/2),y=y+math.ceil(hh/2)},
		})
		surface.DrawRect(x,y-hh,ww,hh)

		surface.SetDrawColor(self.ColorContrast)
		surface.DrawRect(x+2,y-hh+2,ww-4,hh-4)

		surface.SetDrawColor(self.GottenRGB)
		surface.DrawRect(x+3,y-hh+3,ww-6,hh-6)
	end

	self.ColorMixer.colPrev = self.ColorMixer.WangsPanel:Add( "DPanel" )
	self.ColorMixer.colPrev:SetTall( 20 )
	self.ColorMixer.colPrev:Dock( TOP )
	self.ColorMixer.colPrev:DockMargin( 0, 4, 0, 0 )
	self.ColorMixer.colPrev.Paint = function(s,w,h)
		if !self.GottenRGB then return end
		
		surface.SetDrawColor(self.GottenRGB)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(self.ColorContrast)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	function self.ColorMixer.Alpha:Paint(w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(matGrid)
		local size = 128
	
		for i = 0, math.ceil(h / size) do
			surface.DrawTexturedRect(w / 2 - size / 2, i * size, size, size)
		end
	
		surface.SetDrawColor(self.m_BarColor)
		surface.SetMaterial(matGradient)

		surface.DrawTexturedRect(0, 0, w, h)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(0, 0, 0, 250)
		self:DrawOutlinedRect()
		surface.DrawRect(2, (1 - self.m_Value) * h - 3, w - 4, 6)

		surface.SetDrawColor(255, 255, 255, 250)
		surface.DrawRect(4, (1 - self.m_Value) * h - 1, w - 8, 2)
	end
	
	function self.ColorMixer.RGB:Paint(w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.Material)

		surface.DrawTexturedRect(0, 0, w, h)
		
		surface.SetDrawColor(0, 0, 0, 250)
		self:DrawOutlinedRect()
		surface.DrawRect(2, self.LastY - 3, w - 4, 6)
		
		surface.SetDrawColor(255, 255, 255, 250)
		surface.DrawRect(4, self.LastY - 1, w - 8, 2)
	end
end

function PANEL:SetColor(col)
	self.ColorMixer:SetColor(col)
end
function PANEL:GetColor()
	return self.ColorMixer:GetColor()
end

function PANEL:SetLabel(text)
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont(bVGUI.FONT(bVGUI.FONT_CIRCULAR, "REGULAR", 16))
	self.Label:SetTextColor(bVGUI.COLOR_WHITE)
	self.Label:SetText(text)
	self.Label:SizeToContentsX()
	self.Label:SetTall(21)
end

function PANEL:PerformLayout()
	self.ColorMixer:AlignBottom(0)
	if (IsValid(self.Label)) then
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall() - self.Label:GetTall())
	else
		self.ColorMixer:SetSize(self:GetTall() * 1.6, self:GetTall())
	end
end

derma.DefineControl("bVGUI.ColorMixer", nil, PANEL, "bVGUI.BlankPanel")