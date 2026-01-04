hook.Add("eP:PostHTTP", "eP:HTTPLoggingHandeler", function(url, type)
    eProtect.logHTTP(url, type)
end)