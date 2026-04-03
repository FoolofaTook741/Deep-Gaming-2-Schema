include("shared.lua")

local rations
local rationsCode
local lockdownCode
local socioStatus
 -- Load this

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

function CVButton(text, x, y, w, h, color, onuse)
	return {text, x, y, w, h, color, onuse}
end

ENT.Menus = {}

net.Receive("deepupdatedecree", function() 
	local id = net.ReadUInt(3)
	local boole = net.ReadBool()
	if id == 1 then 
		rations = boole
	elseif id == 2 then
		lockdownCode = boole
	else
		separation = boole
	end
end)

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
        if rations == true then 
            color_text = Color(0,255,0)
            rationsCode = "INACTIVE"
        else
            color_text = Color(255,0,0)
            rationsCode = "ACTIVE"
        end
        draw.DrawText("RATION SUSPENSION STATUS :: " .. rationsCode, font64, -450, -200, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        local lckdt = "UNKNOWN"
        if lockdownCode == true then 
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
		CVButton("WITHDRAW/DEPOSIT", -190, 140, 380, 52, CVCOLOR_GREEN, function(self)
			vgui.Create("impulseATMMenu")
		end),
		CVButton("RETURN", -190, 200, 380, 52, CVCOLOR_RED, function(self)
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

        draw.DrawText("LOYALIST TIER ", font50, -450, -300, lightCombineBlueText, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        surface.DrawLine(-525, 300, 500, 300)

        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g + 20, lightCombineBlue.b + 20, 30)
        surface.DrawRect(-190, -175, 380, 25)

        surface.SetDrawColor(lightCombineBlue.r, lightCombineBlue.g, lightCombineBlue.b, 30)
        surface.DrawRect(-190, -175, 380, 275)

		local tier = LocalPlayer().LoyalistTier
		tier = (tier == nil) and "Loading..." or tostring(tier)
        draw.DrawText(
            tier,
            font64,
            0,
            -100,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.DrawText(
            "LOYALIST TIER",
            font40,
            0,
            -0,
            lightCombineBlue,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

		draw.DrawText(
            "CID: ".. LocalPlayer():SteamID64(),
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
            end

            if LocalPlayer():GetTeamRank() < RANK_REPRESENTATIVE then
                self:EmitSound("combine_tech/civic_station/station_menu_select_denied.mp3")
                return LocalPlayer():Notify("You must be a Representative+ to do this.")
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
            vgui.Create("ImpulseCWUBulkOrder")
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

		CVButton("CITIZEN STATUS", -190, -50, 380, 52, CVCOLOR_BLUE, function(self)
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

    if menu_ == "LoyalistTier" then
        LocalPlayer().LoyalistTier = nil

        if (self._nextLoyalistReq or 0) > CurTime() then return end
        self._nextLoyalistReq = CurTime() + 2

        net.Start("impulseHL2RPGetLoyalistTier")
            net.WriteEntity(self)
        net.SendToServer()
    end
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

local function DrawButton(text, x, y, w, h, color)
    if IsVGUIOpen() then
        return false
    end

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

    surface.SetDrawColor(OLCol[color][hovered and 2 or 1])
    surface.DrawOutlinedRect(x, y, w, h, 3.5)

    -- Draw button text
    draw.DrawText(
        text,
        font50,
        x + w / 2,
        y + h / 2 - 25,
        hovered and lightCombineBlueText or combineBlue, -- Hovered or default text color
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    return hovered
end
ENT.UIVisibleTime = 0

function ENT:Draw()
    self:DrawModel()
    local pos = Vector(-28, 0, 0)
    local ang = Angle(0, 263, 90)
    local lp = LocalPlayer()

    if lp:GetPos():DistToSqr(self:GetPos()) <= 95 * 95 then
        if self.UIVisibleTime == 0 then
            self.UIVisibleTime = CurTime() + 0.1
        end
    else
        self.UIVisibleTime = 0
        return
    end

    if CurTime() < self.UIVisibleTime then return end

    local glowPos = self:LocalToWorld(Vector(-15, 0, 0))
    render.SetMaterial(Material("sprites/light_ignorez")) 
    render.DrawSprite(glowPos, 110, 75, Color(50, 173, 255, 5)) -- Blue Glow

	local glowPos = self:LocalToWorld(Vector(-24, 20.5, 2))
	render.SetMaterial(Material("sprites/light_ignorez")) 
	local alpha = 100 * math.abs(math.sin(CurTime() * 2))
	render.DrawSprite(glowPos, 2, 2, Color(0, 255, 0, alpha)) 

    local trace = util.IntersectRayWithPlane(
        lp:EyePos(),
        lp:GetAimVector(),
        self:LocalToWorld(pos),
        self:LocalToWorldAngles(ang):Up()
    )

    local cursor = nil
    if trace then
        cursor = self:WorldToLocal(trace)
        cursor.y = math.Clamp(cursor.y, -11.3, 11.3)
        cursor.z = math.Clamp(cursor.z, -7.3, 7.3)
    end

    cam.Start3D2D(self:LocalToWorld(pos), self:LocalToWorldAngles(ang), 0.02)

        local cx, cy = 0, 0
        if cursor then
            cx = -(cursor.y) * 50
            cy = -(cursor.z) * 50
            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawCircle(cx, cy, 8, 255, 255, 255, 255)
        end

        surface.SetDrawColor(20, 80, 199, 1)
        surface.SetMaterial(Glowie2)
        surface.DrawTexturedRectUV(-565, -365, 1130, 730, -0, -0, 1, .4)

        surface.SetMaterial(Material("icons/npc_icon_combineclaw.png"))
        surface.SetDrawColor(50, 173, 255, 255)
        surface.DrawTexturedRect(425, -325, 100, 100)

        local activemenu = self.Menus[self.__CurrentMenu]
        if activemenu then
            activemenu.paint(self)

            if activemenu.buttons and cursor then
                for k, v in ipairs(activemenu.buttons) do
                    local x, y, w, h = v[2], v[3], v[4], v[5]
                    local hovered = cx >= x and cx <= x + w and cy >= y and cy <= y + h

                    if hovered then
                        surface.SetDrawColor(100, 200, 255, 10 * math.abs(math.sin(CurTime() * 4)))
                        surface.DrawRect(x - 1, y - 1, w + 2, h + 2)
                    end

                    DrawButton(unpack(v))

					if hovered and input.IsKeyDown(KEY_E) and not self._clickCooldown then
						if IsVGUIOpen() then
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
        end

    cam.End3D2D()
end
