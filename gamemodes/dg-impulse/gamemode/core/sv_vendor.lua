impulse.Vendor          = impulse.Vendor          or {}
impulse.Vendor.LiveData = impulse.Vendor.LiveData or {}

local VENDOR_DIR    = "impulse/vendors/"
local WEBHOOK_URL   = DG_NME

util.AddNetworkString("impulseVendorEditorOpen")
util.AddNetworkString("impulseVendorEditorData")
util.AddNetworkString("impulseVendorEditorSave")
util.AddNetworkString("impulseVendorEditorDelete")
util.AddNetworkString("impulseVendorEditorResult")
util.AddNetworkString("impulseVendorSync")
util.AddNetworkString("impulseVendorSyncAll")
util.AddNetworkString("impulseVendorDeleted")
util.AddNetworkString("impulseVendorRequestAll")
util.AddNetworkString("impulseVendorTemplateList")
util.AddNetworkString("impulseVendorBindTemplate")
util.AddNetworkString("impulseVendorForceEdit")

local function LogExploit(ply, action, detail)
    if not IsValid(ply) then return end

    local msg = string.format(
        "[VendorEditor] NET EXPLOIT: %s (%s) attempted: %s — %s",
        ply:SteamName(), ply:SteamID(), action, detail or ""
    )
    ServerLog(msg .. "\n")
    print(msg)

    local embeds = {{
        title       = "Vendor Editor Net Exploit Attempted",
        description = string.format("`%s` sent a privileged vendor net message without superadmin rank.", ply:SteamName()),
        color       = 15548997,
        fields = {
            { name = "Name",    value = ply:SteamName(), inline = true  },
            { name = "SteamID", value = ply:SteamID(),   inline = true  },
            { name = "Action",  value = action,          inline = false },
            { name = "Detail",  value = detail or "none",inline = false },
        },
    }}

    if ReqwestLog and WEBHOOK_URL then
        ReqwestLog(embeds, WEBHOOK_URL)
    end
end

local RATE             = {}
local SAVE_COOLDOWN    = 3
local SAVE_MAX_BURST   = 5
local SAVE_WINDOW      = 30
local DELETE_COOLDOWN  = 5

local function CheckRate(ply, action)
    local sid = ply:SteamID()
    RATE[sid]  = RATE[sid] or {}
    local r    = RATE[sid]

    if action == "save" then
        local now = CurTime()
        if (r.lastSave or 0) + SAVE_COOLDOWN > now then
            return false, "Saving too fast."
        end
        r.saveCount  = (r.saveCount or 0) + 1
        r.saveWindow = r.saveWindow or now
        if now - r.saveWindow > SAVE_WINDOW then
            r.saveCount  = 1
            r.saveWindow = now
        end
        if r.saveCount > SAVE_MAX_BURST then
            LogExploit(ply, "VendorEditorSave", "Burst limit: " .. r.saveCount .. " saves in " .. SAVE_WINDOW .. "s")
            return false, "Rate limit exceeded."
        end
        r.lastSave = now

    elseif action == "delete" then
        if (r.lastDelete or 0) + DELETE_COOLDOWN > CurTime() then
            return false, "Deleting too fast."
        end
        r.lastDelete = CurTime()
    end

    return true
end

local function HydrateVendor(raw)
    local v  = table.Copy(raw)
    v.Sell   = {}
    v.Buy    = {}
    local vendorTeam = (raw.accessTeam and raw.accessTeam ~= -1 and raw.accessTeam) or impulse.Vendor.Conditions.PrimaryTeam(raw.accessConditions)
    local restrictTeam = (vendorTeam == TEAM_CP or vendorTeam == TEAM_OTA)

    for _, item in ipairs(raw.items or {}) do
        local autoDesc = (item.descOverride == nil or item.descOverride == "")
            and impulse.Vendor.Conditions.AutoDescribe(item.conditions or {}, vendorTeam)
            or nil

        local entry = {
            Cost         = item.cost         ~= 0  and item.cost         or nil,
            Max          = item.maxCarry     ~= -1 and item.maxCarry     or nil,
            BuyMax       = item.buyMax       ~= -1 and item.buyMax       or nil,
            Cooldown     = item.cooldown     > 0   and item.cooldown     or nil,
            TempCooldown = item.tempCooldown > 0   and item.tempCooldown or nil,
            Restricted   = item.restricted == true or restrictTeam,
            Desc         = (item.descOverride ~= nil and item.descOverride ~= "" and item.descOverride)
                            or (autoDesc ~= "" and autoDesc)
                            or nil,
            RawDesc      = item.descOverride or "",
            Conditions   = item.conditions   or {},
        }

        if entry.Conditions and #entry.Conditions > 0 then
            local snap   = entry.Conditions
            entry.CanBuy = function(ply)
                return impulse.Vendor.Conditions.EvaluateAll(snap, ply)
            end
        end

        if item.mode == "buy" then
            v.Buy[item.itemClass]  = entry
        else
            v.Sell[item.itemClass] = entry
        end
    end

    local at = v.accessTeam
    local ac = v.accessClass
    local ar = v.accessRank
    local axc = (v.accessConditions and #v.accessConditions > 0) and v.accessConditions or nil
    v.AccessConditions = axc
    local HARD_RANK_GATE = {[TEAM_CP]=true, [TEAM_OTA]=true, [TEAM_CA]=true}
    v.CanUse = function(ent, ply)
        if axc and not impulse.Vendor.Conditions.EvaluateAll(axc, ply) then return false end
        if HARD_RANK_GATE[ply:Team()] and ply:GetTeamRank() == nil then return false end
        return true
    end

    v.UniqueID   = v.uid
    v.Name       = v.name
    v.Desc       = v.desc       or ""
    v.HUDName    = v.hudName    or v.name
    v.HUDDesc    = v.hudDesc    or ""
    v.Model      = v.model      or "models/Humans/Group01/male_02.mdl"
    v.Skin       = v.skin       or 0
    v.Bodygroups = v.bodygroups or ""
    v.Sequence   = v.sequence   or ""
    v._dbManaged = true
    v.ClearSameType = v.clearSameType == true
    v.Talk   = raw.talk == true
    v.Gender = raw.gender or "male"

    return v
end

function impulse.Vendor.LoadAll()
    if not file.IsDir(VENDOR_DIR, "DATA") then
        file.CreateDir(VENDOR_DIR)
        print("[VendorJSON] Created vendor data directory.")
        return
    end

    local files, _ = file.Find(VENDOR_DIR .. "*.json", "DATA")
    local count    = 0

    for _, fname in ipairs(files) do
        local raw = file.Read(VENDOR_DIR .. fname, "DATA")
        if not raw then continue end

        local ok, decoded = pcall(util.JSONToTable, raw)
        if not ok or not decoded or not decoded.uid then
            print("[VendorJSON] Failed to parse: " .. fname)
            continue
        end

        impulse.Vendor.LiveData[decoded.uid] = HydrateVendor(decoded)
        count = count + 1
    end

    print(string.format("[VendorJSON] Loaded %d vendor(s).", count))
    impulse.Vendor.BroadcastAll()
end

function impulse.Vendor.SaveVendor(data)
    if not data or not data.uid then return false, "Missing UID" end

    local safe = {
        uid         = data.uid,
        name        = data.name        or "Unnamed Vendor",
        desc        = data.desc        or "",
        model       = data.model       or "models/Humans/Group01/male_02.mdl",
        skin        = tonumber(data.skin)        or 0,
        bodygroups  = data.bodygroups  or "",
        sequence    = data.sequence    or "",
        talk        = data.talk == true,
        gender      = (data.gender == "female" or data.gender == "cp") and data.gender or "male",
        hudName     = data.hudName     or data.name or "Vendor",
        hudDesc     = data.hudDesc     or "",
        accessTeam  = tonumber(data.accessTeam)  or -1,
        accessClass = data.accessClass or "",
        accessRank  = tonumber(data.accessRank)  or -1,
        accessConditions = {},
        clearSameType = data.clearSameType == true,
        items       = {},
    }

    local allowedTypes = {
        rank_gte=true, rank_gt=true, rank_eq=true, rank_lt=true, rank_range=true,
        teamclass=true, teamclass_not=true, citycode_gte=true, team=true,
        global_flag=true, is_collaborator=true,
        any=true, all=true,
    }
    for _, cond in ipairs(data.accessConditions or {}) do
        if cond.type and allowedTypes[cond.type] then
            safe.accessConditions[#safe.accessConditions+1] = cond
        end
    end

    for _, item in ipairs(data.items or {}) do
        if not item.itemClass or item.itemClass == "" then continue end
        local safeItem = {
            itemClass    = tostring(item.itemClass),
            mode         = item.mode == "buy" and "buy" or "sell",
            cost         = math.Clamp(tonumber(item.cost)         or 0,   0,   999999),
            maxCarry     = math.Clamp(tonumber(item.maxCarry)     or -1, -1,   9999),
            buyMax       = math.Clamp(tonumber(item.buyMax)       or -1, -1,   9999),
            cooldown     = math.Clamp(tonumber(item.cooldown)     or 0,   0,   86400),
            tempCooldown = math.Clamp(tonumber(item.tempCooldown) or 0,   0,   86400),
            restricted   = item.restricted == true,
            descOverride = tostring(item.descOverride or ""):sub(1, 255),
            conditions   = {},
        }
        for _, cond in ipairs(item.conditions or {}) do
            if cond.type and allowedTypes[cond.type] then
                safeItem.conditions[#safeItem.conditions+1] = cond
            end
        end
        safe.items[#safe.items+1] = safeItem
    end

    if not file.IsDir(VENDOR_DIR, "DATA") then
        file.CreateDir(VENDOR_DIR)
    end

    file.Write(VENDOR_DIR .. safe.uid .. ".json", util.TableToJSON(safe, true))
    impulse.Vendor.LiveData[safe.uid] = HydrateVendor(safe)

    return true, safe
end

function impulse.Vendor.DeleteVendor(uid)
    if not uid or uid == "" then return false end
    local path = VENDOR_DIR .. uid .. ".json"
    if file.Exists(path, "DATA") then file.Delete(path) end
    impulse.Vendor.LiveData[uid] = nil
    return true
end

local function SerializeVendor(v)
    local items = {}
    local function addItems(tbl, mode)
        for cls, entry in pairs(tbl) do
            items[#items+1] = {
                itemClass    = cls,
                mode         = mode,
                cost         = entry.Cost         or 0,
                maxCarry     = entry.Max          or -1,
                buyMax       = entry.BuyMax       or -1,
                cooldown     = entry.Cooldown     or 0,
                tempCooldown = entry.TempCooldown or 0,
                restricted   = entry.Restricted   == true,
                descOverride = entry.RawDesc    or "",
                conditions   = entry.Conditions   or {},
            }
        end
    end
    addItems(v.Sell or {}, "sell")
    addItems(v.Buy  or {}, "buy")

    return {
        uid         = v.UniqueID,
        name        = v.Name        or "",
        desc        = v.Desc        or "",
        model       = v.Model       or "",
        skin        = v.Skin        or 0,
        bodygroups  = v.Bodygroups  or "",
        sequence    = v.Sequence    or "",
        hudName     = v.HUDName     or v.Name or "",
        hudDesc     = v.HUDDesc     or "",
        accessTeam  = v.accessTeam  or -1,
        accessClass = v.accessClass or "",
        accessRank  = v.accessRank  or -1,
        accessConditions = v.AccessConditions or {},
        clearSameType = v.ClearSameType == true,
        items       = items,
        _dbManaged  = true,
        talk        = v.Talk == true,
        gender      = v.Gender or "male",
    }
end

function impulse.Vendor.BroadcastUID(uid)
    local v = impulse.Vendor.LiveData[uid]
    if not v then return end
    local encoded = pon.encode(SerializeVendor(v))
    net.Start("impulseVendorSync")
    net.WriteUInt(#encoded, 32)
    net.WriteData(encoded, #encoded)
    net.Broadcast()
end

function impulse.Vendor.BroadcastAll()
    local all = {}
    for _, v in pairs(impulse.Vendor.LiveData) do
        all[#all+1] = SerializeVendor(v)
    end
    if #all == 0 then return end
    local encoded = pon.encode(all)
    net.Start("impulseVendorSyncAll")
    net.WriteUInt(#encoded, 32)
    net.WriteData(encoded, #encoded)
    net.Broadcast()
end

local function SendResult(ply, success, msg)
    net.Start("impulseVendorEditorResult")
    net.WriteBool(success)
    net.WriteString(msg)
    net.Send(ply)
end

local function SendAll(ply)
    local all = {}
    for _, v in pairs(impulse.Vendor.LiveData) do
        all[#all+1] = SerializeVendor(v)
    end
    if #all == 0 then return end
    local encoded = pon.encode(all)
    net.Start("impulseVendorSyncAll")
    net.WriteUInt(#encoded, 32)
    net.WriteData(encoded, #encoded)
    net.Send(ply)
end

local function MarkAndPersist(ent)
    if not IsValid(ent) then return end

    ent.impulseSaveEnt = true

    if ent.CPPISetOwner then
        ent:CPPISetOwner(nil)
    end

    local savedEnts = {}
    for _, k in pairs(ents.GetAll()) do
        if k.impulseSaveEnt then
            table.insert(savedEnts, {
                pos      = k.AlwaysPos or k:GetPos(),
                angle    = k:GetAngles(),
                class    = k:GetClass(),
                model    = k:GetModel(),
                keyvalue = (k.impulseSaveKeyValue or nil),
            })
        end
    end
    file.Write("impulse/saves/" .. string.lower(game.GetMap()) .. ".dat", util.TableToJSON(savedEnts))
end

net.Receive("impulseVendorEditorOpen", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        LogExploit(ply, "impulseVendorEditorOpen", "Not superadmin")
        return
    end

    local entIdx = net.ReadUInt(16)
    local ent    = Entity(entIdx)

    if not IsValid(ent) or ent:GetClass() ~= "impulse_vendor" then return end

    if ply:GetPos():Distance(ent:GetPos()) > 200 then
        LogExploit(ply, "impulseVendorEditorOpen",
            string.format("Distance too large: %.0f units", ply:GetPos():Distance(ent:GetPos())))
        return
    end

    local uid = ent:GetVendorUID()

    if uid ~= "" and impulse.Vendor.LiveData[uid] then
        local vendorData = SerializeVendor(impulse.Vendor.LiveData[uid])
        local encoded = pon.encode(vendorData)
        net.Start("impulseVendorEditorData")
        net.WriteUInt(#encoded, 32)
        net.WriteData(encoded, #encoded)
        net.Send(ply)
    else
        local templates = {}
        for id, v in pairs(impulse.Vendor.LiveData) do
            templates[#templates+1] = { uid = id, name = v.Name or id }
        end
        local payload = pon.encode({ entIdx = entIdx, templates = templates })
        net.Start("impulseVendorTemplateList")
        net.WriteUInt(#payload, 32)
        net.WriteData(payload, #payload)
        net.Send(ply)
    end
end)

net.Receive("impulseVendorBindTemplate", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        LogExploit(ply, "impulseVendorBindTemplate", "Not superadmin")
        return
    end

    local entIdx = net.ReadUInt(16)
    local uid    = net.ReadString()

    if not uid or uid == "" or not uid:match("^[%w_%-]+$") or #uid > 64 then
        LogExploit(ply, "impulseVendorBindTemplate", "Bad UID: " .. tostring(uid))
        return
    end

    local ent = Entity(entIdx)
    if not IsValid(ent) or ent:GetClass() ~= "impulse_vendor" then return end

    if ply:GetPos():Distance(ent:GetPos()) > 200 then
        LogExploit(ply, "impulseVendorBindTemplate",
            string.format("Distance too large: %.0f units", ply:GetPos():Distance(ent:GetPos())))
        return
    end

    local v = impulse.Vendor.LiveData[uid]
    if not v then
        SendResult(ply, false, "Template not found."); return
    end

    ent:SetVendorUID(uid)
    ent:ApplyVendorData(v)
    MarkAndPersist(ent)
    SendResult(ply, true, "Bound to template: " .. (v.Name or uid))
    print(string.format("[VendorEditor] %s bound entity to template: %s", ply:SteamName(), uid))
end)

net.Receive("impulseVendorEditorSave", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        LogExploit(ply, "impulseVendorEditorSave", "Not superadmin")
        return
    end

    local ok, reason = CheckRate(ply, "save")
    if not ok then SendResult(ply, false, reason); return end

    local sz = net.ReadUInt(32)
    if sz > 262144 then
        LogExploit(ply, "impulseVendorEditorSave", string.format("Oversized payload: %d bytes", sz))
        return
    end

    local raw = net.ReadData(sz)
    local decoded
    ok, decoded = pcall(pon.decode, raw)
    if not ok or not decoded or type(decoded) ~= "table" then
        SendResult(ply, false, "Malformed payload."); return
    end

    if not decoded.uid or type(decoded.uid) ~= "string"
    or not decoded.uid:match("^[%w_%-]+$") or #decoded.uid > 64 then
        LogExploit(ply, "impulseVendorEditorSave", "Bad UID: " .. tostring(decoded.uid))
        SendResult(ply, false, "Invalid UID."); return
    end

    if decoded.model and not tostring(decoded.model):match("^models/") then
        LogExploit(ply, "impulseVendorEditorSave", "Suspicious model path: " .. tostring(decoded.model))
        SendResult(ply, false, "Invalid model path."); return
    end

    local saveOk, result = impulse.Vendor.SaveVendor(decoded)
    if not saveOk then SendResult(ply, false, "Save failed: " .. tostring(result)); return end

    local boundEnt = nil

    if decoded._isNew and decoded._entIdx then
        local ent = Entity(decoded._entIdx)
        if IsValid(ent) and ent:GetClass() == "impulse_vendor" then
            ent:SetVendorUID(decoded.uid)
            ent:ApplyVendorData(impulse.Vendor.LiveData[decoded.uid])
            boundEnt = ent
        end
    else
        for _, ent in ipairs(ents.FindByClass("impulse_vendor")) do
            if IsValid(ent) and ent:GetVendorUID() == decoded.uid then
                ent:ApplyVendorData(impulse.Vendor.LiveData[decoded.uid])
                boundEnt = ent
            end
        end
    end

    MarkAndPersist(boundEnt)

    impulse.Vendor.BroadcastUID(decoded.uid)
    SendResult(ply, true, "Vendor saved.")
    print(string.format("[VendorEditor] %s (%s) saved vendor: %s", ply:SteamName(), ply:SteamID(), decoded.uid))
end)

net.Receive("impulseVendorEditorDelete", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        LogExploit(ply, "impulseVendorEditorDelete", "Not superadmin")
        return
    end

    local ok, reason = CheckRate(ply, "delete")
    if not ok then SendResult(ply, false, reason); return end

    local uid = net.ReadString()
    if not uid or uid == "" or not uid:match("^[%w_%-]+$") or #uid > 64 then
        LogExploit(ply, "impulseVendorEditorDelete", "Bad UID: " .. tostring(uid))
        return
    end

    impulse.Vendor.DeleteVendor(uid)

    for _, ent in ipairs(ents.FindByClass("impulse_vendor")) do
        if IsValid(ent) and ent:GetVendorUID() == uid then
            ent.impulseSaveEnt = nil
            ent:Remove()
        end
    end

    local savedEnts = {}
    for _, k in pairs(ents.GetAll()) do
        if k.impulseSaveEnt then
            table.insert(savedEnts, {
                pos      = k.AlwaysPos or k:GetPos(),
                angle    = k:GetAngles(),
                class    = k:GetClass(),
                model    = k:GetModel(),
                keyvalue = (k.impulseSaveKeyValue or nil),
            })
        end
    end
    file.Write("impulse/saves/" .. string.lower(game.GetMap()) .. ".dat", util.TableToJSON(savedEnts))

    net.Start("impulseVendorDeleted")
    net.WriteString(uid)
    net.Broadcast()

    SendResult(ply, true, "Vendor deleted.")
    print(string.format("[VendorEditor] %s (%s) deleted vendor: %s", ply:SteamName(), ply:SteamID(), uid))
end)

net.Receive("impulseVendorRequestAll", function(len, ply)
    if not IsValid(ply) then return end
    if (ply._lastVendorSync or 0) + 10 > CurTime() then return end
    ply._lastVendorSync = CurTime()
    SendAll(ply)
end)

hook.Add("InitPostEntity", "VendorJSON.Load", function()
    timer.Simple(1, function()
        impulse.Vendor.LoadAll()
    end)
end)

if next(player.GetAll()) then
    timer.Simple(0, function()
        impulse.Vendor.BroadcastAll()
    end)
end

hook.Add("PlayerSpawn", "VendorJSON.SyncOnSpawn", function(ply)
    if not IsValid(ply) then return end
    timer.Simple(3, function()
        if not IsValid(ply) then return end
        SendAll(ply)
    end)
end)