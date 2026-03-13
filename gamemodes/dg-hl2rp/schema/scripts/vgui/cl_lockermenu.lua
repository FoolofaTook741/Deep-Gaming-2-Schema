local PANEL = {}

function PANEL:Init()
    local ply = LocalPlayer()
    local model = ply:GetModel()
    local skin = ply:GetSkin()

    self.doThink = false
    self.startTime = 0
    self:SetSize(300, 500)
    self:SetTitle("Locker")
    self:MakePopup()
    self:Center()

    -- Model preview
    self.modelPreview = vgui.Create("impulseModelPanel", self)
    self.modelPreview:SetPos(25, 50)
    self.modelPreview:SetSize(250, 300)
    self.modelPreview:SetModel(model, skin)
    self.modelPreview:MoveToBack()
    self.modelPreview:SetCursor("arrow")
    self.modelPreview:SetFOV(self.modelPreview:GetFOV() - 19)

    function self.modelPreview:LayoutEntity(ent)
        ent:SetAngles(Angle(0, 43, 0))
    end

    timer.Simple(0, function()
        if not IsValid(self.modelPreview) then return end
        local ent = self.modelPreview.Entity
        if not IsValid(ent) then return end

        for _, bg in pairs(ply:GetBodyGroups()) do
            local val = bg.id == 2 and (ply:GetBodygroup(2)) or
                        bg.id == 3 and (ply:GetBodygroup(3)) or
                        bg.num
            ent:SetBodygroup(bg.id, val)
        end
    end)

    self.suitType = vgui.Create("DComboBox", self)
    self.suitType:SetPos(25, 370)
    self.suitType:SetSize(250, self.suitType:GetTall())
    self.suitType:SetText("Pick an outfit")
    self.suitType:AddChoice("Normal")
    self.suitType:AddChoice("Rebel")
    self.suit = 1
	local CWU = false

    self.suitType.OnSelect = function(_, i, val)
		if not IsValid(self.modelPreview.Entity) then
			impulse.debugPrint("Error: Model preview entity is invalid")
			return
		end

		local ent = self.modelPreview.Entity
		local teamClass = ply.GetTeamClass and ply:GetTeamClass() or nil

		if val == "Normal" then
			local torso = 0
			local legs  = 0
			if ply:Team() == TEAM_CWU and teamClass == CLASS_MEDIC then
				torso = 3
				leggs = 0
			end

			ent:SetBodygroup(2, torso)
			ent:SetBodygroup(3, legs)
			self.suit = 1
		elseif val == "Rebel" then

			local bodygroup2 = 10
			local bodygroup3 = 3
			if ply:Team() == TEAM_CWU and teamClass == CLASS_MEDIC then
				bodygroup2 = 12
				
			end
			ent:SetBodygroup(2, bodygroup2)
			ent:SetBodygroup(3, bodygroup3)
			self.suit = 2
		end

		ent:InvalidateBoneCache()
		ent:SetupBones()
		ent:FrameAdvance(0)
	end



    -- Progress bar
    self.progressBar = vgui.Create("DProgress", self)
    self.progressBar:SetPos(25, 420)
    self.progressBar:SetSize(250, 5)
    self.progressBar:SetFraction(0)

    -- Change clothes button
    self.changeButton = vgui.Create("DButton", self)
    self.changeButton:SetPos(25, 425)
    self.changeButton:SetSize(250, 50)
    self.changeButton:SetText("Change Clothes")
    self.changeButton.DoClick = function()
        self.changeButton:SetDisabled(true)
        self.startTime = CurTime()
        self.doThink = true

        surface.PlaySound("ambient/materials/squeeker2.wav")

        timer.Simple(2, function()
            if IsValid(self) then
                net.Start("impulseHL2RPUseLocker")
                net.WriteBool(tobool(self.suit))
                net.SendToServer()

                LocalPlayer():Notify("You have changed clothes.")
                self:Close()
            end
        end)
    end
end

function PANEL:Think()
    if self.doThink then
        self.progressBar:SetFraction(math.Clamp((CurTime() - self.startTime) / 2, 0, 1))
    end
end

vgui.Register("impulseLockerMenu", PANEL, "DFrame")
