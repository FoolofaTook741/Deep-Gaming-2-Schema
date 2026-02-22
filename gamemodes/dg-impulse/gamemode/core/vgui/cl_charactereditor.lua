local PANEL = {}

function PANEL:Init()
	self:SetSize(600, 440)
	self:Center()
	self:SetTitle("Character Editor")
	self:MakePopup()

	local panel = self

	local hairColour = impulse_defaultHairColor

	self.nextButton = vgui.Create("DButton", self)
	self.nextButton:SetPos(470,370)
	self.nextButton:SetPos(470,415)
	self.nextButton:SetSize(120,20)
	self.nextButton:SetText("Change")
	self.nextButton:SetDisabled(false)
	self.nextButton.DoClick = function()
		local characterGender = self.genderBox:GetValue():lower()

		if characterGender == "male" then
			characterGender = false
		else
			characterGender = true
		end

		local characterModel = self.characterPreview.Entity:GetModel()
		local characterSkin = self.characterPreview.Entity:GetSkin()
		local characterHairColour = self.characterPreview.Entity.HairColor
		local characterBeard = self.characterPreview.Entity:GetBodygroup( self.characterPreview.Entity:FindBodygroupByName("beard"))
		local characterHair = self.characterPreview.Entity:GetBodygroup( self.characterPreview.Entity:FindBodygroupByName("hair"))

		local msg = Derma_Message

		local skinBlacklist = impulse.Config.DefaultSkinBlacklist[characterModel]

		if skinBlacklist and table.HasValue(skinBlacklist, characterSkin) then
			return msg("The skin you selected was on the blacklist.\nPlease select another skin or change the model.", "impulse", "OK")
		end

		net.Start("impulseCharacterEdit")
		net.WriteString(characterModel)
		net.WriteUInt(characterSkin, 8)

		net.WriteColor(hairColour)
		
		net.WriteUInt(characterBeard, 8)
		net.WriteUInt(characterHair, 8)
		net.SendToServer()

		self:Remove()
	end

	local curModel = impulse_defaultModel
	local curSkin = impulse_defaultSkin
	local curHairColour = impulse_defaultHairColor
	local curBeard = impulse_defaultBeard
	local curHair = impulse_defaultHair

	local isFemale = LocalPlayer():IsCharacterFemale()

	self.characterPreview = vgui.Create("DModelPanel", self)
	self.characterPreview:SetSize(600,400)
	self.characterPreview:SetPos(0,30)
	self.characterPreview:SetModel(curModel)
	self.characterPreview:MoveToBack()
	self.characterPreview:SetCursor("arrow")
	self.characterPreview:SetFOV(40)
	self.characterPreview:SetCamPos(Vector(52, 52, 52))
	self.characterPreview.Entity.hairBodygroupID = self.characterPreview.Entity:FindBodygroupByName("hair")
	self.characterPreview.Entity.beardBodygroupID = self.characterPreview.Entity:FindBodygroupByName("beard")
	self.characterPreview.Entity:SetSkin(curSkin)
	self.characterPreview.Entity:SetBodygroup( self.characterPreview.Entity.beardBodygroupID, curBeard)
	self.characterPreview.Entity:SetBodygroup( self.characterPreview.Entity.hairBodygroupID, curHair)
	function self.characterPreview:LayoutEntity(ent)
		ent:SetAngles(Angle(0,45,0))

		local headPos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1") or 0)

		if headPos then
			self:SetLookAt(headPos)
			self:SetCamPos(headPos + Vector(30, 30, 5))
		end

		ent.HairColor = hairColour
	end

 	local characterPreview = self.characterPreview

	function self.nextButton:Think()
		local cost = 0
		if panel.genderBox:GetValue() != panel.genderBox.normal then
			cost = cost + impulse.Config.CosmeticGenderPrice
		end

		if panel.characterPreview.Entity:GetModel() != curModel or panel.characterPreview.Entity:GetSkin() != curSkin then
			cost = cost + impulse.Config.CosmeticModelSkinPrice
		end

		if hairColour != curHairColour then
			cost = cost + ( impulse.Config.CosmeticHairDyePrice or 30 )
		end

		if panel.characterPreview.Entity:GetBodygroup( panel.characterPreview.Entity.beardBodygroupID) != curBeard then
			cost = cost + ( impulse.Config.CosmeticBeardPrice or 30 )
		end

		if panel.characterPreview.Entity:GetBodygroup( panel.characterPreview.Entity.hairBodygroupID) != curHair then
			cost = cost + ( impulse.Config.CosmeticHairPrice or 30 )
		end

		if cost > 0 then
			self:SetDisabled(false)
			self:SetText("Change ("..impulse.Config.CurrencyPrefix..cost..")")
		else
			self:SetDisabled(true)
			self:SetText("Change")
		end
	end

	self.genderLbl = vgui.Create("DLabel", self)
	self.genderLbl:SetFont("Impulse-Elements18-Shadow")
	self.genderLbl:SetText("Gender:")
	self.genderLbl:SizeToContents()
	self.genderLbl:SetPos(10,40)

  	self.genderBox = vgui.Create("DComboBox", self)
  	self.genderBox:SetPos(10,60)
  	self.genderBox:SetSize(180,23)

  	if isFemale then
  		self.genderBox:SetValue("Female")
  	else
  		self.genderBox:SetValue("Male")
  	end

  	self.genderBox.normal = self.genderBox:GetValue()

  	self.genderBox:AddChoice("Male")
  	self.genderBox:AddChoice("Female")
  	function self.genderBox.OnSelect(panel, index, value)
  		if value == "Male" then
  			self:PopulateModels(impulse.Config.DefaultMaleModels)
  			characterPreview:SetModel(impulse.Config.DefaultMaleModels[1])
  		else
  			self:PopulateModels(impulse.Config.DefaultFemaleModels)
  			characterPreview:SetModel(impulse.Config.DefaultFemaleModels[1])
			self.beardSlider:SetValue(0)
  		end

		self.characterPreview.Entity.beardBodygroupID = self.characterPreview.Entity:FindBodygroupByName("beard")
		self.characterPreview.Entity.hairBodygroupID = self.characterPreview.Entity:FindBodygroupByName("hair")

		self.skinSlider:SetValue(0)
		self.skinSlider:SetMax(characterPreview.Entity:SkinCount() - 1)

		self.beardSlider:SetValue(0)
		self.beardSlider:SetMax(characterPreview.Entity.beardBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.beardBodygroupID)-1)
		
		self.hairSlider:SetValue(0)
		self.hairSlider:SetMax(characterPreview.Entity.hairBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.hairBodygroupID)-1)
  	end

  	self.genderWarn = vgui.Create("DLabel", self)
  	self.genderWarn:SetFont("Impulse-Elements16")
  	self.genderWarn:SetText("Costs "..impulse.Config.CurrencyPrefix..impulse.Config.CosmeticGenderPrice.." per change")
  	self.genderWarn:SizeToContents()
  	self.genderWarn:SetPos(10, 90)

	self.hairColourLbl = vgui.Create("DLabel", self)
	self.hairColourLbl:SetFont("Impulse-Elements18-Shadow")
	self.hairColourLbl:SetText("Hair Colour: (" ..impulse.Config.CurrencyPrefix..(impulse.Config.CosmeticHairDyePrice or 30)..")")
	self.hairColourLbl:SizeToContents()
	self.hairColourLbl:SetPos(10,110)

	self.hairColourBox = self:Add("DComboBox")
	self.hairColourBox:SetPos(10,130)
  	self.hairColourBox:SetSize(180,23)
	// Black, Brown, Ginger, Grey, Blonde
  	for hairName, hairColour in pairs(impulse.Config.DefaultHairColors) do
		self.hairColourBox:AddChoice(hairName, hairColour)
	end

	self.hairColourBox:SetValue(table.KeyFromValue(impulse.Config.DefaultHairColors, hairColour) or "Custom")

  	function self.hairColourBox.OnSelect(panel, index, value, data)
		hairColour = data
  	end

	self.modelLbl = vgui.Create("DLabel", self)
	self.modelLbl:SetFont("Impulse-Elements18-Shadow")
	self.modelLbl:SetText("Models:")
	self.modelLbl:SizeToContents()
	self.modelLbl:SetPos(400,40)

	if isFemale then
		self:PopulateModels(impulse.Config.DefaultFemaleModels)
	else
		self:PopulateModels(impulse.Config.DefaultMaleModels)
	end

	self.skinLbl = vgui.Create("DLabel", self)
	self.skinLbl:SetFont("Impulse-Elements18-Shadow")
	self.skinLbl:SetText("Skin:")
	self.skinLbl:SizeToContents()
	self.skinLbl:SetPos(400,260)

	self.skinSlider = vgui.Create("DNumSlider", self)
	self.skinSlider:SetMin(0)
	self.skinSlider:SetDecimals(0)
	self.skinSlider:SetMax(characterPreview.Entity:SkinCount()-1)
	self.skinSlider:SetSize(395,20)
	self.skinSlider:SetPos(230, 280)
	self.skinSlider:SetValue(curSkin)
	self.skinSlider.TextArea:SetTextColor(color_white)

	function self.skinSlider:OnValueChanged(newSkin)
		characterPreview.Entity:SetSkin(newSkin)
	end

	self.beardLbl = vgui.Create("DLabel", self)
	self.beardLbl:SetFont("Impulse-Elements18-Shadow")
	self.beardLbl:SetText("Beard Type: (" ..impulse.Config.CurrencyPrefix..(impulse.Config.CosmeticBeardPrice or 30)..")")
	self.beardLbl:SizeToContents()
	self.beardLbl:SetPos(400, 330)

	local beardBodygroupID = characterPreview.Entity.beardBodygroupID
	self.beardSlider = vgui.Create("DNumSlider", self)
	self.beardSlider:SetMin(0)
	self.beardSlider:SetDecimals(0)
	self.beardSlider:SetMax(characterPreview.Entity.beardBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(beardBodygroupID)-1)
	self.beardSlider:SetSize(395,20)
	self.beardSlider:SetPos(230, 350)
	self.beardSlider:SetValue(curBeard)
	self.beardSlider.TextArea:SetTextColor(color_white)

	function self.beardSlider:OnValueChanged(newSkin)
		characterPreview.Entity:SetBodygroup(characterPreview.Entity.beardBodygroupID, newSkin)
	end

	self.hairLbl = vgui.Create("DLabel", self)
	self.hairLbl:SetFont("Impulse-Elements18-Shadow")
	self.hairLbl:SetText("Hair Type: (" ..impulse.Config.CurrencyPrefix..(impulse.Config.CosmeticHairPrice or 30)..")")
	self.hairLbl:SizeToContents()
	self.hairLbl:SetPos(400,370)

	local hairBodygroupID = characterPreview.Entity.hairBodygroupID
	self.hairSlider = vgui.Create("DNumSlider", self)
	self.hairSlider:SetMin(0)
	self.hairSlider:SetDecimals(0)
	self.hairSlider:SetMax(characterPreview.Entity.hairBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(hairBodygroupID)-1)
	self.hairSlider:SetSize(395,20)
	self.hairSlider:SetPos(230, 390)
	self.hairSlider:SetValue(curHair)
	self.hairSlider.TextArea:SetTextColor(color_white)

	function self.hairSlider:OnValueChanged(newSkin)
		characterPreview.Entity:SetBodygroup(characterPreview.Entity.hairBodygroupID, newSkin)
	end

  	self.skinWarn = vgui.Create("DLabel", self)
  	self.skinWarn:SetFont("Impulse-Elements16")
  	self.skinWarn:SetText("Costs "..impulse.Config.CurrencyPrefix..impulse.Config.CosmeticModelSkinPrice.." per change")
  	self.skinWarn:SizeToContents()
  	self.skinWarn:SetPos(400, 310)
end

function PANEL:PopulateModels(modelTable)
	if self.modelScroll then self.modelScroll:Remove() end -- done to fix some weird bugs when changing size of the iconlayout with the sidebar

 	self.modelScroll = vgui.Create("DScrollPanel", self)
 	self.modelScroll:SetPos(400,60)
 	self.modelScroll:SetSize(200,185)

 	self.modelBase = vgui.Create("DIconLayout", self.modelScroll)
 	self.modelBase:Dock(FILL)
 	self.modelBase:SetSpaceY(5)
 	self.modelBase:SetSpaceX(5)

  	for _, model in pairs(modelTable) do
    	local modelIcon = vgui.Create("SpawnIcon", self.modelBase)
    	modelIcon:SetModel(model)
    	modelIcon:SetSize(58,58)
    	modelIcon.savedModel = model
    	modelIcon.DoClick = function()
    		self.characterPreview:SetModel(modelIcon.savedModel)
			
			self.characterPreview.Entity.beardBodygroupID = self.characterPreview.Entity:FindBodygroupByName("beard")
			self.characterPreview.Entity.hairBodygroupID = self.characterPreview.Entity:FindBodygroupByName("hair")

    		self.skinSlider:SetValue(0)
    		self.skinSlider:SetMax(self.characterPreview.Entity:SkinCount()-1)

			self.hairSlider:SetValue(0)
			self.hairSlider:SetMax(self.characterPreview.Entity.hairBodygroupID == -1 and 0 or self.characterPreview.Entity:GetBodygroupCount(self.characterPreview.Entity.hairBodygroupID)-1)

			self.beardSlider:SetValue(0)
			self.beardSlider:SetMax(self.characterPreview.Entity.beardBodygroupID == -1 and 0 or self.characterPreview.Entity:GetBodygroupCount(self.characterPreview.Entity.beardBodygroupID)-1)

    	end
  	end
end


vgui.Register("impulseCharacterEditor", PANEL, "DFrame")
