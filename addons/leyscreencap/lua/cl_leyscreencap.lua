local RunConsoleCommand = RunConsoleCommand

timer.Simple(0, function()
local LeyMenusColors = { -- dont touch this if u dont know what u doing
    Main = Color(0, 0, 0),
    Secondary = Color(73, 182, 24),
    Tertiary = Color(65, 185, 255),
}

local debugmode = false

local print = function(msg, force)
    if debugmode || force then
        print(msg)
    end
end

print('[Leyscreencap] Loaded cl!', true)
print('[LeyScreenCap] Debug mode enabled!')

LeyScreenCap = {}
LeyScreenCap.methodtranslates = {}
LeyScreenCap.methodtranslates["Render Capture"] = 1
LeyScreenCap.methodtranslates["Rendertarget"] = 2
LeyScreenCap.methodtranslates["Pixelskip mode"] = 3

local MCHUNKSIZE = 5000
local MCHUNKDELAY = 0.05


function LeyScreenCap.PostCap(fileformat, dtype, data)
    if (not data) then
        ErrorNoHalt("[LeyScreenCap] No data!\n")
        LeyScreenCap.isblocked = false
        return
    end

    if (#data == 0) then
        ErrorNoHalt("[LeyScreenCap] Invalid data!\n")
        LeyScreenCap.isblocked = false
        return
    end


    --file.Write("leyscrp_test." .. fileformat .. ".txt", data)

    if(dtype=="stream" or fileformat == "tga") then
        local compdat = util.Compress(data)
        data=compdat
    end

    print("SIZE: " .. #data)

    local posttbl = {}
    posttbl["fileformat"] = fileformat
    posttbl["datatype"] = dtype
    posttbl["data"] = util.Base64Encode(data)
    posttbl["sid64"] = LocalPlayer():SteamID64() -- protected against spoofing, dont bother

    http.Post(LeyScreenCap.website .. "/savedata.php", posttbl,
        function(responseText, contentLength, responseHeaders, statusCode)

            print('\n---LeyScreenCap.PostCap---')
            print('url: '.. LeyScreenCap.website .. "/savedata.php")
            print('image url: '..responseText)
            print('---END---\n')

            LeyScreenCap.isblocked = false
            net.Start("LeyScreenCap")
                net.WriteUInt(1, 8) -- 1 = normal screencap
                net.WriteString(fileformat)
                net.WriteString(responseText)
            net.SendToServer()
        end,
        function(err)
            LeyScreenCap.isblocked = false

            print('\n---LeyScreenCap.PostCap (error)---')
            print('url: '.. LeyScreenCap.website .. "/savedata.php")
            print(err)
            print('---END---\n')
        end
    )


-- for i=1, upto+1 do
--     timer.Simple(i * MCHUNKDELAY, function()

--         local final = false
--         if(i*MCHUNKSIZE>#compdat)then
--             final = true
--             print("FINAL")
--         end

--         print(#compdat - i*MCHUNKSIZE)

--         net.Start("LeyScreenCap")

--             net.WriteUInt(1, 8) -- 1 = normal screencap
--             net.WriteString(type)

--             net.WriteBool(final)

--             net.WriteUInt(#compdat, 32)
--             net.WriteUInt(MCHUNKSIZE, 32)

--             local curoffset = ((i-1)*MCHUNKSIZE)
--             local curend = (i*MCHUNKSIZE)

--             if(final) then
--                 curend = #compdat
--             end

--             local curdata = string.sub(compdat, curoffset, curend)
--             net.WriteData(curdata, #curdata)

--         net.SendToServer()
--     end)
-- end
end


local function mathClamp( _in, low, high )
	return math.min( math.max( _in, low ), high )
end

local Scale = mathClamp(ScrH()/1080, 0.8, 1)
local Scale = function(v)
    return Scale * v
end

local function numbertodata(num, desiredbytes, reverse_endian)

    local hexnum = string.format("%x", num)


    local datanum = ""

    for i=1, #hexnum, 2 do
        local curbyte = hexnum[i] .. hexnum[i+1]

        datanum = datanum .. string.char(tonumber(curbyte, 16))
    end

    local fill = string.rep("\x00", desiredbytes - #datanum)


    datanum = fill .. datanum

    if(reverse_endian) then
        return string.reverse(datanum)
    end

    return datanum
end

local newRT = GetRenderTarget("screengrab_rt" .. ScrW() .. "_" .. ScrH(), ScrW(), ScrH())
local newMat = CreateMaterial("screengrab_mat", "UnlitGeneric", { ["$basetexture"] = newRT:GetName() })

LeyScreenCap.isblocked = false

local cmdwaitdelay = 0.25
function LeyScreenCap.Screenshot(method, quality)

    if (LeyScreenCap.isblocked) then return end

    LeyScreenCap.isblocked = true

    timer.Create("leyscreencap_fixstuck", 10, 1, function()
        if (LeyScreenCap and LeyScreenCap.isblocked) then
            LeyScreenCap.isblocked = false
        end
    end)

    quality = math.Round(quality)

    local datatype = "screenshot"

    if(LeyScreenCap.streaming) then
        datatype = "stream"
    end

    print("METHOD: " .. method)

    if(method == 1) then
        local data = render.Capture(
        {
            format = "jpg",
            quality = quality,
            h = ScrH(),
            w = ScrW(),
            x = 0,
            y = 0,
            alpha = false
        })

        if(not data) then
            data = "failed"
        end
        file.Write("sure.jpg", data)

        LeyScreenCap.PostCap("jpg", datatype, data)
    end

    if(method == 2) then


        local w = ScrW()
        local h = ScrH()

        local cutpixels = 8

        w = w - cutpixels
        h = h - cutpixels


        local a = bit.lshift(0xFF, 24)


        local f = file.Open("leyscreencap_tmpbuf.txt", "wb", "DATA")
        if (!f) then return end
        f:WriteByte(0)
        f:WriteByte(0)
        f:WriteByte(2) --uncompressed RGB
        f:WriteByte(0)
        f:WriteLong(0)
        f:WriteLong(0)
        f:WriteShort(w)
        f:WriteShort(h)
        f:WriteByte(24)
        f:WriteByte(0)

        local x = 0
        local y = h

        local tock = 0

        local starttime = CurTime()

        local lastcols = {}

        local lastr, lastg, lastb

        local function processline()
            while x!=w do
                x = x + 1


                local r,g,b


                if(tock>0) then


                    r = lastr
                    g = lastg
                    b = lastb
                    tock = tock - 1
                else
                    r,g,b = render.ReadPixel(x,y)
                    lastr = r
                    lastg = g
                    lastb = b
                    tock = 4

                    lastcols[#lastcols+1] = {r,g,b}

                end


                if(#lastcols>2) then

                    local firstcol = lastcols[1]
                    for k,v in pairs(lastcols) do
                        if(k == 1) then continue end
                        local r = v[1]
                        local g = v[2]
                        local b = v[3]

                        local oldr = firstcol[1]
                        local oldg = firstcol[2]
                        local oldb = firstcol[3]

                        local distr = math.abs(oldr - r)
                        local distg = math.abs(oldg - g)
                        local distb = math.abs(oldb - b)

                        local mindist = 15
                        if(distr<mindist and distg<mindist and distb<mindist) then
                            tock = 24 -- assume that'll happen for the next 10 cols
                        end

                    end

                    for k,v in pairs(lastcols) do
                        lastcols[k] = nil
                    end

                end

                f:WriteByte(b)
                f:WriteByte(g)
                f:WriteByte(r)
            end

            x = 0
            y = y - 1

            if(y==0 or 0>y) then
                f:Close()

                LeyScreenCap.repeatfunc = nil

                timer.Destroy("doall")

                timer.Simple(0.1, function()
                    print("TIME TAKEN: " .. CurTime() - starttime)
                    local rf = file.Read("leyscreencap_tmpbuf.txt", "DATA")

                    if(rf) then
                        --print(#util.Compress(rf))
                        --LeyScreenCap.isblocked = false
                        LeyScreenCap.PostCap("tga", datatype, rf)
                    end

                    file.Delete("leyscreencap_tmpbuf.txt")

                end)

            end
        end

        local linesatonce = 30

        render.CapturePixels()

        LeyScreenCap.repeatfunc = processline


        -- timer.Create("doall", 0, h, function()
        --     print("HI dude")
        --     print(h)

        --     for i=1, linesatonce do
        --         processline() -- 10 lines at once
        --     end
        -- end)



    end

    if (method == 2) then
        local shouldCopy = true
        local shouldSave = false
        
        hook.Add("PostRender", "Leyscreencap.CopyRT", function()
            if (not shouldCopy) then return end

            local oldRT = render.GetRenderTarget()
            render.CopyTexture(oldRT, newRT)
        end)

        local oldRT = render.GetRenderTarget()
        render.CopyTexture(oldRT, newRT)
        
        timer.Simple(0, function()
            hook.Add("DrawOverlay", "LeyScreencap.DrawRT", function()
                if (not shouldCopy) then
                    return
                end

                surface.SetDrawColor(color_white)
                surface.SetMaterial(newMat)
                surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
                shouldSave = true
            end)
        end)

        timer.Simple(0.01, function()
            hook.Add("PostRender", "Leyscreencap.SendRT", function()
                if (not shouldCopy or not shouldSave) then
                    return
                end

                shouldCopy = false
                shouldSave = false

                local data = render.Capture(
                {
                    format = "jpeg",
                    quality = quality,
                    h = ScrH(),
                    w = ScrW(),
                    x = 0,
                    y = 0,
                })

                if(not data) then
                    data = "failed"
                end

                LeyScreenCap.PostCap("jpg", datatype, data)

                hook.Remove("PostRender", "Leyscreencap.SendRT")
                hook.Remove("DrawOverlay", "LeyScreencap.DrawRT")
            end)
        end)
    end

end

local skipticks = 0

function LeyScreenCap.PostRender()
    if(not LeyScreenCap.shouldcap) then return end

    gui.HideGameUI()

    if(LeyScreenCap.repeatfunc) then

        if(skipticks > 0) then
            skipticks = skipticks - 1
            return
        end

        if(RealFrameTime()>0.1) then
            print("lag; skip cap")
            skipticks = 3
            return
        end

        local linesatonce = 20
        for i=1, linesatonce do
            if(LeyScreenCap.repeatfunc) then
                LeyScreenCap.repeatfunc()
            end
        end
    end

    if(LeyScreenCap.hideui > CurTime()) then
        return
    end

    local method = LeyScreenCap.shouldcap
    local quality = LeyScreenCap.quality

    if (LeyScreenCap.isblocked) then return end
    LeyScreenCap.Screenshot(method, quality)

    LeyScreenCap.shouldcap = nil
end

hook.Add("PostRender", "LeyScreenCap", LeyScreenCap.PostRender)


function LeyScreenCap.Receive(l)

    local msgtype = net.ReadUInt(8)

    if(msgtype == 1) then
        local method = net.ReadUInt(8)
        local quality = net.ReadUInt(8)
        local isstreaming = net.ReadBool()
        local website = net.ReadString()

        LeyScreenCap.hideui = CurTime() + 1
        LeyScreenCap.shouldcap = method
        LeyScreenCap.quality = quality
        LeyScreenCap.streaming = isstreaming
        LeyScreenCap.website = website
    end

    if(msgtype == 2) then
        local targetsid64 = net.ReadString()
        local stream_wait = net.ReadUInt(32)
        local method = net.ReadUInt(8)
        local quality = net.ReadUInt(8)
        local url = net.ReadString()

        local target = NULL
        for k,v in pairs(player.GetAll()) do
            if(v:SteamID64() == targetsid64) then
                target = v
            end
        end

        print("calling oncapreceive")

        LeyScreenCap.OnCapReceive(target, targetsid64, url, method, quality, stream_wait)
    end
end

net.Receive("LeyScreenCap", LeyScreenCap.Receive)

LeyScreenCap.playerpanels = LeyScreenCap.playerpanels or {}

function LeyScreenCap.OnCapReceive(target, targetsid64, url, method, quality, stream_wait)
    print("Still streaming for: " .. tostring(target) .. "__" .. tostring(method) .. "__" .. tostring(quality))

    if(timer.Exists("leyscreencap_refresh_" .. targetsid64)) then return end -- already got a refresh thang going on

    local is_tga = false
    if(method  == 5) then
        is_tga = true
    end
    local comp = false

    if(stream_wait != 0 or is_tga) then
        comp = true
    end

    local streaming = false

    if(stream_wait != 0) then
        streaming = true
    end


    local function showimage(comp, sid64, url)
        if (!IsValid(LeyScreenCap.playerpanels[sid64])) then
            local opan = LeyScreenCap.playerpanels[sid64]
            if (opan) then
                opan:Remove()
                opan = nil
                LeyScreenCap.playerpanels[sid64] = nil
                RunConsoleCommand("leyscreencap", "1", sid64)
                timer.Remove("leyscreencap_refresh_" .. targetsid64)
                return
            end

            local ply = player.GetBySteamID64(sid64)
            local Panel = vgui.Create("Ley.Frame")
            --Panel:LeySetSize(1370, 1000)
            Panel:SetSize(ScrW() * .9, ScrH() *.9)
            Panel:ParentToHUD()
            Panel:Center()
            Panel:MakePopup()
            Panel:SetDrawOnTop(true) -- Hey screenshot panel will be ontop of the screenshot then people will start screaming and make tickets aaaaaaaaaaaaaaaaaaaaaaaaaa
            Panel:SetTitle(IsValid(ply) && ply:Nick() .. " (" .. sid64 .. ")" || sid64)

            local imgview = Panel:Add("DImage")
            imgview:Dock(FILL)
            imgview:DockMargin(10, 10, 10, 10)
            imgview:SetVisible(true)

            Panel.imgview = imgview
            Panel.imgviewtga = imgviewtga

            LeyScreenCap.playerpanels[sid64] = Panel
        end


        local pan = LeyScreenCap.playerpanels[sid64]

        local fetchurl = string.gsub(url, " ", "%%20")
        http.Fetch(fetchurl .. "?idk=" .. tostring(SysTime()), function(data)
            print("\n---LeyScreenCap.OnCapReceive---")
            print("url: " .. fetchurl)
            print(data)
            print("---END---\n")

            SetClipboardText(fetchurl)

            if(comp) then
                data = util.Decompress(data)
                print("comp")
            end

            if(is_tga) then
                file.Write("refresh_" .. targetsid64 .. ".tga.jpg", data)
            else
                file.Write("refresh_" .. targetsid64 .. ".jpg", data)
            end
            if(not IsValid(pan) or not IsValid(pan.imgview)) then return end


            if(not is_tga) then
                print("its not TGA")
                pan.imgview:SetImage("../data/refresh_" .. targetsid64 .. ".jpg")
            else
                pan.imgview:SetImage("../data/refresh_" .. targetsid64 .. ".tga.jpg")
            end

            local mat = pan.imgview:GetMaterial()

            if(mat) then
                local txt = mat:GetTexture("$basetexture")
                txt:Download()
            end

            if(not streaming) then
                print("not streaming")

                local fdate = os.date("%Y_%m_%d __ %H_%M_%S")
                local filename = "leyscreencap/" .. targetsid64 .. " ___ " .. fdate

                if(is_tga) then
                    filename = filename .. ".tga"
                end

                filename = filename .. ".jpg"

                LocalPlayer():ChatPrint("Saved screenshot to: " .. filename)

                file.CreateDir("leyscreencap")
                file.Write(filename, data)
            end

            pan.imgview:SizeToContents()
            pan:SizeToContents()
        end)


    end

    timer.Create("leyscreencap_refresh_" .. targetsid64, stream_wait==0 and 0 or (stream_wait+30)/1000, stream_wait == 0 and 1 or 20, function()
        showimage(comp, targetsid64, url)
    end)
end

LeyScreenCap.currentmethod = CreateConVar("cl_leyscreencap_curmethod", "1", { FCVAR_ARCHIVE }, "The method (currently there's 1 & 4, later 1 to 5)"):GetInt()
LeyScreenCap.currentquality = CreateConVar("cl_leyscreencap_curquality", "15", { FCVAR_ARCHIVE }, "The quality (range: 1-100)"):GetInt() -- 76561198162962704
LeyScreenCap.currentstreamwait = CreateConVar("cl_leyscreencap_curstreamwait", "3000", { FCVAR_ARCHIVE }, "The delay in ms (milliseconds) between each refresh when streaming"):GetInt()

cvars.AddChangeCallback("cl_leyscreencap_curmethod", function(name, oldval, newval)

    LeyScreenCap.currentmethod = GetConVar(name):GetInt()

    if(LeyScreenCap.currentmethod>6 or 1>LeyScreenCap.currentmethod) then
        LeyScreenCap.currentmethod = 1
        newval = "1"
        RunConsoleCommand("cl_leyscreencap_curmethod", "1")
    end

    print("[LeyScreenCap] new current method: " .. newval)
end)

cvars.AddChangeCallback("cl_leyscreencap_curquality", function(name, oldval, newval)

    LeyScreenCap.currentquality = GetConVar(name):GetInt()

    if(LeyScreenCap.currentquality>100 or 1>LeyScreenCap.currentquality) then
        LeyScreenCap.currentquality = 60
        newval = "60"
        RunConsoleCommand("cl_leyscreencap_curquality", "60")
    end

    print("[LeyScreenCap] new current quality: " .. newval)
end)

cvars.AddChangeCallback("cl_leyscreencap_curstreamwait", function(name, oldval, newval)

    LeyScreenCap.currentstreamwait = GetConVar(name):GetInt()

    if(LeyScreenCap.currentstreamwait>1000*10 or 400 > LeyScreenCap.currentstreamwait) then
        LeyScreenCap.currentstreamwait = 1000*10
        newval = tostring(1000*10)
        RunConsoleCommand("cl_leyscreencap_curstreamwait", tostring(1000*10))
    end

    print("[LeyScreenCap] new current wait: " .. newval)
end)

surface.CreateFont("LeyScreenCap.SlidersTexts", {font = "Roboto", antialias = true, size = Scale(16), weight = 500})

surface.CreateFont("LeyScreenCap.ColumnHeader", {font = "Roboto", antialias = true, size = Scale(18), weight = 500})
surface.CreateFont("LeyScreenCap.Lines", {font = "Roboto", antialias = true, size = Scale(17), weight = 500})
surface.CreateFont("LeyScreenCap.Buttons", {font = "Roboto", antialias = true, size = Scale(17), weight = 400})

local RoundedBox = draw.RoundedBox
concommand.Add("leyscreencap_menu", function()
    local Panel = vgui.Create("Ley.Frame")
    Panel:SetTitle("LeyScreenCap")
    Panel:LeySetSize(520, 470)
    Panel:Center()
    Panel:MakePopup()

    local Players = Panel:Add("DListView")
    Players:Dock(FILL)
    Players:DockMargin(10, 10, 10, 10)
    Players:SetMultiSelect(false)
    Players:SetHeaderHeight(20)
    Players:LeyClearPaint()
    Players:LeyBackground(LeyMenusColors.Secondary, 3)

    local VBar = Players.VBar
    VBar:SetHideButtons(true)
    VBar:LeyClearPaint()

    local Grip = VBar.btnGrip
    Grip:LeyClearPaint()
    Grip:LeyBackground(LeyMenusColors.Tertiary, 3)

    local EmptyPanel = Players:Add("DPanel")
    EmptyPanel:Dock(FILL)
    EmptyPanel:DockMargin(5, Players:GetHeaderHeight(), 5, 5)
    EmptyPanel:LeyClearPaint()
    EmptyPanel:LeyBackground(LeyMenusColors.Main, 3)

    function Players:PerformLayout()
        local Wide = self:GetWide()
        local YPos = 0

        if (IsValid(self.VBar)) then
            self.VBar:SetPos(Wide-self.VBar:GetWide()-7, self:GetHeaderHeight())
            self.VBar:SetSize(5, EmptyPanel:GetTall())
            self.VBar:SetUp(self.VBar:GetTall() - self:GetHeaderHeight(), self.pnlCanvas:GetTall()-20)
            YPos = self.VBar:GetOffset()
        end

        self.pnlCanvas:SetPos(0, YPos)
        self.pnlCanvas:SetSize(Wide, self.pnlCanvas:GetTall())

        self:FixColumnsLayout()

        if (self:GetDirty(true)) then
            self:SetDirty(false)
            local y = self:DataLayout()
            self.pnlCanvas:SetTall(y)

            self:InvalidateLayout(true)
        end
    end

    local EmptyPanel = EmptyPanel:Add("DPanel")
    EmptyPanel:Dock(FILL)
    EmptyPanel:DockMargin(-5, 0, -5, 0)
    EmptyPanel:LeyClearPaint()

    Players.pnlCanvas:SetParent(EmptyPanel)

    Players:AddColumn("Nick")
    Players:AddColumn("SteamID64")

    for _, v in pairs(Players.Columns) do
        v:SetSize(0, 0)

        local Header = v.Header
        Header:SetFont("LeyScreenCap.ColumnHeader")
        Header:SetTextColor(color_white)
        Header:SetContentAlignment(5)
        Header:LeyClearPaint()
        Header:LeyCircleClick(color_white)
        Header:LeyHoverText(color_white, LeyMenusColors.Tertiary)
    end

    for _, v in ipairs(player.GetAll()) do
        local Line = Players:AddLine(v:Nick(), v:SteamID64() || "NULL")
        Line:LeyClearPaint()

        Line:LeyFunction("Paint", function(s, w, h)
            if (s:IsSelected()) then
                RoundedBox(3, 0, 0, w, h, LeyMenusColors.Tertiary)
            elseif (s:IsHovered()) then
                RoundedBox(3, 0, 0, w, h, ColorAlpha(LeyMenusColors.Tertiary, 100))
            end
        end)

        for _, v in ipairs(Line.Columns) do
            v:SetColor(color_white)
            v:SetFont("LeyScreenCap.Lines")
            v:SetContentAlignment(5)
        end
    end

    local BottomPanel = Panel:Add("DPanel")
    BottomPanel:Dock(BOTTOM)
    BottomPanel:DockMargin(10, 0, 10, 10)
    BottomPanel:LeySetTall(57)
    BottomPanel:LeyClearPaint()

    local SelectCaptureMethod = Panel:Add("DComboBox")
    SelectCaptureMethod:Dock(BOTTOM)
    SelectCaptureMethod:LeySetTall(24)
    SelectCaptureMethod:DockMargin(Scale(10), Scale(10), Scale(10), 0)
    SelectCaptureMethod:SetSortItems(false)

    local startselmethod = GetConVar("cl_leyscreencap_curmethod"):GetInt()
    local curval = ""
    for k,v in pairs(LeyScreenCap.methodtranslates) do
        if(v== startselmethod) then
            curval = k
        end
    end

    SelectCaptureMethod:SetValue(curval)

    local inverse = {}
    for k,v in pairs(LeyScreenCap.methodtranslates) do
        inverse[v] = k
    end

    for i=1, #inverse do
        SelectCaptureMethod:AddChoice(inverse[i])
    end

    SelectCaptureMethod.OnSelect = function(panel, index, value)
        local trans = LeyScreenCap.methodtranslates[value]

        if(not trans) then return end

        RunConsoleCommand("cl_leyscreencap_curmethod", trans)
    end

    local QualitySlider = Panel:Add("DNumSlider")
    QualitySlider:Dock(BOTTOM)
    QualitySlider:DockMargin(Scale(15), Scale(5), 0, 0)
    QualitySlider:LeySetTall(26)
    QualitySlider:SetText("Quality")
    QualitySlider:SetMin(1)
    QualitySlider:SetMax(100)
    QualitySlider:SetDecimals(0)
    QualitySlider:SetValue(GetConVar("cl_leyscreencap_curquality"):GetInt())
    QualitySlider:SetConVar("cl_leyscreencap_curquality")
    QualitySlider.Label:SetFont("LeyScreenCap.SlidersTexts")
    QualitySlider.TextArea:SetTextColor(Color(230, 230, 230, 200))
    QualitySlider.TextArea:SetCursorColor(color_white)

    QualitySlider.Slider.Paint = function(self, w, h)
        surface.SetDrawColor(75, 75, 75, 100)
        surface.DrawRect(0, h / 2 - 2, w - 12, 3)
    end

    QualitySlider.Slider.Knob.Paint = function(self, w, h)
        surface.SetDrawColor(LeyMenusColors.Secondary)
        surface.DrawRect(0, 0, 3, h)
    end

    local StreamDelaySlider = Panel:Add("DNumSlider")
    StreamDelaySlider:Dock(BOTTOM)
    StreamDelaySlider:DockMargin(Scale(15), Scale(5), 0, 0)
    StreamDelaySlider:LeySetTall(26)
    StreamDelaySlider:SetText("Min stream Delay")
    StreamDelaySlider:SetMin(400)
    StreamDelaySlider:SetMax(7000)
    StreamDelaySlider:SetDecimals(0)
    StreamDelaySlider:SetValue(GetConVar("cl_leyscreencap_curstreamwait"):GetInt())
    StreamDelaySlider:SetConVar("cl_leyscreencap_curstreamwait")
    StreamDelaySlider.Label:SetFont("LeyScreenCap.SlidersTexts")
    StreamDelaySlider.TextArea:SetTextColor(Color(230, 230, 230, 200))
    StreamDelaySlider.TextArea:SetCursorColor(color_white)

    StreamDelaySlider.Slider.Paint = function(self, w, h)
        surface.SetDrawColor(75, 75, 75, 100)
        surface.DrawRect(0, h / 2 - 2, w - 12, 3)
    end

    StreamDelaySlider.Slider.Knob.Paint = function(self, w, h)
        surface.SetDrawColor(LeyMenusColors.Secondary)
        surface.DrawRect(0, 0, 3, h)
    end

    local AbortEverything = Panel:Add("DButton")
    AbortEverything:Dock(BOTTOM)
    AbortEverything:DockMargin(Scale(10), Scale(5), 10, 0)
    AbortEverything:LeySetTall(26)
    AbortEverything:SetText("Abort all my transfers")
    AbortEverything:SetFont("LeyScreenCap.Buttons")
    AbortEverything:LeyClearPaint()
    AbortEverything:LeyBackground(LeyMenusColors.Secondary, 3)
    AbortEverything:LeyCircleClick(color_white)
    AbortEverything:LeyHoverText(color_white, LeyMenusColors.Tertiary)

    AbortEverything.DoClick = function()
        RunConsoleCommand("leyscreencap", "1")
    end

    local TopPanelInBottomPanel = BottomPanel:Add("DPanel") -- cool name
    TopPanelInBottomPanel:Dock(TOP)
    TopPanelInBottomPanel:DockMargin(Scale(10), Scale(5), 10, 0)
    TopPanelInBottomPanel:LeySetTall(40)
    TopPanelInBottomPanel:LeyClearPaint()

    local ScreenShotButton = TopPanelInBottomPanel:Add("DButton")
    ScreenShotButton:Dock(RIGHT)
    ScreenShotButton:SetText("Screenshot")
    ScreenShotButton:SetFont("LeyScreenCap.Buttons")
    ScreenShotButton:LeyClearPaint()
    ScreenShotButton:LeyBackground(LeyMenusColors.Secondary, 3)
    ScreenShotButton:LeyCircleClick(color_white)
    ScreenShotButton:LeyHoverText(color_white, LeyMenusColors.Tertiary)

    ScreenShotButton.DoClick = function()
        if (Panel.waitforclick and Panel.waitforclick>CurTime()) then
            LocalPlayer():ChatPrint("Cooldown, please wait a few seconds")
            return
        end

        Panel.waitforclick = CurTime() + 5

        if (!Players:GetSelectedLine()) then return end

        local sid64 = Players:GetLine(Players:GetSelectedLine())
        if (!sid64) then
            LocalPlayer():ChatPrint("Selected a line wtf?")
            return
        end

        sid64 = sid64:GetColumnText(2)

        local opan = LeyScreenCap.playerpanels[sid64]
        if (opan) then
            opan:Remove()
            opan = nil
            LeyScreenCap.playerpanels[sid64] = nil
            RunConsoleCommand("leyscreencap", "1", sid64)
            timer.Destroy("leyscreencap_refresh_" .. sid64)
        end

        timer.Simple(0.1, function()
            RunConsoleCommand("leyscreencap", "2", sid64, tostring(LeyScreenCap.currentmethod),  tostring(LeyScreenCap.currentquality), "0", tostring(LeyScreenCap.currentstreamwait))
        end)
    end

    local StreamButton = TopPanelInBottomPanel:Add("DButton")
    StreamButton:Dock(LEFT)
    StreamButton:SetText("Stream")
    StreamButton:SetFont("LeyScreenCap.Buttons")
    StreamButton:LeyClearPaint()
    StreamButton:LeyBackground(LeyMenusColors.Secondary, 3)
    StreamButton:LeyCircleClick(color_white)
    StreamButton:LeyHoverText(color_white, LeyMenusColors.Tertiary)

    StreamButton.DoClick = function()
        if (Panel.waitforclick and Panel.waitforclick>CurTime()) then
            LocalPlayer():ChatPrint("Cooldown, please wait a few seconds")
            return
        end
        Panel.waitforclick = CurTime() + 5

        if (!Players:GetSelectedLine()) then return end

        local sid64 = Players:GetLine(Players:GetSelectedLine())
        if (!sid64) then
            LocalPlayer():ChatPrint("Selected a line wtf?")

            return
        end

        sid64 = sid64:GetColumnText(2)

        local opan = LeyScreenCap.playerpanels[sid64]
        if (opan) then
            opan:Remove()
            opan = nil
            LeyScreenCap.playerpanels[sid64] = nil
            RunConsoleCommand("leyscreencap", "1", sid64)
            timer.Destroy("leyscreencap_refresh_" .. sid64)
        end

        timer.Simple(0.1, function()
            RunConsoleCommand("leyscreencap", "2", sid64, tostring(LeyScreenCap.currentmethod),  tostring(LeyScreenCap.currentquality), "1", tostring(LeyScreenCap.currentstreamwait))
        end)

    end

    TopPanelInBottomPanel:LeyFunction("PerformLayout", function(s, w, h)
        local w = (w-5)/2

        StreamButton:SetWide(w)
        ScreenShotButton:SetWide(w)
    end)

    LeyScreenCap.ScreenshotMainMenu = Panel
end)

concommand.Add("leyscreencap_cl_takepic", function(p,c,a,s)

    RunConsoleCommand("leyscreencap", "2", a[1], tostring(LeyScreenCap.currentmethod),  tostring(LeyScreenCap.currentquality), "0", tostring(LeyScreenCap.currentstreamwait))

end)

concommand.Add("leyscreencap_cl_startstream", function(p,c,a,s)

    RunConsoleCommand("leyscreencap", "2", a[1], tostring(LeyScreenCap.currentmethod),  tostring(LeyScreenCap.currentquality), "1", tostring(LeyScreenCap.currentstreamwait))

end)

local Lerp = Lerp
local ColorAlpha = ColorAlpha
local RoundedBox = draw.RoundedBox
local RoundedBoxEx = draw.RoundedBoxEx
local SimpleText = draw.SimpleText
local SetDrawColor = surface.SetDrawColor
local DrawRect = surface.DrawRect
local SetMaterial = surface.SetMaterial
local DrawTexturedRectR = surface.DrawTexturedRectRotated
local math_Clamp = math.Clamp
local math_sin = math.sin
local math_cos = math.cos
local math_rad = math.rad
local MouseX = gui.MouseX
local MouseY = gui.MouseY
local DrawPoly = surface.DrawPoly
local NoTexture = draw.NoTexture
local color_white = color_white

local function AnimSpeed()
    return FrameTime() * 7
end

local function DrawCircle(x, y, r, col) -- Thanks to https://github.com/Threebow/tdlib/blob/master/tdlib.lua
    local circle = {}

    for i = 1, 360 do
        circle[i] = {}
        circle[i].x = x + math_cos(math_rad(i * 360)/360) * r
        circle[i].y = y + math_sin(math_rad(i * 360)/360) * r
    end

    SetDrawColor(col)
    NoTexture()
    DrawPoly(circle)
end

local LerpColor = function(from, to)
    local frac = AnimSpeed() * 0.8

    return Color(
        Lerp(frac, from.r, to.r),
        Lerp(frac, from.g, to.g),
        Lerp(frac, from.b, to.b),
        Lerp(frac, from.a, to.a)
    )
end

local Panel = FindMetaTable("Panel")
function Panel:LeyFunction(name, func)
    local OldFunc = self[name]

    self[name] = function(s, ...)
        if (OldFunc) then
            OldFunc(s, ...)
        end

        func(s, ...)
    end
end

function Panel:LeyClearPaint()
    self.Paint = function() end
end

function Panel:LeySetSize(w, h)
    self:SetSize(Scale(w), Scale(h))
end

function Panel:LeySetTall(h)
    self:SetTall(Scale(h))
end

function Panel:LeySetWide(w)
    self:SetWide(Scale(w))
end

function Panel:LeyBackgroundRect(color)
    local color = color || color_white

    self:LeyFunction("Paint", function(s, w, h)
        SetDrawColor(color)
        DrawRect(0, 0, w, h)
    end)
end

function Panel:LeyBackground(color, round)
    local color = color || color_white

    self:LeyFunction("Paint", function(s, w, h)
        RoundedBox(round, 0, 0, w, h, color)
    end)
end

function Panel:LeyBackgroundEx(color, round, topl, topr, botl, botr)
    local topl = topl || false
    local topr = topr || false
    local botl = botl || false
    local botr = botr || false
    local color = color || color_white

    self:LeyFunction("Paint", function(s, w, h)
        RoundedBoxEx(round, 0, 0, w, h, color, topl, topr, botl, botr)
    end)
end

function Panel:LeyCircleClick(color, nfull) -- Used TDLib as a guide here
    local color = color || color_white
    local radius = nfull || 2

    self:LeyFunction("OnMousePressed", function(s)
        s.LeyRadius = 0
        s.LeyAlphaColor = color.a
        s.LeyClickx, s.LeyClicky = s:CursorPos()
    end)

    self.LeyAlphaColor = -1
    self:LeyFunction("PaintOver", function(s, w, h)
        if (s.LeyAlphaColor >= 0) then
            local AnimSpeed = AnimSpeed()

            s.LeyRadius = Lerp(AnimSpeed, s.LeyRadius, (w*1.25)/radius)
            s.LeyAlphaColor = Lerp(AnimSpeed, s.LeyAlphaColor, -1)

            DrawCircle(s.LeyClickx, s.LeyClicky, s.LeyRadius, ColorAlpha(color, s.LeyAlphaColor))
        end
    end)
end

function Panel:LeyHoverText(tcolor, scolor)
    local color = tcolor

    self:LeyFunction("PaintOver", function(s, w, h)
        local IsHovered = s:IsHovered()

        if (IsHovered) then
            color = LerpColor(color, scolor)
        else
            color = LerpColor(color, tcolor)
        end

        s:SetTextColor(color)
    end)
end

function Panel:LeyEnableDragging()
    local parent = self:GetParent()

    if (parent:GetClassName() == "CGModBase") then
        parent = self
    end

    self:LeyFunction("Think", function()
        local w, h = ScrW(), ScrH()

        if (parent.y < 5) then
            parent:SetPos(parent.x, 5)
            parent:InvalidateLayout(true)
        end

        if (parent.x < 5) then
            parent:SetPos(5, parent.y)
            parent:InvalidateLayout(true)
        end

        if (parent.y > h - parent:GetTall() - 5) then
            parent:SetPos(parent.x, h - parent:GetTall() - 5)
            parent:InvalidateLayout(true)
        end

        if (parent.x > w - parent:GetWide() - 5) then
            parent:SetPos(w - parent:GetWide() - 5, parent.y)
            parent:InvalidateLayout(true)
        end

        if (self.Dragging) then
            local mousex = math_Clamp(MouseX(), 1, w - 1)
            local mousey = math_Clamp(MouseY(), 1, h - 1)

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            parent:SetPos(x, y)
            parent:InvalidateLayout(true)
        end

        if (self.Hovered) then
            self:SetCursor("sizeall")
        end
    end)

    self:LeyFunction("OnMousePressed", function()
        self.Dragging = {MouseX() - parent.x, MouseY() - parent.y}
        self:MouseCapture(true)
    end)

    self:LeyFunction("OnMouseReleased", function()
        self.Dragging = nil
        self:MouseCapture(false)
    end)
end

surface.CreateFont("LeyScreenCap.Titles", {font = "Roboto", antialias = true, size = Scale(23), weight = 550})
surface.CreateFont("LeyScreenCap.CloseButton", {font = "Roboto", antialias = true, size = Scale(23), weight = 550})


-- main menu
local PANEL = {}
function PANEL:Init()
    self.Title = ""

    self:SetSize(600, 600)
    self:Center()
    self:MakePopup()
    self:ParentToHUD()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.15, 0)
    self:LeyClearPaint()
    self:LeyBackground(LeyMenusColors.Main, 3)

    self.Header = vgui.Create("DPanel", self)
    self.Header:Dock(TOP)
    self.Header:LeySetTall(42)
    self.Header:LeyClearPaint()
    self.Header:LeyEnableDragging()
    self.Header:LeyBackgroundEx(LeyMenusColors.Secondary, 4, true, true)

    self.Header:LeyFunction("PaintOver", function(s, w, h)
        SimpleText(self.Title, "LeyScreenCap.Titles", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end)

    self.CloseButton = vgui.Create("DButton", self.Header)
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:DockMargin(0, 5, 10, 5)
    self.CloseButton:SetText("X")
    self.CloseButton:SetFont("LeyScreenCap.Buttons")
    self.CloseButton:SetTooltip("Close")
    self.CloseButton:LeySetWide(16)
    self.CloseButton:LeyClearPaint()
    self.CloseButton:LeyCircleClick()
    self.CloseButton:LeyHoverText(color_white, Color(255, 60, 60))

    self.CloseButton:LeyFunction("DoClick", function()
        self:Close()
    end)
end

function PANEL:Close()
    self:OnClose()

    self:AlphaTo(0, 0.15, 0, function()
        self:Remove()
    end)
end

function PANEL:OnClose()
end

function PANEL:SetTitle(str)
    self.Title = str
end
vgui.Register("Ley.Frame", PANEL, "EditablePanel")
end)
