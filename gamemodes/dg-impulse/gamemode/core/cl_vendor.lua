impulse.Vendor          = impulse.Vendor          or {}
impulse.Vendor.LiveData = impulse.Vendor.LiveData or {}

local function HydrateVendor(data)
    local v = table.Copy(data)
    v.Sell  = {}
    v.Buy   = {}
    local vendorTeam = (data.accessTeam and data.accessTeam ~= -1 and data.accessTeam) or impulse.Vendor.Conditions.PrimaryTeam(data.accessConditions)
    local restrictTeam = (vendorTeam == TEAM_CP or vendorTeam == TEAM_OTA)
    for _, item in ipairs(data.items or {}) do
        local autoDesc = (item.descOverride == nil or item.descOverride == "")
            and impulse.Vendor.Conditions.AutoDescribe(item.conditions or {}, vendorTeam)
            or nil

        local entry = {
            Cost         = item.cost         ~= 0  and item.cost         or nil,
            Max          = item.maxCarry     ~= -1 and item.maxCarry     or nil,
            BuyMax       = item.buyMax       ~= -1 and item.buyMax       or nil,
            Cooldown     = item.cooldown     > 0   and item.cooldown     or nil,
            TempCooldown = item.tempCooldown > 0   and item.tempCooldown or nil,
            Restricted   = item.restricted or restrictTeam,
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
    local at, ac, ar = data.accessTeam, data.accessClass, data.accessRank
    local axc = (data.accessConditions and #data.accessConditions > 0) and data.accessConditions or nil
    local RANKED_TEAMS = {[TEAM_CP]=true, [TEAM_OTA]=true, [TEAM_CWU]=true, [TEAM_CA]=true}
    v.CanUse = function(ent, ply)
        if at and at ~= -1 then
            if ply:Team() ~= at then return false end
            if RANKED_TEAMS[at] and ply:GetTeamRank() == nil then return false end
        end
        if ac and ac ~= "" and ply:GetTeamClass() ~= ac then return false end
        if ar and ar ~= -1 then
            local r = ply:GetTeamRank()
            if r == nil or r < ar then return false end
        end
        if axc and not impulse.Vendor.Conditions.EvaluateAll(axc, ply) then return false end
        return true
    end
    v.UniqueID   = data.uid
    v.Name       = data.name
    v.Desc       = data.desc
    v.HUDName    = data.hudName or data.name
    v.HUDDesc    = data.hudDesc or ""
    v.Model      = data.model
    v.Skin       = data.skin
    v.Bodygroups = data.bodygroups
    v.Sequence   = data.sequence
    v.Talk       = data.talk == true
    v.Gender     = data.gender or "male"
    v.ClearSameType = data.clearSameType == true
    v.AccessConditions = (data.accessConditions and #data.accessConditions > 0) and data.accessConditions or nil
    return v
end

net.Receive("impulseVendorSync", function()
    local sz  = net.ReadUInt(32)
    local raw = net.ReadData(sz)
    local ok, data = pcall(pon.decode, raw)
    if not ok or not data or not data.uid then return end
    impulse.Vendor.LiveData[data.uid] = HydrateVendor(data)
end)

net.Receive("impulseVendorSyncAll", function()
    local sz  = net.ReadUInt(32)
    local raw = net.ReadData(sz)
    local ok, list = pcall(pon.decode, raw)
    if not ok or not list then return end
    for _, data in ipairs(list) do
        impulse.Vendor.LiveData[data.uid] = HydrateVendor(data)
    end
end)

net.Receive("impulseVendorDeleted", function()
    local uid = net.ReadString()
    impulse.Vendor.LiveData[uid] = nil
end)

hook.Add("InitPostEntity", "VendorDB.RequestSync", function()
    net.Start("impulseVendorRequestAll")
    net.SendToServer()
end)

if IsValid(LocalPlayer()) then
    net.Start("impulseVendorRequestAll")
    net.SendToServer()
end

local EDITOR_W = 980
local EDITOR_H = 720

local BG      = Color(18,  18,  22)
local BG2     = Color(26,  26,  32)
local BG3     = Color(34,  34,  42)
local BORDER  = Color(50,  50,  62)
local ACCENT  = Color(70,  130, 180)
local ACCENT2 = Color(100, 160, 210)
local TEXT_HI = Color(230, 230, 230)
local TEXT_LO = Color(140, 140, 155)
local GREEN   = Color(80,  190, 100)
local RED     = Color(210, 70,  70)
local YELLOW  = Color(210, 180, 60)

surface.CreateFont("VE.Title", { font = "Roboto",      size = 22, weight = 700 })
surface.CreateFont("VE.Tab",   { font = "Roboto",      size = 14, weight = 600 })
surface.CreateFont("VE.Body",  { font = "Roboto",      size = 13, weight = 400 })
surface.CreateFont("VE.Small", { font = "Roboto",      size = 11, weight = 400 })
surface.CreateFont("VE.Mono",  { font = "Courier New", size = 12, weight = 400 })
surface.CreateFont("VE.Label", { font = "Roboto",      size = 12, weight = 600 })

local function Entry(parent, x, y, w, h, placeholder, value)
    local te = parent:Add("DTextEntry")
    te:SetPos(x, y); te:SetSize(w, h or 24)
    te:SetPlaceholderText(placeholder or "")
    te:SetValue(value or "")
    te:SetFont("VE.Body"); te:SetTextColor(TEXT_HI); te:SetCursorColor(ACCENT2)
    te.Paint = function(s, sw, sh)
        local borderCol = s:IsEditing() and ACCENT or Color(70, 70, 84)
        draw.RoundedBox(4, 0, 0, sw, sh, borderCol)
        draw.RoundedBox(4, 1, 1, sw-2, sh-2, Color(40, 40, 50))
        s:DrawTextEntryText(TEXT_HI, ACCENT2, TEXT_HI)
    end
    return te
end

local function SimpleTabSheet(parent, x, y, w, h)
    local container = parent:Add("DPanel")
    container:SetPos(x, y); container:SetSize(w, h)
    container.Paint = function(s, sw, sh) draw.RoundedBox(6, 0, 0, sw, sh, BG2) end

    local tabBar = container:Add("DPanel")
    tabBar:SetPos(0, 0); tabBar:SetSize(w, 32)
    tabBar.Paint = function() end

    local body = container:Add("DPanel")
    body:SetPos(0, 32); body:SetSize(w, h - 32)
    body.Paint = function() end

    local sheetObj = { tabs = {}, activeIndex = nil }

    local function SetActive(idx)
        sheetObj.activeIndex = idx
        for i, t in ipairs(sheetObj.tabs) do
            t.panel:SetVisible(i == idx)
        end
    end

    function sheetObj:AddSheet(label, panel)
        panel:SetParent(body)
        panel:SetPos(0, 0)
        panel:SetSize(body:GetWide(), body:GetTall())
        panel:SetVisible(false)

        local idx = #sheetObj.tabs + 1
        local tabBtn = tabBar:Add("DButton")
        tabBtn:SetText("")
        tabBtn.label = label

        local entry = { btn = tabBtn, panel = panel, label = label }
        sheetObj.tabs[idx] = entry

        tabBtn.Paint = function(s, sw, sh)
            local active = sheetObj.activeIndex == idx
            local c = active and BG3 or BG2
            if s:IsHovered() and not active then c = Color(BG3.r-4, BG3.g-4, BG3.b-4) end
            draw.RoundedBoxEx(6, 1, 1, sw-2, sh-1, c, true, true, false, false)
            if active then
                surface.SetDrawColor(ACCENT)
                surface.DrawRect(1, sh-3, sw-2, 3)
            end
            draw.SimpleText(s.label, "VE.Tab", sw/2, sh/2, active and TEXT_HI or TEXT_LO, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        tabBtn.DoClick = function() SetActive(idx) end

        local function Reflow()
            local n = #sheetObj.tabs
            if n == 0 then return end
            local tw = tabBar:GetWide() / n
            for i, e in ipairs(sheetObj.tabs) do
                e.btn:SetPos((i-1) * tw, 0)
                e.btn:SetSize(tw, 32)
            end
        end
        Reflow()

        if sheetObj.activeIndex == nil then SetActive(idx) end

        return entry
    end

    function sheetObj:SetTabLabel(idx, newLabel)
        if sheetObj.tabs[idx] then
            sheetObj.tabs[idx].btn.label = newLabel
        end
    end

    return sheetObj
end

local function NumEntry(parent, x, y, w, value, minv, maxv)
    local te = Entry(parent, x, y, w, 24, tostring(minv or 0), tostring(value or 0))
    te.OnChange = function(s)
        local n = tonumber(s:GetValue())
        if n then
            if minv and n < minv then te:SetValue(tostring(minv)) end
            if maxv and n > maxv then te:SetValue(tostring(maxv)) end
        end
    end
    return te
end

local function Btn(parent, x, y, w, h, label, col, onClick)
    local btn = parent:Add("DButton")
    btn:SetPos(x, y); btn:SetSize(w, h); btn:SetText(""); btn.label = label
    btn.bgCol   = col or ACCENT
    btn.DoClick = onClick or function() end
    btn.Paint   = function(s, sw, sh)
        local c = s.bgCol
        if s:IsHovered() then c = Color(c.r+20, c.g+20, c.b+20) end
        draw.RoundedBox(4, 0, 0, sw, sh, c)
        draw.SimpleText(s.label, "VE.Body", sw/2, sh/2, TEXT_HI, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return btn
end

local function ComboGetData(cb)
    local _, data = cb:GetSelected()
    return data
end

local function Combo(parent, x, y, w, options, current)
    local cb = parent:Add("DComboBox")
    cb:SetPos(x, y); cb:SetSize(w, 24); cb:SetFont("VE.Body")
    cb.Paint = function(s, sw, sh)
        draw.RoundedBox(4, 0, 0, sw, sh, BG3)
        draw.RoundedBox(4, 0, 0, sw, sh, BORDER)
        draw.SimpleText(s:GetValue(), "VE.Body", 8, sh/2, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    local selectIdx = nil
    for i, opt in ipairs(options or {}) do
        cb:AddChoice(opt[1], opt[2])
        if opt[2] == current or opt[1] == current then selectIdx = i end
    end
    if selectIdx then cb:ChooseOptionID(selectIdx) end
    return cb
end

local function Checkbox(parent, x, y, label, value, onChange)
    local row = parent:Add("DPanel")
    row:SetPos(x, y); row:SetSize(180, 22); row.Paint = function() end
    row.locked = false
    local cb = row:Add("DCheckBox"); cb:SetPos(0, 2); cb:SetValue(value and true or false)
    cb.Paint = function(s, sw, sh)
        draw.RoundedBox(3, 0, 0, sw, sh, BG3); draw.RoundedBox(3, 0, 0, sw, sh, BORDER)
        if s:GetChecked() then
            surface.SetDrawColor(row.locked and Color(95, 95, 105) or ACCENT)
            surface.DrawRect(3, 3, sw-6, sh-6)
        end
    end
    if onChange then
        cb.OnChange = function(s) if row.locked then return end onChange(s:GetChecked()) end
    end
    local lbl = row:Add("DLabel"); lbl:SetPos(22, 3); lbl:SetText(label or "")
    lbl:SetTextColor(TEXT_HI); lbl:SetFont("VE.Body"); lbl:SizeToContents()
    row.GetChecked = function() return cb:GetChecked() end
    row.SetChecked = function(_, v) cb:SetChecked(v) end
    row.SetLocked  = function(_, v)
        row.locked = v and true or false
        cb:SetMouseInputEnabled(not row.locked)
        lbl:SetTextColor(row.locked and TEXT_LO or TEXT_HI)
    end
    return row
end

local RANK_OPTIONS  = {}
local CLASS_OPTIONS = {}
local TEAM_OPTIONS  = {}
local CODE_OPTIONS  = {}
local function RefreshOptions()
    RANK_OPTIONS = {
        {"Intern",      RANK_INTERN},
        {"Rep",         RANK_REPRESENTATIVE},
        {"Councilman",  RANK_COUNCILMAN},
        {"Deputy/Exec", RANK_DEPUTY},
        {"CA",          RANK_CA},
        {"i1",          RANK_I1},
        {"i2",          RANK_I2},
        {"i3",          RANK_I3},
        {"SqL",         RANK_SQL},
        {"RL/OFC",      RANK_OFC},
        {"DvL",         RANK_DVL},
        {"DcO",         RANK_DCO},
        {"VCMD",        RANK_VCMD},
        {"CmD",         RANK_CMD},
        {"ECS",         RANK_EOS},
        {"CSO",         RANK_OWS},
        {"CCP",         RANK_OCP},
        {"ORD",         RANK_ORD},
        {"CTL",         RANK_OSL},
    }
    CLASS_OPTIONS = {
        {"UNION",    CLASS_UNION},
        {"GHOST",    CLASS_GHOST},
        {"GRID",     CLASS_GRID},
        {"SWORD",    CLASS_SWORD},
        {"HELIX",    CLASS_HELIX},
        {"BASE",     CLASS_BASE},
        {"ICT",      CLASS_ICT},
        {"MEDIC",    CLASS_MEDIC},
        {"REFINERY", CLASS_REFINERY},
        {"INDUST",   CLASS_INDUST},
        {"ECHO",     CLASS_ECHO},
        {"RANGER",   CLASS_RANGER},
        {"MACE",     CLASS_MACE},
        {"NOMAD",    CLASS_NOMAD},
        {"FIST",     CLASS_FIST},
        {"APF",      CLASS_APF},
        {"PAYBACK",  CLASS_PAYBACK},
    }
    CODE_OPTIONS = {}
    for code, info in ipairs(impulse.Dispatch and impulse.Dispatch.CityCodes or {}) do
        CODE_OPTIONS[#CODE_OPTIONS+1] = {info[1], code}
    end
    TEAM_OPTIONS = {}
    for i, t in ipairs(team.GetAllTeams() or {}) do
        TEAM_OPTIONS[#TEAM_OPTIONS+1] = {t.Name or tostring(i), i}
    end
end

local TEAM_CLASS_MAP = {
    [function() return TEAM_CP       end] = {
        {"Any Class", ""},
        {"GHOST",   function() return CLASS_GHOST   end},
        {"GRID",    function() return CLASS_GRID    end},
        {"HELIX",   function() return CLASS_HELIX   end},
        {"UNION",   function() return CLASS_UNION   end},
        {"SWORD",   function() return CLASS_SWORD   end},
        {"RAZOR",   function() return CLASS_RAZOR   end},
        {"PHANTOM", function() return CLASS_PHANTOM end},
    },
    [function() return TEAM_OTA      end] = {
        {"Any Class", ""},
        {"APF",     function() return CLASS_APF     end},
        {"PAYBACK", function() return CLASS_PAYBACK end},
        {"NOMAD",   function() return CLASS_NOMAD   end},
        {"MACE",    function() return CLASS_MACE    end},
        {"FIST",    function() return CLASS_FIST    end},
        {"ECHO",    function() return CLASS_ECHO    end},
        {"RANGER",  function() return CLASS_RANGER  end},
    },
    [function() return TEAM_CWU      end] = {
        {"Any Class",  ""},
        {"INDUST",   function() return CLASS_INDUST   end},
        {"COMMERCE", function() return CLASS_COMMERCE end},
        {"MEDIC",    function() return CLASS_MEDIC    end},
        {"REFINERY", function() return CLASS_REFINERY end},
        {"ICT",      function() return CLASS_ICT      end},
        {"RESEARCH", function() return CLASS_RESEARCH end},
    },
    [function() return TEAM_CA       end] = {
        {"Any Class", ""},
        {"BASE",    function() return CLASS_BASE    end},
    },
}

local TEAM_RANK_MAP = {
    [function() return TEAM_CP  end] = {
        {"Any Rank", -1},
        {"i1",      function() return RANK_I1  end},
        {"i2",      function() return RANK_I2  end},
        {"i3",      function() return RANK_I3  end},
        {"SqL",     function() return RANK_SQL end},
        {"RL/OFC",  function() return RANK_OFC end},
        {"DvL",     function() return RANK_DVL end},
        {"DcO",     function() return RANK_DCO end},
        {"VCmD",     function() return RANK_VCMD end},
        {"CmD",     function() return RANK_CMD end},
    },
    [function() return TEAM_OTA end] = {
        {"Any Rank", -1},
        {"CGR",     function() return RANK_OWG end},
        {"CSO",     function() return RANK_OWS end},
        {"ECS",     function() return RANK_EOS end},
        {"CCP",     function() return RANK_OCP end},
        {"CTL",     function() return RANK_OSL end},
        {"ORD",     function() return RANK_ORD end},
        {"CSC",     function() return RANK_OSC end},
    },
    [function() return TEAM_CWU end] = {
        {"Any Rank",    -1},
        {"Intern",      function() return RANK_INTERN     end},
        {"Employee",    function() return RANK_EMPLOYEE   end},
        {"Supervisor",  function() return RANK_SUPERVISOR end},
        {"Director",    function() return RANK_DIRECTOR   end},
        {"Minister",    function() return RANK_MINISTER   end},
    },
    [function() return TEAM_CA  end] = {
        {"Any Rank",    -1},
        {"Intern",      function() return RANK_INTERN         end},
        {"Rep",         function() return RANK_REPRESENTATIVE end},
        {"Councilman",  function() return RANK_COUNCILMAN     end},
        {"Deputy/Exec", function() return RANK_DEPUTY         end},
        {"CA",          function() return RANK_CA             end},
    },
}

local TEAM_LIST = {
    {"Any Team",      -1},
    {"TEAM_CITIZEN",  function() return TEAM_CITIZEN  end},
    {"TEAM_CWU",      function() return TEAM_CWU      end},
    {"TEAM_CP",       function() return TEAM_CP       end},
    {"TEAM_OTA",      function() return TEAM_OTA      end},
    {"TEAM_CA",       function() return TEAM_CA       end},
    {"TEAM_VORT",     function() return TEAM_VORT     end},
    {"TEAM_ZOMBIE",   function() return TEAM_ZOMBIE   end},
    {"TEAM_STALKER",  function() return TEAM_STALKER  end},
    {"TEAM_CREMATOR", function() return TEAM_CREMATOR end},
}

local function ResolveOpts(tbl)
    local out = {}
    for _, opt in ipairs(tbl) do
        local val = opt[2]
        if type(val) == "function" then val = val() end
        out[#out+1] = {opt[1], val}
    end
    return out
end

local function GetClassOptsForTeam(teamVal)
    for getter, opts in pairs(TEAM_CLASS_MAP) do
        if getter() == teamVal then return ResolveOpts(opts) end
    end
    local all = {{"Any Class", ""}}
    for _, o in ipairs(CLASS_OPTIONS) do all[#all+1] = o end
    return all
end

local function GetGroupClassOpts(teamVal)
    if teamVal == nil or teamVal == -1 then
        local all = { {"Any Class", ""} }
        for _, o in ipairs(CLASS_OPTIONS) do all[#all+1] = o end
        return all
    end
    for getter, opts in pairs(TEAM_CLASS_MAP) do
        if getter() == teamVal then return ResolveOpts(opts) end
    end
    return { {"N/A", ""} }
end

local function GetRankOptsForTeam(teamVal)
    local out = {{"Any Rank", -1}}
    local data = impulse.Teams and impulse.Teams.Data and impulse.Teams.Data[teamVal]
    local ranks = data and data.ranks
    if not ranks then return out end
    for i, entry in ipairs(ranks) do
        local label
        if type(entry) == "table" then
            label = entry.name or entry.Name or ("Rank "..i)
        elseif type(entry) == "string" then
            label = entry
        else
            label = "Rank "..i
        end
        out[#out+1] = {label, i}
    end
    return out
end

local function BuildAccessPanel(data)
    local panel = vgui.Create("DPanel")
    panel.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end

    local ay = 12
    local function Lbl(t)
        local l = panel:Add("DLabel"); l:SetPos(16, ay)
        l:SetText(t); l:SetTextColor(TEXT_LO); l:SetFont("VE.Label"); l:SizeToContents()
        ay = ay + 22
    end

    local currentTeam  = data.accessTeam  or -1
    local currentClass = data.accessClass or ""
    local currentRank  = data.accessRank  or -1

    Lbl("Required Team")
    local cbTeam = Combo(panel, 16, ay, 220, ResolveOpts(TEAM_LIST), currentTeam)
    ay = ay + 34

    Lbl("Required Class")
    local cbClass = Combo(panel, 16, ay, 220, GetClassOptsForTeam(currentTeam), currentClass)
    ay = ay + 34

    Lbl("Required Rank")
    local cbRank = Combo(panel, 16, ay, 220, GetRankOptsForTeam(currentTeam), currentRank)
    ay = ay + 34

    local note = panel:Add("DLabel"); note:SetPos(16, ay)
    note:SetText("All three fields must pass. Leave at Any to allow everyone.")
    note:SetTextColor(TEXT_LO); note:SetFont("VE.Small"); note:SizeToContents()

    local function RebuildClassRank(preserveClass, preserveRank)
        local selTeam = ComboGetData(cbTeam)
        if selTeam == nil then selTeam = -1 end

        local classOpts = GetClassOptsForTeam(selTeam)
        local rankOpts  = GetRankOptsForTeam(selTeam)

        cbClass:Clear()
        local classSet = false
        for _, o in ipairs(classOpts) do
            cbClass:AddChoice(o[1], o[2])
            if preserveClass ~= nil and o[2] == preserveClass then
                cbClass:SetValue(o[1]); classSet = true
            end
        end
        if not classSet and #classOpts > 0 then cbClass:SetValue(classOpts[1][1]) end

        cbRank:Clear()
        local rankSet = false
        for _, o in ipairs(rankOpts) do
            cbRank:AddChoice(o[1], o[2])
            if preserveRank ~= nil and o[2] == preserveRank then
                cbRank:SetValue(o[1]); rankSet = true
            end
        end
        if not rankSet and #rankOpts > 0 then cbRank:SetValue(rankOpts[1][1]) end
    end

    cbTeam.OnSelect = function(_,_,_,_) RebuildClassRank() end

    local function SafeGetData(cb, fallback)
        local v = ComboGetData(cb)
        if v ~= nil and v ~= false then return v end
        return fallback
    end

    panel.GetTeam  = function() return SafeGetData(cbTeam,  -1) end
    panel.GetClass = function() return SafeGetData(cbClass, "") end
    panel.GetRank  = function() return SafeGetData(cbRank,  -1) end

    return panel
end

local COND_TYPES = {
    {"Rank ≥",          "rank_gte"},
    {"Rank >",          "rank_gt"},
    {"Rank =",          "rank_eq"},
    {"Rank <",          "rank_lt"},
    {"Rank between",    "rank_range"},
    {"Team Class",      "teamclass"},
    {"Team Class ≠",    "teamclass_not"},
    {"Requirement Groups (OR)", "any"},
    {"City Code ≥",     "citycode_gte"},
    {"On Team",         "team"},
    {"Global Flag",     "global_flag"},
    {"Is Collaborator", "is_collaborator"},
}

local function ConditionRow(parent, cond, onChange, onRemove, onResize, classFilterTeam)
    cond = cond or {type = "rank_gte", rank = RANK_I1 or 1}
    local row = parent:Add("DPanel")
    row:SetSize(parent:GetWide()-10, 28)
    row.Paint = function(s, sw, sh) draw.RoundedBox(3, 0, 0, sw, sh, BG3) end

    local typeCombo  = Combo(row, 4, 2, 140, COND_TYPES, cond.type)
    local valuePanel = row:Add("DPanel")
    valuePanel:SetPos(152, 2); valuePanel:SetSize(row:GetWide()-200, 24)
    valuePanel.Paint = function() end

    local function GetFilteredClassOpts()
        if classFilterTeam and classFilterTeam ~= -1 then
            local filtered = GetClassOptsForTeam(classFilterTeam)
            local out = {}
            for _, o in ipairs(filtered) do
                if o[2] ~= "" then out[#out+1] = o end
            end
            if #out > 0 then return out end
        end
        return CLASS_OPTIONS
    end

    local function GetFilteredRankOpts()
        if classFilterTeam and classFilterTeam ~= -1 then
            local filtered = GetRankOptsForTeam(classFilterTeam)
            local out = {}
            for _, o in ipairs(filtered) do
                if o[2] ~= -1 then out[#out+1] = o end
            end
            if #out > 0 then return out end
        end
        return RANK_OPTIONS
    end

    local function RebuildValue()
        valuePanel:Clear()
        local t  = ComboGetData(typeCombo) or "rank_gte"
        local newRowHeight = 28

        if t == "any" then
            cond.conditions = cond.conditions or {}

            valuePanel:SetPos(8, 28)
            local fullW = row:GetWide() - 16
            valuePanel:SetWide(fullW)

            local lbl = valuePanel:Add("DLabel"); lbl:SetPos(0, 0)
            lbl:SetText("Allow if ANY group matches (fields in a group are ANDed):"); lbl:SetTextColor(TEXT_LO)
            lbl:SetFont("VE.Small"); lbl:SizeToContents()

            local classOpts = { {"Any class", ""} }
            for _, o in ipairs(GetFilteredClassOpts()) do classOpts[#classOpts+1] = o end
            local rankOpts = GetFilteredRankOpts()
            local opOpts = {
                {"Any rank", ""},
                {"≥",        "rank_gte"},
                {">",        "rank_gt"},
                {"=",        "rank_eq"},
                {"<",        "rank_lt"},
            }
            local codeOpts = { {"Any code", -1} }
            for code in ipairs(impulse.Dispatch and impulse.Dispatch.CityCodes or {}) do
                codeOpts[#codeOpts+1] = {impulse.Vendor.Conditions.CodeName(code), code}
            end

            local teamOpts = { {"Any team", -1} }
            for _, o in ipairs(TEAM_OPTIONS) do teamOpts[#teamOpts+1] = o end

            local function ParseGroup(sub)
                local g = {team = -1, class = "", op = "", rank = -1, code = -1}
                local function take(c)
                    if c.type == "team" then g.team = c.team
                    elseif c.type == "teamclass" then g.class = c.class
                    elseif string.sub(c.type or "", 1, 5) == "rank_" then g.op = c.type; g.rank = c.rank
                    elseif c.type == "citycode_gte" then g.code = c.code end
                end
                if not sub then return g end
                if sub.type == "all" then
                    for _, c in ipairs(sub.conditions or {}) do take(c) end
                else
                    take(sub)
                end
                return g
            end

            local function BuildGroup(g)
                local parts = {}
                if g.team ~= nil and g.team ~= -1 then
                    parts[#parts+1] = {type = "team", team = g.team}
                end
                if g.class ~= nil and g.class ~= "" then
                    parts[#parts+1] = {type = "teamclass", class = g.class}
                end
                if g.op ~= "" and g.rank ~= nil and g.rank ~= -1 then
                    parts[#parts+1] = {type = g.op, rank = g.rank}
                end
                if g.code ~= nil and g.code ~= -1 then
                    parts[#parts+1] = {type = "citycode_gte", code = g.code}
                end
                if #parts == 0 then return nil
                elseif #parts == 1 then return parts[1]
                else return {type = "all", conditions = parts} end
            end

            local function Commit(i, g)
                cond.conditions[i] = BuildGroup(g) or {type = "teamclass", class = ""}
                onChange(cond)
            end

            local removeW, gap = 22, 5
            local avail = fullW - removeW - gap
            local cwTeam  = math.floor(avail * 0.22)
            local cwClass = math.floor(avail * 0.22)
            local cwOp    = math.floor(avail * 0.11)
            local cwRank  = math.floor(avail * 0.20)
            local cwCode  = avail - cwTeam - cwClass - cwOp - cwRank - (gap * 4)

            local xTeam  = 0
            local xClass = cwTeam + gap
            local xOp    = cwTeam + cwClass + gap * 2
            local xRank  = cwTeam + cwClass + cwOp + gap * 3
            local xCode  = cwTeam + cwClass + cwOp + cwRank + gap * 4

            local startY, rowH = 18, 28
            for i, sub in ipairs(cond.conditions) do
                local g  = ParseGroup(sub)
                local gy = startY + (i-1) * rowH

                local cTeam = Combo(valuePanel, xTeam, gy, cwTeam, teamOpts, g.team)
                cTeam.OnSelect = function(_,_,_,d) g.team = d; g.class = ""; g.rank = -1; Commit(i, g); RebuildValue() end

                local cClass = Combo(valuePanel, xClass, gy, cwClass, GetGroupClassOpts(g.team), g.class)
                cClass.OnSelect = function(_,_,_,d) g.class = d; Commit(i, g) end

                local cOp = Combo(valuePanel, xOp, gy, cwOp, opOpts, g.op)
                cOp.OnSelect = function(_,_,_,d)
                    g.op = d
                    if d ~= "" and (g.rank == nil or g.rank == -1) and rankOpts[1] then
                        g.rank = rankOpts[1][2]
                    end
                    Commit(i, g); RebuildValue()
                end

                if g.op ~= "" then
                    local cRank = Combo(valuePanel, xRank, gy, cwRank, GetRankOptsForTeam(g.team), g.rank)
                    cRank.OnSelect = function(_,_,_,d) g.rank = d; Commit(i, g) end
                end

                local cCode = Combo(valuePanel, xCode, gy, cwCode, codeOpts, g.code)
                cCode.OnSelect = function(_,_,_,d) g.code = d; Commit(i, g) end

                Btn(valuePanel, fullW - removeW, gy, removeW, 24, "✕", RED, function()
                    table.remove(cond.conditions, i)
                    onChange(cond); RebuildValue()
                end)
            end

            local addY = startY + #cond.conditions * rowH
            Btn(valuePanel, 0, addY, 120, 24, "+ Add group", Color(40, 90, 40), function()
                cond.conditions[#cond.conditions + 1] = {type = "teamclass", class = ""}
                onChange(cond); RebuildValue()
            end)

            local contentHeight = startY + (#cond.conditions * rowH) + 28 + 6
            valuePanel:SetTall(contentHeight)
            newRowHeight = 28 + contentHeight + 8
        else
            valuePanel:SetPos(152, 2)
            valuePanel:SetSize(row:GetWide()-200, 24)
            local hw = valuePanel:GetWide()

            if t == "rank_gte" or t == "rank_gt" or t == "rank_eq" or t == "rank_lt" then
                local c = Combo(valuePanel, 0, 0, hw, GetFilteredRankOpts(), cond.rank)
                c.OnSelect = function(_,_,_,d) cond.rank=d; onChange(cond) end
            elseif t == "rank_range" then
                local half = math.floor(hw/2) - 2
                local c1 = Combo(valuePanel, 0, 0, half, GetFilteredRankOpts(), cond.rankMin)
                c1.OnSelect = function(_,_,_,d) cond.rankMin=d; onChange(cond) end
                local lbl = valuePanel:Add("DLabel"); lbl:SetPos(half+2, 4); lbl:SetText("–")
                lbl:SetTextColor(TEXT_LO); lbl:SetFont("VE.Small"); lbl:SizeToContents()
                local c2 = Combo(valuePanel, half+12, 0, half, GetFilteredRankOpts(), cond.rankMax)
                c2.OnSelect = function(_,_,_,d) cond.rankMax=d; onChange(cond) end
            elseif t == "teamclass" or t == "teamclass_not" then
                local c = Combo(valuePanel, 0, 0, hw, GetFilteredClassOpts(), cond.class)
                c.OnSelect = function(_,_,_,d) cond.class=d; onChange(cond) end
            elseif t == "citycode_gte" then
                local c = Combo(valuePanel, 0, 0, hw, CODE_OPTIONS, cond.code)
                c.OnSelect = function(_,_,_,d) cond.code=d; onChange(cond) end
            elseif t == "team" then
                local c = Combo(valuePanel, 0, 0, hw, TEAM_OPTIONS, cond.team)
                c.OnSelect = function(_,_,_,d) cond.team=d; onChange(cond) end
            elseif t == "global_flag" then
                local te = Entry(valuePanel, 0, 0, hw, 22, "OCAAB_HEALTHVIALS_UPGRADE", cond.flag or "")
                te.OnChange = function(s) cond.flag=s:GetValue(); onChange(cond) end
            elseif t == "is_collaborator" then
                local lbl = valuePanel:Add("DLabel"); lbl:SetPos(0, 3)
                lbl:SetText("(no parameters)"); lbl:SetTextColor(TEXT_LO)
                lbl:SetFont("VE.Small"); lbl:SizeToContents()
            end
        end

        row:SetTall(newRowHeight)
        if onResize then onResize() end
    end

    typeCombo.OnSelect = function(_,_,_,d)
        cond.type = d
        if d == "any" and not cond.conditions then cond.conditions = {} end
        RebuildValue(); onChange(cond)
    end
    RebuildValue()
    Btn(row, row:GetWide()-44, 2, 40, 24, "✕", RED, function() row:Remove(); onRemove() end)
    row.GetCond = function() return cond end
    return row
end

local function OpenItemPicker(onPick)
    local f = vgui.Create("DFrame")
    f:SetSize(620, 680); f:Center(); f:SetTitle(""); f:SetDraggable(true); f:MakePopup()
    f:ShowCloseButton(false)
    f.Paint = function(s, sw, sh)
        draw.RoundedBox(8, 0, 0, sw, sh, BG); draw.RoundedBox(8, 0, 0, sw, 44, BG2)
        surface.SetDrawColor(BORDER); surface.DrawRect(0, 44, sw, 1)
        draw.SimpleText("Choose Item", "VE.Title", 16, 22, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    Btn(f, 620-100, 8, 88, 28, "✕  Close", Color(70,40,40), function() f:Close() end)

    local searchBar = Entry(f, 16, 54, 588, 28, "Search by name, class, or category...")

    local scroll = vgui.Create("DScrollPanel", f)
    scroll:SetPos(16, 90); scroll:SetSize(588, 580)
    scroll.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end

    local categories  = {}
    local catContainers = {}
    local allRows = {}

    local sourceItems = {}
    if impulse.Inventory and impulse.Inventory.Items then
        for _, it in pairs(impulse.Inventory.Items) do
            sourceItems[#sourceItems+1] = it
        end
    end
    table.sort(sourceItems, function(a, b) return (a.Name or a.UniqueID or "") < (b.Name or b.UniqueID or "") end)

    for _, item in ipairs(sourceItems) do
        local catName = item.Category or "Uncategorized"

        if not categories[catName] then
            local catHeader = scroll:Add("DButton")
            catHeader:Dock(TOP); catHeader:DockMargin(4, 4, 4, 0); catHeader:SetTall(30); catHeader:SetText("")
            catHeader.expanded = true
            catHeader.Paint = function(s, sw, sh)
                local c = s:IsHovered() and BG3 or BG2
                draw.RoundedBox(4, 0, 0, sw, sh, c)
                draw.SimpleText((s.expanded and "▾ " or "▸ ")..catName, "VE.Label", 10, sh/2, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local container = scroll:Add("DPanel")
            container:Dock(TOP); container:DockMargin(4, 0, 4, 4)
            container.Paint = function() end
            container.PerformLayout = function(s)
                local h = 0
                for _, c in ipairs(s:GetChildren()) do
                    if c:IsVisible() then
                        local _, mt, _, mb = c:GetDockMargin()
                        h = h + c:GetTall() + mt + mb
                    end
                end
                if s:GetTall() ~= h then s:SetTall(h) end
            end

            catHeader.DoClick = function()
                catHeader.expanded = not catHeader.expanded
                container:SetVisible(catHeader.expanded)
                scroll:GetCanvas():InvalidateLayout(true)
                scroll:InvalidateLayout(true)
            end

            categories[catName]    = catHeader
            catContainers[catName] = container
        end

        local row = catContainers[catName]:Add("DButton")
        row:Dock(TOP); row:DockMargin(8, 0, 0, 4); row:SetTall(34); row:SetText("")
        row.itemRef = item
        row.Paint = function(s, sw, sh)
            local c = s:IsHovered() and ACCENT or BG3
            draw.RoundedBox(4, 0, 0, sw, sh, c)
            draw.SimpleText(item.Name or item.UniqueID, "VE.Body", 10, sh/2 - 7, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(item.UniqueID, "VE.Small", 10, sh/2 + 8, TEXT_LO, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        row.DoClick = function()
            onPick(item)
            f:Close()
        end

        allRows[#allRows+1] = { row = row, item = item, cat = catName }
    end

    local function ApplyFilter()
        local q = searchBar:GetValue():lower()
        for _, entry in ipairs(allRows) do
            local item = entry.item
            local hay = ((item.Name or "") .. " " .. (item.UniqueID or "") .. " " .. (item.Category or "")):lower()
            local show = (q == "") or hay:find(q, 1, true) ~= nil
            entry.row:SetVisible(show)
        end
        for catName, container in pairs(catContainers) do
            local anyVisible = false
            for _, entry in ipairs(allRows) do
                if entry.cat == catName and entry.row:IsVisible() then anyVisible = true; break end
            end
            local header = categories[catName]
            header:SetVisible(anyVisible)
            container:SetVisible(anyVisible and header.expanded)
            container:InvalidateLayout(true)
        end
        scroll:GetCanvas():InvalidateLayout(true)
        scroll:InvalidateLayout(true)
    end

    searchBar.OnChange = ApplyFilter

    if #sourceItems == 0 then
        local warn = f:Add("DLabel"); warn:SetPos(16, 100)
        warn:SetText("No items found in impulse.Inventory.Items.")
        warn:SetTextColor(RED); warn:SetFont("VE.Body"); warn:SizeToContents()
    end
end

local function BuildAccessPanel(accessConditions)
    local panel = vgui.Create("DPanel")
    panel.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end

    local info = panel:Add("DLabel"); info:SetPos(16, 12); info:SetSize(884, 34)
    info:SetText("Who can use this vendor — all rows must pass (AND). Use \"Requirement Groups (OR)\" to allow several teams or classes. Leave empty to allow everyone.")
    info:SetWrap(true); info:SetContentAlignment(7); info:SetTextColor(TEXT_LO); info:SetFont("VE.Small")

    local condScroll = panel:Add("DScrollPanel"); condScroll:SetPos(16, 52); condScroll:SetSize(900, 452)
    condScroll.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG) end
    local condContainer = condScroll:Add("DPanel"); condContainer:Dock(TOP); condContainer:SetSize(884, 10)
    condContainer.Paint = function() end

    local condRows = {}

    local function ReflowRows()
        local yPos = 4
        for _, r in ipairs(condRows) do
            r:SetPos(4, yPos); yPos = yPos + r:GetTall() + 4
        end
        condContainer:SetTall(math.max(30, yPos))
        condContainer:InvalidateLayout(true); condScroll:InvalidateLayout(true)
    end

    local function AddCondRow(cond)
        local idx = #condRows + 1
        local row = ConditionRow(condContainer, cond,
            function(c) accessConditions[idx] = c end,
            function()
                table.remove(accessConditions, idx); table.remove(condRows, idx)
                for _, r in ipairs(condRows) do r:Remove() end
                condRows = {}
                local tmp = table.Copy(accessConditions); accessConditions = {}
                for _, c in ipairs(tmp) do accessConditions[#accessConditions+1] = c; AddCondRow(c) end
                ReflowRows()
            end,
            ReflowRows,
            -1)
        condRows[#condRows+1] = row
        ReflowRows()
    end

    for _, c in ipairs(accessConditions) do AddCondRow(c) end

    Btn(panel, 16, 512, 180, 28, "+ Add Condition", BG3, function()
        local nc = {type = "rank_gte", rank = RANK_I1 or 1}
        accessConditions[#accessConditions+1] = nc; AddCondRow(nc)
    end)
    Btn(panel, 204, 512, 220, 28, "+ Requirement Groups (OR)", BG3, function()
        local nc = {type = "any", conditions = {{type = "teamclass", class = ""}}}
        accessConditions[#accessConditions+1] = nc; AddCondRow(nc)
    end)

    panel.GetConditions = function() return accessConditions end

    return panel
end

local function OpenItemEditor(itemData, onSave, accessTeam)
    local f = vgui.Create("DFrame")
    f:SetSize(620, 660); f:Center(); f:SetTitle(""); f:SetDraggable(true); f:MakePopup()
    f:ShowCloseButton(false)
    f.Paint = function(s, sw, sh)
        draw.RoundedBox(8, 0, 0, sw, sh, BG); draw.RoundedBox(8, 0, 0, sw, 44, BG2)
        surface.SetDrawColor(BORDER); surface.DrawRect(0, 44, sw, 1)
        draw.SimpleText("Item Editor", "VE.Title", 16, 22, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    Btn(f, 620-100, 8, 88, 28, "✕  Close", Color(70,40,40), function() f:Close() end)

    local y = 56
    local labelW = 150
    local fieldX = 16 + labelW + 8

    local function Row(lbl, widget, ww)
        local l = f:Add("DLabel"); l:SetPos(16, y + 4); l:SetSize(labelW, 22)
        l:SetText(lbl); l:SetTextColor(TEXT_LO); l:SetFont("VE.Label")
        widget:SetParent(f); widget:SetPos(fieldX, y)
        if ww then widget:SetWide(ww) end
        y = y + 36
        return widget
    end

    local classRow = f:Add("DPanel")
    classRow:SetPos(16, y); classRow:SetSize(588, 26); classRow.Paint = function() end
    local classLbl = classRow:Add("DLabel"); classLbl:SetPos(0, 4); classLbl:SetSize(labelW, 22)
    classLbl:SetText("Item Class"); classLbl:SetTextColor(TEXT_LO); classLbl:SetFont("VE.Label")

    local teClass = Entry(classRow, fieldX - 16, 0, 320, 26, "item_healthkit", itemData.itemClass or "")
    local pickedItem = nil
    if itemData.itemClass and itemData.itemClass ~= "" and impulse.Inventory and impulse.Inventory.ItemsRef then
        local netid = impulse.Inventory.ItemsRef[itemData.itemClass]
        if netid then pickedItem = impulse.Inventory.Items[netid] end
    end

    local pickedLbl = classRow:Add("DLabel")
    pickedLbl:SetPos(fieldX - 16 + 330, 4); pickedLbl:SetSize(240, 22)
    pickedLbl:SetTextColor(GREEN); pickedLbl:SetFont("VE.Small")
    pickedLbl:SetText(pickedItem and ("✓ " .. (pickedItem.Name or "")) or "")

    Btn(classRow, fieldX - 16 + 330, 0, 100, 26, "Browse...", ACCENT, function()
        OpenItemPicker(function(item)
            teClass:SetValue(item.UniqueID)
            pickedLbl:SetText("✓ " .. (item.Name or item.UniqueID))
        end)
    end)
    y = y + 38

    local cbMode     = Row("Mode",                Combo(f,0,0,260,{{"Sell (give to player)","sell"},{"Buy (take from player)","buy"}}, itemData.mode or "sell"))
    local teCost     = Row("Cost",                NumEntry(f,0,0,110, itemData.cost         or 0,   0))
    local teMax      = Row("Max Carry (-1 = unlimited)",    NumEntry(f,0,0,110, itemData.maxCarry     or -1, -1))
    local teBuyMax   = Row("Buy Max (-1 = unlimited)",      NumEntry(f,0,0,110, itemData.buyMax       or -1, -1))
    local teCooldown = Row("Cooldown (seconds)",  NumEntry(f,0,0,110, itemData.cooldown     or 0,   0))
    local teTempCD   = Row("Temp Cooldown (seconds)", NumEntry(f,0,0,110, itemData.tempCooldown or 0,   0))
    local cbRestr    = Row("Restricted",          Checkbox(f,0,0,"Cannot be dropped", itemData.restricted))
    local forceRestrict = (accessTeam == TEAM_CP or accessTeam == TEAM_OTA)
    if forceRestrict then
        cbRestr:SetChecked(true)
        cbRestr:SetLocked(true)
    end
    local teDesc = Row("Desc Override", Entry(f,0,0,300,26,"GHOST Only", itemData.descOverride or ""))
    Btn(f, fieldX + 300 + 8, y - 36, 100, 26, "Auto-fill", BG3, function()
        teDesc:SetValue(impulse.Vendor.Conditions.AutoDescribe(conditions, accessTeam))
    end)

    local descPreview = f:Add("DLabel"); descPreview:SetPos(fieldX, y - 36 + 30)
    descPreview:SetSize(420, 16); descPreview:SetFont("VE.Small"); descPreview:SetTextColor(TEXT_LO)
    local function UpdatePreview()
        local auto = impulse.Vendor.Conditions.AutoDescribe(conditions, accessTeam)
        descPreview:SetText(auto ~= "" and ("Suggested: " .. auto) or "")
    end

    y = y + 6
    local condLabel = f:Add("DLabel"); condLabel:SetPos(16, y)
    condLabel:SetText("Access Conditions (all rows must pass — use \"Any Of (OR)\" to allow multiple classes)")
    condLabel:SetTextColor(TEXT_LO); condLabel:SetFont("VE.Label"); condLabel:SizeToContents(); y = y + 24

    local condScroll = f:Add("DScrollPanel"); condScroll:SetPos(16, y); condScroll:SetSize(588, 170)
    condScroll.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end

    local condContainer = condScroll:Add("DPanel"); condContainer:Dock(TOP); condContainer:SetSize(588, 10)
    condContainer.Paint = function() end

    local conditions = table.Copy(itemData.conditions or {})
    local condRows   = {}

    local function ReflowRows()
        local yPos = 4
        for _, r in ipairs(condRows) do
            r:SetPos(4, yPos)
            yPos = yPos + r:GetTall() + 4
        end
        condContainer:SetTall(math.max(30, yPos))
        condContainer:InvalidateLayout(true)
        condScroll:InvalidateLayout(true)
    end

    local function AddCondRow(cond)
        local idx = #condRows+1
        local row = ConditionRow(condContainer, cond,
            function(c) conditions[idx]=c; UpdatePreview() end,
            function()
                table.remove(conditions, idx); table.remove(condRows, idx)
                for _, r in ipairs(condRows) do r:Remove() end
                condRows = {}
                local tmp = table.Copy(conditions); conditions = {}
                for _, c in ipairs(tmp) do conditions[#conditions+1]=c; AddCondRow(c) end
                ReflowRows()
                UpdatePreview()
            end,
            ReflowRows,
            accessTeam)
        condRows[#condRows+1] = row
        ReflowRows()
        UpdatePreview()
    end

    for _, c in ipairs(conditions) do AddCondRow(c) end
    UpdatePreview()

    y = y + 178
    Btn(f, 16, y, 180, 28, "+ Add Condition", BG3, function()
        local nc = {type="rank_gte", rank=RANK_I1 or 1}
        conditions[#conditions+1] = nc; AddCondRow(nc)
    end)
    Btn(f, 204, y, 200, 28, "+ Requirement Groups (OR)", BG3, function()
        local nc = {
            type = "any",
            conditions = {
                {type = "teamclass", class = ""},
            },
        }
        conditions[#conditions+1] = nc; AddCondRow(nc)
    end)

    y = y + 40
    Btn(f, 16, y, 260, 34, "Save Item", GREEN, function()
        local out = {
            itemClass    = teClass:GetValue(),
            mode         = ComboGetData(cbMode) or "sell",
            cost         = tonumber(teCost:GetValue())     or 0,
            maxCarry     = tonumber(teMax:GetValue())      or -1,
            buyMax       = tonumber(teBuyMax:GetValue())   or -1,
            cooldown     = tonumber(teCooldown:GetValue()) or 0,
            tempCooldown = tonumber(teTempCD:GetValue())   or 0,
            restricted   = forceRestrict or cbRestr:GetChecked(),
            descOverride = teDesc:GetValue(),
            conditions   = conditions,
        }
        if out.itemClass == "" then chat.AddText(RED, "Item class cannot be empty."); return end
        onSave(out); f:Close()
    end)
    Btn(f, 290, y, 140, 34, "Cancel", Color(80,50,50), function() f:Close() end)
end

local function BuildInventoryPanel(data, onChanged, getAccessTeam)
    local invPanel = vgui.Create("DPanel")
    invPanel.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end

    local searchBar = Entry(invPanel, 8, 8, invPanel:GetWide() - 168, 26, "Search items in this vendor...")
    searchBar:Dock(TOP); searchBar:DockMargin(8, 8, 8, 0); searchBar:SetTall(26)

    local itemScroll = invPanel:Add("DScrollPanel")
    itemScroll:Dock(FILL); itemScroll:DockMargin(8, 8, 8, 8)
    itemScroll.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG3) end

    local itemList = itemScroll:Add("DPanel"); itemList:Dock(TOP); itemList:DockMargin(4,4,4,4)
    itemList.Paint = function() end

    local Rebuild

    local addBtn = Btn(invPanel, 0, 0, 150, 26, "+ Add Item", GREEN, function()
        OpenItemPicker(function(item)
            local newItem = {
                itemClass    = item.UniqueID,
                mode         = "sell",
                cost         = 0,
                maxCarry     = -1,
                buyMax       = -1,
                cooldown     = 0,
                tempCooldown = 0,
                restricted   = false,
                descOverride = "",
                conditions   = {},
            }
            OpenItemEditor(newItem, function(finalItem)
                data.items[#data.items+1] = finalItem
                if Rebuild then Rebuild() end
                if onChanged then onChanged() end
                if invPanel._updateTabLabel then invPanel._updateTabLabel() end
            end, getAccessTeam and getAccessTeam() or data.accessTeam)
        end)
    end)
    addBtn:Dock(TOP); addBtn:DockMargin(8, 8, 8, 0)

    Rebuild = function()
        itemList:Clear()
        local search = searchBar:GetValue():lower()
        local totalH = 0
        for idx, item in ipairs(data.items) do
            if search ~= "" and not (item.itemClass or ""):lower():find(search, 1, true) then continue end
            local row = itemList:Add("DPanel"); row:SetSize(itemList:GetWide(), 36)
            row:Dock(TOP); row:DockMargin(0,2,0,0); totalH=totalH+38
            local mc = item.mode == "buy" and YELLOW or GREEN
            row.Paint = function(s, sw, sh)
                draw.RoundedBox(4, 0, 0, sw, sh, BG2)
                draw.RoundedBox(3, 4, 8, 38, 20, mc)
                draw.SimpleText(item.mode=="buy" and "BUY" or "SELL", "VE.Small", 23, 18, BG, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(item.itemClass or "?", "VE.Body", 50, 18, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local info = ""
                if item.maxCarry and item.maxCarry ~= -1 then info=info.."max:"..item.maxCarry.."  " end
                if item.cooldown and item.cooldown > 0   then info=info.."cd:"..item.cooldown.."s  " end
                if item.restricted                        then info=info.."[RESTR]  " end
                local nc = #(item.conditions or {})
                if nc > 0 then info=info..nc.." cond"..(nc>1 and "s" or "") end
                draw.SimpleText(info, "VE.Small", sw-104, 18, TEXT_LO, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
            local eb = Btn(row, 0, 5, 44, 26, "Edit", ACCENT, function()
                OpenItemEditor(item, function(u)
                    data.items[idx] = u
                    if Rebuild then Rebuild() end
                    if onChanged then onChanged() end
                end, getAccessTeam and getAccessTeam() or data.accessTeam)
            end); eb:Dock(RIGHT); eb:DockMargin(2,5,2,5); eb:SetWide(44)

            local db = Btn(row, 0, 5, 44, 26, "Del", RED, function()
                table.remove(data.items, idx)
                if Rebuild then Rebuild() end
                if onChanged then onChanged() end
                if invPanel._updateTabLabel then invPanel._updateTabLabel() end
            end); db:Dock(RIGHT); db:DockMargin(2,5,4,5); db:SetWide(44)
        end
        itemList:SetTall(totalH+8)
        if #data.items == 0 then
            local e = itemList:Add("DLabel"); e:Dock(TOP); e:SetTall(40)
            e:SetText("No items. Click + Add Item."); e:SetTextColor(TEXT_LO)
            e:SetFont("VE.Body"); e:SetContentAlignment(5)
        end
        itemScroll:InvalidateLayout(true)
    end

    searchBar.OnChange = function() Rebuild() end
    Rebuild()

    invPanel.Rebuild = Rebuild
    return invPanel
end

function impulse.Vendor.OpenSetupPicker(entIdx, templates)
    if IsValid(impulse.Vendor._pickerFrame) then impulse.Vendor._pickerFrame:Remove() end

    local f = vgui.Create("DFrame")
    impulse.Vendor._pickerFrame = f
    f:SetSize(420, 340); f:Center(); f:SetTitle(""); f:SetDraggable(true); f:MakePopup()
    f:ShowCloseButton(false)
    f.Paint = function(s, sw, sh)
        draw.RoundedBox(8, 0, 0, sw, sh, BG)
        draw.RoundedBox(8, 0, 0, sw, 44, BG2)
        surface.SetDrawColor(BORDER); surface.DrawRect(0, 44, sw, 1)
        draw.SimpleText("Configure Vendor", "VE.Title", 16, 22, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    Btn(f, 420-100, 8, 88, 28, "✕  Close", Color(70,40,40), function() f:Close() end)

    local function OpenNamePrompt()
        f:Close()
        local nf = vgui.Create("DFrame")
        nf:SetSize(360, 160); nf:Center(); nf:SetTitle(""); nf:SetDraggable(true); nf:MakePopup()
        nf:ShowCloseButton(false)
        nf.Paint = function(s, sw, sh)
            draw.RoundedBox(8, 0, 0, sw, sh, BG)
            draw.RoundedBox(8, 0, 0, sw, 44, BG2)
            surface.SetDrawColor(BORDER); surface.DrawRect(0, 44, sw, 1)
            draw.SimpleText("New Vendor Name", "VE.Title", 16, 22, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local hint = nf:Add("DLabel"); hint:SetPos(16, 54)
        hint:SetText("This will be the vendor display name and file name.")
        hint:SetTextColor(TEXT_LO); hint:SetFont("VE.Small"); hint:SizeToContents()

        local te = Entry(nf, 16, 76, 328, 24, "CP Equipment Vendor")

        local statusLbl = nf:Add("DLabel"); statusLbl:SetPos(16, 106)
        statusLbl:SetSize(220, 18); statusLbl:SetText(""); statusLbl:SetFont("VE.Small"); statusLbl:SetTextColor(RED)

        Btn(nf, 16, 108, 160, 30, "Create & Edit", GREEN, function()
            local raw = te:GetValue():match("^%s*(.-)%s*$")
            if raw == "" then statusLbl:SetText("Name cannot be empty."); return end
            if #raw < 3 then statusLbl:SetText("Name too short."); return end

            local uid = raw:lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
            if #uid > 48 then uid = uid:sub(1, 48) end

            local data = {
                uid         = uid,
                name        = raw,
                desc        = "",
                model       = "models/Humans/Group01/male_02.mdl",
                skin        = 0,
                bodygroups  = "",
                sequence    = "",
                hudName     = raw,
                hudDesc     = "",
                accessTeam  = -1,
                accessClass = "",
                accessRank  = -1,
                accessConditions = {},
                clearSameType = false,
                items       = {},
                _isNew      = true,
                _entIdx     = entIdx,
                talk        = true,
                gender      = "male",
            }
            nf:Close()
            RefreshOptions()
            impulse.Vendor.OpenEditor(data)
        end)

        Btn(nf, 192, 108, 100, 30, "Cancel", Color(80,50,50), function() nf:Close() end)
    end

    local desc = f:Add("DLabel"); desc:SetPos(16, 56)
    desc:SetText("What would you like to do with this vendor?")
    desc:SetTextColor(TEXT_LO); desc:SetFont("VE.Body"); desc:SizeToContents()

    Btn(f, 16, 84, 388, 40, "Create New Vendor", GREEN, function() OpenNamePrompt() end)

    local sep = f:Add("DPanel"); sep:SetPos(16, 134); sep:SetSize(388, 1)
    sep.Paint = function(s, sw, sh) draw.RoundedBox(0, 0, 0, sw, sh, BORDER) end

    local orLbl = f:Add("DLabel"); orLbl:SetPos(196, 126)
    orLbl:SetText("or"); orLbl:SetTextColor(TEXT_LO); orLbl:SetFont("VE.Small"); orLbl:SizeToContents()

    if #templates == 0 then
        local noTpl = f:Add("DLabel"); noTpl:SetPos(16, 148)
        noTpl:SetText("No existing templates found.")
        noTpl:SetTextColor(TEXT_LO); noTpl:SetFont("VE.Body"); noTpl:SizeToContents()
    else
        local tplLabel = f:Add("DLabel"); tplLabel:SetPos(16, 148)
        tplLabel:SetText("Use Existing Template:")
        tplLabel:SetTextColor(TEXT_LO); tplLabel:SetFont("VE.Label"); tplLabel:SizeToContents()

        local scroll = f:Add("DScrollPanel")
        scroll:SetPos(16, 168); scroll:SetSize(388, 140)
        scroll.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG3) end

        table.sort(templates, function(a, b) return (a.name or "") < (b.name or "") end)

        for _, tpl in ipairs(templates) do
            local row = scroll:Add("DButton")
            row:Dock(TOP); row:DockMargin(4, 4, 4, 0); row:SetTall(30); row:SetText("")
            local tplName = tpl.name or tpl.uid
            local tplUID  = tpl.uid
            row.Paint = function(s, sw, sh)
                local c = s:IsHovered() and BG2 or BG3
                draw.RoundedBox(4, 0, 0, sw, sh, c)
                draw.SimpleText(tplName, "VE.Body", 10, sh/2, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(tplUID,  "VE.Small", sw-8, sh/2, TEXT_LO, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
            row.DoClick = function()
                f:Close()
                net.Start("impulseVendorBindTemplate")
                net.WriteUInt(entIdx, 16)
                net.WriteString(tplUID)
                net.SendToServer()
            end
        end
    end
end

function impulse.Vendor.OpenEditor(vendorData)
    RefreshOptions()
    if IsValid(impulse.Vendor._editorFrame) then impulse.Vendor._editorFrame:Remove() end

    local data = table.Copy(vendorData)
    data.items = data.items or {}
    local accessConditions = table.Copy(data.accessConditions or {})

    if data.accessTeam and data.accessTeam ~= -1 then
        accessConditions[#accessConditions+1] = {type = "team", team = data.accessTeam}
    end
    if data.accessClass and data.accessClass ~= "" then
        accessConditions[#accessConditions+1] = {type = "teamclass", class = data.accessClass}
    end
    if data.accessRank and data.accessRank ~= -1 then
        accessConditions[#accessConditions+1] = {type = "rank_gte", rank = data.accessRank}
    end

    local f = vgui.Create("DFrame")
    impulse.Vendor._editorFrame = f
    f:SetSize(EDITOR_W, EDITOR_H); f:Center(); f:SetTitle(""); f:SetDraggable(true); f:MakePopup()
    f:ShowCloseButton(false)
    f.Paint = function(s, sw, sh)
        draw.RoundedBox(8, 0, 0, sw, sh, BG); draw.RoundedBox(8, 0, 0, sw, 44, BG2)
        surface.SetDrawColor(BORDER); surface.DrawRect(0, 44, sw, 1)
        draw.SimpleText("Vendor Editor", "VE.Title", 16, 22, TEXT_HI, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("UID: "..(data.uid or "?"), "VE.Small", sw-112, 22, TEXT_LO, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    Btn(f, EDITOR_W-100, 8, 88, 28, "✕  Close", Color(70,40,40), function() f:Close() end)

    local sheet = SimpleTabSheet(f, 8, 52, EDITOR_W-16, EDITOR_H-120)

    local genPanel = vgui.Create("DScrollPanel")
    genPanel.Paint = function(s, sw, sh) draw.RoundedBox(4, 0, 0, sw, sh, BG2) end
    local gw = EDITOR_W-32; local gy = 12
    local function GL(t)
        local l = genPanel:Add("DLabel"); l:SetPos(12, gy); l:SetText(t)
        l:SetTextColor(TEXT_LO); l:SetFont("VE.Label"); l:SizeToContents()
    end
    local function GE(ph, val, w, multi)
        local te
        if multi then
            te = genPanel:Add("DTextEntry"); te:SetPos(12, gy+18); te:SetSize(w or gw-24, 54)
            te:SetMultiline(true); te:SetValue(val or ""); te:SetFont("VE.Body")
            te.Paint = function(s, sw, sh)
                draw.RoundedBox(4, 0, 0, sw, sh, BG3)
                draw.RoundedBox(4, 0, 0, sw, sh, Color(BORDER.r, BORDER.g, BORDER.b, 120))
                s:DrawTextEntryText(TEXT_HI, ACCENT2, TEXT_HI)
            end
            gy = gy+80
        else
            te = Entry(genPanel, 12, gy+18, w or gw-24, 24, ph, val); gy=gy+50
        end
        return te
    end
    GL("Vendor Name *");              local teVName   = GE("Civil Protection Equipment Vendor", data.name)
    GL("Description");                local teVDesc   = GE("Supplies CPs with...",              data.desc,    nil, true)
    GL("HUD Name (crosshair label)"); local teHUDName = GE("CP Equipment",                      data.hudName)
    GL("HUD Description");            local teHUDDesc = GE("E: Open",                           data.hudDesc)
    gy = gy+4
    GL("Model Path *");    local teModel = GE("models/Humans/Group01/male_02.mdl", data.model)
    GL("Skin");            local teSkin  = NumEntry(genPanel, 12, gy+18, 80,  data.skin or 0, 0);            gy=gy+50
    GL("Bodygroups");      local teBodyg = Entry(genPanel, 12, gy+18, 160, 24, "01",  data.bodygroups);      gy=gy+50
    GL("Idle Sequence");   local teSeq   = Entry(genPanel, 12, gy+18, 200, 24, "idle_1", data.sequence);     gy=gy+50
    GL("Inventory Behavior"); local cbClearType = Checkbox(genPanel, 12, gy+18, "Buy clears other same-type items", data.clearSameType); gy=gy+50
    local cbTalk, cbGender
    local function SyncGenderLock()
        if not IsValid(cbGender) then return end
        cbGender:SetEnabled(cbTalk:GetChecked())
        cbGender:SetAlpha(cbTalk:GetChecked() and 255 or 120)
    end
    GL("Voice"); cbTalk = Checkbox(genPanel, 12, gy+18, "Plays a greeting when opened", data.talk ~= false, SyncGenderLock); gy=gy+42
    cbGender = Combo(genPanel, 12, gy, 160, {{"Male","male"},{"Female","female"},{"CP","cp"}}, data.gender or "male"); gy=gy+50
    SyncGenderLock()

    sheet:AddSheet("General", genPanel)

    local accPanel = BuildAccessPanel(accessConditions)
    sheet:AddSheet("Access", accPanel)

    local function RebuildPreview()
    end

    local invPanel = BuildInventoryPanel(data, RebuildPreview, function() return -1 end)
    local invTab = sheet:AddSheet("Inventory ("..#data.items..")", invPanel)
    invPanel._updateTabLabel = function()
        sheet:SetTabLabel(3, "Inventory ("..#data.items..")")
    end

    local barY = EDITOR_H-60
    local statusLbl = f:Add("DLabel"); statusLbl:SetPos(16, barY+16); statusLbl:SetSize(440, 22)
    statusLbl:SetText(""); statusLbl:SetFont("VE.Body"); statusLbl:SetTextColor(TEXT_LO)

    impulse.Vendor.EditorResultCallback = function(success, msg)
        if not IsValid(statusLbl) then return end
        statusLbl:SetTextColor(success and GREEN or RED)
        statusLbl:SetText((success and "✓ " or "✗ ")..msg)
    end

    f.OnClose = function()
        if impulse.Vendor.EditorResultCallback then
            local cb = impulse.Vendor.EditorResultCallback
            timer.Simple(0, function()
                if impulse.Vendor.EditorResultCallback == cb then
                    impulse.Vendor.EditorResultCallback = nil
                end
            end)
        end
    end

    local function DoSave()
        data.name       = teVName:GetValue()
        data.desc       = teVDesc:GetValue()
        data.hudName    = teHUDName:GetValue()
        data.hudDesc    = teHUDDesc:GetValue()
        data.model      = teModel:GetValue()
        data.skin       = tonumber(teSkin:GetValue()) or 0
        data.bodygroups = teBodyg:GetValue()
        data.sequence   = teSeq:GetValue()
        data.accessTeam  = -1
        data.accessClass = ""
        data.accessRank  = -1
        data.accessConditions = accPanel:GetConditions()
        data.clearSameType = cbClearType:GetChecked()
        data.talk   = cbTalk:GetChecked()
        data.gender = ComboGetData(cbGender) or "male"
        if data.name == "" then statusLbl:SetTextColor(RED); statusLbl:SetText("Name cannot be empty."); return end
        if data.model == "" or not data.model:match("^models/") then
            statusLbl:SetTextColor(RED); statusLbl:SetText("Invalid model path."); return
        end
        local encoded = pon.encode(data)
        net.Start("impulseVendorEditorSave"); net.WriteUInt(#encoded, 32); net.WriteData(encoded, #encoded); net.SendToServer()
        statusLbl:SetTextColor(TEXT_LO); statusLbl:SetText("Saving…")
    end

    Btn(f, EDITOR_W-122, barY+8, 110, 36, "💾  Save", GREEN, DoSave)
    Btn(f, EDITOR_W-240, barY+8, 110, 36, "Delete", RED, function()
        if data._isNew then statusLbl:SetTextColor(RED); statusLbl:SetText("Save first before deleting."); return end
        local conf = vgui.Create("DFrame"); conf:SetSize(320, 120); conf:Center()
        conf:SetTitle("Confirm Delete"); conf:MakePopup()
        conf.Paint = function(s, sw, sh) draw.RoundedBox(6, 0, 0, sw, sh, BG) end
        local cl = conf:Add("DLabel"); cl:SetPos(12, 40)
        cl:SetText("Delete '"..data.uid.."'? Cannot be undone.")
        cl:SetTextColor(TEXT_HI); cl:SetFont("VE.Body"); cl:SetWrap(true); cl:SetSize(296, 40)
        Btn(conf, 12, 80, 120, 28, "Yes, Delete", RED, function()
            net.Start("impulseVendorEditorDelete"); net.WriteString(data.uid); net.SendToServer()
            conf:Close(); f:Close()
        end)
        Btn(conf, 145, 80, 100, 28, "Cancel", BG3, function() conf:Close() end)
    end)
end

net.Receive("impulseVendorTemplateList", function()
    local sz  = net.ReadUInt(32)
    local raw = net.ReadData(sz)
    local ok, payload = pcall(pon.decode, raw)
    if not ok or not payload then return end
    impulse.Vendor.OpenSetupPicker(payload.entIdx, payload.templates)
end)

net.Receive("impulseVendorEditorData", function()
    local sz  = net.ReadUInt(32); local raw = net.ReadData(sz)
    local ok, data = pcall(pon.decode, raw)
    if not ok or not data then return end
    impulse.Vendor.OpenEditor(data)
end)

net.Receive("impulseVendorEditorResult", function()
    local success = net.ReadBool(); local msg = net.ReadString()
    if impulse.Vendor.EditorResultCallback then
        impulse.Vendor.EditorResultCallback(success, msg)
    end
    notification.AddLegacy((success and "✓ " or "✗ ")..msg, success and NOTIFY_GENERIC or NOTIFY_ERROR, 4)
end)

local EDITOR_OPEN_RANGE = 96

hook.Add("KeyPress", "VendorEditor.OpenOnUse", function(ply, key)
    if key ~= IN_USE then return end
    if not LocalPlayer():IsSuperAdmin() then return end
    local ent = LocalPlayer():GetEyeTrace().Entity
    if not IsValid(ent) or ent:GetClass() ~= "impulse_vendor" then return end
    if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > (EDITOR_OPEN_RANGE * EDITOR_OPEN_RANGE) then return end
    if ent:GetVendorUID() == "" then
        net.Start("impulseVendorEditorOpen")
        net.WriteUInt(ent:EntIndex(), 16)
        net.SendToServer()
    end
end)

net.Receive("impulseVendorUseDownload", function()
    local uid     = net.ReadString()
    local buyLen  = net.ReadUInt(32)
    local buy     = pon.decode(net.ReadData(buyLen))
    local sellLen = net.ReadUInt(32)
    local sell    = pon.decode(net.ReadData(sellLen))

    local function Rehydrate(tbl)
        for _, entry in pairs(tbl or {}) do
            if entry.Conditions and #entry.Conditions > 0 then
                local snap = entry.Conditions
                entry.CanBuy = function(ply)
                    return impulse.Vendor.Conditions.EvaluateAll(snap, ply)
                end
            end
        end
    end
    Rehydrate(buy)
    Rehydrate(sell)

    impulse.Vendor.Data[uid] = impulse.Vendor.Data[uid] or { Buy = {}, Sell = {} }
    impulse.Vendor.Data[uid].Buy  = buy
    impulse.Vendor.Data[uid].Sell = sell

    if impulse_vendor and IsValid(impulse_vendor) then return end
    impulse_vendor = vgui.Create("impulseVendorMenu")
    impulse_vendor:SetupVendor()
end)

local function SerializeLiveDataForEditor(uid)
    local liveData = impulse.Vendor.LiveData and impulse.Vendor.LiveData[uid]
    if not liveData then return nil end

    local serialized = {
        uid         = liveData.UniqueID or uid,
        name        = liveData.Name       or "",
        desc        = liveData.Desc       or "",
        hudName     = liveData.HUDName    or "",
        hudDesc     = liveData.HUDDesc    or "",
        model       = liveData.Model      or "",
        skin        = liveData.Skin       or 0,
        bodygroups  = liveData.Bodygroups or "",
        sequence    = liveData.Sequence   or "",
        accessTeam  = liveData.accessTeam  or -1,
        accessClass = liveData.accessClass or "",
        accessRank  = liveData.accessRank  or -1,
        accessConditions = liveData.AccessConditions or {},
        clearSameType = liveData.ClearSameType == true,
        items       = {},
        talk        = liveData.Talk or false,
        gender      = liveData.Gender or "male",
    }

    for cls, entry in pairs(liveData.Sell or {}) do
        serialized.items[#serialized.items+1] = {
            itemClass=cls, mode="sell",
            cost=entry.Cost or 0, maxCarry=entry.Max or -1, buyMax=entry.BuyMax or -1,
            cooldown=entry.Cooldown or 0, tempCooldown=entry.TempCooldown or 0,
            restricted=entry.Restricted==true, restricted=entry.Restricted==true, descOverride=entry.RawDesc or "",
            conditions=entry.Conditions or {},
        }
    end
    for cls, entry in pairs(liveData.Buy or {}) do
        serialized.items[#serialized.items+1] = {
            itemClass=cls, mode="buy",
            cost=entry.Cost or 0, maxCarry=entry.Max or -1, buyMax=entry.BuyMax or -1,
            cooldown=entry.Cooldown or 0, tempCooldown=entry.TempCooldown or 0,
            restricted=entry.Restricted==true, restricted=entry.Restricted==true, descOverride=entry.RawDesc or "",
            conditions=entry.Conditions or {},
        }
    end

    return serialized
end

net.Receive("impulseVendorForceEdit", function()
    local uid = net.ReadString()
    local serialized = SerializeLiveDataForEditor(uid)
    if serialized then
        impulse.Vendor.OpenEditor(serialized)
    end
end)

function impulse.Vendor.InjectVendorEditButton(shopPanel, uid)
    if not LocalPlayer():IsSuperAdmin() then return end
    if not uid or uid == "" then return end

    local pw, ph = shopPanel:GetSize()
    local titleBarH = 24
    local btnW, btnH = 130, titleBarH

    local editBtn = vgui.Create("DButton", shopPanel)
    editBtn:SetSize(btnW, btnH)
    editBtn:SetPos((pw - btnW) / 2, 0)
    editBtn:SetText("")
    editBtn.label = "Edit Vendor"
    editBtn.Paint = function(s, w, h)
        local c = Color(40, 90, 140)
        if s:IsHovered() then c = Color(60, 110, 160) end
        draw.RoundedBox(0, 0, 0, w, h, c)
        draw.SimpleText(s.label, "DermaDefault", w/2, h/2, Color(230,230,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    editBtn.DoClick = function()
        shopPanel:Remove()
        local serialized = SerializeLiveDataForEditor(uid)
        if serialized then
            impulse.Vendor.OpenEditor(serialized)
        end
    end
end