--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
-- [ File Details ] --
-- Purpose: Datatables setup, misc.
function SWEP:SetupDataTables()
	-- QUESTION:
	-- Could we migrate to SYNC vars, if Longsword is running in the Singularity Framework (or derived)?
	-- Could provide a decent bump in performance. (sophie S.)
	self:NetworkVar("Bool", 0, "Ironsights")
	self:NetworkVar("Bool", 1, "Reloading")
	self:NetworkVar("Bool", 2, "Bursting")
	self:NetworkVar("Bool", 3, "Reliable")
	self:NetworkVar("Int", 0, "FireMode")
	self:NetworkVar("Float", 1, "IronsightsRecoil")
	self:NetworkVar("Float", 2, "Recoil")
	self:NetworkVar("Float", 3, "ReloadTime")
	self:NetworkVar("Float", 4, "NextIdle")
	if self.ExtraDataTables then
		self.ExtraDataTables(self)
	end
end