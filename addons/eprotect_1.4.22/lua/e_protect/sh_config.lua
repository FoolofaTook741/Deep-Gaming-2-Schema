eProtect = eProtect or {}

eProtect.config = eProtect.config or {}

eProtect.config["language"] = "en"

eProtect.config["prefix"] = "[eProtect] "

eProtect.config["storage_type"] = "sql_local"-- (sql_local or mysql)

eProtect.config["disablehttplogging"] = false -- If a DRM is ran after eProtect it could break if they check for HTTP modifications! If so make this true.

eProtect.config["ignoreDRM"] = false

eProtect.config["scURL"] = "https://hl2rp.deepgaming2.com/img.php" -- This is the URL used to handle screenshots, can be self hosted here: https://github.com/Stromic/eprotect-web

eProtect.config["punishMaliciousIntent"] = true

eProtect.config["disabledModules"] = {
    ["identifier"] = false,
    ["detection_log"] = false,
    ["net_limiter"] = false,
    ["net_logger"] = false,
    ["exploit_patcher"] = false,
    ["exploit_finder"] = false,
    ["fake_exploits"] = false,
    ["data_snooper"] = false
}

eProtect.config["permission"] = {
    ["owner"] = true,
    ["superadmin"] = true,
    ["leadadmin"] = true,
    ["leadadmincollaborator"] = true,
    ["developer"] = true,
    ["leaddeveloper"] = true
}