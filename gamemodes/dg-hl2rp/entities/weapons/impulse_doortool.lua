AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Door Editor"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.CLMode = 0
end
SWEP.HoldType = "fists"

SWEP.Category = "impulse"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.IsAlwaysRaised = true

SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DoorGroup = 1 
SWEP.NextGo = 0
SWEP.NextSecondary = 0

if CLIENT then
	function SWEP:Initialize()
		self.DoorGroup = 1 
		if impulse and impulse.Config and impulse.Config.DoorGroups then
			print("Client DoorGroups:", table.Count(impulse.Config.DoorGroups))
			for k, v in pairs(impulse.Config.DoorGroups) do
				print("  Group "..k..": "..tostring(v))
			end
		else
			print("Client: impulse.Config.DoorGroups is nil or invalid")
		end
	end

	function SWEP:PrimaryAttack()
		if self.NextPrimary and self.NextPrimary > CurTime() then return end
		self.NextPrimary = CurTime() + self.Primary.Delay
		local lp = self.Owner
		local tr = lp:GetEyeTrace()
		if IsValid(tr.Entity) and (tr.Entity:IsDoor() or tr.Entity:IsPropDoor()) then
			if not impulse.Config.DoorGroups or not impulse.Config.DoorGroups[self.DoorGroup] then
				lp:ChatPrint("Invalid group: "..tostring(self.DoorGroup))
				return
			end
			print("Applying group "..self.DoorGroup.." ("..tostring(impulse.Config.DoorGroups[self.DoorGroup])..") to door")
			RunConsoleCommand("impulse_door_setgroup", self.DoorGroup)
		end
	end

	function SWEP:SecondaryAttack()
		if self.NextSecondary > CurTime() then return end
		self.NextSecondary = CurTime() + self.Secondary.Delay
		local maxGroups = (impulse.Config.DoorGroups and table.Count(impulse.Config.DoorGroups)) or 0
		if maxGroups == 0 then
			self.Owner:ChatPrint("No door groups available!")
			return
		end
		self.DoorGroup = self.DoorGroup + 1
		if self.DoorGroup > maxGroups then
			self.DoorGroup = 1 
		end
		local groupName = tostring(impulse.Config.DoorGroups[self.DoorGroup] or "Invalid group")
		self.Owner:ChatPrint("Selected group: "..groupName)
		print("Cycled to group "..self.DoorGroup.." ("..groupName..")")
	end

	function SWEP:Reload()
		if self.NextGo > CurTime() then return end
		self.NextGo = CurTime() + 1
		local lp = self.Owner
		local tr = lp:GetEyeTrace()
		if IsValid(tr.Entity) and (tr.Entity:IsDoor() or tr.Entity:IsPropDoor()) then
			local b = (tr.Entity:GetSyncVar(SYNC_DOOR_BUYABLE, nil) != nil) and 0 or 1
			RunConsoleCommand("impulse_door_sethidden", tostring(b))
		end
	end

	function SWEP:DrawHUD()
		local groupName = impulse.Config.DoorGroups and impulse.Config.DoorGroups[self.DoorGroup] or "Invalid group "..self.DoorGroup
		draw.SimpleText("LEFT: Apply group to door, RIGHT: Cycle door group, RELOAD: Toggle hidden on door.", "BudgetLabel", 100, 100)
		draw.SimpleText("STATE: "..tostring(groupName), "BudgetLabel", 100, 120)
		draw.SimpleText("Made by Nick S, Fixed by Matters", "BudgetLabel", 100, 140)
	end
end