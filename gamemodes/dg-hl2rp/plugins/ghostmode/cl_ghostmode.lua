local range = 1500 ^ 2
local col = Color(182, 252, 237)
local nextVortScan = 0
local plys = {}
local targs = {}
function PLUGIN:PreDrawHalos()
	if not LocalPlayer():GetSyncVar(SYNC_HAL_GHOST, false) then
        return
    end

	if not LocalPlayer():Alive() then
		return
	end

	if nextVortScan < CurTime() then
		local pos = LocalPlayer():GetPos()
		plys = {}
        targs = {}

		for v,k in pairs(player.GetAll()) do
            if not k:Alive() and GHOST_TARG and GHOST_TARG == k then
                GHOST_TARG = nil
            end

			if not k:GetNoDraw() and k.GetPos(k):DistToSqr(pos) < range then
                if GHOST_TARG and GHOST_TARG == k then
                    table.insert(targs, k)
                else
                    table.insert(plys, k)
                end
				
			end
		end

		nextVortScan = CurTime() + 0.1
	end

	halo.Add(plys, col, 5, 5, 1, nil, true)
    halo.Add(targs, Color(255, 0, 0, 255), 8, 8, 5, nil, true)
end

net.Receive("impulseGhostTarget", function()
    GHOST_TARG = net.ReadEntity()

    if GHOST_TARG:EntIndex() == 0 then
        GHOST_TARG = nil
    end
end)

net.Receive("impulseGhostMessage", function()
    local msg = net.ReadString()
    local text = vgui.Create("impulseFadeText")

    function text:Think()
    	local name = msg
	    local nl = string.len(name)
        local crazyName = ""

        for i=1, nl do
            local o = string.sub(name, i, i)
            if math.random(1, 5) == 1 then
                o = string.char(math.random(97, 122))
            end
    
            if math.random(1, 3) == 1 then
                o = string.upper(o)
            end

            crazyName = crazyName..o
        end

        text.text = crazyName
    end

    text:Setup(msg, nil, nil, 1.5, 1.5, 3.5)
end)


function PLUGIN:HUDPaint()
    local tr = LocalPlayer():GetEyeTrace()

    if tr.HitPos and IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity:GetSyncVar(SYNC_HAL_GHOST, false) and tr.Entity:GetNoDraw() == false then
        if (tr.Entity.LastStingerGhost or 0) < CurTime() then
            surface.PlaySound("music/stingers/hl1_stinger_song27.mp3")
            tr.Entity.LastStingerGhost = CurTime() + 100
        end
    end

	if not LocalPlayer():GetSyncVar(SYNC_HAL_GHOST, false) then
        return
    end

	if not LocalPlayer():Alive() then
		return
	end

    local scrW = ScrW()
    local scrH = ScrH()

    local h = scrH * .1

    draw.SimpleText("You are a Ghostly Spirit", "Impulse-Elements36", scrW * .5, h, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText("/gs Ghost message to target | ALT+C (on player) - See options", "Impulse-Elements17", scrW * .5, h + 50, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText("Currently Hunting: "..(IsValid(GHOST_TARG) and GHOST_TARG:Nick() or "No one"), "Impulse-Elements17", scrW * .5, h + 65, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local geeman = {
	["$pp_colour_addr"] = 0.13,
	["$pp_colour_addg"] = 0.06,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.03,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.7,
	["$pp_colour_mulr"] = 1,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 1
}
drawScary = drawScary or false
net.Receive("impulseGhostReality",function()
    drawScary = net.ReadBool()
    RunConsoleCommand("r_shadows",tonumber(not drawScary))
    surface.PlaySound(Sound("ambient/levels/gman/gman_seg_00_01_03.wav"))
    LocalPlayer():ScreenFade(SCREENFADE.IN,color_white,1,0.1)
end)

function PLUGIN:RenderScreenspaceEffects()
    if drawScary then
        DrawColorModify(geeman)
    end
end


function PLUGIN:PrePlayerDraw(ply)
    if drawScary then
        if ply == LocalPlayer() then return false end
        if not ply:GetSyncVar(SYNC_HAL_GHOST,false) and not ply:GetSyncVar(SYNC_HAL_GHOST_TARGET,false) then
            return true
        end
    else
        if ply:GetSyncVar(SYNC_HAL_SCARY,false) then
            return true
        end
        if ply:GetSyncVar(SYNC_HAL_GHOST_VIS,false) and not LocalPlayer():GetSyncVar(SYNC_HAL_GHOST_TARGET,false) then
            return true
        end
    end
    --[[if ply:GetSyncVar(SYNC_HAL_GHOST,false) then
        if not (drawScary) and ply:GetSyncVar(SYNC_HAL_GHOST_VIS,false) then
            return true
        end
    end
    if drawScary and not (ply:GetSyncVar(SYNC_HAL_GHOST,false)) and not (ply == LocalPlayer()) then
        return true
    elseif ply:GetSyncVar(SYNC_HAL_SCARY,false) and not (ply == LocalPlayer()) then
        return true
    end]]
end

function PLUGIN:PreDrawSkyBox()
    if drawScary then
       return true
    end
end