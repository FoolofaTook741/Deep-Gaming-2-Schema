include("shared.lua")

local myFrame
local progbar
local mylabel

local LR = false
local incrementValue = 0.18 

local finished = false 

local reps = 0

surface.CreateFont( "myFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Draw()

    self:DrawModel()

end

function ENT:Initialize()

    --drawFrame()
    
end


hook.Add("Think", "potatoPeelDecay", function()
  if myFrame and myFrame:IsVisible() then
	local frac = progbar:GetFraction()
    if frac > 0 then
      progbar:SetFraction(math.max(0, frac - 0.003 * FrameTime()))
    end
	if((input.IsKeyDown(27) && !input.IsKeyDown(15)) && (LR == false  && finished == false)) then
		LR = true
		progbar:SetFraction(progbar:GetFraction() + incrementValue)
	end
	if((input.IsKeyDown(15) && !input.IsKeyDown(27)) && (LR == true && finished == false)) then
		LR = false 
		progbar:SetFraction(progbar:GetFraction() + incrementValue)
	end
	if(progbar:GetFraction() >= 1 && finished == false) then
		finished = true 
		reps = reps + 1
		mylabel:SetText("Reps: "..reps)
	elseif (progbar:GetFraction() <= 0 && finished == true  ) then
		finished = false                 
	elseif (finished == true ) then
		progbar:SetFraction(progbar:GetFraction() - 0.01)
	end
  end
end)

net.Receive("potatoSignal",function()

    drawFrame()
    myFrame:SetVisible(true)


end)



function drawFrame()

    reps = 0
    LR = false


    local outlineColor = Color(0,0,0)    
    local backgroundColor = Color(59,57,57)

    local labelOutline = Color(0,0,0)
    local labelColor = Color(124,120,120)

    local textColor = Color(0,0,0)


    local frame = vgui.Create("DFrame")
    frame:SetSize( ScrW() * 1200/1920, ScrH() * 800/1080 )
    frame:SetTitle( "Potato Peeler" )
    frame:SetDraggable( false ) 
    frame:Center()
    frame:SetVisible(false )
    frame:MakePopup()
    frame:SetSizable(true)  
    frame:ShowCloseButton(false )
    frame.Paint = function(s , w , h)
    
        draw.RoundedBox(5,0,0,w,h,outlineColor)
        draw.RoundedBox(5,2,2,w-4,h-4,backgroundColor)
    end
    myFrame = frame

    local bar = vgui.Create( "DProgress",frame )
    bar:SetPos( (ScrW()*(3/16)),(ScrH()/8))
    bar:SetSize( (ScrW()/4), 50 )
    bar:SetFraction( 0.0 )
    progbar = bar

    local repCounter = vgui.Create("DLabel",frame)
    repCounter:SetPos((ScrW() * 520/1920),(ScrH() * 270/1080) )
    repCounter:SetText("Reps: "..reps)
    repCounter:SetTextColor(textColor)
    repCounter:SetSize((ScrW() * 200/1920),(ScrH() * 100/1080) )
    repCounter:SetTextInset( 30, 0 )
    repCounter:SetFont("myFont")
    repCounter.Paint = function(s , w , h)
    
        draw.RoundedBox(5,0,0,w,h,labelOutline)
        draw.RoundedBox(5,2,2,w-4,h-4,labelColor)
    end
    mylabel = repCounter

    local qLab = vgui.Create("DLabel",frame)
    qLab:SetPos((ScrW()/8),(ScrH()/8))
    qLab:SetFont("myFont")
    qLab:SetText("Q")
    qLab:SetSize((ScrW()/24),(ScrH()/24))
    qLab:SetTextColor(textColor)
    qLab:SetTextInset((ScrW()/64), 0 )
    qLab.Paint = function(s , w , h)
    
        draw.RoundedBox(5,0,0,w,h,labelOutline)
        draw.RoundedBox(5,2,2,w-4,h-4,labelColor)
    end

    local eLab = vgui.Create("DLabel",frame)
    eLab:SetPos((ScrW()*(29/64)),(ScrH()/8))
    eLab:SetFont("myFont")
    eLab:SetText("E")
    eLab:SetSize((ScrW()/24),(ScrH()/24))
    eLab:SetTextColor(textColor)
    eLab:SetTextInset((ScrW()/64), 0 )
    eLab.Paint = function(s , w , h)
    
        draw.RoundedBox(5,0,0,w,h,labelOutline)
        draw.RoundedBox(5,2,2,w-4,h-4,labelColor)
    end

    local finButton = vgui.Create("DButton",frame)
    finButton:SetPos((ScrW() * (18/64)),(ScrH() * (3/8)) )
    finButton:SetSize((ScrW() * (1/12)),(ScrH() * (1/12)) )
    finButton:SetText("Finish")
    finButton:SetFont("myFont")
    finButton.Paint = function(s , w , h)
    
        draw.RoundedBox(5,0,0,w,h,labelOutline)
        draw.RoundedBox(5,2,2,w-4,h-4,labelColor)
    end
    finButton.DoClick = function()
        net.Start("potatoesPeeled")
            net.WriteInt(reps,32)
        net.SendToServer()
        frame:Close()
    end

end
