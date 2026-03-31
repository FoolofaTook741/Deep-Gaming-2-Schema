/*
** Copyright (c) 2017 Jake Green (TheVingard)
** This file is private and may not be shared, downloaded, used or sold.
*/

impulse.hudEnabled = impulse.hudEnabled or true

local hidden = {}
hidden["CHudHealth"] = true
hidden["CHudBattery"] = true
hidden["CHudAmmo"] = true
hidden["CHudSecondaryAmmo"] = true
hidden["CHudCrosshair"] = true
hidden["CHudHistoryResource"] = true
hidden["CHudDeathNotice"] = true

function GM:HUDShouldDraw(element)
	if (hidden[element]) then
		return false
	end
	return true
end

local blur = Material("pp/blurscreen")
local cheapBlur = Color(0,0,0,205)
local function BlurRect(x, y, w, h)
	if not impulse.GetSetting("perf_blur") then
		draw.RoundedBox(0,x,y,w,h, cheapBlur)
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(x,y,w,h)
	else
		local X, Y = 0,0

		surface.SetDrawColor(color_white)
		surface.SetMaterial(blur)

		for i = 1, 2 do
			blur:SetFloat("$blur", (i / 10) * 20)
			blur:Recompute()

			render.UpdateScreenEffectTexture()

			render.SetScissorRect(x, y, x+w, y+h, true)
			surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end
end

local vignette = Material("mrp/menu_stuff/vignette.png")
local vig_alpha_normal = Color(255,255,255,255)
local lasthealth
local time = 0
local zoneLbl
local gradient = Material("vgui/gradient-l")
local watermark = Material("deep/dg_rounded.png")
local watermarkCol = Color(255,255,255,120)
local fde = 0
local hudBlackGrad = Color(40,40,40,180)
local hudBlack = Color(20,20,20,140)
local darkCol = Color(30, 30, 30, 190)
local whiteCol = Color(255, 255, 255, 255)
local iconsWhiteCol = Color(255, 255, 255, 220)
local bleedFlashCol = Color(230, 0, 0, 220)
local painCol = Color(255,10,10,80)
local crosshairGap = 5
local crosshairLength = crosshairGap + 5
local healthIcon = Material("impulse/icons/heart-128.png")
local healthCol = Color(210, 0, 0, 255)
local armourIcon = Material("impulse/icons/shield-128.png")
local armourCol = Color(205, 190, 0, 255)
local hungerIcon = Material("impulse/icons/bread-128.png")
local hungerCol = Color(205, 133, 63, 255)
local moneyIcon = Material("impulse/icons/banknotes-128.png")
local moneyCol = Color(133, 227, 91, 255)
local timeIcon = Material("impulse/icons/clock-128.png")
local xpIcon = Material("impulse/icons/star-128.png")
local warningIcon = Material("impulse/icons/warning-128.png")
local infoIcon = Material("impulse/icons/info-128.png")
local announcementIcon = Material("impulse/icons/megaphone-128.png")
local exitIcon = Material("impulse/icons/exit-128.png")
local bleedingIcon = Material("impulse/icons/droplet-256.png")
local medicicon = Material("materials/dghud/medical-pack.png")

local dgh_dbb = Color(0, 0, 0, 150)
local dgh_outlinecolor = Color(225,225,225,150)
local dgh_smallteams = {"Citizen", "C.W.", "M.P.F.", "C.T.A.", "O.C.A.", "Vortigaunt", "Zombie", "Stalker"}
local dgh_mediclogo = Material("materials/dghud/medical-pack.png")
local dgh_hpcol = Color(255, 100, 100, 225)
local dgh_armorlogo = Material("dghud/kevlar-vest.png")
local dgh_teamlogo = Material("dghud/person.png")
local dgh_foodlogo = Material("dghud/fork-knife-spoon.png")
local dgh_hungcol = Color(255, 110, 75, 255)
local dgh_moneylogo = Material("dghud/money-stack.png")
local dgh_moneycol = Color(75, 150, 75, 255)
local dgh_propslogo = Material("dghud/hammer-nails.png")
local dgh_propscol = Color(126, 80, 50, 255)
local dgh_ammologo = Material("dghud/ammo-box.png")
local dgh_xplogo = Material("dghud/sergeant.png")
local dgh_xpcol = Color(50, 50, 150, 255)
local dgh_zonelogo = Material("dghud/position-marker.png")
local dgh_imprisonedlogo = Material("dghud/handuffs.png")
local blank = ""
local function thirdPersonEnabled()
	if impulse.GetSetting("view_thirdperson") == "Enabled" then
		return true
	end
end

local gladient = Material("vgui/gradient-l")

local gradient = Material("vgui/gradient-r")

local flr, interp = math.floor, Lerp

local lastModel = ""
local lastSkin = ""
local lastTeam = 99
local lastBodygroups = {}
local iconLoaded = false

local painFt
local painFde = 1

local bleedFlash = false
local hotPink = Color(148, 0, 211)

local function DrawOverheadInfo(target, alpha)
	local pos = target:EyePos()

	pos.z = pos.z + 5
	pos = pos:ToScreen()
	pos.y = pos.y - 50

	local myGroup = LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil)
	local group = target:GetSyncVar(SYNC_GROUP_NAME, nil)
	local rank = target:GetSyncVar(SYNC_GROUP_RANK, nil)
	local col = ColorAlpha(team.GetColor(target:Team()), alpha)

	if myGroup and not LocalPlayer():IsCP() and not target:IsCP() and group and rank and group == myGroup then
		if impulse.GetSetting("hudselection") == "Deep - Standard" then
			draw.DrawText(group.." - "..rank, "Oswald22", pos.x, pos.y - 15, ColorAlpha(hotPink, alpha), 1)
		else
			draw.DrawText(group.." - "..rank, "Impulse-Elements16-Shadow", pos.x, pos.y - 15, ColorAlpha(hotPink, alpha), 1)
		end
	end

	if impulse.GetSetting("hudselection") == "Deep - Standard" then
		draw.DrawText(target:KnownName(), "Oswald28", pos.x, pos.y, col, 1)
	else
		draw.DrawText(target:KnownName(), "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	end
	if impulse.GetSetting("hudselection") == "Deep - Standard" then
		if target:GetSyncVar(SYNC_TYPING, false) then
			draw.DrawText("Speaking...", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_STUNNED, false) then
			draw.DrawText("*STUNNED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_FLASHED, false) then
			draw.DrawText("*BLINDED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_GASSED, false) then
			draw.DrawText("*GASSED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_BROKENLEGS, false) then
			draw.DrawText("*CRIPPLED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_WOUNDED, false) then
			draw.DrawText("*WOUNDED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif (target:GetSyncVar(SYNC_ARRESTED, false) and LocalPlayer():CanArrest(target)) or target:GetSyncVar(SYNC_CUFFED, false) then
			draw.DrawText("*RESTRAINED*", "Oswald18", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:Health() < 80 then
			local text, color = target:GetKnownHealth()
			draw.DrawText(text, "Oswald18", pos.x-25, pos.y + 15, color)
		end
	else
		if target:GetSyncVar(SYNC_TYPING, false) then
			draw.DrawText("Speaking...", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_STUNNED, false) then
			draw.DrawText("*STUNNED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_FLASHED, false) then
			draw.DrawText("*BLINDED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_GASSED, false) then
			draw.DrawText("*GASSED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_BROKENLEGS, false) then
			draw.DrawText("*CRIPPLED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:GetSyncVar(SYNC_WOUNDED, false) then
			draw.DrawText("*WOUNDED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif (target:GetSyncVar(SYNC_ARRESTED, false) and LocalPlayer():CanArrest(target)) or target:GetSyncVar(SYNC_CUFFED, false) then
			draw.DrawText("*RESTRAINED*", "Impulse-Elements16-Shadow", pos.x, pos.y + 15, ColorAlpha(color_white, alpha), 1)
		elseif target:Health() < 80 then
			local text, color = target:GetKnownHealth()
			draw.DrawText(text, "Impulse-Elements16-Shadow", pos.x, pos.y + 15, color, TEXT_ALIGN_CENTER)
		end
	end
end

local function DrawDoorInfo(target, alpha)
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local doorOwners = target:GetSyncVar(SYNC_DOOR_OWNERS, nil)
	local doorName = target:GetSyncVar(SYNC_DOOR_NAME, nil)
	local doorGroup =  target:GetSyncVar(SYNC_DOOR_GROUP, nil)
	local doorBuyable = target:GetSyncVar(SYNC_DOOR_BUYABLE, nil)
	local col = ColorAlpha(impulse.Config.MainColour, alpha)

	if doorName then
		draw.DrawText(doorName, "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	elseif doorGroup then
		draw.DrawText(impulse.Config.DoorGroups[doorGroup], "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	elseif doorOwners then
		local ownedBy
		if #doorOwners > 1 then
			ownedBy = "Owners:"
		else
			ownedBy = "Owner:"
		end

		for v,k in pairs(doorOwners) do
			local owner = Entity(k)

			if IsValid(owner) and owner:IsPlayer() then
				ownedBy = ownedBy.."\n"..owner:Name()
			end
		end
		draw.DrawText(ownedBy, "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	end

	if LocalPlayer():CanBuyDoor(doorOwners, doorBuyable) then
		draw.DrawText("Ownable door (F2)", "Impulse-Elements18-Shadow", pos.x, pos.y, col, 1)
	end
end




hook.Add( "PlayerBindPress", "Pinecrest.HUD.Inspect", function( ply, bind, pressed, code )
    if code ~= KEY_F then
        return
    end

    local tr = ply:GetEyeTrace()
	if tr.Entity.Inspected then return end

    tr.Entity.Inspected = true
	tr.Entity.overheadAlpha = 2
    return true
end )


local entities_you_CANNOT_fucking_use = {
	["deep_spawnforcefield"] = true,
	["impulse_hl2rp_laundryfoldingtable"] = true,
	["impulse_hl2rp_laundryendbasket"] = true,
	["impulse_hl2rp_scanner"] = true,
	["impulse_hl2rp_vendingmachine"] = true,
	["impulse_hl2rp_vendingmachine"] = true,
}

local len = 180
local colorWhite = Color( 215, 215, 215 )

local function DrawEntInfo( target, alpha )
	if entities_you_CANNOT_fucking_use[target:GetClass()] then return end

	local angs = LocalPlayer():EyeAngles()
	angs.r = 0
	angs.p = 0

	local wcenter = target:LocalToWorld(target:OBBCenter())
	local sfinal = wcenter:ToScreen()

	local frac = alpha / 255
	local size = math.ease.OutQuart(frac) * 12
	local colorCenter = ColorAlpha(darkCol, frac * 220)
	local colorWhite = ColorAlpha(colorWhite, alpha)
	local black = ColorAlpha(color_black, alpha)

	surface.SetDrawColor(colorCenter)
	surface.DrawRect(sfinal.x - 16, sfinal.y - 16, 32, 32)

	surface.DrawOutlinedRect(sfinal.x - 16, sfinal.y - 16, 32, 32, 2)

	draw.SimpleText(
		"E",
		"Impulse-Elements22-Shadow",
		sfinal.x,
		sfinal.y,
		colorWhite,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
	)

	local text = "Interact"

	if target.Inspected then
		text = target.HUDName or ""
		local desc = target.HUDDesc or ""
		
		if #desc > 55 then
			desc = string.Trim(string.Left(desc, 69)) .. "..."
		end

		draw.SimpleTextOutlined(
			desc,
			"Impulse-Elements20-Shadow",
			sfinal.x, sfinal.y + size + 20,
			colorWhite,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_TOP,
			1, colorCenter
		)
	else
		local scrw = ScrW()
		local scrh = ScrH()

		local labelX = (scrw / 2) + 24
		local labelY = scrh - 128 + 24
		local boxX = labelX - 58 - 58
		local boxY = labelY - 24
		local keyX = boxX + 24
		local keyY = boxY + 24

		local black = ColorAlpha(color_black, alpha)
		local boxCol = ColorAlpha(darkCol, math.min(alpha, 190))

		draw.RoundedBox(4, boxX, boxY, 48, 48, boxCol)

		draw.SimpleText("Inspect", "Impulse-Elements32-Shadow", labelX + 1, labelY + 1, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Inspect", "Impulse-Elements32-Shadow", labelX, labelY, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("F", "Impulse-CharacterInfo-NO", keyX, keyY, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	draw.SimpleTextOutlined(
		text,
		"Impulse-Elements22-Shadow",
		sfinal.x, sfinal.y + size,
		colorWhite,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_TOP,
		2, colorCenter
	)
end


local function _drawItemInfo( target, alpha )
	local pos = target:LocalToWorld(target:OBBCenter())

	pos.z = pos.z
	pos = pos:ToScreen()

    local frac = alpha / 255
    local colorCenter = ColorAlpha( darkCol, frac * 220 )
	local colorWhite = ColorAlpha( colorWhite, alpha )

    local size = math.ease.OutQuart( frac ) * 18

	surface.SetDrawColor( colorWhite )
	surface.DrawLine( pos.x, pos.y, pos.x, pos.y - len + 40 )

	surface.DrawOutlinedRect( pos.x - 16, pos.y - len - 16, 32, 32, 2 )

	surface.SetDrawColor( colorCenter )
	surface.DrawRect( pos.x - 16, pos.y - len - 16, 32, 32 )

    draw.SimpleText(
		"E",
		"Impulse-Elements22-Shadow",
		pos.x, pos.y - len,
		colorWhite,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_CENTER
    )

    local text = "Grab"
    if target.Inspected then
        text = target.HUDName

        local desc = target.HUDDesc
        if #desc > 55 then
            desc = string.Trim( string.Left( desc, 55 ) ) .. "..."
        end

        draw.SimpleTextOutlined(
            desc,
			"Impulse-Elements20-Shadow",
            pos.x, pos.y + size - len + 20,
            colorWhite,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP,
            1, colorCenter
        )

    else
        local scrw = ScrW()
        local scrh = ScrH()

		local labelX = (ScrW() / 2) + 24
		local labelY = ScrH() - 128 + 24
		local boxX = labelX - 58 - 58
		local boxY = labelY - 24
		local keyX = boxX + 24
		local keyY = boxY + 24

		local black = ColorAlpha( color_black, alpha )
		local boxCol = ColorAlpha( darkCol, math.min( alpha, 190 ) )

		draw.RoundedBox( 4, boxX, boxY, 48, 48, boxCol )

		draw.SimpleText( "Inspect", "Impulse-Elements32-Shadow", labelX + 1, labelY + 1, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Inspect", "Impulse-Elements32-Shadow", labelX, labelY, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "F", "Impulse-CharacterInfo-NO", keyX, keyY, colorWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    draw.SimpleTextOutlined(
		text,
		"Impulse-Elements22-Shadow",
		pos.x, pos.y + size - len,
		colorWhite,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_TOP,
        2, colorCenter
    )
end


local color_yellow = Color(255, 215, 0)
local function DrawRagdollInfo(target, alpha)
    local localPly = LocalPlayer()
    if localPly:GetPos():DistToSqr(target:GetPos()) > (100 ^ 2) then return end

    local chestBone = target:LookupBone("ValveBiped.Bip01_Spine2")
        or target:LookupBone("ValveBiped.Bip01_Spine1")
        or target:LookupBone("ValveBiped.spine3")
        or target:LookupBone("ValveBiped.spine2")

    local bonePos
    if chestBone then
        bonePos = target:GetBonePosition(chestBone)
    else
        bonePos = target:LocalToWorld(target:OBBCenter())
    end

    local pos = (bonePos + Vector(0, 0, 5)):ToScreen()

    if IsValid(target) and target:IsRagdoll() and target:GetNWBool("IsDeadPlayerRagdoll", false) then
        local deadPlayerName = target:GetNWString("DeadPlayerName") or "Unknown"
        draw.DrawText(deadPlayerName.."'s corpse.", "Impulse-Elements18-Shadow", pos.x, pos.y + 20, ColorAlpha(color_yellow, alpha), 1)
    end
end

local function DrawButtonInfo(target, alpha)	
	local pos = target.LocalToWorld(target, target:OBBCenter()):ToScreen()
	local scrW = ScrW()
	local scrH = ScrH()
	local buttonId = impulse_ActiveButtons[target:EntIndex()]
	local hudCol = impulse.Config.InteractColour
	local buttonData = impulse.Config.Buttons[buttonId]

	if not buttonData then
		return
	end

	if not buttonData.desc then
		return
	end

	draw.DrawText(buttonData.desc, HIGH_RES("Impulse-Elements18-Shadow", "Impulse-Elements20A-Shadow"), pos.x, pos.y + 20, ColorAlpha(hudCol, alpha), 1)
end

function meta:GetKnownHealth()
	local h = self.Health(self)
	if h < 10 then
		return "(Extremely Injured)", Color(255, 0, 0)
	elseif h < 25 then
		return "(Heavily Injured)", Color(255, 50, 0)
	elseif h < 40 then
		return "(Injured)", Color(255, 100, 0)
	elseif h < 60 then
		return "(Hurt)", Color(255, 150, 0)
	elseif h < 80 then
		return "(Bruised)", Color(255, 175, 0)
	end
end

local function DrawCrosshair(x, y)
	local style = impulse.GetSetting("crosshair_style")
	if style == "Classic" then
		surface.SetDrawColor(color_white)

		surface.DrawLine(x - crosshairLength, y, x - crosshairGap, y)
		surface.DrawLine(x + crosshairLength, y, x + crosshairGap, y)
		surface.DrawLine(x, y - crosshairLength, x, y - crosshairGap)
		surface.DrawLine(x, y + crosshairLength, x, y + crosshairGap)
	elseif style == "Circle & Dot" then
		surface.SetDrawColor(color_white)

		surface.DrawCircle(x,y,16)
		surface.DrawCircle(x,y,1)
	elseif style == "Dot" then
		surface.SetDrawColor(color_white)

		surface.DrawCircle(x,y,1)
	elseif style == "X" then
		surface.SetDrawColor(color_white)

		surface.DrawLine(x - crosshairLength, y - crosshairLength, x - crosshairGap, y)
		surface.DrawLine(x + crosshairLength, y, x + crosshairGap, y)
		surface.DrawLine(x, y - crosshairLength, x, y - crosshairGap)
		surface.DrawLine(x, y + crosshairLength, x, y + crosshairGap)
		surface.DrawLine(x, y, x+1, y+1)
	end
end

surface.CreateFont("Impulse-DeathHeaderLarge", {
	font = "Arial",
	size = 64,
	weight = 800,
	antialias = true,
	shadow = true
})

function GM:HUDPaint()
	local health = LocalPlayer():Health()
	local lp = LocalPlayer()
	local lpTeam = lp:Team()
	local scrW, scrH = ScrW(), ScrH()
	local hudWidth, hudHeight = 360, 178
	local seeColIcons = impulse.GetSetting("hud_iconcolours")
	local aboveHUDUsed = false
	local deathSoundPlayed

	if LocalPlayer().CamView == true then
		return false
	end
	--[[ Quest HUD 
    local quest = LocalPlayer().CurrentQuest or {title = "None",description="You have no quests available to you."}

	if lpTeam == TEAM_CITIZEN and impulse.hudEnabled and impulse.GetSetting("showquests") == true then

		draw.SimpleText("Current Quest", "terminal50", ScrW() * 0.001, ScrH() * 0.045, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		surface.SetMaterial(gladient)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawTexturedRect(ScrW() * 0.001, ScrH() * 0.095, ScrW() * 0.25, ScrH() * 0.07)

		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(ScrW() * 0.0001 - 25, ScrH() * 0.095, ScrW() * 0.25, ScrH() * 0.0015)
		surface.DrawTexturedRect(ScrW() * 0.0001 - 25, ScrH() * 0.163, ScrW() * 0.25, ScrH() * 0.0015)

		--surface.DrawTexturedRect(x, y, width, height)

		draw.SimpleText(quest.title or "", "terminal32", ScrW() * 0.005, ScrH() * 0.1, color_white, 0, 0, 1, color_black)
		draw.SimpleText(quest.description or "", "terminal24", ScrW() * 0.005, ScrH() * 0.13, color_white, 0, 0, 1, color_black)
	end
	]]
	if CLIENT then


		local function FormatRespawnTime(timeLeft)
			if timeLeft <= 0 then return "00:00:00" end
			local minutes = math.floor(timeLeft / 60)
			local seconds = math.floor(timeLeft % 60)
			local milliseconds = math.floor((timeLeft % 1) * 100)
			return string.format("%02d:%02d:%02d", minutes, seconds, milliseconds)
		end


		local lastSoundTime = 0
		local SOUND_COOLDOWN = 5


		hook.Add("HUDShouldDraw", "Impulse_DisableDefaultDeathScreen", function(name)
			local lp = LocalPlayer()
			if not IsValid(lp) then return end
			if not lp:Alive() then
				if name == "CHudDamageIndicator" then
					return false
				end
			end
		end)


		if not lp:Alive() then
			local ft = FrameTime()

			if not deathRegistered then
				if CurTime() - lastSoundTime >= SOUND_COOLDOWN then
					local deathSound = hook.Run("GetDeathSound") or "impulse/death.mp3"
					surface.PlaySound(deathSound)
					lastSoundTime = CurTime()
				end

				deathWait = CurTime() + impulse.Config.RespawnTime
				if lp:IsDonator() then
					deathWait = CurTime() + impulse.Config.RespawnTimeDonator
				end

				deathRegistered = true
			end

			fde = math.Clamp(fde + ft * .2, 0, 1)
			painFde = 0.7

			surface.SetDrawColor(0, 0, 0, math.ceil(fde * 255))
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

			local textAlpha = math.ceil(fde * 255)
			local textCol = Color(255, 255, 255, textAlpha)
			local youDiedCol = Color(255, 0, 0, textAlpha)
			local youDiedShadowCol = Color(139, 0, 0, textAlpha)

			draw.SimpleText("YOU DIED", "Impulse-DeathHeaderLarge", scrW / 2, scrH / 2 - 50, youDiedCol, TEXT_ALIGN_CENTER)

			local wait = deathWait - CurTime()
			if wait > 0 then
				draw.SimpleText("You will respawn in "..FormatRespawnTime(wait).." seconds.", "Impulse-Elements23", scrW/2, (scrH/2)+30, textCol, TEXT_ALIGN_CENTER)
				draw.SimpleText("WARNING: NLR applies, you may not return to this area until 3 minutes after your death.", "Impulse-Elements18", scrW/2, (scrH/2)+70, textCol, TEXT_ALIGN_CENTER)
				draw.SimpleText("If you feel you were unfairly killed, submit a report (F3) for assistance.", "Impulse-Elements16", scrW/2, scrH-20, textCol, TEXT_ALIGN_CENTER)
			end

			if IsValid(PlayerIcon) then
				PlayerIcon:Remove()
			end

			return
		else
			fde = 0
			if deathRegistered then
				deathRegistered = false
			end
			LocalPlayer().Ragdoll = nil
		end
	end

	if impulse.hudEnabled == false or (impulse.CinematicIntro and LocalPlayer():Alive()) or (IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible()) or hook.Run("ShouldDrawHUDBox") == false then
		if IsValid(PlayerIcon) then
			PlayerIcon:Remove()
		end
		return
	end

	if health < 45 then
		healthstate = Color(255,0,0,240)
	elseif health < 70 then
		healthstate = Color(255,0,0,190)
	else
		healthstate = nil
	end

	--Crosshair
	local x, y
	local curWep = lp:GetActiveWeapon()
	if curWep then
		if impulse.GetSetting("view_thirdperson") == true then
			local p = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
			x, y = p.x, p.y
		else
			x, y = scrW/2, scrH/2
		end
		DrawCrosshair(x, y)
	end

	-- HUD
	if impulse.GetSetting("hudselection") == "impulse - Original" then
		y = scrH-hudHeight-8-10
		BlurRect(10, y, hudWidth, hudHeight)
		surface.SetDrawColor(darkCol)
		surface.DrawRect(10, y, hudWidth, hudHeight)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(10, y, hudWidth, hudHeight)

		surface.SetFont("Impulse-Elements23")
		surface.SetTextColor(color_white)
		surface.SetDrawColor(color_white)
		surface.SetTextPos(30, y+10)
		surface.DrawText(LocalPlayer():Name())

		/*if SW.Time then
			local hr = math.floor( SW.Time )
			local min = math.floor( 60 * ( SW.Time - hr ) )
			surface.SetFont("Impulse-Elements19")
			surface.SetTextColor(color_white)
			surface.SetDrawColor(color_white)
			surface.SetTextPos(hudWidth-80, y+30)
			local timetext = ""
			local ampm = "AM"

			if hr >= 12 then

				ampm = "PM"

			end

			if hr > 12 then

				hr = hr - 12

			end

			if hr == 0 then

				hr = 12

			end

			if min < 10 then

				min = "0" .. min

			end

			timetext = hr .. ":" .. min .. " " .. ampm
			surface.DrawText(timetext)
		end*/

		surface.SetTextColor(team.GetColor(lpTeam))
		surface.SetTextPos(30, y+30)
		surface.DrawText(team.GetName(lpTeam))

		local yAdd = 0

		surface.SetTextColor(color_white)
		surface.SetFont("Impulse-Elements19")

		surface.SetTextPos(56, y+64+yAdd)
		surface.DrawText("Health: "..LocalPlayer():Health())
		if seeColIcons == true then surface.SetDrawColor(healthCol) end
		surface.SetMaterial(healthIcon)
		surface.DrawTexturedRect(30, y+66+yAdd, 18, 16)

		surface.SetTextPos(56, y+86+yAdd)
		surface.DrawText("Hunger: "..LocalPlayer():GetSyncVar(SYNC_HUNGER, 100))
		if seeColIcons == true then surface.SetDrawColor(hungerCol) end
		surface.SetMaterial(hungerIcon)
		surface.DrawTexturedRect(30, y+87+yAdd, 18, 18)

		surface.SetTextPos(56, y+108+yAdd)
		surface.DrawText("Money: "..impulse.Config.CurrencyPrefix..LocalPlayer():GetSyncVar(SYNC_MONEY, 0))
		if seeColIcons == true then surface.SetDrawColor(moneyCol) end
		surface.SetMaterial(moneyIcon)
		surface.DrawTexturedRect(30, y+107+yAdd, 18, 18)

		surface.SetDrawColor(color_white)

		if lp:GetSyncVar(SYNC_ARRESTED, false) == true and impulse_JailTimeEnd and impulse_JailTimeEnd > CurTime() then
			local timeLeft = math.ceil(impulse_JailTimeEnd - CurTime())

			surface.SetMaterial(exitIcon)
			surface.DrawTexturedRect(10, y-30, 18, 18)
			draw.DrawText("Sentence remaining: "..string.FormattedTime(timeLeft, "%02i:%02i"), "Impulse-Elements19", 35, y-30, color_white, TEXT_ALIGN_LEFT)
			aboveHUDUsed = true
		end

		draw.DrawText(lp:GetSyncVar(SYNC_XP, 0).."XP", "Impulse-Elements19", 55, y+150+(yAdd-8), color_white, TEXT_ALIGN_LEFT)
		surface.SetMaterial(xpIcon)
		surface.DrawTexturedRect(30, y+150+(yAdd-8), 18, 18)

		local iconsX = 315
		local bleedIconCol

		if lp:GetSyncVar(SYNC_BLEEDING, false) then
			if (nextBleedFlash or 0) < CurTime() then
				bleedFlash = !bleedFlash
				nextBleedFlash = CurTime() + 1
			end

			if bleedFlash then
				bleedIconCol = bleedFlashCol
			else
				bleedIconCol = iconsWhiteCol
			end

			surface.SetDrawColor(bleedIconCol)
			surface.SetMaterial(bleedingIcon)
			surface.DrawTexturedRect(iconsX, y + 10, 30, 30)
		end

		surface.SetDrawColor(color_white)


		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) then
			if weapon:GetMaxClip1() != -1 then
				surface.SetDrawColor(darkCol)
				surface.DrawRect(scrW-70, scrH-45, 70, 30)
				surface.SetTextPos(scrW-60, scrH-40)
				surface.DrawText(weapon:Clip1().."/"..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()))
			elseif weapon:GetClass() == "weapon_physgun" or weapon:GetClass() == "gmod_tool" then
				draw.DrawText("Don't have this weapon out in RP.\nYou may be punished for this.", "Impulse-Elements16", 35, y-35, color_white, TEXT_ALIGN_LEFT)
				surface.SetMaterial(warningIcon)
				surface.DrawTexturedRect(10, y-32, 18, 18)
				aboveHUDUsed = true

				surface.SetDrawColor(darkCol)
				surface.DrawRect(scrW-140, scrH-55, 140, 30)

				surface.SetFont("Impulse-Elements18-Shadow")
				surface.SetTextPos(scrW-130, scrH-50)
				local ply = LocalPlayer()

				local maxProps
				if ply:IsGameMaster() then
					maxProps = "∞"
				else
					maxProps = (ply:IsDonator() and impulse.Config.PropLimitDonator) or impulse.Config.PropLimit
				end

				surface.DrawText("Props: " ..ply:GetSyncVar(SYNC_PROPCOUNT, 0) .."/" .. maxProps)
			end
		end

		if not aboveHUDUsed then
			if impulse.ShowZone then
				if IsValid(zoneLbl) then
					zoneLbl:Remove()
				end

				zoneLbl = vgui.Create("impulseZoneLabel")
				zoneLbl:SetPos(30, y - 25)
				zoneLbl.Zone = lp:GetZoneName()

				impulse.ShowZone = false
			end
		elseif zoneLbl and IsValid(zoneLbl) then
			zoneLbl:Remove()
		end

		local isPreview = GetConVar("impulse_ispreview"):GetBool()

		if isPreview then
			surface.SetTextPos(390, y)
			surface.SetTextColor(watermarkCol)
			surface.SetFont("Impulse-Elements18-Shadow")
			surface.DrawText("PREVIEW BUILD - "..impulse.Version.." - "..LocalPlayer():SteamID64().. " - ".. os.date("%H:%M:%S - %d/%m/%Y", os.time()))
			surface.SetTextPos(390, y + 20)
			surface.DrawText("SCHEMA: "..SCHEMA_NAME.." VERSION: "..(impulse.Config.SchemaVersion or "?").."  |  COPYRIGHT LOLOLOLOL")

			-- watermark
			surface.SetDrawColor(watermarkCol)
			surface.SetMaterial(watermark)
			surface.DrawTexturedRect(390, y + 40, 112, 112)
		end

		-- dev hud

		if impulse_DevHud and (lp:IsSuperAdmin() or lp:IsDeveloper()) then
			local trace = {}
			trace.start = lp:EyePos()
			trace.endpos = trace.start + lp:GetAimVector() * 3000
			trace.filter = lp

			local traceData = util.TraceLine(trace)
			local traceEnt = traceData.Entity

			if traceEnt and traceEnt != NULL then
				surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 100)
				surface.DrawText(tostring(traceEnt))

				surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 80)
				surface.DrawText(traceEnt:GetModel().."     "..traceData.HitTexture or "")

				local syncData = impulse.Sync.Data[traceEnt:EntIndex()]
				local netData
				local y = (scrH / 2) - 40

				if syncData then
					for v,k in pairs(syncData) do
						if type(k) == "table" then
							k = table.ToString(k)
						end

						surface.SetTextPos((scrW / 2) + 30, y)
						surface.DrawText("syncvalue: "..v.." ; "..tostring(k))
						y = y + 20
					end
				end

				if IsValid(traceEnt) and traceEnt.GetNetworkVars then
					netData = traceEnt:GetNetworkVars()
				end

				if netData then
					for v,k in pairs(netData) do
						surface.SetTextPos((scrW / 2) + 30, y)
						surface.DrawText("netvalue: "..v.." ; "..tostring(k))
						y = y + 20
					end
				end
			end

			surface.SetTextPos(400, scrH / 1.5)
			surface.DrawText(tostring(lp:GetPos()))
			surface.SetTextPos(400, (scrH / 1.5) + 20)
			surface.DrawText(tostring(lp:GetAngles()))
			surface.SetTextPos(400, (scrH / 1.5) + 40)
			surface.DrawText(lp:GetVelocity():Length2D())
		end

		lasthealth = health
	    elseif impulse.GetSetting("hudselection") == "Pinnacle" then
        y = scrH-hudHeight-8-10

        local xAdd = 0

        local iconSpacing = 200
        local baseX = 120 + xAdd
        local baseY = y + 99

        -- Health
		surface.SetTextColor(color_white)
		surface.SetFont("terminal40")
		local healthStr = tostring(LocalPlayer():Health())
		local healthX = baseX + iconSpacing * 0
		surface.SetTextPos(healthX, baseY)
		surface.DrawText(healthStr)
		local healthW, _ = surface.GetTextSize(healthStr)
		surface.SetTextColor(Color(200,200,200,200))
		surface.SetFont("terminal32")
		surface.SetTextPos(healthX + healthW + 8, baseY + 5) -- 8px padding
		surface.DrawText(" | 100")
		surface.SetDrawColor(color_white)
		if seeColIcons == true then surface.SetDrawColor(healthCol) end
		surface.SetMaterial(healthIcon)
		surface.DrawTexturedRect(baseX + iconSpacing * 0 - 50, baseY + 2, 40, 36)

		-- Hunger
		surface.SetTextColor(color_white)
		surface.SetFont("terminal40")
		local hungerStr = tostring(LocalPlayer():GetSyncVar(SYNC_HUNGER, 100))
		local hungerX = baseX + iconSpacing * 1.35
		surface.SetTextPos(hungerX, baseY)
		surface.DrawText(hungerStr)
		local hungerW, _ = surface.GetTextSize(hungerStr)
		surface.SetTextColor(Color(200,200,200,200))
		surface.SetFont("terminal32")
		surface.SetTextPos(hungerX + hungerW + 8, baseY + 5)
		surface.DrawText(" | 100")
		surface.SetDrawColor(color_white)
		if seeColIcons == true then surface.SetDrawColor(hungerCol) end
		surface.SetMaterial(hungerIcon)
		surface.DrawTexturedRect(baseX + iconSpacing * 1.1, baseY + 3, 40, 36)

-- Ammo (if you want dynamic spacing for ammo as well)
		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) and weapon:GetMaxClip1() != -1 then
			surface.SetFont("terminal64")
			local ammoStr = tostring(weapon:Clip1())
			local ammoX = scrW-240
			surface.SetTextPos(ammoX, scrH-120)
			surface.SetTextColor(color_white)
			surface.DrawText(ammoStr)
			local ammoW, _ = surface.GetTextSize(ammoStr)
			surface.SetFont("terminal50")
			surface.SetTextColor(Color(200,200,200,200))
			surface.SetTextPos(ammoX + ammoW + 8, scrH-115)
			surface.DrawText(" | "..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()))
		end

		local function IsPlayerMorphed(ply)
			if not IsValid(ply) then return false end
			if not pk_pills then return false end
			if not pk_pills.getMappedEnt then return false end
			
			return IsValid(pk_pills.getMappedEnt(ply))
		end

		if IsValid(weapon) and not IsPlayerMorphed(LocalPlayer()) and (weapon:GetClass() == "weapon_physgun" or weapon:GetClass() == "gmod_tool") then
			aboveHUDUsed = true

			-- Dynamic spacing for props count
			local propCount = tostring(LocalPlayer():GetSyncVar(SYNC_PROPCOUNT, 0))
			local propLimit = (LocalPlayer():IsDonator() and impulse.Config.PropLimitDonator) or impulse.Config.PropLimit
			local propX = scrW-240
			surface.SetFont("terminal64")
			surface.SetTextColor(color_white)
			surface.SetTextPos(propX - 135, scrH-120)
			surface.DrawText("Props: " .. propCount)
			local propW, _ = surface.GetTextSize(propCount)
			surface.SetFont("terminal50")
			surface.SetTextColor(Color(200,200,200,200))
			surface.SetTextPos(propX + propW + 8, scrH-115)
			surface.DrawText(" | "..propLimit)
		end

        -- Money (optional, add if you want)
        --[[
        surface.SetTextColor(color_white)
        surface.SetFont("terminal32")
        surface.SetTextPos(baseX + iconSpacing * 2, baseY)
        surface.DrawText("Money: "..impulse.Config.CurrencyPrefix..LocalPlayer():GetSyncVar(SYNC_MONEY, 0))
        if seeColIcons == true then surface.SetDrawColor(moneyCol) end
        surface.SetMaterial(moneyIcon)
        surface.DrawTexturedRect(baseX + iconSpacing * 2 - 26, baseY + 3, 18, 18)
        ]]

        surface.SetDrawColor(color_white)

        if lp:GetSyncVar(SYNC_ARRESTED, false) == true and impulse_JailTimeEnd and impulse_JailTimeEnd > CurTime() then
            local timeLeft = math.ceil(impulse_JailTimeEnd - CurTime())

            surface.SetMaterial(exitIcon)
            surface.DrawTexturedRect(10, y-30, 18, 18)
            draw.DrawText("Sentence remaining: "..string.FormattedTime(timeLeft, "%02i:%02i"), "Impulse-Elements19", 35, y-30, color_white, TEXT_ALIGN_LEFT)
            aboveHUDUsed = true
        end

        local iconsX = 315
        local bleedIconCol

        if lp:GetSyncVar(SYNC_BLEEDING, false) then
            if (nextBleedFlash or 0) < CurTime() then
                bleedFlash = !bleedFlash
                nextBleedFlash = CurTime() + 1
            end

            if bleedFlash then
                bleedIconCol = bleedFlashCol
            else
                bleedIconCol = iconsWhiteCol
            end

            surface.SetDrawColor(bleedIconCol)
            surface.SetMaterial(bleedingIcon)
            surface.DrawTexturedRect(iconsX, y + 10, 30, 30)
        end

        surface.SetDrawColor(color_white)

        if not aboveHUDUsed then
            if impulse.ShowZone then
                if IsValid(zoneLbl) then
                    zoneLbl:Remove()
                end

                zoneLbl = vgui.Create("impulseZoneLabel")
                zoneLbl:SetPos(45, y - 25)
                zoneLbl.Zone = lp:GetZoneName()

                impulse.ShowZone = false
            end
        elseif zoneLbl and IsValid(zoneLbl) then
            zoneLbl:Remove()
        end

        local isPreview = GetConVar("impulse_ispreview"):GetBool()

        if isPreview then
            -- watermark
            surface.SetDrawColor(watermarkCol)
            surface.SetMaterial(watermark)
            surface.DrawTexturedRect(390, y, 112, 30)

            surface.SetTextPos(390, y + 30)
            surface.SetTextColor(watermarkCol)
            surface.SetFont("Impulse-Elements18-Shadow")
            surface.DrawText("PREVIEW BUILD - "..impulse.Version.." - "..LocalPlayer():SteamID64().. " - ".. os.date("%H:%M:%S - %d/%m/%Y", os.time()))
            surface.SetTextPos(390, y + 50)
            surface.DrawText("SCHEMA: "..SCHEMA_NAME.." VERSION: "..impulse.Config.SchemaVersion or "?")
        end
		-- dev hud

		if impulse_DevHud and (lp:IsSuperAdmin() or lp:IsDeveloper()) then
			local trace = {}
			trace.start = lp:EyePos()
			trace.endpos = trace.start + lp:GetAimVector() * 3000
			trace.filter = lp

			local traceData = util.TraceLine(trace)
			local traceEnt = traceData.Entity

			if traceEnt and traceEnt != NULL then
				surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 100)
				surface.DrawText(tostring(traceEnt))

				surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 80)
				surface.DrawText(traceEnt:GetModel().."     "..traceData.HitTexture or "")

				local syncData = impulse.Sync.Data[traceEnt:EntIndex()]
				local netData
				local y = (scrH / 2) - 40

				if syncData then
					for v,k in pairs(syncData) do
						if type(k) == "table" then
							k = table.ToString(k)
						end

						surface.SetTextPos((scrW / 2) + 30, y)
						surface.DrawText("syncvalue: "..v.." ; "..tostring(k))
						y = y + 20
					end
				end

				if IsValid(traceEnt) and traceEnt.GetNetworkVars then
					netData = traceEnt:GetNetworkVars()
				end

				if netData then
					for v,k in pairs(netData) do
						surface.SetTextPos((scrW / 2) + 30, y)
						surface.DrawText("netvalue: "..v.." ; "..tostring(k))
						y = y + 20
					end
				end
			end

			surface.SetTextPos(400, scrH / 1.5)
			surface.DrawText(tostring(lp:GetPos()))
			surface.SetTextPos(400, (scrH / 1.5) + 20)
			surface.DrawText(tostring(lp:GetAngles()))
			surface.SetTextPos(400, (scrH / 1.5) + 40)
			surface.DrawText(lp:GetVelocity():Length2D())
		end

		lasthealth = health
	elseif impulse.GetSetting("hudselection") == "Deep - Standard" then
		local dgh_XSize = ScrW() * 0.25
		local dgh_YSize = ScrH() * 0.06
		local dgh_XPos = ScrW() * 0.02
		local dgh_YPos = ScrH() * 0.9
		local dgh_y5per = ScrH() * 0.05
		local dgh_x5per = ScrW() * 0.05
		local dgh_smallx = math.ceil(ScrW() / 384)
		local dgh_smally = math.ceil(ScrH() / 216)
		local ammopos = ScrW() * 0.9
		local dgh_lphunger = LocalPlayer():GetSyncVar(SYNC_HUNGER, 100)
		local dgh_lpmoney = LocalPlayer():GetSyncVar(SYNC_MONEY, 0)
		local dgh_lpxp = LocalPlayer():GetSyncVar(SYNC_XP, 0)
		local dgh_lpname = LocalPlayer():Name()

		local dgh_lpteam = LocalPlayer():Team()
		local dgh_teamcol = team.GetColor(dgh_lpteam)
		local dgh_dist = {math.floor(ScrW()/192), math.floor(ScrW()/64), math.floor(ScrW()/96), math.floor(ScrW()/96), math.floor(ScrW()/96), ScrW() + 1.007, ScrW() + 1.007, math.floor(ScrW()/96), math.floor(ScrW()/96)}

		local bigfont
		local littlefont
		local iconsize

		if ScrW() >= 1000 then
			bigfont = "MediumOswaldFont"
			littlefont = "SmallOswaldFont"
			iconsize = 20
		elseif ScrW() >= 850 then
			bigfont = "Oswald22"
			littlefont = "Oswald18"
			iconsize = 16
		elseif ScrW() >= 700 then
			bigfont = "SmallOswaldFont"
			littlefont = "TinyOswaldFont"
			iconsize = 12
		else
			bigfont = "TinyOswaldFont"
			littlefont = "SuperTinyOswaldFont"
			iconsize = 8
		end

		surface.SetDrawColor(dgh_dbb)
		surface.DrawRect(dgh_XPos, dgh_YPos, dgh_XSize, dgh_YSize)

		surface.SetDrawColor(dgh_outlinecolor)
		surface.DrawOutlinedRect(dgh_XPos, dgh_YPos, dgh_XSize, dgh_YSize, 1)

		surface.SetTextColor(color_white)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 3), dgh_YPos + dgh_smally)
		surface.DrawText(dgh_lpname)

		/*if SW.Time then
			local hr = math.floor( SW.Time )
			local min = math.floor( 60 * ( SW.Time - hr ) )
			surface.SetTextColor(color_white)
			surface.SetFont(littlefont)
			surface.SetTextPos(dgh_XPos + (dgh_smallx * 3), dgh_YPos - dgh_smally * 4)
			local timetext = ""
			local ampm = "AM"

			if hr >= 12 then

				ampm = "PM"

			end

			if hr > 12 then

				hr = hr - 12

			end

			if hr == 0 then

				hr = 12

			end

			if min < 10 then

				min = "0" .. min

			end

			timetext = hr .. ":" .. min .. " " .. ampm
			surface.DrawText(timetext)
		end*/

		surface.SetTextColor(dgh_teamcol)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_XSize * 0.8) + (dgh_dist[dgh_lpteam]), dgh_YPos + dgh_smally )
		surface.DrawText((dgh_smallteams[dgh_lpteam] or "Unassigned"))

		surface.SetMaterial(dgh_mediclogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_hpcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 3), dgh_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(littlefont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 8), dgh_YPos + (dgh_smally * 7))
		surface.DrawText("HP: " .. LocalPlayer():Health())

		surface.SetMaterial(dgh_foodlogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_hungcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 20), dgh_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(littlefont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 25), dgh_YPos + (dgh_smally * 7))
		surface.DrawText("HNG: " .. dgh_lphunger)

		surface.SetMaterial(dgh_moneylogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_moneycol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 40), dgh_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(littlefont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 45), dgh_YPos + (dgh_smally * 7))
		surface.DrawText("MNY: " .. dgh_lpmoney)

		surface.SetMaterial(dgh_xplogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_xpcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 60), dgh_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(littlefont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 65), dgh_YPos + (dgh_smally * 7))
		surface.DrawText("XP: " .. dgh_lpxp)

		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) then
			if weapon:GetMaxClip1() != -1 then
				surface.SetFont(littlefont)
				surface.SetTextPos(scrW-(ScrW()/20), dgh_YPos+(ScrW()/39))
				surface.DrawText(weapon:Clip1().."/"..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()))
			elseif weapon:GetClass() == "weapon_physgun" or weapon:GetClass() == "gmod_tool" then
				draw.DrawText("DON'T HAVE THIS WEAPON OUT IN RP.\nYOU MAY BE PUNISHED FOR THIS.", littlefont, dgh_XPos, dgh_YPos - (ScrW()/35), color_white, TEXT_ALIGN_LEFT)
				aboveHUDUsed = true

				surface.SetFont(littlefont)
				surface.SetTextPos(ScrW()-(ScrW()/14.769), dgh_YPos+(ScrW()/40))
				local ply = LocalPlayer()
				local maxProps
				if ply:IsGameMaster() then
					maxProps = "∞"
				else
					maxProps = (ply:IsDonator() and impulse.Config.PropLimitDonator) or impulse.Config.PropLimit
				end
				surface.DrawText("Props: " ..ply:GetSyncVar(SYNC_PROPCOUNT, 0) .."/" .. maxProps)
			end
		end

		if lp:GetSyncVar(SYNC_ARRESTED, false) == true and impulse_JailTimeEnd and impulse_JailTimeEnd > CurTime() then
			local timeLeft = math.ceil(impulse_JailTimeEnd - CurTime())

			surface.SetMaterial(dgh_imprisonedlogo)
			surface.DrawTexturedRect(10, y-30, 18, 18)
			draw.DrawText("Sentence remaining: "..string.FormattedTime(timeLeft, "%02i:%02i"), "Oswald22", 35, y-30, color_white, TEXT_ALIGN_LEFT)
			aboveHUDUsed = true
		end
	elseif impulse.GetSetting("hudselection") == "Landis (Requires Horizons Content)" then

		surface.SetMaterial(gladient)
		surface.SetDrawColor(24,46,48,60)
		surface.DrawTexturedRect(0, scrH - 100, 540, 100)

		surface.SetDrawColor(255, 255, 255, 120)
		surface.DrawTexturedRect(0, scrH - 102, 540, 2)

		-- HEART ICON START

		-- BACKGROUND
		local healthFraction = LocalPlayer():Health() / 100

		-- Medium+ has a percent shaded health icon.

		-- HIGH QUALITY, FILTER SHADED BAR FOR FRACTION OF THE SHADE TO BE VISIBLE, PREVENTING PIXEL JUMPING!
		local heightFX = 48 * healthFraction
		local fxY = flr((scrH - 28) + (heightFX))
		--print(fxY)
		local interPixelDistanceShade = ((heightFX) % 1)
		if colIcons then
			surface.SetDrawColor(150, 0, 0, 255)
		else
			surface.SetDrawColor(255, 255, 255, 255)
		end

		render.SetScissorRect(80,(scrH - 76) + (fxY - 1), 128,(scrH - 76) + (fxY), true)
		surface.SetMaterial(dgh_mediclogo)
		surface.DrawTexturedRect(80, scrH - 76, 48, 48)
		render.SetScissorRect(0, 0, 0, 0, false)

		local health = LocalPlayer():Health()
		surface.SetFont("terminal64")


		local textW, textH = surface.GetTextSize(health)
		surface.SetTextPos(146, scrH - 50 - (textH/2))

		surface.SetTextPos(144, scrH - 52 - (textH/2))

		surface.SetFont("terminal64")
		surface.SetTextColor(255, 255, 255, 255)
		surface.DrawText(health, false)

		surface.SetFont("terminal32")
		local tw2, th2 = surface.GetTextSize("| 100")

		surface.SetTextPos(160 + textW, scrH - 52 - (th2/2))
		surface.SetTextColor(140, 140, 140, 255)
		surface.SetFont("terminal32")
		surface.DrawText("| 100")

		local hunger = LocalPlayer():GetSyncVar(SYNC_HUNGER, 100)

		local hungerFraction = hunger / 100

		render.SetScissorRect(300, scrH - 76, 348, (scrH - 76) + (48 * (1 - hungerFraction)), true)

		surface.SetMaterial(hungerIcon)
		surface.SetDrawColor(100, 100, 100, 255)
		surface.DrawTexturedRect(300, scrH - 76, 48, 48)

		render.SetScissorRect(0, 0, 0, 0, false)
		render.SetScissorRect(300, (scrH - 28) - (48 * (hungerFraction)), 348, scrH - 28, true)

		surface.SetMaterial(hungerIcon)
		if colIcons then
			surface.SetDrawColor(255, 159, 10, 255)
		else
			surface.SetDrawColor(255, 255, 255, 255)
		end
		surface.DrawTexturedRect(300, scrH - 76, 48, 48)

		render.SetScissorRect(0, 0, 0, 0, false)

		surface.SetFont("terminal64")

		surface.SetTextColor(255, 255, 255, 255)

		local textW2, textH2 = surface.GetTextSize(hunger)

		surface.SetTextPos(364, scrH - 52 - (textH2/2))
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetFont("terminal64")
		surface.DrawText(hunger)

		surface.SetFont("terminal32")
		local tw3, th3 = surface.GetTextSize("| 100")

		surface.SetTextColor(140, 140, 140, 255)
		surface.SetTextPos(380 + textW2, scrH - 52 - (th3/2))
		surface.SetFont("terminal32")
		surface.DrawText("| 100")

	elseif impulse.GetSetting("hudselection") == "Deep - Minimalistic" then
		local dgh_XPos = ScrW() * 0.02
		local dghm_YPos = ScrH() * 0.925
		local dgh_y5per = ScrH() * 0.05
		local dgh_x5per = ScrW() * 0.05
		local dgh_smallx = math.ceil(ScrW() / 384)
		local dgh_smally = math.ceil(ScrH() / 216)
		local ammopos = ScrW() * 0.9
		local dgh_lphunger = LocalPlayer():GetSyncVar(SYNC_HUNGER, 100)
		local dgh_lpmoney = LocalPlayer():GetSyncVar(SYNC_MONEY, 0)
		local dgh_lpxp = LocalPlayer():GetSyncVar(SYNC_XP, 0)
		local dgh_lpname = LocalPlayer():Name()

		local dgh_lpteam = LocalPlayer():Team()
		local dgh_teamcol = team.GetColor(dgh_lpteam)
		local dgh_dist = {math.floor(ScrW()/192), math.floor(ScrW()/64), math.floor(ScrW()/96), math.floor(ScrW()/96), math.floor(ScrW()/96), math.floor(ScrW()/96), math.floor(ScrW()/96), math.floor(ScrW()/96)}

		local bigfont
		local littlefont
		local iconsize

		if ScrW() >= 1000 then
			bigfont = "MediumOswaldFont"
			littlefont = "SmallOswaldFont"
			iconsize = 32
		elseif ScrW() >= 850 then
			bigfont = "Oswald22"
			littlefont = "Oswald18"
			iconsize = 24
		elseif ScrW() >= 700 then
			bigfont = "SmallOswaldFont"
			littlefont = "TinyOswaldFont"
			iconsize = 16
		else
			bigfont = "TinyOswaldFont"
			littlefont = "SuperTinyOswaldFont"
			iconsize = 12
		end

		surface.SetMaterial(dgh_mediclogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_hpcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 3), dghm_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 10), dghm_YPos + (dgh_smally * 7))
		surface.DrawText("HP: " .. LocalPlayer():Health())

		surface.SetMaterial(dgh_foodlogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_hungcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 50), dghm_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 57), dghm_YPos + (dgh_smally * 7))
		surface.DrawText("HNG: " .. dgh_lphunger)


		surface.SetMaterial(dgh_moneylogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_moneycol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 97), dghm_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 104), dghm_YPos + (dgh_smally * 7))
		surface.DrawText("MNY: " .. dgh_lpmoney)

		surface.SetMaterial(dgh_xplogo)
		if seeColIcons == true then
			surface.SetDrawColor(dgh_xpcol)
		else
			surface.SetDrawColor(color_white)
		end
		surface.DrawTexturedRect(dgh_XPos + (dgh_smallx * 144), dghm_YPos + (dgh_smally * 7), iconsize, iconsize)

		surface.SetTextColor(color_white)
		surface.SetFont(bigfont)
		surface.SetTextPos(dgh_XPos + (dgh_smallx * 151), dghm_YPos + (dgh_smally * 7))
		surface.DrawText("XP: " .. dgh_lpxp)

		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) then
			if weapon:GetMaxClip1() != -1 then
				surface.SetFont(bigfont)
				surface.SetTextPos(scrW-(dgh_smallx*18),  dghm_YPos + (dgh_smally * 7))
				surface.DrawText(weapon:Clip1().."/"..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()))
			end
		end

		if lp:GetSyncVar(SYNC_ARRESTED, false) == true and impulse_JailTimeEnd and impulse_JailTimeEnd > CurTime() then
			local timeLeft = math.ceil(impulse_JailTimeEnd - CurTime())

			surface.SetMaterial(dgh_imprisonedlogo)
			surface.DrawTexturedRect(10, y-30, 18, 18)
			draw.DrawText("Sentence remaining: "..string.FormattedTime(timeLeft, "%02i:%02i"), "Oswald22", 35, y-30, color_white, TEXT_ALIGN_LEFT)
			aboveHUDUsed = true
		end
	end
end

local nextOverheadCheck = 0
local lastEnt
local trace = {}
local approach = math.Approach
local letterboxFde = 0
local textFde = 0
local holdTime
overheadEntCache = {}
-- overhead info is HEAVILY based off nutscript. I'm not taking credit for it. but it saves clients like 70 fps so its worth it
function GM:HUDPaintBackground()

	if impulse.GetSetting("hud_vignette") == true then
		surface.SetMaterial(vignette)
		surface.SetDrawColor(vig_alpha_normal)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	if impulse.hudEnabled == false then
		return
	end

	local lp = LocalPlayer()
	local realTime = RealTime()
	local frameTime = FrameTime()

	if nextOverheadCheck < realTime then
		nextOverheadCheck = realTime + 0.5

		trace.start = lp.GetShootPos(lp)
		trace.endpos = trace.start + lp.GetAimVector(lp) * 300
		trace.filter = lp
		trace.mins = Vector(-4, -4, -4)
		trace.maxs = Vector(4, 4, 4)
		trace.mask = MASK_SHOT_HULL

		lastEnt = util.TraceHull(trace).Entity

		if IsValid(lastEnt) then
			overheadEntCache[lastEnt] = true
		end
	end

	for entTarg, shouldDraw in pairs(overheadEntCache) do
		if IsValid(entTarg) then
			local goal = shouldDraw and 255 or 0
			local alpha = approach(entTarg.overheadAlpha or 0, goal, frameTime * 1000)

			if lastEnt != entTarg then
				overheadEntCache[entTarg] = false
			end

			if alpha > 0 then
				if not entTarg:GetNoDraw() then
					if entTarg:IsPlayer() then
						DrawOverheadInfo(entTarg, alpha)
					elseif entTarg:GetClass() == "impulse_item" then
						_drawItemInfo( entTarg, alpha )
					elseif entTarg.HUDName then
						DrawEntInfo(entTarg, alpha)
					elseif entTarg:IsDoor() then
						DrawDoorInfo(entTarg, alpha)
					elseif entTarg:IsRagdoll() then
						DrawRagdollInfo(entTarg, alpha)
					elseif impulse_ActiveButtons[entTarg.EntIndex(entTarg)] then
						DrawButtonInfo(entTarg, alpha)
					end
				end
			end

			entTarg.overheadAlpha = alpha

			if alpha == 0 and goal == 0 then
				overheadEntCache[entTarg] = nil
			end
		else
			overheadEntCache[entTarg] = nil
		end
	end

	if impulse.CinematicIntro and lp:Alive() then
		local ft = FrameTime()
		local maxTall =  ScrH() * .12

		if holdTime and holdTime + 6 < CurTime() then
			letterboxFde = math.Clamp(letterboxFde - ft * .5, 0, 1)
			textFde = math.Clamp(textFde - ft * .3, 0, 1)

			if letterboxFde == 0 then
				impulse.CinematicIntro = false
			end
		elseif holdTime and holdTime + 4 < CurTime() then
			textFde = math.Clamp(textFde - ft * .3, 0, 1)
		else
			letterboxFde = math.Clamp(letterboxFde + ft * .5, 0, 1)

			if letterboxFde == 1 then
				textFde = math.Clamp(textFde + ft * .1, 0, 1)
				holdTime = holdTime or CurTime()
			end
		end

		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, ScrW(), (maxTall * letterboxFde))
		surface.DrawRect(0, (ScrH() - (maxTall * letterboxFde)) + 1, ScrW(), maxTall)

		draw.DrawText(impulse.CinematicTitle, "Impulse-Elements36", ScrW() - 150, ScrH() * .905, ColorAlpha(color_white, (255 * textFde)), TEXT_ALIGN_RIGHT)
	else
		letterboxFde = 0
		textFde = 0
		holdTime = nil
	end
end

concommand.Add("impulse_cameratoggle", function()
	impulse.hudEnabled = (!impulse.hudEnabled)

	if not IsValid(impulse.chatBox.frame) then
		return
	end

	if impulse.hudEnabled then
		impulse.chatBox.frame:Show()
	else
		impulse.chatBox.frame:Hide()
	end
end)
