--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
CreateClientConVar("plutonic_debug", "0", false, false)
CreateClientConVar("plutonic_centered", "0", true, false, "Centers the viewmodel, DOOM style.", 0, 1)
surface.CreateFont(
	"PlutonicDebugSimple",
	{
		font = "Segoe UI Black",
		size = 14,
		weight = 1000,
		antialias = true,
		shadow = true
	}
)

surface.CreateFont(
	"PlutonicDebugUnSimple",
	{
		font = "Segoe UI Black",
		size = 32,
		weight = 1000,
		antialias = true,
		shadow = true
	}
)

local debugCol = Color(12, 120, 255, 255)
local debugValue = Color(200, 200, 200, 255)
local ironFade = ironFade or 0
local GetConVar = GetConVar
local LocalPlayer = LocalPlayer

-- ESP variables
local showBoneESP = false
local showAttachmentESP = false
local showWorldModelESP = false
local boneESPColor = Color(0, 255, 0, 255)
local attachmentESPColor = Color(255, 0, 0, 255)
local worldmodelESPColor = Color(0, 0, 255, 255)

function SWEP:DrawBoneESP()
	if not showBoneESP and not showAttachmentESP and not showWorldModelESP then return end
	
	local vm = LocalPlayer():GetViewModel()
	local worldmodel = self
	
	cam.Start3D(EyePos(), EyeAngles())
	
	-- ViewModel ESP
	if IsValid(vm) then
		if showBoneESP then
			-- Draw viewmodel bones
			for boneId = 0, vm:GetBoneCount() - 1 do
				local bonePos = vm:GetBonePosition(boneId)
				local boneName = vm:GetBoneName(boneId)
				
				if bonePos then
					-- Draw bone point
					render.SetColorMaterial()
					render.DrawSphere(bonePos, 0.5, 8, 8, boneESPColor)
					
					-- Draw bone name
					local screenPos = bonePos:ToScreen()
					if screenPos.visible then
						cam.Start2D()
						draw.SimpleText("VM: " .. boneName, "PlutonicDebugSimple", screenPos.x, screenPos.y, boneESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText("ID: " .. boneId, "PlutonicDebugSimple", screenPos.x, screenPos.y + 12, boneESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						cam.End2D()
					end
					
					-- Draw bone hierarchy lines
					local parentBoneId = vm:GetBoneParent(boneId)
					if parentBoneId and parentBoneId >= 0 then
						local parentPos = vm:GetBonePosition(parentBoneId)
						if parentPos then
							render.DrawLine(bonePos, parentPos, boneESPColor, false)
						end
					end
				end
			end
		end
		
		if showAttachmentESP then
			-- Draw viewmodel attachments
			local attachments = vm:GetAttachments() or {}
			for i, att in ipairs(attachments) do
				local attPos = vm:GetAttachment(att.id)
				if attPos and attPos.Pos then
					-- Draw attachment point
					render.SetColorMaterial()
					render.DrawSphere(attPos.Pos, 0.8, 8, 8, attachmentESPColor)
					
					-- Draw attachment name and info
					local screenPos = attPos.Pos:ToScreen()
					if screenPos.visible then
						cam.Start2D()
						draw.SimpleText("VM: " .. (att.name or "unnamed"), "PlutonicDebugSimple", screenPos.x, screenPos.y, attachmentESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText("ID: " .. att.id, "PlutonicDebugSimple", screenPos.x, screenPos.y + 12, attachmentESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						cam.End2D()
					end
					
					-- Draw attachment axis
					debugoverlay.Axis(attPos.Pos, attPos.Ang, 2, 0.1, true)
				end
			end
		end
	end
	
	-- WorldModel ESP
	if showWorldModelESP and IsValid(worldmodel) then
		-- Draw worldmodel bones
		if showBoneESP then
			for boneId = 0, worldmodel:GetBoneCount() - 1 do
				local bonePos = worldmodel:GetBonePosition(boneId)
				local boneName = worldmodel:GetBoneName(boneId)
				
				if bonePos then
					-- Draw bone point
					render.SetColorMaterial()
					render.DrawSphere(bonePos, 0.5, 8, 8, worldmodelESPColor)
					
					-- Draw bone name
					local screenPos = bonePos:ToScreen()
					if screenPos.visible then
						cam.Start2D()
						draw.SimpleText("WM: " .. boneName, "PlutonicDebugSimple", screenPos.x, screenPos.y, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText("ID: " .. boneId, "PlutonicDebugSimple", screenPos.x, screenPos.y + 12, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						cam.End2D()
					end
					
					-- Draw bone hierarchy lines
					local parentBoneId = worldmodel:GetBoneParent(boneId)
					if parentBoneId and parentBoneId >= 0 then
						local parentPos = worldmodel:GetBonePosition(parentBoneId)
						if parentPos then
							render.DrawLine(bonePos, parentPos, worldmodelESPColor, false)
						end
					end
				end
			end
		end
		
		-- Draw worldmodel attachments using the weapon's own attachment system
		if showAttachmentESP then
			-- Method 1: Try to get attachments via the weapon's attachment system
			if self.Attachments then
				for attachmentName, attachmentData in pairs(self.Attachments) do
					if self.EquippedAttachments[attachmentName] then
						-- Get the bone position for this attachment
						local boneIndex = worldmodel:LookupBone(attachmentData.Bone or "ValveBiped.Bip01_R_Hand")
						if boneIndex then
							local bonePos, boneAng = worldmodel:GetBonePosition(boneIndex)
							if bonePos then
								-- Apply the attachment offset
								local offset = attachmentData.Pos or Vector(0, 0, 0)
								local angleOffset = attachmentData.Ang or Angle(0, 0, 0)
								
								local attPos = bonePos + boneAng:Forward() * offset.x + boneAng:Right() * offset.y + boneAng:Up() * offset.z
								local attAng = boneAng + angleOffset
								
								-- Draw attachment point
								render.SetColorMaterial()
								render.DrawSphere(attPos, 0.8, 8, 8, worldmodelESPColor)
								
								-- Draw attachment name and info
								local screenPos = attPos:ToScreen()
								if screenPos.visible then
									cam.Start2D()
									draw.SimpleText("WM: " .. attachmentName, "PlutonicDebugSimple", screenPos.x, screenPos.y, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
									draw.SimpleText("Bone: " .. (attachmentData.Bone or "default"), "PlutonicDebugSimple", screenPos.x, screenPos.y + 12, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
									cam.End2D()
								end
								
								-- Draw attachment axis
								debugoverlay.Axis(attPos, attAng, 2, 0.1, true)
							end
						end
					end
				end
			end
			
			-- Method 2: Try the standard GetAttachments method (might work for some weapons)
			local attachments = worldmodel:GetAttachments() or {}
			for i, att in ipairs(attachments) do
				local attPos = worldmodel:GetAttachment(att.id)
				if attPos and attPos.Pos then
					-- Draw attachment point
					render.SetColorMaterial()
					render.DrawSphere(attPos.Pos, 0.8, 8, 8, worldmodelESPColor)
					
					-- Draw attachment name and info
					local screenPos = attPos.Pos:ToScreen()
					if screenPos.visible then
						cam.Start2D()
						draw.SimpleText("WM: " .. (att.name or "unnamed"), "PlutonicDebugSimple", screenPos.x, screenPos.y, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText("ID: " .. att.id, "PlutonicDebugSimple", screenPos.x, screenPos.y + 12, worldmodelESPColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						cam.End2D()
					end
					
					-- Draw attachment axis
					debugoverlay.Axis(attPos.Pos, attPos.Ang, 2, 0.1, true)
				end
			end
			
			-- Method 3: Draw the actual attachment entities if they exist
			if self.AttachmentEntCache then
				for _, ent in pairs(self.AttachmentEntCache) do
					if IsValid(ent) then
						local entPos = ent:GetPos()
						local entAng = ent:GetAngles()
						
						-- Draw attachment entity point
						render.SetColorMaterial()
						render.DrawSphere(entPos, 1.0, 8, 8, Color(255, 255, 0, 255)) -- Yellow for actual entities
						
						-- Draw entity name and info
						local screenPos = entPos:ToScreen()
						if screenPos.visible then
							cam.Start2D()
							draw.SimpleText("WM Entity: " .. ent:GetClass(), "PlutonicDebugSimple", screenPos.x, screenPos.y, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							cam.End2D()
						end
						
						-- Draw entity axis
						debugoverlay.Axis(entPos, entAng, 2, 0.1, true)
					end
				end
			end
		end
	end
	
	cam.End3D()
end

function SWEP:DrawHUD()
	-- Call the ESP drawing first (it uses 3D context)
	self:DrawBoneESP()
	
	local attachment
	local debugMode = GetConVar("plutonic_debug")
	if Singularity_DevHud or debugMode:GetBool() then
		local scrW = 68
		local scrH = 292
		local dev = GetConVar("developer"):GetInt()

		surface.SetFont("PlutonicDebugUnSimple")
		surface.SetTextColor(debugCol)
		surface.SetTextPos(64, 96)
		surface.DrawText("[PLUTONIC v1.0.0]")
		surface.SetFont("PlutonicDebugSimple")
		surface.SetTextPos(64, 128)
		surface.DrawText("Debug Mode Enabled!")
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) - 0)
		surface.DrawText((self.PrintName or "PrintName ERROR") .. " [BDMG: " .. (self.Primary.Damage or "?") .. ", RPM: " .. (60 / (self.Primary.Delay or 0)) .. ", SHOTS: " .. (self.Primary.NumShots or "?") .. "]")
		surface.SetTextColor(debugCol)
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 15)
		surface.DrawText("Recoil: ")
		surface.SetTextColor(debugValue)
		surface.DrawText(tostring(math.Round(self.Recoil or 0, 4)))
		surface.SetTextColor(debugCol)
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 30)
		surface.DrawText("Spread: ")
		surface.SetTextColor(debugValue)
		surface.DrawText(tostring(math.Round(self.LastSpread or 0, 4)))
		surface.SetTextColor(debugCol)
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 45)
		surface.DrawText("Penetration: ")
		surface.SetTextColor(debugValue)
		surface.DrawText(tostring(self.Primary.PenetrationScale or "?"))
		if self.LastSpread then
			surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 60)
			surface.SetTextColor(debugCol)
			surface.DrawText("Cone: ")
			surface.SetTextColor(debugValue)
			local perc = self.LastSpread / self.Primary.Cone
			surface.DrawText(math.floor(perc * 100) .. "% of Base Cone")
		end

		local ns = (self:GetNextPrimaryFire() or 0) - CurTime()
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 105)
		surface.DrawText("Next Shot: " .. (ns > 0 and ns or "CLEAR"))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 120)
		surface.DrawText("VMBobCycle Oscillation: " .. tostring(self.VMBobCycle))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 135)
		surface.DrawText("VMBetterVis Oscillation: " .. math.Round(tostring(self.VMRDBEF), 8))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 150)
		surface.DrawText("VMBlocked: " .. tostring(self.VMBlocked))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 165)
		surface.DrawText("VMVel: " .. tostring(math.Round(self.VMVel, 4)))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 180)
		surface.DrawText("VMIronsightsFraction: " .. tostring(self.VMIronsights))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 195)
		surface.DrawText("VMSprint: " .. tostring(self.VMSprint))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 210)
		surface.DrawText("Attachments: " .. table.concat(self.AttachmentEntCache or {}, ", "))
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 225)
		surface.DrawText("VMRecoilAng: " .. tostring(self.VMRecoilAng))
		
		-- Add ESP status to debug display
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 240)
		surface.SetTextColor(debugCol)
		surface.DrawText("Bone ESP: ")
		surface.SetTextColor(showBoneESP and Color(0, 255, 0) or Color(255, 0, 0))
		surface.DrawText(showBoneESP and "ENABLED" or "DISABLED")
		
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 255)
		surface.SetTextColor(debugCol)
		surface.DrawText("Attachment ESP: ")
		surface.SetTextColor(showAttachmentESP and Color(0, 255, 0) or Color(255, 0, 0))
		surface.DrawText(showAttachmentESP and "ENABLED" or "DISABLED")
		
		surface.SetTextPos((scrW / 2) + 30, (scrH / 2) + 270)
		surface.SetTextColor(debugCol)
		surface.DrawText("WorldModel ESP: ")
		surface.SetTextColor(showWorldModelESP and Color(0, 0, 255) or Color(255, 0, 0))
		surface.DrawText(showWorldModelESP and "ENABLED" or "DISABLED")
	end

	if self.Attachments then
		local hasScope = false
		for att, _ in pairs(self.EquippedAttachments) do
			if self.Attachments[att].Behaviour == "sniper_sight" then
				hasScope = true
				attachment = att
			end
		end

		if not hasScope then return end
	end

	if not self:GetIronsights() then
		ironFade = 0
		self.scopedIn = false

		return
	end

	local scrw = ScrW()
	local scrh = ScrH()
	local ft = FrameTime()
	if ironFade ~= 1 and not self.scopedIn then
		ironFade = math.Clamp(ironFade + (ft * 2.6), 0, 1)
		surface.SetDrawColor(ColorAlpha(color_black, ironFade * 255))
		surface.DrawRect(0, 0, scrw, scrh)

		return
	else
		self.scopedIn = true
	end

	if self.scopedIn and ironFade ~= 0 then
		ironFade = math.Clamp(ironFade - (ft * 1), 0, 1)
		surface.SetDrawColor(ColorAlpha(color_black, ironFade * 255))
		surface.DrawRect(0, 0, scrw, scrh)
	end

	plutonic_debug_StopHUDDraw = true
	local scopeh = scrh * 1
	local scopew = scopeh * 1.8
	local hw = (scrw * 0.5) - (scopew / 2)
	local hh = (scrh * 0.5) - (scopeh / 2)
	surface.SetDrawColor(color_black)
	surface.DrawRect(0, 0, scrw, hh)
	surface.DrawRect(0, 0, scrw - scopew, scrh)
	surface.DrawRect(scrw - hw, 0, scrw - scopew, scrh)
	surface.DrawRect(0, hh + scopeh, scrw, scrh)
	surface.SetDrawColor(self.Attachments[attachment].ScopeColor or color_white)
	surface.SetMaterial(self.Attachments[attachment].ScopeTexture)
	surface.DrawTexturedRect(hw, hh, scopew, scopeh)

	if self.Attachments[attachment].ScopePaint then
		self.Attachments[attachment].ScopePaint(self)
	end
end

SWEP.SelectColor = Color(255, 210, 0)
SWEP.EmptySelectColor = Color(255, 50, 0)
function SWEP:DrawWeaponSelection()
end

hook.Add(
	"ShouldDrawHUDBox",
	"PlutonicSingularityHUDStopDrawing",
	function()
		local v = tonumber(plutonic_debug_StopHUDDraw or 1)
		plutonic_debug_StopHUDDraw = false

		return tobool(v)
	end
)

concommand.Add(
	"plutonic_debug_vm_bones",
	function(ply, cmd, args)
		showBoneESP = not showBoneESP
		showAttachmentESP = false
		showWorldModelESP = false
		
		if showBoneESP then
			print("=== VIEWMODEL BONES ===")
			local vm = ply:GetViewModel()
			if IsValid(vm) then
				for boneId = 0, vm:GetBoneCount() - 1 do
					local boneName = vm:GetBoneName(boneId)
					print(boneId, boneName)
				end
			else
				print("No viewmodel found!")
			end
			print("Bone ESP: ENABLED")
		else
			print("Bone ESP: DISABLED")
		end
	end
)

concommand.Add(
	"plutonic_debug_vm_attachments",
	function(ply, cmd, args)
		showAttachmentESP = not showAttachmentESP
		showBoneESP = false
		showWorldModelESP = false
		
		if showAttachmentESP then
			print("=== VIEWMODEL ATTACHMENTS ===")
			local vm = ply:GetViewModel()
			if IsValid(vm) then
				local attachments = vm:GetAttachments() or {}
				if #attachments > 0 then
					for i, att in ipairs(attachments) do
						print(i, att.name)
					end
				else
					print("No attachments found on viewmodel!")
				end
			else
				print("No viewmodel found!")
			end
			print("Attachment ESP: ENABLED")
		else
			print("Attachment ESP: DISABLED")
		end
	end
)

concommand.Add(
	"plutonic_debug_wm_attachments",
	function(ply, cmd, args)
		showWorldModelESP = not showWorldModelESP
		
		if showWorldModelESP then
			print("=== WORLDMODEL DEBUG INFO ===")
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) then
				-- Print weapon attachment system info
				if wep.Attachments then
					print("Weapon Attachment Slots:")
					for name, data in pairs(wep.Attachments) do
						print("  " .. name .. " -> Bone: " .. (data.Bone or "default") .. ", Equipped: " .. tostring(wep.EquippedAttachments and wep.EquippedAttachments[name] or false))
					end
				else
					print("No weapon attachment system found!")
				end
				
				-- Print standard attachments
				local attachments = wep:GetAttachments() or {}
				if #attachments > 0 then
					print("Standard Attachments:")
					for i, att in ipairs(attachments) do
						print("  " .. i .. ": " .. att.name)
					end
				else
					print("No standard attachments found!")
				end
				
				-- Print bones
				print("WorldModel Bones:")
				for boneId = 0, wep:GetBoneCount() - 1 do
					local boneName = wep:GetBoneName(boneId)
					print("  " .. boneId .. ": " .. boneName)
				end
				
				-- Print attachment entities
				if wep.AttachmentEntCache then
					print("Attachment Entities:")
					for k, ent in pairs(wep.AttachmentEntCache) do
						if IsValid(ent) then
							print("  " .. k .. ": " .. ent:GetClass() .. " at " .. tostring(ent:GetPos()))
						end
					end
				end
			else
				print("No active weapon found!")
			end
			print("WorldModel ESP: ENABLED")
		else
			print("WorldModel ESP: DISABLED")
		end
	end
)