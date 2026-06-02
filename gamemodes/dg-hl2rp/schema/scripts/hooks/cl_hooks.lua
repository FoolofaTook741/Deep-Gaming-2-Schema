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
		elseif ply:Team() == TEAM_OTA then
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