if CLIENT then
    QuizFrame = nil

    net.Receive("dgQuizOpen", function()
        print("received dgQuizOpen")
        local team = net.ReadUInt(8)
        QuizFrame = vgui.Create("dgQuiz")
        QuizFrame:SetTeam(team)
    end)

    net.Receive("dgQuizData", function()
        local team = net.ReadUInt(8)
        local quizData = net.ReadTable()
        if IsValid(QuizFrame) then
            QuizFrame:SetQuiz(quizData, team)
        end
    end)
end

local PANEL = {}

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self.darkOverlay or Color(50,50,50,220))
end

function PANEL:Init()
    self:SetSize(600, 480)
    self:Center()
    self:SetTitle("Team Quiz")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:MakePopup()

    self.darkOverlay = Color(50, 50, 50, 220)
    
    self.header = vgui.Create("DPanel", self)
    self.header:Dock(TOP)
    self.header:SetTall(50)
    function self.header:Paint(w, h)
        w = w or self:GetWide()
        h = h or self:GetTall()
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 30, 255))
        draw.SimpleText("Team Competency Quiz", "Impulse-Elements20-Shadow", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.info = vgui.Create("DLabel", self)
    self.info:SetFont("Impulse-Elements14")
    self.info:SetText("Before you can join this team, you must pass a competency quiz.\nComplete each question. If you fail, you'll have to wait " .. impulse.Config.QuizWaitTime .. " minutes to retry.\nDo not ask for answers or cheat.")
    self.info:Dock(TOP)
    self.info:DockMargin(10, 10, 10, 10)
    self.info:SetWrap(true)
    self.info:SetAutoStretchVertical(true)

    self.questionPanel = vgui.Create("DPanel", self)
    self.questionPanel:Dock(FILL)
    self.questionPanel:DockMargin(10, 0, 10, 10)
    self.questionPanel:SetPaintBackground(false)

    self.navPanel = vgui.Create("DPanel", self)
    self.navPanel:Dock(BOTTOM)
    self.navPanel:SetTall(40)
    self.navPanel:DockMargin(10, 10, 10, 10)
    function self.navPanel:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40, 220))
    end
	
	self.handbookBtn = vgui.Create("DButton", self.navPanel)
	self.handbookBtn:SetText("Open Handbook")
	self.handbookBtn:SetFont("Impulse-Elements16")
	self.handbookBtn:Dock(LEFT)
	self.handbookBtn:DockMargin(5, 5, 5, 5)
	self.handbookBtn:SetWide(130)
	function self.handbookBtn:DoClick()
		local quizPanel = self:GetParent():GetParent()
		local handbookURL = quizPanel.handbook or ""
		if handbookURL == "" then
			chat.AddText("No handbook available.")
		else
			gui.OpenURL(handbookURL)
		end
	end

    self.selections = {}
    self.currentQuestion = 1
    self.quizData = nil
end

function PANEL:SetTeam(team)
    self.TeamID = team
    net.Start("dgQuizRequest")
	net.WriteUInt(team, 8)
    net.SendToServer()
end

function PANEL:SetQuiz(quizData, team)
    self.TeamID = team
    self.quizData = quizData.questions
    self.handbook = quizData.handbook or ""
    self.selections = {}
    self.currentQuestion = 1

    self:ShowQuestion(1)
    self:UpdateNavigation()
end

function PANEL:ShowQuestion(index)
    if not self.quizData or #self.quizData < index then return end

    self.questionPanel:Clear()
    local question = self.quizData[index]
    self.currentQuestion = index

    local qp = self.questionPanel

    local bg = vgui.Create("DPanel", qp)
    bg:Dock(FILL)
    bg:DockMargin(5, 5, 5, 5)
    bg.MainPanel = self
    function bg:Paint(w, h)
        local borderThickness = 2
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 30, 255))
    end

    local textContainer = vgui.Create("DPanel", bg)
    textContainer:Dock(FILL)
    textContainer:DockMargin(10, 10, 10, 5)
    textContainer:SetPaintBackground(false)

    local qLabel = vgui.Create("DLabel", textContainer)
    qLabel:SetText(question.question)
    qLabel:SetFont("Impulse-Elements18")
    qLabel:Dock(TOP)
    qLabel:SetWrap(true)
    qLabel:SetAutoStretchVertical(true)
    qLabel:SizeToContentsY()

    local answerbox = vgui.Create("DComboBox", bg)
    answerbox:Dock(BOTTOM)
    answerbox:DockMargin(10, 5, 10, 10)
    answerbox:SetValue("Select answer...")
    answerbox.QuestionID = question.id

    for i, answerText in ipairs(question.answers) do
        answerbox:AddChoice(answerText)
    end

    if self.selections[question.id] then
        local selIndex = self.selections[question.id]
        local selText = question.answers[selIndex]
        if selText then
            answerbox:SetValue(selText)
        end
    end

    function answerbox:OnSelect(index, value, data)
        self:GetParent().MainPanel.selections[self.QuestionID] = index
        self:GetParent().MainPanel:UpdateNavigation()
    end
end


function PANEL:UpdateNavigation()
    self.navPanel:Clear()

    -- Re-add the Handbook Button each time
    local handbookBtn = vgui.Create("DButton", self.navPanel)
    handbookBtn:SetText("Open Handbook")
    handbookBtn:SetFont("Impulse-Elements16")
    handbookBtn:Dock(LEFT)
    handbookBtn:DockMargin(5, 5, 5, 5)
    handbookBtn:SetWide(130)
    function handbookBtn:DoClick()
        local quizPanel = self:GetParent():GetParent()
        local handbookURL = quizPanel.handbook or ""
        if handbookURL == "" then
            chat.AddText("No handbook available.")
        else
            gui.OpenURL(handbookURL)
        end
    end

    -- (Rest of your navigation code below remains unchanged.)
    local total = #self.quizData
    local current = self.currentQuestion

    local prevBtn = vgui.Create("DButton", self.navPanel)
    prevBtn:SetText("Previous")
    prevBtn:SetFont("Impulse-Elements16")
    prevBtn:Dock(LEFT)
    prevBtn:DockMargin(5, 5, 5, 5)
    prevBtn:SetWide(130)
    if current == 1 then
        prevBtn:SetDisabled(true)
    else
        prevBtn:SetDisabled(false)
        function prevBtn:DoClick()
            self:GetParent():GetParent():ShowQuestion(current - 1)
            self:GetParent():GetParent():UpdateNavigation()
        end
    end

    local nextBtn = vgui.Create("DButton", self.navPanel)
    if current < total then
        nextBtn:SetText("Next")
    else
        nextBtn:SetText("Complete Quiz")
    end
    nextBtn:SetFont("Impulse-Elements16")
    nextBtn:Dock(RIGHT)
    nextBtn:DockMargin(5, 5, 10, 5)
    nextBtn:SetWide(130)
    local answerGiven = self.selections[self.quizData[current].id] ~= nil
    nextBtn:SetDisabled(not answerGiven)
    function nextBtn:DoClick()
        local parent = self:GetParent():GetParent()
        if parent.currentQuestion < #parent.quizData then
            parent:ShowQuestion(parent.currentQuestion + 1)
            parent:UpdateNavigation()
        else
            net.Start("dgQuizSubmit")
            net.WriteUInt(parent.TeamID, 8)
            net.WriteTable(parent.selections)
            net.SendToServer()
            parent:Remove()
        end
    end

    local exitBtn = vgui.Create("DButton", self.navPanel)
    exitBtn:SetText("Exit Quiz")
    exitBtn:SetFont("Impulse-Elements16")
    exitBtn:Dock(RIGHT)
    exitBtn:DockMargin(5, 5, 10, 5)
    exitBtn:SetWide(130)
    function exitBtn:DoClick()
        net.Start("dgQuizSubmit")
        net.WriteUInt(self:GetParent():GetParent().TeamID, 8)
        net.WriteTable({ exit = true })
        net.SendToServer()
        LocalPlayer().quizzing = false
        self:GetParent():GetParent():Remove()
    end
end


function PANEL:Think()
    if not LocalPlayer():Alive() then
        self:Remove()
    end
end

vgui.Register("dgQuiz", PANEL, "DFrame")
