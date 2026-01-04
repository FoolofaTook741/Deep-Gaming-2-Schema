-- This file contains private info, do NOT publicise.

local types = {
	["chat"] = "https://hooks.slack.com/services/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",
	["death"] = "https://hooks.slack.com/services/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"
}

function plogsSlackLog(type, message)
	local isPreview = GetConVar("impulse_ispreview"):GetBool()

	if isPreview then
		return	
	end

	local post = {
		text = message
	}

	local struct = {
		failed = function(error) MsgC(Color(255,0,0), "Impulse Slack log error: "..error) end,
		method = "post",
		url = types[type],
		body = util.TableToJSON(post),
		type = "application/json"
	}

	HTTP(struct)
end