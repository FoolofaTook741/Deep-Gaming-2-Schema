AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SetPassenger(client)
	if not IsValid(client) then return end

	local AI = self:GetAI()
	local DriverSeat = self:GetDriverSeat()
	local AllowedToBeDriver = hook.Run("LVS.CanPlayerDrive", client, self) != false
	if IsValid(DriverSeat) and not IsValid(DriverSeat:GetDriver()) and not client:KeyDown(IN_WALK) and not AI and AllowedToBeDriver then
		client:EnterVehicle(DriverSeat)
	else
		local Seat = NULL
		local Dist = 500000
		for _, v in pairs(self:GetPassengerSeats()) do
			if not IsValid(v) or IsValid(v:GetDriver()) then continue end
			if v:GetNWInt("pPodIndex") == -1 then continue end
			local cDist = (v:GetPos() - client:GetPos()):Length()
			if cDist < Dist then
				Seat = v
				Dist = cDist
			end
		end

		if IsValid(Seat) then
			client:EnterVehicle(Seat)
		else
			if IsValid(DriverSeat) then
				if not IsValid(self:GetDriver()) and not AI then
					if AllowedToBeDriver then
						client:EnterVehicle(DriverSeat)
					else
						hook.Run("LVS.OnPlayerCannotDrive", client, self)
					end
				end
			else
				self:EmitSound("doors/default_locked.wav")
				client:PrintMessage(HUD_PRINTCENTER, "No available seats!")
			end
		end
	end
end
