local PANEL = {}

function PANEL:Init()
    self:SetSize(500,400)
    self:SetPos(50,300)
    self:SetSkin("combine")
    self:SetTitle("CAMERA ALERT")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    timer.Simple(10,function()
        self:Remove()
    end)
    self.Camera = nil
end

function PANEL:Paint(w,h)
    derma.SkinHook("Paint","Frame",self,w,h)
    if not self.Camera then return end
    local data = self.Camera:GetAttachment(self.Camera:LookupAttachment("eyes"))
    if not data then return end
    data.Pos = data.Pos + data.Ang:Forward() * 2.8
    local x, y = self:GetPos()
    local old = DisableClipping(true)
    render.RenderView({
        aspect = 450/350,
        fov = 70,
        origin = data.Pos,
        angles = data.Ang,
        x = x+25, y = y+25,
        w = w-50, h = h-50
    })
    DisableClipping(old)
end

vgui.Register("landisHL2RPCamView", PANEL, "DFrame")