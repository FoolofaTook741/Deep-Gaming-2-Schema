if CLIENT then
    local availableSkillPoints = 0
    local clientSkillData = {}

    function getVortSkillPoints()
        return availableSkillPoints
    end

    vortSkills = vortSkills or {}
    vortSkills.Skills = vortSkills.Skills or {}

    local invPanel = vgui.GetControlTable("impulseInventory")
    if invPanel then
        local oldInit = invPanel.Init
        function invPanel:Init(...)
            oldInit(self, ...)

            if LocalPlayer():Team() == TEAM_VORT then
                local vortSkillsPanel = vgui.Create("DPanel", self.tabs)
                vortSkillsPanel:Dock(FILL)
                vortSkillsPanel.Paint = function(self, w, h)
                    draw.RoundedBox(8, 0, 0, w, h, Color(40,40,40,240))
                end

                local skillsScroll = vgui.Create("DScrollPanel", vortSkillsPanel)
                skillsScroll:Dock(FILL)
                skillsScroll:DockMargin(0,0,0,10)
                skillsScroll.Paint = function(self, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, Color(60,60,60,220))
                end

                local function rebuildList(parent)
                    parent:Clear()
					
                    local pointsPanel = vgui.Create("DPanel", parent)
                    pointsPanel:Dock(TOP)
                    pointsPanel:SetTall(50)
                    pointsPanel:DockMargin(10, 10, 10, 10)
                    pointsPanel.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, Color(80,80,80,240))
                        draw.SimpleText("Available Skill Points: " .. getVortSkillPoints(), "Impulse-Elements22-Shadow", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
					
					local resetButton = vgui.Create("DButton", parent)
					resetButton:Dock(TOP)
					resetButton:SetTall(40)
					resetButton:DockMargin(10, 0, 10, 10)
					resetButton:SetFont("Impulse-Elements22-Shadow")

					local function updateResetButton()
						if not IsValid(resetButton) then
							timer.Remove("VortResetCountdown")
							return
						end

						local invested = 0
						for k, lvl in pairs(clientSkillData) do 
							if k ~= "lastReset" then
								invested = invested + lvl 
							end
						end
						resetButton:SetToolTip("Refunds " .. invested .. " point(s)")

						local last = clientSkillData.lastReset or 0
						local remaining = 0
						if last > 0 then
							remaining = math.max(0, (6 * 3600) - (os.time() - last))
						end
						if remaining > 0 then
							local h = math.floor(remaining / 3600)
							local m = math.floor((remaining % 3600) / 60)
							local s = math.ceil(remaining % 60)
							resetButton:SetText(string.format("Reset Skills (%02d:%02d:%02d)", h, m, s))
							resetButton:SetEnabled(false)
						elseif invested > 0 then
							resetButton:SetText("Reset Skills")
							resetButton:SetEnabled(true)
						else
							resetButton:SetText("No points to reset")
							resetButton:SetEnabled(false)
						end
					end

					resetButton.DoClick = function()
						Derma_Query(
							"Are you sure you want to reset all your skill points?",
							"Confirm Reset",
							"Yes", function() net.Start("vortResetSkills") net.SendToServer() end,
							"No", function() end
						)
					end

					timer.Create("VortResetCountdown", 1, 0, updateResetButton)
					updateResetButton()

                    if not next(vortSkills.Skills) then
                        local noSkillsLabel = vgui.Create("DLabel", parent)
                        noSkillsLabel:Dock(TOP)
                        noSkillsLabel:SetTall(50)
                        noSkillsLabel:SetContentAlignment(5)
                        noSkillsLabel:SetFont("Impulse-Elements22-Shadow")
                        noSkillsLabel:SetText("No skills found!")
                        noSkillsLabel:DockMargin(10, 10, 10, 10)
                    else
                        for skillID, data in pairs(vortSkills.Skills) do
                            local skillPanel = vgui.Create("DPanel", parent)
                            skillPanel:SetTall(120)
                            skillPanel:Dock(TOP)
                            skillPanel:DockMargin(10, 0, 10, 10)
                            skillPanel.Skill = skillID

                            local currentLevel = clientSkillData[skillID] or 0
                            local maxLevel = data.maxLevel or 10
                            local skillName = data.niceName or skillID
                            local skillDesc = data.desc or ""

                            skillPanel.Paint = function(self, w, h)
                                draw.RoundedBox(6, 0, 0, w, h, Color(50,50,50,210))
                                surface.SetDrawColor(100,100,100,255)
                                surface.DrawOutlinedRect(0,0,w,h)
                                draw.SimpleText(skillName, "Impulse-Elements22-Shadow", 20, 10, Color(255,255,255), TEXT_ALIGN_LEFT)
                                draw.SimpleText("Level " .. currentLevel .. " / " .. maxLevel, "Impulse-Elements22-Shadow", w - 70, 10, Color(255,255,255), TEXT_ALIGN_RIGHT)
                            end

                            local descLabel = vgui.Create("DLabel", skillPanel)
                            descLabel:SetFont("Impulse-Elements19-Shadow")
                            descLabel:SetTextColor(Color(200,200,200))
                            descLabel:SetText(skillDesc)
                            descLabel:SetWrap(true)
                            descLabel:SetAutoStretchVertical(true)
                            descLabel:Dock(TOP)
                            descLabel:DockMargin(20, 40, 60, 0)

                            local plusButton = vgui.Create("DButton", skillPanel)
                            plusButton:SetSize(40,40)
                            plusButton:SetText("+")
                            plusButton:SetFont("Impulse-Elements22-Shadow")
                            plusButton.DoClick = function()
                                if getVortSkillPoints() > 0 then
                                    net.Start("vortSpendSkill")
									net.WriteString(skillID)
                                    net.SendToServer()
                                else
                                    LocalPlayer():Notify("You have no skill points to spend!")
                                end
                            end

                            skillPanel.OnSizeChanged = function(self, w, h)
                                plusButton:SetPos(w - 50, (h - plusButton:GetTall()) * 0.5)
                            end
                        end
                    end
                end

                rebuildList(skillsScroll)

                net.Receive("vortUpdateSkills", function()
                    local data = net.ReadTable() or {}
                    availableSkillPoints = data.availableSkillPoints or 0
                    clientSkillData = data.skills or {}
					clientSkillData.lastReset = data.lastReset or 0
                    vortSkills.Skills = data.skillsTable or {}
                    if IsValid(skillsScroll) then
                        rebuildList(skillsScroll)
                        skillsScroll:InvalidateLayout(true)
                        skillsScroll:PerformLayout()
                    end
                end)

                self.tabs:AddSheet("Vort Skills", vortSkillsPanel, false, false, "Vortigaunt Skills")

                net.Start("vortSkillsTable")
                net.SendToServer()
            end
        end
    end
end
