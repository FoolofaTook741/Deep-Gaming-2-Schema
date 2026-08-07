include("shared.lua")

local Glow = Material("null")
local GradientDown = Material("null")
local ShieldTex = Material("null")
local Glowie = Material("null")
local Glowie2 = Material("null")
-- Colors
combineBlue = Color(71,98,105) -- text & outline
lightCombineBlue = Color(58, 130, 144) -- hovered bg
lightCombineBlueText = Color(89,171,179) -- hovered text
local ocaBroadcastCol = Color(128, 0, 128)
cp = Material("icons/civilprotection_logo.png")
local sprite_light_ignorez = Material("sprites/light_ignorez")
local claw_icon = Material("icons/npc_icon_combineclaw.png")
local atmInputStr = ""
local atmStatusMsg = nil
local atmStatusColor = color_white
local atmStatusExpire = 0

local transferInputStr = ""
local transferSelectedTarget = nil
local transferScrollOffset = 0
local transferSending = false
local transferSpinStart = 0
local transferSpinDuration = 0
local transferPendingResult = nil
local transferScrollDragging = false
local transferScrollDragStartCY = 0
local transferScrollDragStartOffset = 0
local transferFilterStr = ""

local Point = Vector(19, -0, 7)

local font64 = "terminal64"
local font50 =  "terminal50"
local font40 =  "terminal40"
local font32 =  "terminal32"
local font24 =  "terminal24"

local CVCOLOR_NORMAL = 0
local CVCOLOR_GREEN = 1
local CVCOLOR_RED = 2
local CVCOLOR_BLUE = 3
local CVCOLOR_PURPLE = 4

local GlowCol = {
	[CVCOLOR_NORMAL] = {Color(100, 100, 100, 100), Color(100, 100, 100, 140)},
	[CVCOLOR_RED] = {Color(100, 10, 10, 100), Color(124, 10, 10, 140)},
	[CVCOLOR_GREEN] = {Color(10, 100, 10, 100), Color(10, 124, 10, 140)},
	[CVCOLOR_BLUE] = {Color(10, 10, 100, 100), Color(10, 10, 124, 140)},
	[CVCOLOR_PURPLE] = {Color(100, 10, 100, 100), Color(124, 10, 124, 140)}
}
local OLCol = {
	[CVCOLOR_NORMAL] =  {Color(71,98,105,100), Color(71,98,105,100)},
	[CVCOLOR_RED] =  {Color(71,98,105,100), Color(71,98,105,100)},
	[CVCOLOR_GREEN] =  {Color(71,98,105,100), Color(71,98,105,100)},
	[CVCOLOR_BLUE] = {Color(71,98,105,100), Color(71,98,105,100)},
	[CVCOLOR_PURPLE] =  {Color(71,98,105,100), Color(71,98,105,100)}
}

net.Receive("impulseATMResult", function()
    local success = net.ReadBool()
    local message = net.ReadString()

    if transferSending then
        transferPendingResult = {success = success, message = message}
        return
    end

    atmStatusMsg = message
    atmStatusColor = success and Color(80, 220, 120) or Color(255, 90, 90)
    atmStatusExpire = CurTime() + 4

    if success then
        atmInputStr = ""
    end
end)

function CVButton(text, x, y, w, h, color, onuse, font)
	return {text, x, y, w, h, color, onuse, font}
end

ENT.Menus = {}

ENT.Menus[""] = {
	buttons = {
		CVButton("ENTER TERMINAL", -190, 50, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("Main")
			self:EmitSound("combine_tech/civic_station/station_menu_appear.mp3")
		end),
	},
	paint = function(self)

		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
        surface.SetDrawColor(lightCombineBlueText)
        surface.DrawLine(-525, -240, 500, -240)
		surface.DrawLine(-525, 300, 500, 300)

        local color_text
	    local rationsCode = "UNKNOWN"
	    if DG_RATIONS == true then 
	        color_text = Color(0,255,0)
	        rationsCode = "INACTIVE"
	    else
	        color_text = Color(255,0,0)
	        rationsCode = "ACTIVE"
	    end
	    draw.DrawText("RATION SUSPENSION STATUS :: " .. rationsCode, font64, -450, -200, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	    local lckdt = "UNKNOWN"
	    if DG_CITYLOCKDOWN == true then 
	        color_text = Color(255,0,0)
	        lckdt = "ACTIVE"
	    else
	        color_text = Color(0,255,0)
	        lckdt = "INACTIVE"
	    end
	    draw.DrawText("LOCKDOWN :: " .. lckdt, font64, -450, -125, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
}

ENT.Menus["balances"] = {
	buttons = {
		CVButton("WITHDRAW/DEPOSIT", -190, 120, 380, 52, CVCOLOR_GREEN, function(self)
			atmInputStr = ""
			atmStatusMsg = nil
			self:OpenMenu("ATM")
		end),
		CVButton("CREDITS TRANSFER", -190, 182, 380, 45, CVCOLOR_BLUE, function(self)
			transferScrollOffset = 0
			transferScrollDragging = false
			transferSelectedTarget = nil
			transferFilterStr = ""
			self:OpenMenu("Transfer")
		end),
		CVButton("RETURN", -190, 237, 380, 45, CVCOLOR_RED, function(self)
			self:OpenMenu("Main")
		end)
	},
	paint = function(self)

		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.DrawText("CREDITS BALANCE ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		surface.DrawLine(-525, 300, 500, 300)
		local bank = LocalPlayer():GetBankMoney()

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
		surface.DrawRect(-190, -175, 380, 25)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
		surface.DrawRect(-190, -175, 380, 275)
		

		draw.DrawText(
			bank,
			font64,
			0,
			-100,
			lightCombineBlue,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		draw.DrawText(
   			"TOTAL BALANCE",
			font40,
			0,
			-0,
			lightCombineBlue,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
}

ENT.Menus["HB"] = { --WIP
	buttons = {
		CVButton("RETURN", -190, 200, 380, 52, CVCOLOR_RED, function(self)
			self:OpenMenu("Main")
		end),
		CVButton("REGULAR HOUSING", -190, 100, 380, 52, CVCOLOR_RED, function(self)
			self:OpenMenu("")

			net.Start("impulseHL2RPHousingRequest")
				net.WriteEntity(self)
			net.SendToServer()
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("HOUSING SELECTION ", font50, -520, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
}


ENT.Menus["request_handling"] = {
	buttons = {
		CVButton("RESOLVE REQUEST", -190, 110, 380, 72, CVCOLOR_BLUE, function(self)
			
			self:OpenMenu("")
			self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
			self:StopSound("combine_tech/civic_station/station_menu_alarm.wav")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.DrawText(
			"REQUEST SENT",
			font50,
			-400,
			-285,
			Color(10,255,10,100),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		draw.DrawText(
			"Please wait for a response.",
			font50,
			-0,
			-0,
			Color(255,10,10,255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		draw.DrawText(
			"You can mark your request as resolved by pressing the button below.",
			font32,
			-0,
			50,
			color_white,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
}

ENT.Menus["request"] = {
	buttons = {
		CVButton("MAKE REQUEST", -190, 130, 380, 52, CVCOLOR_RED, function(self)
				if not (LocalPlayer():Team() == TEAM_CITIZEN or LocalPlayer():Team() == TEAM_CWU) then 
					self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
					return LocalPlayer():Notify("You must be a Citizen or CWU to do this.") 
				end

				if (LocalPlayer().nextRequest or 0) > CurTime() then 
					self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
					return LocalPlayer():Notify("Please wait a while before sending another request.") 
				end
	
				if LocalPlayer():GetSyncVar(SYNC_ARRESTED, false) then
					self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
					return LocalPlayer():Notify("You can not send a request when arrested.")
				end
	
				if LocalPlayer():IsRebelSmart() then
					self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
					return LocalPlayer():Notify("You can not send a request as a rebel.")
				end
	
				net.Start("impulseHL2RPTerminalRequest")
					net.WriteUInt(LocalPlayer():EntIndex(), 8)
					net.WriteString(LocalPlayer():Nick() .. " requests assistance. (Sent from Terminal: " .. self:EntIndex() .. ")")
				net.SendToServer()
	
				LocalPlayer():Notify("You have sent a request to Civil Protection teams.")
				self:EmitSound("ambient/levels/prison/radio_random2.wav")
				self:EmitSound("combine_tech/civic_station/station_menu_alarm.wav")
				LocalPlayer().nextRequest = CurTime() + 30
				self:OpenMenu("request_handling")
		end),
		CVButton("RETURN", -190, 190, 380, 52, CVCOLOR_RED, function(self)
			self:OpenMenu("Main")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("REQUEST CIVIL AUTHORITIES ", font50, -520, -300, Color(255,10,10,100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		surface.SetDrawColor(lightCombineBlueText)
		surface.SetMaterial(cp)
		surface.DrawTexturedRect(-100, -125, 190, 190)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
		surface.DrawRect(-190, -175, 380, 25)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
		surface.DrawRect(-190, -175, 380, 275)
		

		surface.DrawLine(-525, 300, 500, 300)
	end
}

local function ATMKeypadButton(label, x, y, onuse)
	return CVButton(label, x, y, 110, 45, CVCOLOR_BLUE, onuse)
end

local ROW_X, ROW_W = -20, 320
local ROW_TOP, ROW_H, ROW_GAP = -140, 38, 6
local ROW_PITCH = ROW_H + ROW_GAP
local VISIBLE_ROWS = 6
local SCROLLBAR_X, SCROLLBAR_W = 305, 25

local CID_KP_X = -340
local CID_KP_BTN_W, CID_KP_BTN_H, CID_KP_GAP = 80, 38, 6
local CID_KP_PITCH_X = CID_KP_BTN_W + CID_KP_GAP
local CID_KP_ROW_TOP = -71
local CID_KP_ROW_PITCH = 44
local CID_KP_W = CID_KP_BTN_W * 3 + CID_KP_GAP * 2
local CID_FIELD_Y = CID_KP_ROW_TOP - 50

local function GetDisplayName(ply)
	if ply.IsDebugFake then
		return ply:Nick()
	end
	return ply:RawName()
end

local function GetTransferEligiblePlayers()
	local list = {}
	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and ply ~= LocalPlayer() and not ply:IsCP()
			and ply:Team() ~= TEAM_ZOMBIE and ply:Team() ~= TEAM_STALKER and ply:Team() ~= TEAM_CREMATOR then
			table.insert(list, ply)
		end
	end
	table.sort(list, function(a, b) return a:Nick() < b:Nick() end)
	return list
end

local function TruncateText(text, maxWidth, font)
	surface.SetFont(font)
	local w = surface.GetTextSize(text)
	if w <= maxWidth then return text end

	local ellipsis = "..."
	local truncated = text
	while #truncated > 0 do
		truncated = string.sub(truncated, 1, -2)
		local testW = surface.GetTextSize(truncated .. ellipsis)
		if testW <= maxWidth then
			return truncated .. ellipsis
		end
	end
	return ellipsis
end

local function DrawArc(x, y, radius, thickness, startAng, endAng, seg, color)
	local step = (endAng - startAng) / seg
	surface.SetDrawColor(color)
	draw.NoTexture()
	for i = 0, seg - 1 do
		local ang1 = math.rad(startAng + step * i)
		local ang2 = math.rad(startAng + step * (i + 1))
		local poly = {
			{x = x + math.sin(ang1) * radius, y = y - math.cos(ang1) * radius},
			{x = x + math.sin(ang2) * radius, y = y - math.cos(ang2) * radius},
			{x = x + math.sin(ang2) * (radius - thickness), y = y - math.cos(ang2) * (radius - thickness)},
			{x = x + math.sin(ang1) * (radius - thickness), y = y - math.cos(ang1) * (radius - thickness)}
		}
		surface.DrawPoly(poly)
	end
end

local function DrawSpinner(x, y, radius, thickness, baseAngle, color)
	DrawArc(x, y, radius, thickness, 0, 360, 40, Color(color.r, color.g, color.b, 40))
	DrawArc(x, y, radius, thickness, baseAngle, baseAngle + 90, 24, color)
end

ENT.Menus["ATM"] = {
	buttons = {
		ATMKeypadButton("1", -170, -110, function(self) atmInputStr = atmInputStr .. "1" end),
		ATMKeypadButton("2", -55,  -110, function(self) atmInputStr = atmInputStr .. "2" end),
		ATMKeypadButton("3",  60,  -110, function(self) atmInputStr = atmInputStr .. "3" end),

		ATMKeypadButton("4", -170, -60, function(self) atmInputStr = atmInputStr .. "4" end),
		ATMKeypadButton("5", -55,  -60, function(self) atmInputStr = atmInputStr .. "5" end),
		ATMKeypadButton("6",  60,  -60, function(self) atmInputStr = atmInputStr .. "6" end),

		ATMKeypadButton("7", -170, -10, function(self) atmInputStr = atmInputStr .. "7" end),
		ATMKeypadButton("8", -55,  -10, function(self) atmInputStr = atmInputStr .. "8" end),
		ATMKeypadButton("9",  60,  -10, function(self) atmInputStr = atmInputStr .. "9" end),

		CVButton("CLR", -170, 40, 110, 45, CVCOLOR_RED, function(self) atmInputStr = "" end),
		ATMKeypadButton("0", -55, 40, function(self)
			if atmInputStr ~= "" then
				atmInputStr = atmInputStr .. "0"
			end
		end),
		CVButton("DEL", 60, 40, 110, 45, CVCOLOR_RED, function(self)
			atmInputStr = string.sub(atmInputStr, 1, -2)
		end),

		CVButton("WITHDRAW", -215, 128, 205, 52, CVCOLOR_GREEN, function(self)
			local amount = math.floor(tonumber(atmInputStr) or 0)
			if amount < 1 then return end

			self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
			net.Start("impulseATMWithdraw")
				net.WriteUInt(amount, 32)
			net.SendToServer()
		end),
		CVButton("DEPOSIT", 10, 128, 205, 52, CVCOLOR_GREEN, function(self)
			local amount = math.floor(tonumber(atmInputStr) or 0)
			if amount < 1 then return end

			self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
			net.Start("impulseATMDeposit")
				net.WriteUInt(amount, 32)
			net.SendToServer()
		end),

		CVButton("RETURN", -190, 215, 380, 52, CVCOLOR_RED, function(self)
			self:OpenMenu("balances")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("CREDIT MANAGEMENT ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local prefix = impulse.Config.CurrencyPrefix
		local cash = LocalPlayer():GetSyncVar(SYNC_MONEY, 0)
		local bank = LocalPlayer():GetSyncVar(SYNC_BANKMONEY, 0)

		draw.DrawText("CASH: " .. prefix .. cash .. "   |   BANK: " .. prefix .. bank, font24, 0, -200, lightCombineBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 40)
		surface.DrawRect(-190, -175, 380, 40)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(-190, -175, 380, 40)

		local displayAmount = atmInputStr == "" and "0" or atmInputStr
		local amountText = prefix .. displayAmount
		surface.SetFont(font32)
		local amountW, amountH = surface.GetTextSize(amountText)
		draw.DrawText(amountText, font32, 0, -155 - amountH / 2 - 2, lightCombineBlueText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		if atmStatusMsg and CurTime() < atmStatusExpire then
			draw.DrawText(atmStatusMsg, font24, 0, 180, atmStatusColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		surface.DrawLine(-525, 300, 500, 300)
	end
}

ENT.Menus["Transfer"] = {
	buttons = {
		CVButton("1", CID_KP_X, CID_KP_ROW_TOP, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "1" end
			transferScrollOffset = 0
		end),
		CVButton("2", CID_KP_X + CID_KP_PITCH_X, CID_KP_ROW_TOP, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "2" end
			transferScrollOffset = 0
		end),
		CVButton("3", CID_KP_X + CID_KP_PITCH_X * 2, CID_KP_ROW_TOP, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "3" end
			transferScrollOffset = 0
		end),

		CVButton("4", CID_KP_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "4" end
			transferScrollOffset = 0
		end),
		CVButton("5", CID_KP_X + CID_KP_PITCH_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "5" end
			transferScrollOffset = 0
		end),
		CVButton("6", CID_KP_X + CID_KP_PITCH_X * 2, CID_KP_ROW_TOP + CID_KP_ROW_PITCH, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "6" end
			transferScrollOffset = 0
		end),

		CVButton("7", CID_KP_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 2, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "7" end
			transferScrollOffset = 0
		end),
		CVButton("8", CID_KP_X + CID_KP_PITCH_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 2, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "8" end
			transferScrollOffset = 0
		end),
		CVButton("9", CID_KP_X + CID_KP_PITCH_X * 2, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 2, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "9" end
			transferScrollOffset = 0
		end),

		CVButton("CLR", CID_KP_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 3, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_RED, function(self)
			transferFilterStr = ""
			transferScrollOffset = 0
		end),
		CVButton("0", CID_KP_X + CID_KP_PITCH_X, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 3, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_BLUE, function(self)
			if #transferFilterStr < 10 then transferFilterStr = transferFilterStr .. "0" end
			transferScrollOffset = 0
		end),
		CVButton("DEL", CID_KP_X + CID_KP_PITCH_X * 2, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 3, CID_KP_BTN_W, CID_KP_BTN_H, CVCOLOR_RED, function(self)
			transferFilterStr = string.sub(transferFilterStr, 1, -2)
			transferScrollOffset = 0
		end),

		CVButton("RETURN", -190, 245, 380, 45, CVCOLOR_RED, function(self)
			self:OpenMenu("ATM")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("CREDITS TRANSFER ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local kpFrameX1, kpFrameY1 = CID_KP_X - 12, CID_FIELD_Y - 12
		local kpFrameX2, kpFrameY2 = CID_KP_X + CID_KP_W + 12, CID_KP_ROW_TOP + CID_KP_ROW_PITCH * 3 + CID_KP_BTN_H + 12
		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
		surface.DrawRect(kpFrameX1, kpFrameY1, kpFrameX2 - kpFrameX1, kpFrameY2 - kpFrameY1)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(kpFrameX1, kpFrameY1, kpFrameX2 - kpFrameX1, kpFrameY2 - kpFrameY1)

		local listFrameX1, listFrameY1 = ROW_X - 12, ROW_TOP - 12
		local listFrameX2 = SCROLLBAR_X + SCROLLBAR_W + 12
		local listFrameY2 = ROW_TOP + (VISIBLE_ROWS - 1) * ROW_PITCH + ROW_H + 12
		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
		surface.DrawRect(listFrameX1, listFrameY1, listFrameX2 - listFrameX1, listFrameY2 - listFrameY1)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(listFrameX1, listFrameY1, listFrameX2 - listFrameX1, listFrameY2 - listFrameY1)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 40)
		surface.DrawRect(CID_KP_X, CID_FIELD_Y, CID_KP_W, 40)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(CID_KP_X, CID_FIELD_Y, CID_KP_W, 40)

		local filterDisplay = transferFilterStr == "" and "Search Civic ID" or transferFilterStr
		surface.SetFont(font32)
		local filterW, filterH = surface.GetTextSize(filterDisplay)
		draw.DrawText(filterDisplay, font32, CID_KP_X + CID_KP_W / 2, CID_FIELD_Y + 20 - filterH / 2 + 1, lightCombineBlueText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		local eligible = GetTransferEligiblePlayers()

		if transferFilterStr ~= "" then
			local filtered = {}
			for _, ply in ipairs(eligible) do
				local idTarget = ply.IsDebugFake and ply.RealPlayer or ply
				local idStr = IsValid(idTarget) and tostring(idTarget:GetCivicID()) or ""
				if string.sub(idStr, 1, #transferFilterStr) == transferFilterStr then
					table.insert(filtered, ply)
				end
			end
			eligible = filtered
		end

		local totalRows = #eligible
		local maxOffset = math.max(0, totalRows - VISIBLE_ROWS)
		transferScrollOffset = math.Clamp(transferScrollOffset, 0, maxOffset)

		self.DynamicRows = {}

		for i = 1, math.min(VISIBLE_ROWS, totalRows) do
			local idx = i + transferScrollOffset
			local ply = eligible[idx]
			if ply then
				local y = ROW_TOP + (i - 1) * ROW_PITCH
				local realTarget = ply.IsDebugFake and ply.RealPlayer or ply
				local label = TruncateText(GetDisplayName(ply), ROW_W - 24, font50)
				table.insert(self.DynamicRows, CVButton(label, ROW_X, y, ROW_W, ROW_H, CVCOLOR_BLUE, function(term)
					transferSelectedTarget = realTarget
					transferInputStr = ""
					term:OpenMenu("TransferAmount")
				end))
			end
		end

		if totalRows == 0 then
			local msg = transferFilterStr ~= "" and ("NO MATCHES FOR CID: " .. transferFilterStr) or "NO ELIGIBLE RECIPIENTS ONLINE"
			draw.DrawText(msg, font24, ROW_X + ROW_W / 2, 0, lightCombineBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local trackTop = ROW_TOP
		local trackHeight = (ROW_TOP + (VISIBLE_ROWS - 1) * ROW_PITCH + ROW_H) - trackTop

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 40)
		surface.DrawRect(SCROLLBAR_X, trackTop, SCROLLBAR_W, trackHeight)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(SCROLLBAR_X, trackTop, SCROLLBAR_W, trackHeight)

		if totalRows > VISIBLE_ROWS then
			local thumbH = math.max(20, trackHeight * (VISIBLE_ROWS / totalRows))
			local thumbY = trackTop + (trackHeight - thumbH) * (transferScrollOffset / maxOffset)

			surface.SetDrawColor(lightCombineBlueText)
			surface.DrawRect(SCROLLBAR_X + 3, thumbY, SCROLLBAR_W - 6, thumbH)
		end

		self.TransferScrollTrack = {x = SCROLLBAR_X, w = SCROLLBAR_W, top = trackTop, height = trackHeight, maxOffset = maxOffset, totalRows = totalRows}

		surface.DrawLine(-525, 300, 500, 300)
	end
}

ENT.Menus["TransferAmount"] = {
	buttons = {
		ATMKeypadButton("1", -170, -110, function(self) transferInputStr = transferInputStr .. "1" end),
		ATMKeypadButton("2", -55,  -110, function(self) transferInputStr = transferInputStr .. "2" end),
		ATMKeypadButton("3",  60,  -110, function(self) transferInputStr = transferInputStr .. "3" end),

		ATMKeypadButton("4", -170, -60, function(self) transferInputStr = transferInputStr .. "4" end),
		ATMKeypadButton("5", -55,  -60, function(self) transferInputStr = transferInputStr .. "5" end),
		ATMKeypadButton("6",  60,  -60, function(self) transferInputStr = transferInputStr .. "6" end),

		ATMKeypadButton("7", -170, -10, function(self) transferInputStr = transferInputStr .. "7" end),
		ATMKeypadButton("8", -55,  -10, function(self) transferInputStr = transferInputStr .. "8" end),
		ATMKeypadButton("9",  60,  -10, function(self) transferInputStr = transferInputStr .. "9" end),

		CVButton("CLR", -170, 40, 110, 45, CVCOLOR_RED, function(self) transferInputStr = "" end),
		ATMKeypadButton("0", -55, 40, function(self)
			if transferInputStr ~= "" then
				transferInputStr = transferInputStr .. "0"
			end
		end),
		CVButton("DEL", 60, 40, 110, 45, CVCOLOR_RED, function(self)
			transferInputStr = string.sub(transferInputStr, 1, -2)
		end),

		CVButton("SEND", -215, 110, 205, 45, CVCOLOR_GREEN, function(self)
			if not IsValid(transferSelectedTarget) then
				transferInputStr = ""
				return self:OpenMenu("Transfer")
			end

			local amount = math.floor(tonumber(transferInputStr) or 0)
			if amount < 1 then return end

			self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
			self:OpenMenu("TransferConfirm")
		end),
		CVButton("CANCEL", 10, 110, 205, 45, CVCOLOR_RED, function(self)
			transferInputStr = ""
			self:OpenMenu("Transfer")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("CREDITS TRANSFER ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local recipName = IsValid(transferSelectedTarget) and transferSelectedTarget:RawName() or "UNKNOWN"
		local prefix = impulse.Config.CurrencyPrefix
		local bank = LocalPlayer():GetSyncVar(SYNC_BANKMONEY, 0)

		draw.DrawText("SENDING TO: " .. recipName, font24, 0, -215, lightCombineBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.DrawText("YOUR BANK BALANCE: " .. prefix .. bank, font24, 0, -195, lightCombineBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 40)
		surface.DrawRect(-190, -175, 380, 40)
		surface.SetDrawColor(lightCombineBlueText)
		surface.DrawOutlinedRect(-190, -175, 380, 40)

		local displayAmount = transferInputStr == "" and "0" or transferInputStr
		local amountText = prefix .. displayAmount
		surface.SetFont(font32)
		local amountW, amountH = surface.GetTextSize(amountText)
		draw.DrawText(amountText, font32, 0, -155 - amountH / 2 - 2, lightCombineBlueText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.DrawLine(-525, 300, 500, 300)
	end
}

ENT.Menus["TransferConfirm"] = {
	buttons = {
		CVButton("CONFIRM", -215, 110, 205, 45, CVCOLOR_GREEN, function(self)
			if not IsValid(transferSelectedTarget) then
				transferInputStr = ""
				return self:OpenMenu("Transfer")
			end

			local amount = math.floor(tonumber(transferInputStr) or 0)
			if amount < 1 then
				return self:OpenMenu("TransferAmount")
			end

			transferSending = true
			transferSpinStart = CurTime()
			transferSpinDuration = math.Rand(2, 4)
			transferPendingResult = nil

			self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")

			net.Start("impulseATMTransfer")
				net.WriteEntity(transferSelectedTarget)
				net.WriteUInt(amount, 32)
			net.SendToServer()

			self:OpenMenu("TransferSpinner")
		end),
		CVButton("CANCEL", 10, 110, 205, 45, CVCOLOR_RED, function(self)
			self:OpenMenu("TransferAmount")
		end)
	},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("CONFIRM TRANSFER ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local recipName = IsValid(transferSelectedTarget) and transferSelectedTarget:RawName() or "UNKNOWN"
		local prefix = impulse.Config.CurrencyPrefix
		local displayAmount = transferInputStr == "" and "0" or transferInputStr

		draw.DrawText(
			"You are sending " .. prefix .. displayAmount .. " to " .. recipName .. ".",
			font32,
			0,
			-20,
			lightCombineBlueText,
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		surface.DrawLine(-525, 300, 500, 300)
	end
}

ENT.Menus["TransferSpinner"] = {
	buttons = {},
	paint = function(self)
		surface.DrawLine(-525, -240, 500, -240)
		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.DrawText("PROCESSING TRANSFER ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local elapsed = CurTime() - transferSpinStart
		local spinAngle = (elapsed * 320) % 360

		DrawSpinner(0, -20, 60, 10, spinAngle, lightCombineBlueText)

		draw.DrawText("SENDING...", font24, 0, 60, lightCombineBlue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		if transferPendingResult and elapsed >= transferSpinDuration then
			atmStatusMsg = transferPendingResult.message
			atmStatusColor = transferPendingResult.success and Color(80, 220, 120) or Color(255, 90, 90)
			atmStatusExpire = CurTime() + 4

			transferSending = false
			transferPendingResult = nil
			transferInputStr = ""
			transferSelectedTarget = nil

			self:OpenMenu("balances")
		end

		surface.DrawLine(-525, 300, 500, 300)
	end
}

net.Receive("impulseHL2RPLoyalistTierReturn", function()
    local level = net.ReadUInt(8)
    LocalPlayer().LoyalistTier = level
end)

ENT.Menus['LoyalistTier'] = {
    buttons = {
        CVButton("RETURN", -190, 190, 380, 52, CVCOLOR_RED, function(self)
            self:OpenMenu("Main")
        end)
    },
    paint = function(self)

        surface.DrawLine(-525, -240, 500, -240)
        draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        draw.DrawText("CIVIC STATUS ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.DrawLine(-525, 300, 500, 300)

        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
        surface.DrawRect(-190, -175, 380, 25)

        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
        surface.DrawRect(-190, -175, 380, 275)

        surface.SetDrawColor(lightCombineBlueText)
        surface.DrawLine(0, -160, 0, 40)

		local tier = tostring(LocalPlayer():GetLoyalistLevel())
        draw.DrawText(
            tier,
            font64,
            -95,
            -100,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.DrawText(
            "LOYALIST TIER",
            font32,
            -95,
            -20,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

		local merits = tostring(LocalPlayer():GetCivicMerits())
        draw.DrawText(
            merits,
            font64,
            95,
            -100,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.DrawText(
            "CIVIC MERITS",
            font32,
            95,
            -20,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

		draw.DrawText(
            "CID: ".. LocalPlayer():GetCivicID(),
            font24,
            0,
            60,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        surface.DrawLine(-525, 300, 500, 300)
    end
}

local curBulletin

local MAX_BULLETIN_LENGTH = 500

local function LogOCABExploit(reason, data)
    print(string.format(
        "[OCAB CLIENT BLOCKED] Reason: %s | Data: %s",
        reason,
        tostring(data)
    ))
end

net.Receive("impulseHL2RPOCABReturn", function()
    local text = net.ReadString()
    local updater = net.ReadEntity()

    if not isstring(text) or text == "" then
        LogOCABExploit("Invalid or empty bulletin text", text)
        return
    end

    if #text > MAX_BULLETIN_LENGTH then
        LogOCABExploit("Bulletin text too long", #text)
        return
    end

    if not IsValid(updater) or not updater:IsPlayer() then
        LogOCABExploit("Invalid updater entity", updater)
        return
    end

    text = string.Trim(text)
    curBulletin = text
    chat.AddText(ocaBroadcastCol, "[OCA BROADCAST] ", color_white, updater:Nick(), ocaBroadcastCol, " has updated the O.C.A Bulletin. Please view the civic terminal for more information.")
end)

local function WrapText(text, maxWidth)
    local wrapped = {}
    local currentLine = ""

    for word in string.gmatch(text, "%S+") do
        if #currentLine + #word + 1 > maxWidth then
            table.insert(wrapped, currentLine)
            currentLine = word
        else
            currentLine = currentLine == "" and word or currentLine .. " " .. word
        end
    end

    if currentLine ~= "" then
        table.insert(wrapped, currentLine)
    end

    return wrapped
end

ENT.Menus['OCAB'] = {
    buttons = {
        CVButton("EDIT OCAB", -190, 130, 380, 52, CVCOLOR_BLUE, function(self)
            if LocalPlayer():Team() != TEAM_CA then
                self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
                return LocalPlayer():Notify("You must be a member of the OCA to do this.")
            elseif LocalPlayer():GetTeamRank() == 0 then
            	self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
                return LocalPlayer():Notify("You must have your rank.")
            end

			self:OpenMenu("")

            Derma_StringRequest(
                "Write A Bulletin", 
                "Write a bulletin to the OCA Bulletin.",
                "",
                function(text) 
                    net.Start("impulseHL2RPOCABUpdate")
                        net.WriteString(text)
                        net.WriteEntity(self)
                    net.SendToServer()
                end,
                function(text) return end
            )

            self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
        end),
        CVButton("RETURN", -190, 190, 380, 52, CVCOLOR_RED, function(self)
            self:OpenMenu("Main")
        end)
    },
    paint = function(self)
        surface.DrawLine(-525, -240, 500, -240)
        draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        draw.DrawText("OCA BULLETIN ", font50, -520, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
        surface.DrawRect(-300, -175, 650, 25)

        local maxWidth = 55
        local wrappedText = WrapText(curBulletin or "No Bulletin has been posted.", maxWidth)

        local startY = -150
        for i, line in ipairs(wrappedText) do
            draw.DrawText(line, font32, -290, startY + (i - 1) * 25, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        
        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
        surface.DrawRect(-300, -175, 650, 275)

        surface.DrawLine(-525, 300, 500, 300)
    end
}

ENT.Menus['Commerce'] = {
    buttons = {
--[[        CVButton("PURCHASE DISTRIBUTION PERMIT", -290, -120, 600, 52, CVCOLOR_BLUE, function(self)
            self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
            net.Start("ImpulseHL2RPPurchaseDistPermit")
                net.WritePlayer(LocalPlayer())
            net.SendToServer()
        end),]]--
        CVButton("COMMERICAL SUPPLY ORDER", -290, -50, 600, 52, CVCOLOR_BLUE, function(self)
		    self:EmitSound("combine_tech/civic_station/station_menu_select.mp3")
		    timer.Simple(0, function()
		        vgui.Create("ImpulseCWUBulkOrder")
		    end)
		end),
        CVButton("RETURN", -190, 190, 380, 52, CVCOLOR_RED, function(self)
            self:OpenMenu("Main")
        end)
    },
    paint = function(self)
        surface.DrawLine(-525, -240, 500, -240)
        draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        draw.DrawText("COMMERCE ", font50, -520, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        
        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
        surface.DrawRect(-300, -175, 650, 25)
        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
        surface.DrawRect(-300, -175, 650, 275)

        surface.DrawLine(-525, 300, 500, 300)
    end
}

ENT.Menus["Main"] = {
	buttons = {
		CVButton("CREDIT BALANCE", -190, -190, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("balances")
		end),
		CVButton("REQUEST", -190, -120, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("request")
		end),

		CVButton("CIVIC STATUS", -190, -50, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("LoyalistTier")
		end),

		CVButton("OCA BULLETIN", -190,  20, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("OCAB")
		end),

		CVButton("COMMERCE", -190,  90, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("Commerce")
		end),

		CVButton("EXIT TERMINAL", -190, 160, 380, 52, CVCOLOR_BLUE, function(self)
			self:OpenMenu("")
			self:EmitSound("combine_tech/civic_station/station_menu_disappear.mp3")
		end)
	},
	paint = function(self)
		draw.DrawText("NAVIGATION ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.SetDrawColor(50, 173, 255, 255)
        surface.DrawLine(-525, -240, 500, -240)
		surface.DrawLine(-525, 300, 500, 300)

		draw.DrawText("CIVIC TERMINAL :: " .. self:EntIndex() * 21, font32, 400, -285, lightCombineBlueText, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end
}



ENT.__CurrentMenu = ""

function ENT:OpenMenu(menu_)
    self.__CurrentMenu = menu_
end


function ENT:CurMenu()
	return self.Menus[self.__CurrentMenu], self.__CurrentMenu
end

local cursor
local function ScreenToLocal(x, y)
	return Vector(19, x * 0.02, y * -0.02 + 12)
end

local function IsVGUIOpen()
    for _, panel in pairs(vgui.GetWorldPanel():GetChildren()) do
        if panel:HasFocus() then
           return true
        end
    end
end

local function DrawButton(text, x, y, w, h, color, vguiOpen, font)
    if vguiOpen then
        return false
    end

    font = font or font50

    local hovered = false
    if cursor then
        -- Pixel-perfect hover detection
        local myLocalPos = ScreenToLocal(x + w / 2, y + h / 2)
        local wdist = math.abs(cursor.y - myLocalPos.y)
        local hdist = math.abs(cursor.z - myLocalPos.z)

        hovered = (wdist < w * 0.01 and hdist < h * 0.01)
    end

    color = color or CVCOLOR_NORMAL

    if hovered then
        surface.SetDrawColor(lightCombineBlue) -- Hovered background color
    else
        surface.SetDrawColor(Color(255, 255, 255, 0))
    end
    surface.DrawRect(x, y, w, h)

    surface.SetDrawColor(lightCombineBlueText)
    surface.DrawOutlinedRect(x, y, w, h, 3.5)

    -- Draw button text
    surface.SetFont(font)
    local textW, textH = surface.GetTextSize(text)
    draw.DrawText(
        text,
        font,
        x + w / 2,
        y + h / 2 - textH / 2 - 3,
        lightCombineBlueText, -- Hovered or default text color
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_TOP
    )
    return hovered
end
ENT.UIVisibleTime = 0

local DRAW_POS = Vector(-27, 1, 0)
local DRAW_ANG = Angle(0, 261, 90)
local DIST_CHECK_INTERVAL = 0.15

function ENT:Draw()
    self:DrawModel()
    local lp = LocalPlayer()

    if not self.CachedPos then
        self.CachedPos = self:GetPos()
    end

    if (self.NextDistCheck or 0) <= CurTime() then
        self.NextDistCheck = CurTime() + DIST_CHECK_INTERVAL
        self.InRange = lp:GetPos():DistToSqr(self.CachedPos) <= 95 * 95
    end

    if self.InRange then
        if self.UIVisibleTime == 0 then
            self.UIVisibleTime = CurTime() + .25
        end
    else
        self.UIVisibleTime = 0
        return
    end

    if CurTime() < self.UIVisibleTime then return end

    local glowPos = self:LocalToWorld(Vector(-15, 0, 0))
    render.SetMaterial(sprite_light_ignorez) 
    render.DrawSprite(glowPos, 110, 75, Color(50, 173, 255, 5)) -- Blue Glow

	local glowPos2 = self:LocalToWorld(Vector(-24, 20.5, 2))
	render.SetMaterial(sprite_light_ignorez) 
	local alpha = 100 * math.abs(math.sin(CurTime() * 2))
	render.DrawSprite(glowPos2, 2, 2, Color(0, 255, 0, alpha))

   	local worldPos = self:LocalToWorld(DRAW_POS)
	local worldAng = self:LocalToWorldAngles(DRAW_ANG)

	local trace = util.IntersectRayWithPlane(
	    lp:EyePos(),
	    lp:GetAimVector(),
	    worldPos,
	    worldAng:Up()
	)

	local cx, cy = nil, nil
	if trace then
	    local diff = trace - worldPos
	    local scale = 0.02
	    cx = math.Clamp(diff:Dot(worldAng:Forward()) / scale, -565, 565)
            cy = math.Clamp(diff:Dot(worldAng:Right()) / scale, -365, 365)
	end

	cam.Start3D2D(worldPos, worldAng, 0.02)

	    if cx then
	        surface.SetDrawColor(255, 255, 255, 200)
	        surface.DrawCircle(cx, cy, 8, 255, 255, 255, 255)
	    end

        surface.SetDrawColor(20, 80, 199, 1)
        surface.SetMaterial(Glowie2)
        surface.DrawTexturedRectUV(-565, -365, 1130, 730, -0, -0, 1, .4)

        surface.SetMaterial(claw_icon)
        surface.SetDrawColor(50, 173, 255, 255)
        surface.DrawTexturedRect(425, -325, 100, 100)

        local activemenu = self.Menus[self.__CurrentMenu]
        if activemenu then
            activemenu.paint(self)

            local buttonsToRender = activemenu.buttons
            if self.__CurrentMenu == "Transfer" and self.DynamicRows then
                buttonsToRender = {}
                for _, b in ipairs(activemenu.buttons or {}) do table.insert(buttonsToRender, b) end
                for _, b in ipairs(self.DynamicRows) do table.insert(buttonsToRender, b) end
            end

            if buttonsToRender and cx then
                local vguiOpen = IsVGUIOpen()
                for k, v in ipairs(buttonsToRender) do
                    local x, y, w, h = v[2], v[3], v[4], v[5]
                    local hovered = cx >= x and cx <= x + w and cy >= y and cy <= y + h

                    if hovered then
                        surface.SetDrawColor(100, 200, 255, 10 * math.abs(math.sin(CurTime() * 4)))
                        surface.DrawRect(x - 1, y - 1, w + 2, h + 2)
                    end

                    DrawButton(v[1], v[2], v[3], v[4], v[5], v[6], vguiOpen, v[8])

                    if hovered and input.IsKeyDown(KEY_E) and not self._clickCooldown then
						if vguiOpen then
							return
						end

						self._clickCooldown = true
						timer.Simple(0.2, function()
							if IsValid(self) then
								self._clickCooldown = false
							end
						end)

						if isfunction(v[7]) then
							v[7](self)
						end

						surface.PlaySound("combine_tech/civic_station/station_menu_hover.mp3")
					end
				end
            end

            if self.__CurrentMenu == "Transfer" and cx then
                local track = self.TransferScrollTrack
                if track and track.totalRows > VISIBLE_ROWS then
                    local overThumb = cx >= track.x and cx <= track.x + track.w and cy >= track.top and cy <= track.top + track.height
                    local vguiOpenDrag = IsVGUIOpen()

                    if not transferScrollDragging then
                        if overThumb and input.IsKeyDown(KEY_E) and not vguiOpenDrag then
                            transferScrollDragging = true
                            transferScrollDragStartCY = cy
                            transferScrollDragStartOffset = transferScrollOffset
                        end
                    else
                        if not input.IsKeyDown(KEY_E) then
                            transferScrollDragging = false
                        else
                            local deltaY = cy - transferScrollDragStartCY
                            local thumbH = math.max(20, track.height * (VISIBLE_ROWS / track.totalRows))
                            local scrollableTrackPx = track.height - thumbH
                            local deltaRows = 0
                            if scrollableTrackPx > 0 then
                                deltaRows = (deltaY / scrollableTrackPx) * track.maxOffset
                            end
                            transferScrollOffset = math.Clamp(math.floor(transferScrollDragStartOffset + deltaRows + 0.5), 0, track.maxOffset)
                        end
                    end
                else
                    transferScrollDragging = false
                end
            else
                transferScrollDragging = false
            end
        end

    cam.End3D2D()
end
