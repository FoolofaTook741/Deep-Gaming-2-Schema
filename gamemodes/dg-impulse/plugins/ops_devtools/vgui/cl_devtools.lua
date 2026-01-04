local PANEL = {}

function PANEL:OnTargetChange()
    --self.XP:SetText("XP: "..(self.Target.Player and self.Target.Player:GetXP() or "[NO TARGET]"))
end

language.Add("dv.notarg","Please select a target before attempting to issue commands!")

function PANEL:SetupChangelog()
    return -- i use external program now :)
end

function PANEL:SetupPlayers()
    if not LocalPlayer():IsSuperAdmin() then return self:Remove() end
    if not self.Tools then return LocalPlayer():Notify("If you see this, yell at nick.") end

    self.Players = vgui.Create("DScrollPanel",self.Tools,"opsDevPlayers")
    self.Players:DockMargin(25,25,25,25)
    self.Players:Dock(FILL)
    
    for Team=1,#impulse.Teams.Data do
        for v,k in ipairs(team.GetPlayers(Team)) do
            local plyBtn = vgui.Create("DButton",self.Players)
            plyBtn:SetText("")
            plyBtn.Player = k
            plyBtn.Text   = k:Name() .. " (" .. k:SteamName() .. ") (" .. k:SteamID() .. ")"
            plyBtn.Paint = function(btn,w,h)
                draw.RoundedBox(2,0,0,w,h,Color(40,40,40,180))
                draw.SimpleText(btn.Text,"Impulse-Elements20A-Shadow",10,10,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
                local teamText = IsValid(btn.Player) and team.GetName(btn.Player:Team()) or "DISCONNECTED"
                local teamColor = IsValid(btn.Player) and team.GetColor(btn.Player:Team()) or Color(255,0,0) 
                draw.SimpleText(teamText,"Impulse-Elements20-Shadow",10,30,teamColor)
            end
            plyBtn.DoClick = function(btn)
                if not IsValid(btn.Player) then
                    LocalPlayer():Notify("PLAYER HAS DISCONNECTED!")
                    return
                end
                self.Target.Player = btn.Player
                self.Target:SetText("Target: " .. btn.Player:Name() .. " (" .. btn.Player:SteamName() .. ") (" .. btn.Player:SteamID() .. ")")
                self:OnTargetChange()
                LocalPlayer():Notify("Target Set to: " .. btn.Player:SteamName())
            end
            plyBtn:SetTall(55)
            plyBtn:Dock(TOP)
            self.Players:AddItem(plyBtn)
        end
    end

    self.Tools:AddSheet("Players",self.Players,"icon16/group.png")
end

function PANEL:SetupItems()
    if not LocalPlayer():IsSuperAdmin() then return self:Remove() end
    if not self.Tools then return LocalPlayer():Notify("If you see this, yell at nick.") end

    self.Items = vgui.Create("DScrollPanel",self.Tools,"opsDevPlayers")
    self.Items:DockMargin(25,25,25,25)
    self.Items:Dock(FILL)

    local cats = {}

    for v,k in pairs(impulse.Inventory.Items) do
        if not cats[k.Category or "Unknown"] then 
            local cat = self.Items:Add("DCollapsibleCategory")
            cat:Dock(TOP)
            cat:SetLabel(k.Category or "Unknown")
            cat:SetExpanded(false)
            
            cats[k.Category or "Unknown"] = vgui.Create("DPanelList", panel)
            local list =  cats[k.Category or "Unknown"]
            list:Dock(FILL)
            list:SetSpacing(5)
            cat:SetContents(list)
        end

        local btn = vgui.Create("DButton")
        btn:SetText("  "..k.Name.." ("..k.UniqueID..")")
        btn:SetContentAlignment(4)
        btn:Dock(TOP)
        btn:SetFont("Impulse-Elements18")
        btn:DockMargin(0, 0, 0, 5)
        btn.ItemClass = k.UniqueID

        btn.DoClick = function(btn)
            if not IsValid(self.Target.Player) then return LocalPlayer():Notify("Please select a target before attempting to issue commands!") end
            Derma_StringRequest("ops!!!","ENTER THE AMOUNT","1",function(str)
                net.Start("opsDevGiveItem")
                net.WriteEntity(self.Target.Player)
                net.WriteString(btn.ItemClass)
                net.WriteInt(tonumber(str or 1), 32)
                net.SendToServer()
            end)
            
        end

        cats[k.Category or "Unknown"]:AddItem(btn)
    end

    self.Tools:AddSheet("Items",self.Items,"icon16/bricks.png")
end

function PANEL:SetupData()
    if not LocalPlayer():IsSuperAdmin() then return self:Remove() end
    if not self.Tools then return LocalPlayer():Notify("If you see this, yell at nick.") end

    self.Data = vgui.Create("DPanel",self.Tools,"opsDevData")
    self.Data:SetPaintBackground(false)
    self.Data:DockMargin(25,25,25,25)
    self.Data:Dock(FILL)

    self.HowTo = vgui.Create("DCollapsibleCategory",self.Data,"opsDevDataHowto")
    self.HowTo:SetLabel("Badges")
    --self.HowTo:SetFont("Impulse-Elements23-Shadow")
    self.HowTo:Dock(TOP)

    self.MakeTester = self.HowTo:Add("Give Tester Badge")
    self.MakeTester:SetContentAlignment(4)
    self.MakeTester:SetTextColor(color_white)
    self.MakeTester.Paint = function() end
    self.MakeTester:SetFont("Impulse-Elements18-Shadow")
    self.MakeTester:Dock(TOP)
    self.MakeTester.DoClick = function()
        if not self.Target.Player then return LocalPlayer():Notify("Please select a target before attempting to issue commands!") end
        net.Start("opsDevSetTester")
        net.WriteEntity(self.Target.Player or nil)
        net.WriteBool(true) -- give or revoke
        net.SendToServer()
    end
    
    self.rMakeTester = self.HowTo:Add("Revoke Tester Badge")
    self.rMakeTester:SetContentAlignment(4)
    self.rMakeTester:SetTextColor(color_white)
    self.rMakeTester.Paint = function() end
    self.rMakeTester:SetFont("Impulse-Elements18-Shadow")
    self.rMakeTester:Dock(TOP)
    self.rMakeTester.DoClick = function()
        if not self.Target.Player then return LocalPlayer():Notify("Please select a target before attempting to issue commands!") end
        net.Start("opsDevSetTester")
        net.WriteEntity(self.Target.Player or nil)
        net.WriteBool(false) -- give or revoke
        net.SendToServer()
    end

    self.et = self.HowTo:Add("Give Event Team Badge")
    self.et:SetContentAlignment(4)
    self.et:SetTextColor(color_white)
    --self.et:SetText()
    self.et.Paint = function() end
    self.et:SetFont("Impulse-Elements18-Shadow")
    self.et:Dock(TOP)
    self.et.DoClick = function()
        if not self.Target.Player then return LocalPlayer():Notify("Please select a target before attempting to issue commands!") end
        net.Start("opsDevSetET")
        net.WriteEntity(self.Target.Player or nil)
        net.WriteBool(true) -- give or revoke
        net.SendToServer()
    end
    self.ret = self.HowTo:Add("Revoke Event Team Badge")
    self.ret:SetTextColor(color_white)
    self.ret:SetContentAlignment(4)
    self.ret.Paint = function() end
    self.ret:SetFont("Impulse-Elements18-Shadow")
    self.ret:Dock(TOP)
    self.ret.DoClick = function()
        if not self.Target.Player then return LocalPlayer():Notify("Please select a target before attempting to issue commands!") end
        net.Start("opsDevSetET")
        net.WriteEntity(self.Target.Player or nil)
        net.WriteBool(false) -- give or revoke
        net.SendToServer()
    end

    local achievement = vgui.Create("DCollapsibleCategory",self.Data,"opsDevAchievements")
    achievement:Dock(TOP)
    achievement:SetLabel("Achievements")
    for v,k in pairs(impulse.Config.Achievements) do
        local panel = achievement:Add( k.Name .. " (" .. v .. ")")
        panel:SetTextColor(color_white)
        panel.achID = v
        panel.Paint = function() end
        panel:SetFont("Impulse-Elements18-Shadow")
        panel.DoClick = function()
            Derma_Query("the lord giveth and the lord taketh","ops dev tools","Giveth", function()
                net.Start("opsDevDoAction")
                net.WriteString("add_ach")
                net.WriteTable({self.Target.Player,panel.achID})
                net.SendToServer()
            end,"Taketh",function()
                net.Start("opsDevDoAction")
                net.WriteString("del_ach")
                net.WriteTable({self.Target.Player,panel.achID})
                net.SendToServer()
            end,"Cancel",function()
            end)
        end
    end
    achievement:SetExpanded(false)

    self.Tools:AddSheet("Data",self.Data,"icon16/database_gear.png")
end

-- icon16/emoticon_evilgrin.png
function PANEL:SetupFun()
    if not LocalPlayer():IsSuperAdmin() then return self:Remove() end
    if not self.Tools then return LocalPlayer():Notify("If you see this, yell at nick.") end

    self.Fun = vgui.Create("DScrollPanel",self.Tools,"opsDevFun")
    self.Fun:SetPaintBackground(false)
    self.Fun:DockMargin(25,25,25,25)
    self.Fun:Dock(FILL)

    self.Global = self.Fun:Add("DCollapsibleCategory")
    self.Global:SetLabel("Global")
    self.Global:SetExpanded(false)
    self.Global:Dock(TOP)

    self.OwOOC = vgui.Create("DButton",self.Global,"opsDevOwOifyOn")
    self.OwOOC:SetPaintBackground(false)
    self.OwOOC:SetText("Toggle Furry Speak OOC")
    self.OwOOC:SetFont("Impulse-Elements18-Shadow")
    self.OwOOC:Dock(TOP)
    self.OwOOC.DoClick = function()
        net.Start("OwOifyOn")
        net.SendToServer()
    end

    self.Local = self.Fun:Add("DCollapsibleCategory")
    self.Local:SetLabel("Local (Affects Target)")
    self.Local:SetExpanded(false)
    self.Local:Dock(TOP)

    self.Say = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.Say:SetPaintBackground(false)
    self.Say:SetText("Force Say")
    self.Say.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops dev forcesay","Enter the message:","",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevForceSay")
                net.WriteEntity(self.Target.Player)
                net.WriteString(str)
            net.SendToServer()
        end)
    end
    self.Say:SetFont("Impulse-Elements18-Shadow")
    self.Say:Dock(TOP)

    self.Notify = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.Notify:SetPaintBackground(false)
    self.Notify:SetText("Notify")
    self.Notify.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops dev notify","Enter the notification:","",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevNotify")
                net.WriteEntity(self.Target.Player)
                net.WriteString(str)
            net.SendToServer()
        end)
    end
    self.Notify:SetFont("Impulse-Elements18-Shadow")
    self.Notify:Dock(TOP)

    self.Scale = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.Scale:SetPaintBackground(false)
    self.Scale:SetText("SCale")
    self.Scale.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops dev SCLAE","Enter the SCALE:","",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevDoAction")
            net.WriteString("set_modelscale")
            net.WriteTable({self.Target.Player,tonumber(str)})
            net.SendToServer()
        end)
    end
    self.Scale:SetFont("Impulse-Elements18-Shadow")
    self.Scale:Dock(TOP)

    self.GiveMoney = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.GiveMoney:SetPaintBackground(false)
    self.GiveMoney:SetText("Give Money")
    self.GiveMoney.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops","Enter the amount to give:","0",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevDoAction")
            net.WriteString("add_money")
            net.WriteTable({self.Target.Player,tonumber(str)})
            net.SendToServer()
        end)
    end
    self.GiveMoney:SetFont("Impulse-Elements18-Shadow")
    self.GiveMoney:Dock(TOP)

    self.SetRPName = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.SetRPName:SetPaintBackground(false)
    self.SetRPName:SetText("Set RP Name (Do not save)")
    self.SetRPName.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops","Enter the name to set:","Johnathan Doe",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevDoAction")
            net.WriteString("set_rpname")
            net.WriteTable({self.Target.Player,str})
            net.SendToServer()
        end)
    end
    self.SetRPName:SetFont("Impulse-Elements18-Shadow")
    self.SetRPName:Dock(TOP)

    self.SetRPNameSave = vgui.Create("DButton",self.Local,"opsDevForceSay")
    self.SetRPNameSave:SetPaintBackground(false)
    self.SetRPNameSave:SetText("Set RP Name (Save)")
    self.SetRPNameSave.DoClick = function()
        if not IsValid(self.Target.Player) then
            LocalPlayer():Notify("Please select a target before attempting to issue commands!")
            return
        end

        Derma_StringRequest("ops","Enter the name to set:","Johnathan Doe",function(str)
            if (not str) or (str == "") then return end
            net.Start("opsDevDoAction")
            net.WriteString("set_rpname_save")
            net.WriteTable({self.Target.Player,str})
            net.SendToServer()
        end)
    end
    self.SetRPNameSave:SetFont("Impulse-Elements18-Shadow")
    self.SetRPNameSave:Dock(TOP)

    self.Tools:AddSheet("Fun",self.Fun,"icon16/emoticon_evilgrin.png")
end

function PANEL:Init()

    local lp = LocalPlayer()

    if not lp then
        self:Remove()
        return
    end

    if not lp:IsSuperAdmin() and not lp:IsDeveloper() then
        self:Remove()
        return lp:Notify("This tool is for superadmins and developers only!")
    end

    self:SetSize(1200,900)
    self:Center()
    self:SetTitle("ops dev tools")
    self:MakePopup()
    self:SetIcon("icon16/cog_edit.png")

    self.Target = vgui.Create("DLabel",self,"opsDevTarget")
    self.Target:SetText("Target: None")
    self.Target:SetFont("Impulse-Elements23-Shadow")
    self.Target:SetPos(50,45)
    self.Target:SetSize(1100,self.Target:GetTall())

    self.Target.Player = nil

    self.Tools = vgui.Create("DPropertySheet",self,"opsDevTools")
    self.Tools:DockMargin(50,50,50,50)
    self.Tools:Dock(FILL)

    self:SetupPlayers()
    self:SetupItems()
    self:SetupData()
    self:SetupFun()
    self:SetupChangelog()

    hook.Run("SetupDeveloperTools",self)

end

vgui.Register("impulseOpsDevTools",PANEL,"DFrame")