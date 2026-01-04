sound.Add( {
	name = "motionsensortriggered",
	channel = CHAN_ITEM,
	volume = 0.5,
	level = 90,
	pitch = {100},
	sound = "scramble/ui_mp_nukebomb_v1.mp3"
} )

function meta:IsNearSignalJammer()
	local result = false
	for k,v in pairs(ents.FindByClass("deep_signaljammer")) do
		if self:GetPos():Distance(v:GetPos()) < 900 then
			result = true
			break
		end
	end
	if result != true then
		for k,v in pairs(player.GetAll()) do
			if v.IsAJammer and v.IsAJammer == true then
				if v:GetPos():Distance(self:GetPos()) < 450 then
					result = true
					break
				end
			end
		end
	end
	return result
end

function meta:IsNearMotionSensor(sensor)
	if self:GetPos():Distance(sensor:GetPos()) < 100 then
		if self:IsNearSignalJammer() and self:GetMoveType() != MOVETYPE_NOCLIP then
			return false
		end
		return true
	end
	return false
end

function meta:IsNearAudioBug()
	local result = false
	for k,v in pairs(ents.FindByClass("deep_bug")) do
		if self:GetPos():Distance(v:GetPos()) < 750 and self:GetMoveType() != MOVETYPE_NOCLIP then
			result = true
			break
		end
	end
	return result
end