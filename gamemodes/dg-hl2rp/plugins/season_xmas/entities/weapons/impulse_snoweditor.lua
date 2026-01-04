AddCSLuaFile()

if( CLIENT ) then
	SWEP.PrintName = "Snow Editor"
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
			owner:StripWeapon("impulse_snoweditor")
		end
	end
	function SWEP:PrimaryAttack()
	end

	function SWEP:Reload()
	end
	
	function SWEP:SecondaryAttack()
	end
else
	local texCache = texCache or {}
	local output = output or {}
	function SWEP:PrimaryAttack()
		if self.NextGo > CurTime() then return end
		self.NextGo = CurTime() + .3
		
		local tex = LocalPlayer():GetEyeTrace().HitTexture

		if tex == "** empty **" or tex == "**studio**" or tex == "**displacement**" then
			return LocalPlayer():Notify("You can not edit this texture.")
		end


		local oldMat = Material(tex)

		if oldMat:GetTexture("$basetexture"):GetName() == "nature/snow_002" then
			return LocalPlayer():Notify("Remove old snow first!")
		end
		
		if oldMat:GetTexture("$basetexture"):GetName() == "nature/snowfloor003a" and texCache[tex] then
			oldMat:SetTexture("$basetexture", texCache[tex])
			return LocalPlayer():Notify("Texture reset.")
		end

		local oldMat = Material(tex)
		texCache[tex] = oldMat:GetTexture("$basetexture")
		oldMat:SetTexture("$basetexture", Material("nature/snowfloor003a"):GetTexture("$basetexture"))

		output[tex] = "nature/snowfloor003a"

		LocalPlayer():Notify("Major snow applied to "..tex..".")
	end

	function SWEP:SecondaryAttack()
		if self.NextGo > CurTime() then return end
		self.NextGo = CurTime() + .3
		
		local tex = LocalPlayer():GetEyeTrace().HitTexture

		if tex == "** empty **" or tex == "**studio**" or tex == "**displacement**" then
			return LocalPlayer():Notify("You can not edit this texture.")
		end

		local oldMat = Material(tex)

		if oldMat:GetTexture("$basetexture"):GetName() == "nature/snowfloor003a" then
			return LocalPlayer():Notify("Remove old snow first!")
		end
		
		if oldMat:GetTexture("$basetexture"):GetName() == "nature/snow_002" and texCache[tex] then
			oldMat:SetTexture("$basetexture", texCache[tex])
			return LocalPlayer():Notify("Texture reset.")
		end

		local oldMat = Material(tex)
		texCache[tex] = oldMat:GetTexture("$basetexture")
		oldMat:SetTexture("$basetexture", Material("nature/snow_002"):GetTexture("$basetexture"))

		output[tex] = "nature/snow_002"

		LocalPlayer():Notify("Minor snow applied to "..tex..".")
	end

	function SWEP:Reload()
		if self.NextGo > CurTime() then return end
		self.NextGo = CurTime() + .3

		if table.Count(output) < 1 then
			return LocalPlayer():Notify("No data to output!")
		end

		local o = game.GetMap().." = {"

		for v,k in pairs(output) do
			o = o ..'\n    ["'..v..'"] = "'..k..'",'
		end

		o = o.."\n}"

		chat.AddText("-----------------OUTPUT-----------------")
		print(o)
		chat.AddText("Output copied to clipboard.")
		SetClipboardText(o)
	end

	function SWEP:DrawHUD()
		draw.SimpleText("LEFT: Apply/remove major snow, RIGHT: Apply/remove minor snow, RELOAD: Export", "BudgetLabel", 100, 100)
		draw.SimpleText("STATE: "..(self.State or "Nothing selected"), "BudgetLabel", 100, 120)
		draw.SimpleText("Click on a ground texture to begin, to remove texture click the snow again.", "BudgetLabel", 100, 140)

		draw.SimpleText("CUR TEX: "..LocalPlayer():GetEyeTrace().HitTexture, "BudgetLabel", 100, 180)
	end
end