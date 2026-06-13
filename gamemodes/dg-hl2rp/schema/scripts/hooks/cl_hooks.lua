function SCHEMA:ProcessICChatMessage(sender, message)
	if sender:IsCP() and sender:Team() != TEAM_CA then
		return "<:: "..message.." ::>"
	end
end

function SCHEMA:DefineSettings()
	impulse.DefineSetting("misc_localfootstepvol", {name="Local footstep volume", category="Misc", type="slider", default=65, minValue=30, maxValue=100})
end

function SCHEMA:PlayerGetJailData(duration, jailData)
	local cycles = duration / 60
	local reasons = "Your sentence length has been changed to "..cycles.." cycles in prison."

	if jailData then
		reasons = "You have been found guilty by Civil Protection of the following act(s):\n"

		for v,k in pairs(jailData) do
			reasons = reasons..impulse.Config.ArrestCharges[k].name.."\n"
		end

		reasons = reasons.."\nAs a punishment you have been assigned to serve "..cycles.." cycles in prison.\nCo-operation and civil behaviour may warrant a reduced sentence.\n\n\nWARNING: Disconnecting from the game will reset your sentence."
	end
	Derma_Message(reasons, "Your charges", "ACCEPT")
end

function SCHEMA:PlayerFootstep(ply, pos, foot, soundName, vol)
	if ply:KeyDown(IN_SPEED) then
		if ply:Team() == TEAM_CP then
			if ply == LocalPlayer() then
				EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav", ply:GetPos(), -1, nil, impulse.GetSetting("misc_localfootstepvol", 65) / 100)
			else
				ply:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav", 90)
			end

			return true
		elseif ply:Team() == TEAM_OTA and ply:GetTeamClass() ~= CLASS_PAYBACK then
			if ply == LocalPlayer() then
				EmitSound("npc/combine_soldier/gear"..math.random(1,6)..".wav", ply:GetPos(), -1, nil, impulse.GetSetting("misc_localfootstepvol", 65) / 100)
			else
				ply:EmitSound("npc/combine_soldier/gear"..math.random(1,6)..".wav", 100)
			end

			return true
		elseif ply:Team() == TEAM_VORT then
			if ply == LocalPlayer() then
				EmitSound("npc/vort/vort_foot"..math.random(1,4)..".wav", ply:GetPos(), -1, nil, impulse.GetSetting("misc_localfootstepvol", 65) / 100)
			else
				ply:EmitSound("npc/vort/vort_foot"..math.random(1,4)..".wav", 100)
			end
		end
	end
end

function SCHEMA:PlayerGetKnownName(target)
	if target:GetSyncVar(SYNC_COS_FACE, 0) == 4 and LocalPlayer() != target then -- if wearning facewrap
		return ("Unknown (" .. target:SteamID64() .. ")")
	end
end

function SCHEMA:RenderScreenspaceEffects()
	if impulse_beingGassed and LocalPlayer():Alive() then
		if impulse_beingGassed > CurTime() then
			DrawMotionBlur(0.06, 2, 0.01)
		else
			impulse_beingGassed = nil
		end
	end
end

local blur = Material("pp/blurscreen")
function SCHEMA:HUDPaint()
	if impulse_beingGassed and LocalPlayer():Alive() then
		local X, Y = 0, 0
		local x, y = 0, 0
		local w, h = ScrW(), ScrH()

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

function SCHEMA:RagdollMenuAddOptions(panel, body)
	if not LocalPlayer():IsCP() or LocalPlayer():GetTeamClass() != CLASS_JURY then
		return
	end

	panel:AddAction("impulse/icons/detective-256.png", "Investigate Body", function()
		panel:Remove()

		if impulse.Anim.GetModelClass(body:GetModel()) == "metrocop" then
			impulse.MakeWorkbar(15, "Inspecting body...", function()
				if not IsValid(body) or not LocalPlayer():IsCP() or not LocalPlayer():Alive() then
					return
				end

				impulse.MakeWorkbar(15, "Reviewing bodycam footage...", function()
					if not IsValid(body) then
						return
					end

					net.Start("impulseHL2RPInspectBody")
					net.WriteEntity(body)
					net.SendToServer()
				end, true)
			end, true)
		else
			impulse.MakeWorkbar(15, "Inspecting body...", function()
				if not IsValid(body) then
					return
				end

				if body:GetModel() == "models/gibs/fast_zombie_legs.mdl" then
					Derma_Message("A skeleton remains, with most of it's flesh ripped off...\nWhat happened here?", "impulse", "Close")
					return
				end

				net.Start("impulseHL2RPInspectBody")
				net.WriteEntity(body)
				net.SendToServer()
			end, true)
		end
	end)
end

local range = impulse.Config.VortessenceRange ^ 2
local zomrange = 1000
local col = Color(138, 43, 226)
local zomcol = Color(150,0,0)
local nextVortScan = 0
local nextZomScan = 0
local plys = {}
hook.Add("PostDrawEffects", "Zombie_VortOutline", function()
	if LocalPlayer():Team() == TEAM_VORT then
		if not VORTESSENCE_EXPIRE or VORTESSENCE_EXPIRE < CurTime() then
			return
		end

		if LocalPlayer():Team() != TEAM_VORT then
			VORTESSENCE_EXPIRE = nil
			return
		end

		if not LocalPlayer():Alive() then
			VORTESSENCE_EXPIRE = nil
			return
		end

		if nextVortScan < CurTime() then
			local pos = LocalPlayer():GetPos()
			plys = {}

			for v,k in pairs(player.GetAll()) do
				if not k:GetNoDraw() and k.GetPos(k):DistToSqr(pos) < range then
					table.insert(plys, k)
				end
			end

			nextVortScan = CurTime() + 0.5
		end

		--halo.Add(plys, col, 5, 5, 1, true, true)
		outline.Add(plys, col, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	elseif LocalPlayer():Team() == TEAM_ZOMBIE and LocalPlayer():Name() == "Zombified Rebel" then
		if nextZomScan < CurTime() then
			local pos = LocalPlayer():GetPos()
			plys = {}
			for v,k in pairs(player.GetAll()) do
				if not k:GetNoDraw() and k.GetPos(k):DistToSqr(pos) < range	 then
					table.insert(plys, k)
				end
			end
			nextZomScan = CurTime() + 0.5
		end
		--halo.Add(plys, zomcol, 2, 2, 1, true, true)
		outline.Add(plys, zomcol, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
	end
end)

-- Bye bye thirdperson peeking.
--[[
hook.Add("PrePlayerDraw", "VisibilityCheck", function(ply)
    local lp = LocalPlayer()

    if lp:IsScanner() then return end
    if not IsValid(lp) or ply == lp then return end
    if ply:InVehicle() then return end

    local eyePos = lp:EyePos()

    local trace = util.TraceLine({
        start = eyePos,
        endpos = ply:EyePos(),
        filter = lp
    })

	if trace.Hit and trace.Entity != ply then
        local class = trace.Entity:GetClass()

        if class == "prop_physics" or class == "prop_physics_multiplayer" or class == "prop_dynamic" then
            return
        else
            return true
        end
    end
end)

Disabled for now
]]-- 



--- Markup helper functions
-- @module Markup

impulse.Markup = impulse.Markup or {}


local MARKUP_HELPER = {}

function MARKUP_HELPER:AddElement(element)
	self.elements[#self.elements + 1] = element
end

function MARKUP_HELPER:AppendText(text)
	self:AddElement({
		type = "text",
		text = text
	})
end

function MARKUP_HELPER:SetGlobalFont(font)
	self.globalFont = font
end

function MARKUP_HELPER:SetGlobalColor(color)
	self.globalColor = color
end

function MARKUP_HELPER:Parse()
	local elements = self.elements
	local globalFont = self.globalFont
	local globalColor = self.globalColor

	local output = ""
	output = output .. [[<font=]] .. globalFont .. [[>]] -- set global font
	output = output .. [[<color=]] .. globalColor.r .. "," .. globalColor.g .. "," .. globalColor.b .. "," .. globalColor.a .. [[>]] -- set global color

	for k, v in ipairs(elements) do
		if (v.type == "text") then
			local text = v.text
			local font = v.font or globalFont
			local color = v.color or globalColor

			if (font != globalFont) then
				output = output .. [[</font>]] -- close previous font
				output = output .. [[<font=]] .. font .. [[>]] -- open new font
			end

			if (color != globalColor) then
				output = output .. [[</color>]] -- close previous color
				output = output .. [[<color=]] .. color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a .. [[>]] -- open new color
			end
			
			self:SetGlobalFont(font)
			self:SetGlobalColor(color)

			output = output .. text
		end
	end

	output = output .. [[</color>]] -- close color
	output = output .. [[</font>]] -- close font

	return output
end

function impulse.Markup.Create()
	return setmetatable({
		elements = {},
		globalFont = "impulse-Elements18",
		globalColor = color_white 
	}, {__index = MARKUP_HELPER})
end

hook.Add("RenderScreenspaceEffects", "PGHL2RP-Filter", function()
    local tab = {}
    tab[ "$pp_colour_addr" ] = 0
    tab[ "$pp_colour_addg" ] = 0
    tab[ "$pp_colour_addb" ] = 0
    tab[ "$pp_colour_brightness" ] = 0.03
    tab[ "$pp_colour_contrast" ] = 1.15
    tab[ "$pp_colour_colour" ] = 1.15
    tab[ "$pp_colour_mulr" ] = 0
    tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0

    DrawColorModify(tab)
end)


matproxy.Add({
    name = "HairColor",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, (ent.GetHairColor and ent:GetHairColor():ToVector()) or Vector(1, 1, 1))
   end
})

matproxy.Add({
    name = "PantsColor",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, (ent.GetPantsColor and ent:GetPantsColor():ToVector()) or Vector(1, 1, 1))
   end
})

matproxy.Add({
    name = "TorsoColor",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, (ent.GetTorsoColor and ent:GetTorsoColor():ToVector()) or Vector(1, 1, 1))
   end
})

matproxy.Add({
    name = "ShirtColor",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, (ent.GetShirtColor and ent:GetShirtColor():ToVector()) or Vector(1, 1, 1))
   end
})

matproxy.Add({
    name = "HeadGearColor",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
    end,
    bind = function(self, mat, ent)
        mat:SetVector(self.ResultTo, (ent.GetHeadGearColor and ent:GetHeadGearColor():ToVector()) or Vector(1, 1, 1))
   end
})

net.Receive("ixSetHairColor", function()
    --print("[DEBUG] ixSetHairColor received")

    local sid64 = net.ReadString()
    local color = net.ReadColor(true)

    if not sid64 or sid64 == "" then
        --print("[DEBUG] sid64 missing/empty")
        return
    end

    if not color then
        --print("[DEBUG] Color is NIL")
        return
    end
--[[
    print(string.format(
        "[DEBUG] Payload: sid64=%s colour=R=%d G=%d B=%d A=%d",
        sid64,
        color.r or -1,
        color.g or -1,
        color.b or -1,
        color.a or -1
    ))

--]]


    local timerName = "ixSetHairColor_apply_" .. sid64
    timer.Remove(timerName)

    local tries = 0
    timer.Create(timerName, 0.1, 80, function()
        tries = tries + 1

        local ent = player.GetBySteamID64(sid64)
        if IsValid(ent) then
            --print("[DEBUG] Resolved player after tries=", tries, "->", ent:Nick())
            ent:SetHairColor(color)
            timer.Remove(timerName)
        elseif tries % 10 == 0 then
            --print("[DEBUG] Waiting for player entity sid64=", sid64, "tries=", tries)
        end
    end)
end)

net.Receive("ixSetPantsColor", function()
    local ent = net.ReadEntity()
    if ( !IsValid(ent) ) then return end

    local color = net.ReadColor(true)

    if ( IsValid(ent) ) then
        ent:SetPantsColor(color)
    end
end)

net.Receive("ixSetTorsoColor", function()
    local ent = net.ReadEntity()
    if ( !IsValid(ent) ) then return end

    local color = net.ReadColor(true)

    if ( IsValid(ent) ) then
        ent:SetTorsoColor(color)
    end
end)

net.Receive("ixSetShirtColor", function()
    local ent = net.ReadEntity()
    if ( !IsValid(ent) ) then return end

    local color = net.ReadColor(true)

    if ( IsValid(ent) ) then
        ent:SetShirtColor(color)
    end
end)

net.Receive("ixSetHeadGearColor", function()
    local ent = net.ReadEntity()
    if ( !IsValid(ent) ) then return end

    local color = net.ReadColor(true)

    if ( IsValid(ent) ) then
        ent:SetHeadGearColor(color)
    end
end)

net.Receive("impulse.HairDye", function()
    local dframe = vgui.Create("DFrame")
    dframe:Center()
    dframe:MakePopup()
    dframe:SetTitle("Hair Dye")
    dframe:SetSize(500, 400)

    local characterPreview = dframe:Add("DModelPanel")
    characterPreview:Dock(LEFT)
    characterPreview:SetWide(200)
    characterPreview:SetFOV(30)
    characterPreview:SetModel(LocalPlayer():GetModel())
    characterPreview.Entity:SetSkin(LocalPlayer():GetSkin())
    
    local bodygroups = LocalPlayer():GetBodyGroups()
    for i = 0, #bodygroups do
        characterPreview.Entity:SetBodygroup(i, LocalPlayer():GetBodygroup(i))
    end

    local colourMixer = dframe:Add("DColorMixer")
    colourMixer:Dock(TOP)
    colourMixer:SetColor(LocalPlayer():GetHairColor())

    characterPreview.LayoutEntity = function(t, entity)
        entity:SetAngles(Angle(0, 45, 0))
        entity:SetHairColor(colourMixer:GetColor())
    end
    
    local button = dframe:Add("DButton")
    button:SetText("Dye Hair")
    button:Dock(BOTTOM)
    button.DoClick = function()
        local colour = colourMixer:GetColor()
        net.Start("impulse.HairDye")
            net.WriteColor(colour, true)
        net.SendToServer()

        dframe:Remove()
    end
end)


net.Receive("impulse.SyncColours", function()
    local target = net.ReadPlayer()
    local hairColour = net.ReadColor()
    local torsoColour = net.ReadColor()
    local shirtColour = net.ReadColor()
    local headGearColour = net.ReadColor()
    local pantsColour = net.ReadColor()

    if ( IsValid(target) ) then
        target:SetHairColor(hairColour)
        target:SetTorsoColor(torsoColour)
        target:SetShirtColor(shirtColour)
        target:SetHeadGearColor(headGearColour)
        target:SetPantsColor(pantsColour)
    end
end)

hook.Add("OnPlayerChangedTeam", "VortessenceClearESP", function(ply, oldTeam, newTeam)
    if ply ~= LocalPlayer() then return end
    if oldTeam ~= TEAM_VORT then return end
    VORTESSENCE_EXPIRE = nil
end)

surface.CreateFont("DeepSpawnTitle", {
    font      = "Roboto",
    size      = 28,
    weight    = 700,
    antialias = true,
})
surface.CreateFont("DeepSpawnSub", {
    font      = "Roboto",
    size      = 15,
    weight    = 400,
    antialias = true,
})
surface.CreateFont("DeepSpawnBtn", {
    font      = "Roboto",
    size      = 17,
    weight    = 600,
    antialias = true,
})
surface.CreateFont("DeepSpawnDesc", {
    font      = "Roboto",
    size      = 13,
    weight    = 400,
    antialias = true,
})
surface.CreateFont("DeepSpawnClose", {
    font      = "Roboto",
    size      = 18,
    weight    = 700,
    antialias = true,
})

local COL_BG        = Color(12,  12,  14,  240)
local COL_PANEL     = Color(20,  22,  26,  255)
local COL_BORDER    = Color(45,  50,  60,  255)
local COL_ACCENT    = Color(65, 105, 200, 255)
local COL_WHITE     = Color(230, 230, 230, 255)
local COL_MUTED     = Color(130, 130, 140, 255)
local COL_DISABLED  = Color(60,  60,  65,  255)
local COL_HOVER     = Color(30,  35,  45,  255)
local COL_BTN       = Color(22,  26,  34,  255)
local COL_BTN_HOVER = Color(38,  45,  62,  255)
local COL_ATTACK    = Color(180, 40,  40,  255)
local COL_LOCKED    = Color(80,  80,  85,  255)
local COL_CLOSE     = Color(160, 40,  40,  255)
local COL_CLOSE_H   = Color(200, 60,  60,  255)

local CARD_W   = 280
local CARD_H   = 360
local CARD_GAP = 24
local IMG_H    = 160

local function WordWrap(text, font, maxW)
    surface.SetFont(font)
    local words = string.Explode(" ", text)
    local lines = {}
    local line  = ""
    for _, word in ipairs(words) do
        local test = line == "" and word or (line .. " " .. word)
        local w    = surface.GetTextSize(test)
        if w > maxW and line ~= "" then
            table.insert(lines, line)
            line = word
        else
            line = test
        end
    end
    if line ~= "" then table.insert(lines, line) end
    return lines
end

local LOCATION_DATA = {
    Nexus = {
        label  = "NEXUS",
        desc   = "Central command and processing. Standard reporting location for on-duty units.",
    },
    FOB = {
        label  = "FOB",
        desc   = "Forward Operating Base. Tactical staging point for field operations.",
        cpOnly = true,
    },
    OZ = {
        label  = "OZ",
        desc   = "Elite Protection Unit staging area. Restricted to authorised personnel.",
    },
}

local function GetLocationImage(locationName)
    local key  = locationName .. "SpawnPicture"
    local path = impulse.Config and impulse.Config[key]
    if path and path ~= "" then
        return Material(path, "noclamp smooth")
    end
    return nil
end

local spawnPanel    = nil
local pendingTeamID = nil

local function CloseSpawnUI()
    if IsValid(spawnPanel) then
        spawnPanel:Remove()
        spawnPanel = nil
    end
    pendingTeamID = nil
end

local function SendChoice(choice)
    if not pendingTeamID then return end
    net.Start("DeepSpawnTeamChange")
        net.WriteUInt(pendingTeamID, 8)
        net.WriteString(choice)
    net.SendToServer()
    CloseSpawnUI()
end

local function BuildCard(parent, locationName, data, enabled, attackedMsg, ox, oy)
    local card = vgui.Create("DPanel", parent)
    card:SetPos(ox, oy)
    card:SetSize(CARD_W, CARD_H)
    card.hovering = false

    card.Paint = function(self, w, h)
        local borderCol = enabled and (self.hovering and COL_ACCENT or COL_BORDER) or COL_DISABLED
        local bgCol     = enabled and (self.hovering and COL_HOVER or COL_PANEL) or COL_PANEL
        draw.RoundedBox(6, 0, 0, w, h, bgCol)
        surface.SetDrawColor(borderCol)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        if enabled then
            draw.RoundedBoxEx(6, 0, 0, w, 3, COL_ACCENT, true, true, false, false)
        end
    end

    card.OnMouseEntered = function(self) self.hovering = enabled end
    card.OnMouseExited  = function(self) self.hovering = false   end

    local imgPanel = vgui.Create("DPanel", card)
    imgPanel:SetPos(0, 0)
    imgPanel:SetSize(CARD_W, IMG_H)
    local mat = GetLocationImage(locationName)
    imgPanel.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, Color(18, 20, 24), true, true, false, false)
        if mat then
            surface.SetDrawColor(255, 255, 255, enabled and 255 or 80)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(0, 0, w, h)
        else
            draw.SimpleText(data.label, "DeepSpawnTitle", w/2, h/2,
                enabled and COL_MUTED or COL_DISABLED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        if not enabled then
            draw.RoundedBoxEx(6, 0, 0, w, h, Color(0, 0, 0, 140), true, true, false, false)
        end
    end

    local labelY = IMG_H + 10
    local lbl = vgui.Create("DLabel", card)
    lbl:SetPos(12, labelY)
    lbl:SetSize(CARD_W - 24, 24)
    lbl:SetFont("DeepSpawnBtn")
    lbl:SetText(data.label)
    lbl:SetTextColor(enabled and COL_WHITE or COL_MUTED)

    local msgY = labelY + 26
    if attackedMsg then
        local msg = vgui.Create("DLabel", card)
        msg:SetPos(12, msgY)
        msg:SetSize(CARD_W - 24, 16)
        msg:SetFont("DeepSpawnDesc")
        msg:SetText(attackedMsg)
        msg:SetTextColor(COL_ATTACK)
        msgY = msgY + 18
    end

    local descPanel = vgui.Create("DPanel", card)
    descPanel:SetPos(12, msgY)
    descPanel:SetSize(CARD_W - 24, CARD_H - msgY - 44)
    descPanel.Paint = function() end

    local lines = WordWrap(data.desc, "DeepSpawnDesc", CARD_W - 24)
    local dy = 0
    for _, line in ipairs(lines) do
        local dl = vgui.Create("DLabel", descPanel)
        dl:SetPos(0, dy)
        dl:SetSize(CARD_W - 24, 18)
        dl:SetFont("DeepSpawnDesc")
        dl:SetText(line)
        dl:SetTextColor(enabled and COL_MUTED or COL_DISABLED)
        dy = dy + 18
    end

    local btn = vgui.Create("DButton", card)
    btn:SetPos(12, CARD_H - 38)
    btn:SetSize(CARD_W - 24, 30)
    btn:SetText("")

    btn.Paint = function(self, w, h)
        local bg = enabled and (self:IsHovered() and COL_BTN_HOVER or COL_BTN) or COL_DISABLED
        local tc = enabled and COL_WHITE or COL_LOCKED
        draw.RoundedBox(4, 0, 0, w, h, bg)
        if enabled then
            surface.SetDrawColor(self:IsHovered() and COL_ACCENT or COL_BORDER)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end
        draw.SimpleText(
            enabled and ("DEPLOY TO " .. data.label) or "UNAVAILABLE",
            "DeepSpawnBtn", w/2, h/2, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if enabled then
        btn.DoClick = function()
            surface.PlaySound("buttons/button15.wav")
            SendChoice(locationName)
        end
    else
        btn:SetEnabled(false)
    end

    return card
end

local function OpenSpawnUI(team, ozAvail, nexusOK, fobOK, ozOK, cityCode)
    CloseSpawnUI()
    pendingTeamID = team

    local locations = {}
    if team == TEAM_CP then
        locations = { "Nexus", "FOB", "OZ" }
    elseif team == TEAM_OTA then
        locations = { "Nexus", "OZ" }
    else
        return
    end

    if team == TEAM_CP and not nexusOK and not fobOK and not ozOK then
        nexusOK = true
    end
    if team == TEAM_OTA and not nexusOK and not ozOK then
        nexusOK = true
    end

    local numCards = #locations
    local totalW   = numCards * CARD_W + (numCards - 1) * CARD_GAP
    local panelW   = totalW + 80
    local panelH   = CARD_H + 150

    local frame = vgui.Create("DFrame")
    frame:SetSize(panelW, panelH)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()
    spawnPanel = frame

    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, COL_BG)
        surface.SetDrawColor(COL_BORDER)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
        draw.RoundedBoxEx(8, 0, 0, w, 3, COL_ACCENT, true, true, false, false)
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetPos(panelW - 36, 10)
    closeBtn:SetSize(26, 26)
    closeBtn:SetText("")
    closeBtn.Paint = function(self, w, h)
        local bg = self:IsHovered() and COL_CLOSE_H or COL_CLOSE
        draw.RoundedBox(4, 0, 0, w, h, bg)
        draw.SimpleText("✕", "DeepSpawnClose", w/2, h/2, COL_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn.DoClick = function()
        surface.PlaySound("buttons/button6.wav")
        CloseSpawnUI()
    end

    local title = vgui.Create("DLabel", frame)
    title:SetPos(0, 18)
    title:SetSize(panelW - 44, 30)
    title:SetFont("DeepSpawnTitle")
    title:SetText("SELECT DEPLOYMENT LOCATION")
    title:SetTextColor(COL_WHITE)
    title:SetContentAlignment(5)

    local teamName = team == TEAM_CP and "Metro Police Force" or "Combine Transhuman Arm"
    local sub = vgui.Create("DLabel", frame)
    sub:SetPos(0, 50)
    sub:SetSize(panelW, 18)
    sub:SetFont("DeepSpawnSub")
    sub:SetText(teamName)
    sub:SetTextColor(COL_MUTED)
    sub:SetContentAlignment(5)

    local startX = (panelW - totalW) / 2
    local cardY  = 78

    for i, locName in ipairs(locations) do
        local data = LOCATION_DATA[locName]
        if not data then continue end

        local locOK     = true
        local attackMsg = nil

        if locName == "Nexus" then
            locOK = nexusOK
            if not locOK then attackMsg = "Location under attack" end
        elseif locName == "FOB" then
            locOK = fobOK
            if not locOK then attackMsg = "Location under attack" end
        elseif locName == "OZ" then
            locOK = ozOK and ozAvail
            if not ozOK then
                attackMsg = "Location under attack"
            elseif not ozAvail then
                attackMsg = "Restricted access"
            end
        end

        local ox = startX + (i - 1) * (CARD_W + CARD_GAP)
        BuildCard(frame, locName, data, locOK, attackMsg, ox, cardY)
    end

    local footer = vgui.Create("DLabel", frame)
    footer:SetPos(0, panelH - 28)
    footer:SetSize(panelW, 20)
    footer:SetFont("DeepSpawnDesc")
    footer:SetText("Press ✕ to cancel and stay on your current team.")
    footer:SetTextColor(COL_MUTED)
    footer:SetContentAlignment(5)
end

net.Receive("DeepSpawnSelectorOpen", function()
    local team     = net.ReadUInt(8)
    local ozAvail  = net.ReadBool()
    local nexusOK  = net.ReadBool()
    local fobOK    = net.ReadBool()
    local ozOK     = net.ReadBool()
    local cityCode = net.ReadUInt(8)

    timer.Simple(0.1, function()
        OpenSpawnUI(team, ozAvail, nexusOK, fobOK, ozOK, cityCode)
    end)
end)

net.Receive("DeepSpawnSelectorClose", function()
    CloseSpawnUI()
end)

function DeepSpawn_RequestSelector(teamID)
    if teamID == TEAM_CP or teamID == TEAM_OTA then
        net.Start("DeepSpawnSelectorRequest")
            net.WriteUInt(teamID, 8)
        net.SendToServer()
        return true
    end
    return false
end