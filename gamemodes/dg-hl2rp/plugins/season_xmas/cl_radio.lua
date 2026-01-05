local nextRadioCheck = nextRadioCheck or nil
local loadingStream = loadingStream or false

impulse.DefineSetting("xmas_radiovol", {name="Festive Radio volume", category="Christmas", type="slider", default=50, minValue=0, maxValue=100})

function PLUGIN:Think()
	local c = CurTime()

	if c < (nextRadioCheck or 0) then
		return
	end
	
	nextRadioCheck = c + 1

	local nearest
	local nDist = 9999999999
	local isRadio = false
	local myPos = LocalPlayer():GetPos()

	for v,k in pairs(ents.FindByClass("impulse_hl2rp_xmasradio")) do
		local dist = myPos:DistToSqr(k:GetPos())
		if dist < nDist then
			nDist = dist
			nearest = k
		end
	end

	if IsValid(nearest) then
		if loadingStream then
			return
		end

		if not nearest:GetRadioOn() then
			if IsValid(xmasStream) then
				xmasStream:Stop()
				xmasSteam = nil
			end
		
			return
		end
		
		if not IsValid(xmasStream) then
			loadingStream = true
			sound.PlayURL("https://strm112.1.fm/christmas_mobile_mp3?aw_0_req.gdpr=true&listenerid=bb7522080bc2814d32ed59dee8cd47a5&awparams=companionAds%3Atrue", "3d", function(chn, errorid, errorname)
				loadingStream = false

				if errorid then
					impulse.debugPrint("[impulse] [xmas radio] Error code: "..errorid.." | Error name: "..errorname)
					return
				end

				if IsValid(nearest) then
					chn:SetPos(nearest:GetPos())
					chn:Set3DFadeDistance(400, 1300)
					chn:SetVolume(impulse.GetSetting("xmas_radiovol", 50) * 0.01)
					chn:Play()

					xmasStream = chn
				end
			end)

			return
		end


		xmasStream:SetPos(nearest:GetPos())
		debugoverlay.Text(nearest:GetPos(), "live radio stream", 1, true)
	else
		if IsValid(xmasStream) then
			xmasStream:Stop()
			xmasSteam = nil
		end
	end
end

concommand.Add("impulse_xmas_radioreload", function()
	if IsValid(xmasStream) then
		xmasStream:Stop()
		impulse.debugPrint("[impulse] [xmas radio] Stopped radio stream...")
	else
		impulse.debugPrint("[impulse] [xmas radio] Found no radio stream")
	end
end)