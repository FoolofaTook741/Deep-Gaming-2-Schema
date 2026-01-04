include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    --self:DrawEntityOutline( 1.0 ) -- Draw an outline of 1 world unit.
    self:DrawModel()       -- Draw the model.
 
    --AddWorldTip( self:EntIndex(), "BATHTUB TIME!", 0.5, self:GetPos(), self  ) -- Add an example tip.
end

local w, h = ScrW(), ScrH()
local blurDrawPanel = {
	[1] = function(x, y, w, h)
		-- Bokeh DOF blur
		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
		DrawBokehDOF(6, 0, 0)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
}

local function BlurRect(x, y, w, h)
	blurDrawPanel[1](x,y,w,h)
end

local speed = 1000

net.Receive("pinnacle_portable_cam_viewer_open", function()
    local tbl = net.ReadTable()

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() / 2, ScrH() / 2)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(true)
    frame:MakePopup()

    local parent = frame

    frame.Paint = function(self, w, h)
        BlurRect(self.x, self.y, w, h)
        surface.SetDrawColor(Color(0,0,0,215)) -- menu body
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(Color(255,255,255))
        surface.DrawRect(20,65,450,1)

        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(0,0, w, h, 1)
    end
        -- title
    local titleLabel = vgui.Create("DLabel", frame)
    titleLabel:SetFont("terminal50")
    titleLabel:SetText("Camera Monitoring System")
    titleLabel:SetPos(25,0)
    titleLabel:SizeToContents()

    local parentPanel = vgui.Create("DPanel", frame)
    parentPanel:DockMargin(0,50,0,0)
    parentPanel:Dock(FILL)
    function parentPanel:Paint(w,h)
        return
    end

    local scrollPanel = vgui.Create("DScrollPanel", parentPanel)
    scrollPanel:Dock(FILL)

    for _, cam in ipairs(tbl) do
        local camImage = vgui.Create("DButton", scrollPanel)
        camImage:SetSize(760, 70)
        camImage:SetText("CAM " .. cam:EntIndex())
        camImage:SetFont("terminal32")
        camImage:SetPos(10, 10 + (_ - 1) * 80)

        camImage.Paint = function(self, w, h)
            local hovered = self:IsHovered()
            self.HoverAlpha = math.Approach(self.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * 10)

            surface.SetDrawColor(81, 81, 81, 10)
            surface.DrawRect(0, 0, w, h)

            if self.HoverAlpha > 0 then
                surface.SetDrawColor(32, 32, 32, self.HoverAlpha)
                surface.DrawRect(0, 0, w, h)
            end

            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        camImage.DoClick = function()
            local camFrame = vgui.Create("DFrame")
            camFrame:SetSize(ScrW() / 5, ScrH() / 10)
            camFrame:SetTitle("Camera View - " .. cam:EntIndex())
            camFrame:Center()
            camFrame:MakePopup()
            camFrame:ShowCloseButton(false) 

            LocalPlayer().CamView = true
            frame:Remove()


            camFrame.Paint = function(self, w, h)
                BlurRect(self.x, self.y, w, h)
                surface.SetDrawColor(Color(0,0,0,215)) -- menu body
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(color_white)
                surface.DrawOutlinedRect(0,0, w, h, 1)
            end

            local ExitButton = vgui.Create("DButton", camFrame)
            ExitButton:SizeToContents()
            ExitButton:SetFont("terminal32")
            ExitButton:Dock(FILL)
            ExitButton:SetText("Exit Camera View")

            ExitButton.Paint = function(self, w, h)
                local hovered = self:IsHovered()
                self.HoverAlpha = math.Approach(self.HoverAlpha or 0, hovered and 255 or 0, FrameTime() * speed)

                surface.SetDrawColor(81, 81, 81, 10)
                surface.DrawRect(0, 0, w, h)

                if self.HoverAlpha > 0 then
                    surface.SetDrawColor(32, 32, 32, self.HoverAlpha)
                    surface.DrawRect(0, 0, w, h)
                end

                surface.SetDrawColor(255, 255, 255, 200)
                surface.DrawOutlinedRect(0, 0, w, h)
            end 
            ExitButton.DoClick = function()
                camFrame:Close()
                LocalPlayer().CamView = false
                net.Start("pinnacle_portable_cam_viewer_exit")
                net.WritePlayer(LocalPlayer())
                net.SendToServer()
                LocalPlayer().IsWatchingCam = false

                hook.Remove("HUDPaint", "impulseCameraHUD")
            end
            
            ExitButton:Center()

            net.Start("pinnacle_portable_cam_viewer_watch")
            net.WriteEntity(cam)
            net.WritePlayer(LocalPlayer())
            net.SendToServer()
            LocalPlayer().IsWatchingCam = true

            if LocalPlayer().IsWatchingCam == true then
                    local scannerColorModify = {
                        ["$pp_colour_addr"] = 0,
                        ["$pp_colour_addg"] = 0,
                        ["$pp_colour_addb"] = 0,
                        ["$pp_colour_brightness"] = 1,
                        ["$pp_colour_contrast"] = 0,
                        ["$pp_colour_colour"] = 0,
                        ["$pp_colour_mulr"] = 0,
                        ["$pp_colour_mulg"] = 0,
                        ["$pp_colour_mulb"] = 0
                    }
                hook.Add("HUDPaint", "impulseCameraHUD", function()
                    local scanner = LocalPlayer()


                    -- nutscript style scanner hud
                    local boxWide, boxHeight = 580, 420
                    local boxWide2, boxHeight2 = boxWide * 0.5, boxHeight * 0.5
                    local scrW, scrH = ScrW() * 0.5, ScrH() * 0.5
                    local x, y = scrW - boxWide2, scrH - boxHeight2
                    local pos = scanner:GetPos()
                    local ang = LocalPlayer():GetAimVector():Angle()

                    draw.SimpleText("POS ("..math.floor(pos[1])..", "..math.floor(pos[2])..", "..math.floor(pos[3])..")", "impulseHL2RPScannerFont", x + 8, y + 8, color_white)
                    draw.SimpleText("ANG ("..math.floor(ang[1])..", "..math.floor(ang[2])..", "..math.floor(ang[3])..")", "impulseHL2RPScannerFont", x + 8, y + 24, color_white)
                    surface.SetDrawColor(235, 235, 235, 230)

                    surface.DrawLine(x, y, x + 128, y)
                    surface.DrawLine(x, y, x, y + 128)

                    x = scrW + boxWide2

                    surface.DrawLine(x, y, x - 128, y)
                    surface.DrawLine(x, y, x, y + 128)

                    x = scrW - boxWide2
                    y = scrH + boxHeight2

                    surface.DrawLine(x, y, x + 128, y)
                    surface.DrawLine(x, y, x, y - 128)

                    x = scrW + boxWide2

                    surface.DrawLine(x, y, x - 128, y)
                    surface.DrawLine(x, y, x, y - 128)
                end)
            end
        end
    end
end)
