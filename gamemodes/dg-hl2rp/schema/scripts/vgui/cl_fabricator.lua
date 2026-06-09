-- marked for removal, can be replaced with Derma_Query

local PANEL = {}
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

local upgradesTable = { --! PLACEHOLDER
    ['wep_pistol'] = {
        mdl = "models/weapons/w_pistol.mdl",
        Cost = 3,
        purchaseItem = "att_resin_pistol",
        name = "USP-9 Upgrade"
    },
    ['wep_smg'] = {
        mdl = "models/weapons/w_smg1.mdl",
        Cost = 6,
        purchaseItem = "att_resin_mp7",
        name = "MP7 Upgrade"
    },
    ['wep_rifle'] = {
        mdl = "models/weapons/w_rif_m4a1.mdl",
        Cost = 12,
        purchaseItem = "att_resin_ak47",
        name = "AK47 Upgrade"
    },
    ['wep_shotgun'] = {
        mdl = "models/weapons/w_shotgun.mdl",
        Cost = 9,
        purchaseItem = "att_resin_spas12",
        name = "SPAS-12 Upgrade"
    },
}

local wireframeMat = Material("models/wireframe")

function PANEL:Init(fabricator)
    self.Scroll = vgui.Create("DScrollPanel", self)
    self.Scroll:Dock(FILL)
    self.Scroll:DockMargin(16, 16, 16, 16)

        for class, data in pairs(upgradesTable) do
        local upgradePanel = self.Scroll:Add("DPanel")
        upgradePanel:Dock(TOP)
        upgradePanel:DockMargin(0, 0, 0, 8)
        upgradePanel:SetTall(100)
        upgradePanel.Paint = function(s, w, h)
        end

        local modelPanel = vgui.Create("DModelPanel", upgradePanel)
        modelPanel:SetModel(data.mdl)
        modelPanel:SetSize(100, 100)
        modelPanel:SetPos(8, 0)
        modelPanel:SetFOV(40)
        modelPanel:SetCamPos(Vector(40, 0, 20))
        modelPanel:SetLookAt(Vector(0, 0, 10))
        modelPanel.LayoutEntity = function(self, ent)
            self:RunAnimation()
            ent:SetAngles(Angle(0, CurTime() * 50 % 360, 0))
        end

        modelPanel.PreDrawModel = function(self, ent)
            render.MaterialOverride(wireframeMat)
        end
        modelPanel.PostDrawModel = function(self, ent)
            render.MaterialOverride(nil)
        end

        local nameLabel = vgui.Create("DLabel", upgradePanel)
        nameLabel:SetText(data.name)
        nameLabel:SetFont("DermaLarge")
        nameLabel:SetTextColor(Color(255,255,255))
        nameLabel:SizeToContents()
        nameLabel:SetPos(120, 20)

        local costLabel = vgui.Create("DLabel", upgradePanel)
        costLabel:SetText("Cost: " .. data.Cost .. " Resin")
        costLabel:SetFont("DermaDefaultBold")
        costLabel:SetTextColor(Color(200,200,50))
        costLabel:SizeToContents()
        costLabel:SetPos(120, 60)

        local purchaseBtn = vgui.Create("DButton", upgradePanel)
        purchaseBtn:SetText("PURCHASE")
        purchaseBtn:SetFont("DermaDefault")
        purchaseBtn:SetSize(100, 32)
        purchaseBtn:SetPos(500, 34)
        purchaseBtn.Paint = function(s, w, h)
            surface.SetDrawColor(Color(50, 255, 100))
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        purchaseBtn.DoClick = function()
            surface.PlaySound("ui/hls_ui_scroll_click.wav")
            --[[
            net.Start("impulseFabricatorPurchase")
                net.WriteString(data.purchaseItem)
                net.WriteString(data.name)
                net.WriteInt(data.Cost, 16)
            net.SendToServer()
            --]]

            self:Remove()
        end
        upgradePanel.PerformLayout = function(s, w, h)
            purchaseBtn:SetPos(w - 120, 34)
        end
    end
end

function PANEL:Paint(w,h)
	BlurRect(self.x, self.y, w, h)
	surface.SetDrawColor(Color(0,0,0,215)) -- menu body
	surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(Material("overlays/cmb_terminal_bg.png"))
    surface.DrawTexturedRect(0,0,w,h)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(Material("overlays/cmb_bg_animated1"))
    surface.DrawTexturedRect(0,0,w,h)

end
vgui.Register("impulseRebelFabricatorMenu", PANEL, "DPanel")
