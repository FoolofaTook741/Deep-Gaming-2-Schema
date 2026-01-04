local defView = Vector(0, 0, 64)
local defViewCrouched = Vector(0, 0, 28)
local defMins = Vector(-16, -16, 0)
local defMaxs = Vector(16, 16, 72)
local defMaxCrouched = Vector(16, 16, 36)
local defStep = 18
local scale = 0.5

local function setupSize(ply)
	ply:SetModelScale(scale)

	ply:SetViewOffset(defView * scale)
	ply:SetViewOffsetDucked(defViewCrouched * scale)

	ply:SetHull(defMins * scale, defMaxs * scale)
	ply:SetHullDuck(defMins * scale, defMaxCrouched * scale)
end

if CLIENT then
	surface.CreateFont("Impulse-ChatRadio", {
		font = "Comic Sans MS",
		size = 17,
		weight = 500,
		antialias = true,
		shadow = true,
	} )

	netstream.Hook("voicePlay", function(sounds, volume, index)
		local pitch = 130
		if index then
			local client = Entity(index)

			if (IsValid(client)) then

				if client:IsPlayer() and client:Name():find("i4") then
					pitch = 70
				end
				client:EmitQueuedSounds(sounds, nil, nil, volume, pitch)
			end
		else
			--table.insert(sounds, 1, "npc/overwatch/radiovoice/on1.wav")
			--table.insert(sounds, "npc/overwatch/radiovoice/off4.wav")

			if LocalPlayer():IsPlayer() and LocalPlayer():Name():find("i4") then
				pitch = 70
			end
			LocalPlayer():EmitQueuedSounds(sounds, nil, nil, volume, pitch)
		end
	end)

	function PLUGIN:PostLoadFonts()
		surface.CreateFont("Impulse-ChatRadio", {
			font = "Comic Sans MS",
			size = 27,
			weight = 500,
			antialias = true,
			shadow = true,
		} )
	end
end

local function chadI4()
	impulse.Teams.Data[TEAM_CP].ranks[RANK_I4].name = "CHAD-i4"
	impulse.Teams.Data[TEAM_CP].ranks[RANK_I4].model = "models/dpfilms/metropolice/police_fragger.mdl"
	impulse.Teams.Data[TEAM_CP].ranks[RANK_I4].subMaterial = nil
	impulse.Teams.Data[TEAM_CP].ranks[RANK_I4].onBecome = function(ply)
		ply:GiveInventoryItem("wep_abracadabra", 1, true)
	end
end

timer.Create("chadI4", 1, 0, chadI4)