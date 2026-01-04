-- Allows the grenade to be used in TTT.
AddCSLuaFile()

hook.Add("Initialize", "SH_FLASHBANG_TTTSUPPORT", function()
	if not (engine.ActiveGamemode() == "terrortown") then
		return end
	
	AMMO_FLASHBANG = 201

	local function AddSupport()
		local ENT = scripted_ents.GetStored("proj_sh_flashbang").t

		DEFINE_BASECLASS("ttt_basegrenade_proj")
		ENT.Base = "ttt_basegrenade_proj"

		if (SERVER) then
			AccessorFunc(ENT, "thrower", "Thrower")
		
			function ENT:Initialize() BaseClass.Initialize(self) self:SetElasticity(2) end
			function ENT:Think() return BaseClass.Think(self) end
			function ENT:SetupDataTables() self:NetworkVar("Float", 0, "ExplodeTime") end
			function ENT:SetDetonateTimer(length) self:SetDetonateExact(CurTime() + length) end
			function ENT:SetDetonateExact(t) self:SetExplodeTime(t or CurTime()) end
			ENT.Explode = ENT.DoExplode
		end
		
		local SWEP = weapons.GetStored("weapon_sh_flashbang")
		
		DEFINE_BASECLASS("weapon_tttbasegrenade")
		SWEP.Base = "weapon_tttbasegrenade"
		SWEP.HoldType = "grenade"

		SWEP.Icon = "vgui/ttt/icon_nades"
		SWEP.IconLetter = "P"
	   
		SWEP.WeaponID = AMMO_FLASHBANG
		SWEP.Kind = WEAPON_NADE
		SWEP.ViewModelFlip = false

		SWEP.AutoSpawnable = true
		SWEP.IsGrenade = true
		SWEP.NoSights = true
		SWEP.HoldReady = "grenade"
		SWEP.HoldNormal = "slam"
		SWEP.detonate_timer = SWEP.CookTime

		AccessorFunc(SWEP, "det_time", "DetTime")
		
		-- Let the SWEP base or whatever handle it..!
		function SWEP:Initialize() self:SetupVars() BaseClass.Initialize(self) end
		function SWEP:SetupDataTables() BaseClass.SetupDataTables(self) end
		function SWEP:Holster(we) return BaseClass.Holster(self, we) end
		function SWEP:OwnerChanged() BaseClass.OwnerChanged(self) end
		function SWEP:OnRemove() BaseClass.OnRemove(self) end
		function SWEP:Deploy() return BaseClass.Deploy(self) end
		function SWEP:OnDrop() BaseClass.OnDrop(self) end
		function SWEP:Think() BaseClass.Think(self) end
		function SWEP:PrimaryAttack() BaseClass.PrimaryAttack(self) end
		function SWEP:SecondaryAttack() BaseClass.SecondaryAttack(self) end
		function SWEP:GetGrenadeName() return self.ThrownProjectile end
		function SWEP:PreDrop() BaseClass.PreDrop(self) end

		local allow = {}
		if (FLASHBANG_SETTINGS.TTT.TraitorsGet) then table.insert(allow, ROLE_TRAITOR) end
		if (FLASHBANG_SETTINGS.TTT.DetectivesGet) then table.insert(allow, ROLE_DETECTIVE) end

		if (#allow > 0) then
			SWEP.EquipMenuData = {
				type = "item_weapon",
				desc = [[A grenade which blinds and deafens
anyone unfortunate enough to
look at it when it detonates.]],
			}

			SWEP.AutoSpawnable = false
			SWEP.Kind = WEAPON_EQUIP
			SWEP.CanBuy = allow
			SWEP.LimitedStock = FLASHBANG_SETTINGS.TTT.LimitedStock
			SWEP.Icon = "vgui/ttt/icon_flashbang"
		end

		if (CLIENT) then
			SWEP.DrawCrosshair = false
		end
	end
	
	AddSupport()
end)