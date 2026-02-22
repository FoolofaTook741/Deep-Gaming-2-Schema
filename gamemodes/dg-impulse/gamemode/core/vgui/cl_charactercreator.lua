local PANEL = {}

function PANEL:Init()
	self:SetSize(600, 420)
	self:Center()
	self:SetTitle("Character Creation")
	self:MakePopup()
	self:SetBackgroundBlur(true)

	local hairColour = impulse.Config.DefaultHairColors[table.GetKeys(impulse.Config.DefaultHairColors)[1]]
	self.nextButton = vgui.Create("DButton", self)
	self.nextButton:SetPos(530,390)
	self.nextButton:SetSize(60,20)
	self.nextButton:SetText("Finish")
	self.nextButton:SetDisabled(false)
	self.nextButton.DoClick = function()
		local characterName = self.nameEntry:GetValue()
		local characterGender = self.genderBox:GetValue():lower()
		local characterModel = self.characterPreview.Entity:GetModel()
		local characterSkin = self.characterPreview.Entity:GetSkin()
		local characterHairColour = self.characterPreview.Entity.HairColor
		local characterBeard = self.characterPreview.Entity:GetBodygroup( self.characterPreview.Entity:FindBodygroupByName("beard"))
		local characterHair = self.characterPreview.Entity:GetBodygroup( self.characterPreview.Entity:FindBodygroupByName("hair"))
		local character

		local msg = Derma_Message

		local skinBlacklist = impulse.Config.DefaultSkinBlacklist[characterModel]

		if skinBlacklist and table.HasValue(skinBlacklist, characterSkin) then
			return msg("The skin you selected was on the blacklist.\nPlease select another skin or change the model.", "impulse", "OK")
		end
		
		local name, rejectReason = impulse.CanUseName(characterName)
		if name == false then return msg(rejectReason, "impulse", "OK") end

		Derma_Query("Are you sure you are finished?\nYou can edit your character later, but it will cost a fee.", "impulse", "Yes", function()
			print("[impulse] Sending character data to server...")

			net.Start("impulseCharacterCreate")
			net.WriteString(characterName)
			net.WriteString(characterModel)
			net.WriteUInt(characterSkin, 8)

			net.WriteColor(hairColour)

			net.WriteUInt(characterBeard, 8)
			net.WriteUInt(characterHair, 8)
			net.SendToServer()

    		LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 4, 0.3)
    		self:Remove()
    		self:GetParent():Remove()
			impulse.hudEnabled = true
			FORCE_FADESPAWN = true
			impulse_isNewPlayer = false

			if CHAR_MUSIC and CHAR_MUSIC:IsPlaying() then
				CHAR_MUSIC:FadeOut(15)

				timer.Simple(16, function()
					if CHAR_MUSIC:IsPlaying() then
						CHAR_MUSIC:Stop()
					end
				end)
			end
		end, "No, take me back")
	end

	

	self.characterPreview = vgui.Create("DModelPanel", self)
	self.characterPreview:SetSize(600,400)
	self.characterPreview:SetPos(0,30)
	self.characterPreview:SetModel(impulse.Config.DefaultMaleModels[1])
	self.characterPreview:MoveToBack()
	self.characterPreview:SetCursor("arrow")
	self.characterPreview:SetFOV(40)
	self.characterPreview:SetCamPos(Vector(52, 52, 52))
	self.characterPreview.Entity.hairBodygroupID = self.characterPreview.Entity:FindBodygroupByName("hair")
	self.characterPreview.Entity.beardBodygroupID = self.characterPreview.Entity:FindBodygroupByName("beard")

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

	self.nameLbl = vgui.Create("DLabel", self)
 	self.nameLbl:SetFont("Impulse-Elements18-Shadow")
	self.nameLbl:SetText("Full Name:")
	self.nameLbl:SizeToContents()
	self.nameLbl:SetPos(10,40)

 	self.nameEntry = vgui.Create("DTextEntry", self)
 	self.nameEntry:SetSize(180,23)
 	self.nameEntry:SetPos(10,60)
 	self.nameEntry:SetAllowNonAsciiCharacters(false)

	self.genderLbl = vgui.Create("DLabel", self)
	self.genderLbl:SetFont("Impulse-Elements18-Shadow")
	self.genderLbl:SetText("Gender:")
	self.genderLbl:SizeToContents()
	self.genderLbl:SetPos(10,90)

  	self.genderBox = vgui.Create("DComboBox", self)
  	self.genderBox:SetPos(10,110)
  	self.genderBox:SetSize(180,23)
  	self.genderBox:SetValue("Male")
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

		characterPreview.Entity.beardBodygroupID = characterPreview.Entity:FindBodygroupByName("beard")
		characterPreview.Entity.hairBodygroupID = characterPreview.Entity:FindBodygroupByName("hair")

		self.skinSlider:SetValue(0)
		self.skinSlider:SetMax(characterPreview.Entity:SkinCount() - 1)

		self.beardSlider:SetValue(0)
		self.beardSlider:SetMax(characterPreview.Entity.beardBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.beardBodygroupID)-1)
		
		self.hairSlider:SetValue(0)
		self.hairSlider:SetMax(characterPreview.Entity.hairBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.hairBodygroupID)-1)
  	end

	self.hairColourLbl = vgui.Create("DLabel", self)
	self.hairColourLbl:SetFont("Impulse-Elements18-Shadow")
	self.hairColourLbl:SetText("Hair Colour:")
	self.hairColourLbl:SizeToContents()
	self.hairColourLbl:SetPos(10,150)

	self.hairColourBox = self:Add("DComboBox")
	self.hairColourBox:SetPos(10,170)
  	self.hairColourBox:SetSize(180,23)

	for hairName, hairColor in pairs(impulse.Config.DefaultHairColors) do
		self.hairColourBox:AddChoice(hairName, hairColor)
	end

	self.hairColourBox:SetValue(self.hairColourBox:GetOptionText(1))

  	function self.hairColourBox.OnSelect(panel, index, value, data)
		hairColour = data
  	end

	self.modelLbl = vgui.Create("DLabel", self)
	self.modelLbl:SetFont("Impulse-Elements18-Shadow")
	self.modelLbl:SetText("Models:")
	self.modelLbl:SizeToContents()
	self.modelLbl:SetPos(400,40)

  	self:PopulateModels(impulse.Config.DefaultMaleModels)

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
	self.skinSlider:SetValue(0)
	self.skinSlider.TextArea:SetTextColor(color_white)

	function self.skinSlider:OnValueChanged(newSkin)
    	characterPreview.Entity:SetSkin(math.floor(newSkin))
	end

	self.beardLbl = vgui.Create("DLabel", self)
	self.beardLbl:SetFont("Impulse-Elements18-Shadow")
	self.beardLbl:SetText("Beard Type:")
	self.beardLbl:SizeToContents()
	self.beardLbl:SetPos(400, 300)

	local beardBodygroupID = characterPreview.Entity:FindBodygroupByName("beard")
	self.beardSlider = vgui.Create("DNumSlider", self)
	self.beardSlider:SetMin(0)
	self.beardSlider:SetDecimals(0)
	self.beardSlider:SetMax(characterPreview.Entity.beardBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.beardBodygroupID)-1)
	self.beardSlider:SetSize(395,20)
	self.beardSlider:SetPos(230, 320)
	self.beardSlider:SetValue(0)
	self.beardSlider.TextArea:SetTextColor(color_white)

	function self.beardSlider:OnValueChanged(newSkin)
		characterPreview.Entity:SetBodygroup(characterPreview.Entity.beardBodygroupID, newSkin)
	end

	self.hairLbl = vgui.Create("DLabel", self)
	self.hairLbl:SetFont("Impulse-Elements18-Shadow")
	self.hairLbl:SetText("Hair Type:")
	self.hairLbl:SizeToContents()
	self.hairLbl:SetPos(400,340)

	local hairBodygroupID = characterPreview.Entity:FindBodygroupByName("hair")
	self.hairSlider = vgui.Create("DNumSlider", self)
	self.hairSlider:SetMin(0)
	self.hairSlider:SetDecimals(0)
	self.hairSlider:SetMax(characterPreview.Entity.hairBodygroupID == -1 and 0 or characterPreview.Entity:GetBodygroupCount(characterPreview.Entity.hairBodygroupID)-1)
	self.hairSlider:SetSize(395,20)
	self.hairSlider:SetPos(230, 360)
	self.hairSlider:SetValue(0)
	self.hairSlider.TextArea:SetTextColor(color_white)

	
	function self.hairSlider:OnValueChanged(newSkin)
		characterPreview.Entity:SetBodygroup(characterPreview.Entity.hairBodygroupID, newSkin)
	end
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


vgui.Register("impulseCharacterCreator", PANEL, "DFrame")
