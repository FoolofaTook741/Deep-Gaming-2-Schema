local PANEL = {}

function PANEL:Init()
	self:SetSize(800, 750)
	self:Center()
	self:SetTitle("Icon Camera Editor")
	self:MakePopup()

	local lbl = vgui.Create("DLabel", self)
	lbl:SetText("Real:                       Upscale:")
	lbl:SizeToContents()
	lbl:SetPos(5, 280)

	local panel = self
	local noCnt = false

	self.bg = vgui.Create("DPanel", self)
	self.bg:SetPos(5, 300)
	self.bg:SetSize(64, 64)
	function self.bg:Paint(w, h)
		draw.RoundedBox(1, 0, 0, w, h, color_white)
	end

	self.model = vgui.Create("DModelPanel", self)
	self.model:SetPos(5, 300)
	self.model:SetSize(64, 64)
	self.model:SetModel("models/props_junk/wood_crate001a.mdl")
	self.model:SetSkin(0)
	self.model:SetFOV(55)

	function self.model:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 90, 0))
		return
	end

	self.bg2 = vgui.Create("DPanel", self)
	self.bg2:SetPos(100, 300)
	self.bg2:SetSize(255, 255)
	function self.bg2:Paint(w, h)
		draw.RoundedBox(1, 0, 0, w, h, color_white)
	end

	self.modelBig = vgui.Create("DModelPanel", self)
	self.modelBig:SetPos(100, 300)
	self.modelBig:SetSize(255, 255)
	self.modelBig:SetModel("models/props_junk/wood_crate001a.mdl")
	self.modelBig:SetSkin(0)
	self.modelBig:SetFOV(55)

	function self.modelBig:LayoutEntity(ent)
		ent:SetAngles(Angle(0, 90, 0))
		return
	end

	local function updateCamera()
		local x = panel.camLeftRightSlider:GetValue()
		local y = panel.camForwardBackSlider:GetValue()
		local z = panel.camUpDownSlider:GetValue()
		local lookZ = panel.lookZSlider:GetValue()

		panel.model:SetCamPos(Vector(x, y, z))
		panel.modelBig:SetCamPos(Vector(x, y, z))
		panel.model:SetLookAt(Vector(0, 0, lookZ))
		panel.modelBig:SetLookAt(Vector(0, 0, lookZ))
	end

	self.modelEntry = vgui.Create("DTextEntry", self)
	self.modelEntry:SetPos(100, 50)
	self.modelEntry:SetSize(400, 20)
	self.modelEntry:SetText("Model name here")
	function self.modelEntry:OnEnter()
		panel.model:SetModel(self:GetValue())
		panel.modelBig:SetModel(self:GetValue())
	end

	self.useNoCenter = vgui.Create("DCheckBoxLabel", self)
	self.useNoCenter:SetPos(560, 50)
	self.useNoCenter:SetText("No Center")
	self.useNoCenter:SetValue(0)
	self.useNoCenter:SizeToContents()
	function self.useNoCenter:OnChange(v)
		noCnt = v
	end

	self.fovSlider = vgui.Create("DNumSlider", self)
	self.fovSlider:SetPos(100, 80)
	self.fovSlider:SetSize(700, 30)
	self.fovSlider:SetText("FOV (zoom)")
	self.fovSlider:SetMin(2)
	self.fovSlider:SetMax(100)
	self.fovSlider:SetDecimals(0)
	self.fovSlider:SetValue(55)
	function self.fovSlider:OnValueChanged(val)
		panel.model:SetFOV(val)
		panel.modelBig:SetFOV(val)
	end

	self.camLeftRightSlider = vgui.Create("DNumSlider", self)
	self.camLeftRightSlider:SetPos(100, 110)
	self.camLeftRightSlider:SetSize(700, 30)
	self.camLeftRightSlider:SetText("Camera Left / Right")
	self.camLeftRightSlider:SetMin(-160)
	self.camLeftRightSlider:SetMax(160)
	self.camLeftRightSlider:SetDecimals(0)
	self.camLeftRightSlider:SetValue(0)
	function self.camLeftRightSlider:OnValueChanged(val)
		updateCamera()
	end

	self.camForwardBackSlider = vgui.Create("DNumSlider", self)
	self.camForwardBackSlider:SetPos(100, 140)
	self.camForwardBackSlider:SetSize(700, 30)
	self.camForwardBackSlider:SetText("Camera Distance (forward / back)")
	self.camForwardBackSlider:SetMin(-160)
	self.camForwardBackSlider:SetMax(160)
	self.camForwardBackSlider:SetDecimals(0)
	self.camForwardBackSlider:SetValue(58)
	function self.camForwardBackSlider:OnValueChanged(val)
		updateCamera()
	end

	self.camUpDownSlider = vgui.Create("DNumSlider", self)
	self.camUpDownSlider:SetPos(100, 170)
	self.camUpDownSlider:SetSize(700, 30)
	self.camUpDownSlider:SetText("Camera Up / Down")
	self.camUpDownSlider:SetMin(-160)
	self.camUpDownSlider:SetMax(160)
	self.camUpDownSlider:SetDecimals(0)
	self.camUpDownSlider:SetValue(66)
	function self.camUpDownSlider:OnValueChanged(val)
		updateCamera()
	end

	self.lookZSlider = vgui.Create("DNumSlider", self)
	self.lookZSlider:SetPos(100, 200)
	self.lookZSlider:SetSize(700, 30)
	self.lookZSlider:SetText("Look At Height (aim camera up / down)")
	self.lookZSlider:SetMin(-160)
	self.lookZSlider:SetMax(160)
	self.lookZSlider:SetDecimals(0)
	self.lookZSlider:SetValue(66)
	function self.lookZSlider:OnValueChanged(val)
		updateCamera()
	end

	self.output = vgui.Create("DButton", self)
	self.output:SetPos(105, 240)
	self.output:SetSize(650, 25)
	self.output:SetText("Output (copy data to clipboard)")
	function self.output:DoClick()
		local camPos = panel.model:GetCamPos()
		local lookZ = panel.lookZSlider:GetValue()
		local output = "iconFOV = "..panel.model:GetFOV()..",\n"
		output = output.."iconCamPos = Vector("..camPos.x..", "..camPos.y..", "..camPos.z.."),\n"
		output = output.."iconLookAt = Vector(0, 0, "..lookZ.."),"

		print(output)
		SetClipboardText(output)
		LocalPlayer():Notify("Exported to clipboard.")
	end

	-- Set initial camera
	panel.model:SetCamPos(Vector(0, 58, 66))
	panel.modelBig:SetCamPos(Vector(0, 58, 66))
	panel.model:SetLookAt(Vector(0, 0, 66))
	panel.modelBig:SetLookAt(Vector(0, 0, 66))
end

vgui.Register("impulseIconEditor", PANEL, "DFrame")