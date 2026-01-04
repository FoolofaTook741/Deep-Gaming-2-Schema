AddCSLuaFile()

if( CLIENT ) then
	SWEP.PrintName = "Property Editor"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.CLMode = 0
end
SWEP.HoldType = "fists"

SWEP.Category = "impulse"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Delay			= 1
SWEP.Primary.Recoil			= 0	
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= -1	
SWEP.Primary.DefaultClip	= -1	
SWEP.Primary.Automatic   	= false	
SWEP.Primary.Ammo         	= "none"
SWEP.IsAlwaysRaised = true
 
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
SWEP.NextGo = 0

if SERVER then
	function SWEP:Equip(owner)
		if not owner:IsAdmin() then
			owner:StripWeapon("impulse_apteditor")
		end
	end
	function SWEP:PrimaryAttack()
	end

	function SWEP:Reload()
	end
	
	function SWEP:SecondaryAttack()
	end
else
	function SWEP:PrimaryAttack()
		if self.NextGo > CurTime() then return end
		
		local traceEnt = LocalPlayer():GetEyeTrace().Entity

		if not IsValid(traceEnt) or not traceEnt:IsDoor() then
			return self.Owner:Notify("Invalid entity selection. Look at a door.")
		end

		self.Doors = self.Doors or {}
		table.insert(self.Doors, traceEnt:EntIndex() - game.MaxPlayers())

		if #self.Doors == 1 then
			self.State = "Front door registered, awaiting more doors or an export."

			surface.PlaySound("buttons/blip1.wav")
		else
			self.State = #self.Doors.." doors registered."

			surface.PlaySound("buttons/blip1.wav")
		end

		self.NextGo = CurTime() + .3
	end

	function SWEP:SecondaryAttack()
		if self.NextGo > CurTime() then return end

		self.Doors = {}
		self.State = nil
		self.Exporting = false

		surface.PlaySound("buttons/button10.wav")
		self.NextGo = CurTime() + .3
	end

	function SWEP:Reload()
		if #self.Doors > 0 and not self.Exporting then
			self.Exporting = true


			local doors = "{"
			local size = #self.Doors

			for v,k in pairs(self.Doors) do
				doors = doors .. k

				if v != size then
					doors = doors .. ", "
				end
			end
			doors = doors .. "}"

			Derma_StringRequest("impulse", "Enter Display Name:", nil, function(name)
				Derma_StringRequest("impulse","Enter Internal Tag:",nil,function(tag)
					Derma_StringRequest("impulse","Enter the cost",nil,function(cost)
						Derma_Query("Select a type","impulse","apt",function()
							-- We need the "lua" code for this
							local output = '{cat="apt",tag="'..tag..'",name="'..name..'",doors='..doors..',cost='..cost..'}'

							chat.AddText("-----------------OUTPUT-----------------")
							chat.AddText(output)
							chat.AddText("Output copied to clipboard.")
							SetClipboardText(output)
							
							self.Doors = {}
							self.State = nil
							self.Exporting = false
						end,"nil",function()
							local output = '{tag="'..tag..'",name="'..name..'",doors='..doors..',cost='..cost..'}'
				
							chat.AddText("-----------------OUTPUT-----------------")
							chat.AddText(output)
							chat.AddText("Output copied to clipboard.")
							SetClipboardText(output)

							self.Doors = {}
							self.State = nil
							self.Exporting = false
						end)
					end)
				end)
			end)
		end
	end

	function SWEP:DrawHUD()
		draw.SimpleText("LEFT: Register door, RIGHT: Reset, RELOAD: Export", "BudgetLabel", 100, 100)
		draw.SimpleText("STATE: "..(self.State or "Nothing selected"), "BudgetLabel", 100, 120)
		draw.SimpleText("Click on the main door to begin, then click on\nthe other doors.", "BudgetLabel", 100, 140)
			local w, h = ScrW(), ScrH()
	-- Draw a debugging notice
	draw.SimpleText("BUILDINGS DEBUG TOOL", "BudgetLabel", w/2, 25, Color(0,255,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	local invalidTerminals = 0
	local terminals = 0
	for _, trm in ipairs(ents.FindByClass("impulse_hl2rp_property_index")) do
		local v = trm:GetPos():ToScreen()
		if (true) then
			
			-- Draw info
			draw.SimpleText("[" .. tostring(trm:EntIndex()) .. "] TERMINAL: " .. trm:GetTag(), "BudgetLabel", v.x, v.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local tag = trm:GetTag()
			if (not tag) or (tag == "") then
				draw.SimpleText("ERR: NO TAG", "BudgetLabel", v.x, v.y + 15, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				invalidTerminals = invalidTerminals + 1
			elseif not impulse.Buildings.Data[tag] then
				draw.SimpleText("ERR: INVALID TAG", "BudgetLabel", v.x, v.y + 15, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				invalidTerminals = invalidTerminals + 1
			else
				draw.SimpleText("VALID", "BudgetLabel", v.x, v.y + 15, Color(0,255,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	if invalidTerminals > 0 then
		draw.SimpleText(invalidTerminals .. " INVALID TERMINALS", "BudgetLabel", w/2, 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	end

	
	
end

if SERVER then
	util.AddNetworkString("impulsePropertyCreate")

	net.Receive("impulsePropertyCreate",function(len,ply)
		if (ply.nextTryCreateProp or 0) > CurTime() then
			return
		end
		ply.nextTryCreateProp = CurTime() + 1

		if not ply:IsSuperAdmin() then
			return
		end

		local dat = net.ReadTable()

		PrintTable(dat)

		-- merge into the active data table
		local rDat = impulse.File.Read("buildings/"..game.GetMap()) or {}
		rDat[dat.tag] = dat

		impulse.File.Write("buildings/"..game.GetMap(),"building",rDat)
		ply:Notify("Saved successfully")
	end)
end