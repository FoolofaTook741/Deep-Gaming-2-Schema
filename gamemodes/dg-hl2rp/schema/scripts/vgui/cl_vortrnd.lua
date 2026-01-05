local PANEL = {}

local w, h = ScrW(), ScrH()
local blurDrawPanel = {
    [1] = function(x, y, w, h)
        -- Bokeh DOF blur
        render.UpdateScreenEffectTexture()

        render.SetScissorRect(x, y, x+w, y+h, true)
        DrawBokehDOF(6, 0, 0)
        render.SetScissorRect(0, 0, 0, 0, false)
    end
}

concommand.Add("debug_blueprints", function()
    impulse.debugPrint("=== Blueprint Status Debug ===")
    impulse.debugPrint("BlueprintUnlocked_AK:", BlueprintUnlocked_AK)
    impulse.debugPrint("BlueprintUnlocked_P90:", BlueprintUnlocked_P90)
    impulse.debugPrint("BlueprintUnlocked_SCARH:", BlueprintUnlocked_SCARH)
    impulse.debugPrint("BlueprintUnlocked_SPAS12:", BlueprintUnlocked_SPAS12)
    impulse.debugPrint("BlueprintUnlocked_FAMAS:", BlueprintUnlocked_FAMAS)
    impulse.debugPrint("BlueprintUnlocked_TAU:", BlueprintUnlocked_TAU)
    impulse.debugPrint("BlueprintUnlocked_Scanners:", BlueprintUnlocked_Scanners)
    impulse.debugPrint("BlueprintUnlocked_Cameras:", BlueprintUnlocked_Cameras)
    impulse.debugPrint("BlueprintUnlocked_BodyArmor:", BlueprintUnlocked_BodyArmor)
end)

local function BlurRect(x, y, w, h)
    blurDrawPanel[1](x,y,w,h)
end

local skillTree = {
    -- Tier 1
    {name = "AK", desc = "A simple rifle blueprint - unlocks crafting for everyone once researched", tier = 1, x = 0.2, y = 0.7, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 5},
     onLearn = function()
         LocalPlayer():Notify("You can now craft AK-47 rifles! Blueprint available to all players.", 1)
         hook.Run("VortSkillLearned", "AK")
     end},
    {name = "P90", desc = "An SMG Blueprint - unlocks crafting for everyone once researched", tier = 1, x = 0.8, y = 0.7, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 3},
     onLearn = function()
         LocalPlayer():Notify("P90 SMG blueprint acquired! Available to all players.", 1)
         hook.Run("VortSkillLearned", "P90")
     end},
    
    -- Tier 2
    {name = "OSIAER Blueprint", desc = "Blueprint for the Overwatch Standard Issue Antimatter Enforcement Regulator", tier = 2, x = 0.1, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 8, util_metalplate = 3, util_electronics = 2},
     onLearn = function()
         LocalPlayer():Notify("O.S.I.A.E.R. weapon blueprint acquired! Available to all players.", 1)
         hook.Run("VortSkillLearned", "OSIAER Blueprint")
     end},
    {name = "OSIPR MK. I Blueprint", desc = "Blueprint for the Overwatch Standard Issue Pulse Rifle Mark I", tier = 2, x = 0.25, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 10, util_metalplate = 4, util_electronics = 3},
     onLearn = function()
         LocalPlayer():Notify("O.S.I.P.R. MK. I blueprint learned! Available to all players.", 1)
         hook.Run("VortSkillLearned", "OSIPR MK. I Blueprint")
     end},
    {name = "AK-47 Blueprint", desc = "Blueprint for the reliable AK-47 assault rifle", tier = 2, x = 0.4, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 6, util_metalplate = 3, util_gear = 2},
     onLearn = function()
         LocalPlayer():Notify("AK-47 blueprint acquired! Available to all players.", 1)
         hook.Run("VortSkillLearned", "AK-47 Blueprint")
     end},
    {name = "FAMAS Blueprint", desc = "Blueprint for the French FAMAS assault rifle", tier = 2, x = 0.55, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 7, util_metalplate = 3, util_electronics = 1},
     onLearn = function()
         LocalPlayer():Notify("FAMAS blueprint learned! Available to all players.", 1)
         hook.Run("VortSkillLearned", "FAMAS Blueprint")
     end},
    {name = "Scanners", desc = "A blueprint for Combine surveillance drone technology", tier = 2, x = 0.7, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 6, util_metalplate = 2},
     onLearn = function()
         LocalPlayer():Notify("Scanner drone technology unlocked! Blueprint available to all players.", 1)
         hook.Run("VortSkillLearned", "Scanners")
     end},
    {name = "Nest Cleansing", desc = "A special Ability for Vortigaunts to cleanse Antlion nests.", tier = 2, x = 0.85, y = 0.5, unlocked = true, learned = false, 
     requirements = {util_antlionextract = 10},
     onLearn = function()
         LocalPlayer():Notify("Nest Cleansing ability unlocked!", 1)
         LocalPlayer().hasNestCleansing = true
         net.Start("CleanseSkillLearned")
         net.SendToServer()
     end},
    
    -- Tier 3 - Advanced Combine Weapons
    {name = "OSIPR MK. II-E Blueprint", desc = "Blueprint for the enhanced Overwatch Standard Issue Pulse Rifle Mark II", tier = 3, x = 0.1, y = 0.3, unlocked = false, learned = false, 
     requirements = {util_antlionextract = 15, util_electronics = 4, util_gear = 2},
     onLearn = function()
         LocalPlayer():Notify("O.S.I.P.R. MK. II-E blueprint acquired! Advanced Combine weaponry unlocked.", 1)
         hook.Run("VortSkillLearned", "OSIPR MK. II-E Blueprint")
     end},
    {name = "OSIPR MK. II-R Blueprint", desc = "Blueprint for the rapid-fire Overwatch Standard Issue Pulse Rifle Mark II", tier = 3, x = 0.3, y = 0.3, unlocked = false, learned = false, 
     requirements = {util_antlionextract = 15, util_metalplate = 5, util_electronics = 4},
     onLearn = function()
         LocalPlayer():Notify("O.S.I.P.R. MK. II-R blueprint learned! Rapid-fire technology unlocked.", 1)
         hook.Run("VortSkillLearned", "OSIPR MK. II-R Blueprint")
     end},
    {name = "Body Armor", desc = "Blueprint for Combine protective armor systems", tier = 3, x = 0.5, y = 0.3, unlocked = false, learned = false, 
     requirements = {util_antlionextract = 15, util_metalplate = 5, util_plastic = 3},
     onLearn = function()
         LocalPlayer():Notify("Combine armor crafting knowledge acquired! Craft various protective gear.", 1)
         hook.Run("VortSkillLearned", "Body Armor")
     end},
    {name = "OSIPR MK. III Blueprint", desc = "Blueprint for the most advanced Overwatch Standard Issue Pulse Rifle", tier = 3, x = 0.7, y = 0.3, unlocked = false, learned = false, 
     requirements = {util_antlionextract = 20, util_electronics = 5, util_gear = 3},
     onLearn = function()
         LocalPlayer():Notify("O.S.I.P.R. MK. III blueprint mastered! Ultimate Combine weapon technology!", 1)
         hook.Run("VortSkillLearned", "OSIPR MK. III Blueprint")
     end},
    
    -- Tier 4 (master skill) - TAU Cannon Blueprint
    {name = "TAU Cannon Blueprint", desc = "Blueprint for the ultimate superweapon - the TAU Cannon. Most advanced technology.", tier = 4, x = 0.5, y = 0.1, unlocked = false, learned = false, 
     requirements = {util_antlionextract = 25, util_metalplate = 10, util_electronics = 5, util_gear = 3},
     onLearn = function()
         LocalPlayer():Notify("TAU CANNON BLUEPRINT ACQUIRED! The ultimate weapon technology is yours!", 1)
         hook.Run("VortSkillLearned", "TAU Cannon Blueprint")
         -- Special celebration effects
         for i = 1, 5 do
             timer.Simple(i * 0.5, function()
                 if IsValid(LocalPlayer()) then
                     local effectdata = EffectData()
                     effectdata:SetOrigin(LocalPlayer():GetPos() + Vector(0, 0, 50))
                     effectdata:SetMagnitude(2)
                     util.Effect("cball_explode", effectdata)
                 end
             end)
         end
         -- Play special sound
         surface.PlaySound("ambient/energy/weld1.wav")
     end},
}

-- Network receivers for server responses
net.Receive("VortSkillLearned", function()
    local skillName = net.ReadString()
    
    -- Find and mark skill as learned
    for _, skill in ipairs(skillTree) do
        if skill.name == skillName then
            skill.learned = true
            
            -- Set the corresponding blueprint boolean
            local blueprintMappings = {
                ["OSIAER Blueprint"] = function() BlueprintUnlocked_OSIAER = true end,
                ["OSIPR MK. I Blueprint"] = function() BlueprintUnlocked_OSIPRMK1 = true end,
                ["OSIPR MK. II-E Blueprint"] = function() BlueprintUnlocked_OSIPRMK2E = true end,
                ["OSIPR MK. II-R Blueprint"] = function() BlueprintUnlocked_OSIPRMK2R = true end,
                ["OSIPR MK. III Blueprint"] = function() BlueprintUnlocked_OSIPRMK3 = true end,
                ["AK-47 Blueprint"] = function() BlueprintUnlocked_AK47 = true end,
                ["FAMAS Blueprint"] = function() BlueprintUnlocked_FAMAS = true end,
                ["TAU Cannon Blueprint"] = function() BlueprintUnlocked_TAU = true end,
                ["Scanners"] = function() BlueprintUnlocked_Scanners = true end,
                ["Body Armor"] = function() BlueprintUnlocked_BodyArmor = true end,
            }
            
            if blueprintMappings[skillName] then
                blueprintMappings[skillName]()
                impulse.debugPrint("Blueprint unlocked: " .. skillName) -- Debug output
            end
        
            if skill.onLearn then
                skill.onLearn()
            end
            
            -- Unlock next tier skills
            if skill.tier < 4 then
                for _, nextSkill in ipairs(skillTree) do
                    if nextSkill.tier == skill.tier + 1 then
                        nextSkill.unlocked = true
                    end
                end
            end
            break
        end
    end
    
    LocalPlayer():Notify("Learned: " .. skillName, 1)
    surface.PlaySound("oakman/deadspace/ui/hud_save_confirm.wav")
end)

function PANEL:Init()
    self:SetSize(800, 600)
    self:Center()
    self:SetTitle("Vortigaunt Skill Tree")
    self:SetDraggable(false)
    self:MakePopup()
    self:SetDeleteOnClose(true)
    
    self.skillNodes = {}
    self.stars = {}
    self.tooltipAlpha = 0
    self.tooltipTargetAlpha = 0
    self.hoveredSkill = nil
    
    -- Generate stars and skill nodes
    self:GenerateStars()
    
    self:CreateSkillNodes()
end

function PANEL:GenerateStars()
    local numStars = 150 -- Number of stars
    
    for i = 1, numStars do
        local star = {
            x = math.random(0, self:GetWide()),
            y = math.random(0, self:GetTall()),
            size = math.random(1, 4), -- Random size between 1-4 pixels
            speed = math.random(10, 50), -- Random speed for mouse avoidance
            direction = math.random(0, 360), -- Random direction in degrees
            brightness = math.random(100, 255), -- Random brightness
            twinkle = math.random(0, 100) / 100, -- Twinkle effect
        }
        table.insert(self.stars, star)
    end
end

function PANEL:CreateSkillNodes()
    for i, skill in ipairs(skillTree) do
        local node = vgui.Create("DButton", self)
        local nodeSize = 100
        node:SetSize(nodeSize, nodeSize)
        node:SetPos(skill.x * (self:GetWide() - nodeSize), skill.y * (self:GetTall() - nodeSize))
        node:SetText("")
        
        node.skill = skill
        node.skillIndex = i
        node.isHovered = false
        
        function node:Paint(w, h)
            local centerX, centerY = w/2, h/2
            local radius = w/2 - 5
            
            -- Initialize hover animation properties if not set
            if not self.hoverRadius then
                self.hoverRadius = 0
                self.targetHoverRadius = 0
            end
            
            -- Animate hover radius
            self.hoverRadius = Lerp(FrameTime() * 10, self.hoverRadius, self.targetHoverRadius)
            
            -- Draw animated hover glow circle
            if self.hoverRadius > 0 then
                surface.SetDrawColor(Color(255, 255, 255, math.min(100, self.hoverRadius * 2)))
                local hoverPoly = {}
                for i = 1, 32 do
                    local angle = (i / 32) * math.pi * 2
                    table.insert(hoverPoly, {
                        x = centerX + math.cos(angle) * self.hoverRadius,
                        y = centerY + math.sin(angle) * self.hoverRadius
                    })
                end
                surface.DrawPoly(hoverPoly)
            end
            
            -- Draw skill circle
            local bgColor = Color(255, 50, 50, 25)
            if self.skill.learned then
                bgColor = Color(0, 150, 0, 100) -- Green for learned
            elseif self.skill.unlocked then
                bgColor = Color(100, 100, 150, 100) -- Blue for available
            end
            
            -- Brighten color when hovered
            if self.isHovered then
                bgColor.r = math.min(255, bgColor.r + 30)
                bgColor.g = math.min(255, bgColor.g + 30)
                bgColor.b = math.min(255, bgColor.b + 30)
            end
            
            -- Draw circle background
            draw.NoTexture()
            surface.SetDrawColor(bgColor)
            
            local segments = 32
            local poly = {}
            for i = 1, segments do
                local angle = (i / segments) * math.pi * 2
                table.insert(poly, {
                    x = centerX + math.cos(angle) * radius,
                    y = centerY + math.sin(angle) * radius
                })
            end
            surface.DrawPoly(poly)
            
            -- Draw border with greater thickness
            local borderColor = Color(255, 255, 255, 150)
            if self.isHovered then
                borderColor = Color(255, 255, 255, 255)
            end
            surface.SetDrawColor(borderColor)
            
            -- Draw multiple circles for thickness
            local borderThickness = 3
            for thickness = 1, borderThickness do
                local borderRadius = radius - thickness + 1
                for i = 1, segments do
                    local angle1 = (i / segments) * math.pi * 2
                    local angle2 = ((i + 1) / segments) * math.pi * 2
                    surface.DrawLine(
                        centerX + math.cos(angle1) * borderRadius,
                        centerY + math.sin(angle1) * borderRadius,
                        centerX + math.cos(angle2) * borderRadius,
                        centerY + math.sin(angle2) * borderRadius
                    )
                end
            end
            
            -- Draw skill name
            local textColor = Color(255, 255, 255)
            if self.isHovered then
                textColor = Color(255, 255, 100) -- Yellow when hovered
            end
            draw.SimpleText(self.skill.name, "DermaDefault", centerX, centerY - 10, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Tier " .. self.skill.tier, "DermaDefault", centerX, centerY + 10, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        function node:OnCursorEntered()
            self.isHovered = true
            local radius = self:GetWide()/2 - 5
            local borderThickness = 3
            self.targetHoverRadius = radius - borderThickness -- Fits inside the border
            self:GetParent().hoveredSkill = self.skill
            self:GetParent().tooltipTargetAlpha = 255
            surface.PlaySound("oakman/deadspace/ui/ui_hover.wav")
        end
        
        function node:OnCursorExited()
            self.isHovered = false
            self.targetHoverRadius = 0
            self:GetParent().hoveredSkill = nil
            self:GetParent().tooltipTargetAlpha = 0
        end
        
        function node:DoClick()
            if self.skill.unlocked and not self.skill.learned then
                -- Check if player has required items first
                local hasItems, missingItem, requiredAmount, playerAmount = self:GetParent():HasRequiredItems(self.skill.requirements or {})
                
                if not hasItems then
                    local itemName = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(missingItem)] and 
                    impulse.Inventory.Items[impulse.Inventory.ClassToNetID(missingItem)].Name or missingItem
                    LocalPlayer():Notify("Missing: " .. requiredAmount .. "x " .. itemName .. " (have " .. playerAmount .. ")", 2)
                    surface.PlaySound("oakman/deadspace/door_locked.mp3")
                    return
                end
                
                -- Start the minigame
                local minigame = vgui.Create("VortResearchMinigame")
                minigame.skillName = self.skill.name
                minigame.skillRequirements = self.skill.requirements or {}
                
                -- Close this panel while minigame is active
                self:GetParent():SetVisible(false)
                
                -- Show this panel again when minigame closes
                minigame.OnClose = function()
                    timer.Simple(0.1, function()
                        if IsValid(self:GetParent()) then
                            self:GetParent():SetVisible(true)
                        end
                    end)
                end
            end
        end
        
        self.skillNodes[i] = node
    end
end

function PANEL:Think()
    -- Smooth tooltip fade in/out
    self.tooltipAlpha = Lerp(FrameTime() * 8, self.tooltipAlpha, self.tooltipTargetAlpha)
    
    -- Get mouse position relative to panel
    local mouseX, mouseY = self:ScreenToLocal(input.GetCursorPos())
    
    -- Animate stars
    for _, star in ipairs(self.stars) do
        -- Calculate distance from mouse
        local dx = star.x - mouseX
        local dy = star.y - mouseY
        local distance = math.sqrt(dx * dx + dy * dy)
        
        -- If mouse is close, make star move away
        local avoidRadius = 80
        if distance < avoidRadius and distance > 0 then
            -- Calculate direction away from mouse
            local angle = math.atan2(dy, dx)
            star.x = star.x + math.cos(angle) * star.speed * FrameTime()
            star.y = star.y + math.sin(angle) * star.speed * FrameTime()
        else
            -- Normal random movement
            local radians = math.rad(star.direction)
            star.x = star.x + math.cos(radians) * (star.speed * 0.3) * FrameTime()
            star.y = star.y + math.sin(radians) * (star.speed * 0.3) * FrameTime()
        end
        
        -- Wrap around screen edges
        if star.x > self:GetWide() then
            star.x = 0
        elseif star.x < 0 then
            star.x = self:GetWide()
        end
        
        if star.y > self:GetTall() then
            star.y = 0
        elseif star.y < 0 then
            star.y = self:GetTall()
        end
        
        -- Update twinkle effect
        star.twinkle = star.twinkle + FrameTime() * 2
        if star.twinkle > math.pi * 2 then
            star.twinkle = 0
        end
    end
end

function PANEL:Paint(w, h)
    -- Apply overall blur effect to background
    BlurRect(self.x, self.y, w-2, h-2)
    
    -- Draw black background with slight transparency to show blur
    surface.SetDrawColor(Color(0, 0, 0, 240))
    surface.DrawRect(0, 0, w-2, h-2)
    
    -- Draw animated square stars that avoid mouse
    for _, star in ipairs(self.stars) do
        local twinkleAlpha = math.abs(math.sin(star.twinkle)) * 0.3 + 0.7
        local alpha = math.min(255, star.brightness * twinkleAlpha)
        
        surface.SetDrawColor(Color(255, 255, 255, alpha))
        
        -- Draw simple square star
        surface.DrawRect(star.x - star.size/2, star.y - star.size/2, star.size, star.size)
    end
    
    -- Draw subtle border
    surface.SetDrawColor(Color(100, 100, 100, 255))
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2, 1)
    
    -- Draw title with space theme
    draw.SimpleText("Vortigaunt Research Tree", "DermaLarge", w/2, 30, Color(200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    -- Draw connecting lines between tiers
    self:DrawConnections()
    
    -- Draw tooltip
    if self.hoveredSkill and self.tooltipAlpha > 0 then
        self:DrawTooltip()
    end
end

function PANEL:DrawTooltip()
    local skill = self.hoveredSkill
    local mouseX, mouseY = input.GetCursorPos()
    local x, y = self:ScreenToLocal(mouseX, mouseY)
    
    -- Calculate tooltip height based on requirements
    local baseHeight = 80
    local requirementsHeight = 0
    if skill.requirements and table.Count(skill.requirements) > 0 then
        requirementsHeight = 20 + (table.Count(skill.requirements) * 15)
    end
    
    local tooltipW = 300
    local tooltipH = baseHeight + requirementsHeight
    
    -- Position tooltip near cursor but keep it on screen
    local tooltipX = x + 15
    local tooltipY = y - tooltipH - 10
    
    if tooltipX + tooltipW > self:GetWide() then
        tooltipX = x - tooltipW - 15
    end
    if tooltipY < 0 then
        tooltipY = y + 15
    end
    
    -- Draw tooltip background
    surface.SetDrawColor(Color(0, 0, 0, math.min(200, self.tooltipAlpha)))
    surface.DrawRect(tooltipX, tooltipY, tooltipW, tooltipH)
    
    -- Draw tooltip border
    surface.SetDrawColor(Color(255, 255, 255, self.tooltipAlpha))
    surface.DrawOutlinedRect(tooltipX, tooltipY, tooltipW, tooltipH)
    
    local yOffset = tooltipY + 10
    
    -- Draw skill name
    draw.SimpleText(skill.name, "DermaDefaultBold", tooltipX + 10, yOffset, 
        Color(255, 255, 100, self.tooltipAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    yOffset = yOffset + 20
    
    -- Draw skill description
    draw.SimpleText(skill.desc, "DermaDefault", tooltipX + 10, yOffset, 
        Color(255, 255, 255, self.tooltipAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    yOffset = yOffset + 20
    
    -- Draw requirements
    if skill.requirements and not skill.learned and table.Count(skill.requirements) > 0 then
        draw.SimpleText("Requirements:", "DermaDefaultBold", tooltipX + 10, yOffset, 
            Color(255, 200, 100, self.tooltipAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        yOffset = yOffset + 15
        
        for itemClass, amount in pairs(skill.requirements) do
            local id = impulse.Inventory.ClassToNetID(itemClass)
            local itemData = impulse.Inventory.Items[id]
            local itemName = itemData and itemData.Name or itemClass

            -- Get player's item count using the same method as server
            local playerAmount = 0
            if LocalPlayer().InventoryRegister and LocalPlayer().InventoryRegister[itemClass] then
                playerAmount = LocalPlayer().InventoryRegister[itemClass]
            else
                -- Fallback to manual counting
                local localInv = impulse.Inventory.Data[0][1] or {}
                for _, item in pairs(localInv) do
                    if item.class == itemClass then
                        playerAmount = playerAmount + 1
                    end
                end
            end
            
            local requirementColor = Color(100, 255, 255, self.tooltipAlpha)

            draw.SimpleText("• " .. amount .. "x " .. itemName, 
                "DermaDefault", tooltipX + 20, yOffset, requirementColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            yOffset = yOffset + 15
        end
    end
    
    -- Draw status
    local statusText = ""
    local statusColor = Color(200, 200, 200, self.tooltipAlpha)
    if skill.learned then
        statusText = "✓ RESEARCHED"
        statusColor = Color(0, 255, 0, self.tooltipAlpha)
    elseif skill.unlocked then
        local hasItems = self:HasRequiredItems(skill.requirements or {})
        if hasItems then
            statusText = "Click to learn"
            statusColor = Color(100, 150, 255, self.tooltipAlpha)
        else
            statusText = "Missing requirements"
            statusColor = Color(255, 100, 100, self.tooltipAlpha)
        end
    else
        statusText = "LOCKED"
        statusColor = Color(255, 100, 100, self.tooltipAlpha)
    end
    
    draw.SimpleText(statusText, "DermaDefault", tooltipX + 10, yOffset, 
        statusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

-- Helper function to check if player has required items (client-side display only)
function PANEL:HasRequiredItems(requirements)
    -- This is just for tooltip display - actual checking happens server-side
    for itemClass, amount in pairs(requirements) do
        local playerAmount = 0
        
        -- Use the same logic as the server-side HasInventoryItem function
        if LocalPlayer().InventoryRegister and LocalPlayer().InventoryRegister[itemClass] then
            playerAmount = LocalPlayer().InventoryRegister[itemClass]
        else
            -- Fallback to manual counting from inventory data
            local localInv = impulse.Inventory.Data[0][1] or {}
            for _, item in pairs(localInv) do
                -- Get the item data from the network ID
                local itemData = impulse.Inventory.Items[item.id]
                if itemData and itemData.UniqueID == itemClass then
                    playerAmount = playerAmount + 1
                end
            end
        end
        
        if playerAmount < amount then
            return false, itemClass, amount, playerAmount
        end
    end
    return true
end

function PANEL:DrawConnections()
    surface.SetDrawColor(Color(255, 255, 255, 150))
    
    -- Draw lines connecting skills between tiers
    for i, skill in ipairs(skillTree) do
        if skill.tier < 4 then
            local node = self.skillNodes[i]
            local nodeX, nodeY = node:GetPos()
            nodeX = nodeX + 40 -- center of node
            nodeY = nodeY + 40
            
            -- Connect to next tier skills
            for j, nextSkill in ipairs(skillTree) do
                if nextSkill.tier == skill.tier + 1 then
                    local nextNode = self.skillNodes[j]
                    local nextX, nextY = nextNode:GetPos()
                    nextX = nextX + 40
                    nextY = nextY + 40
                    
                    surface.DrawLine(nodeX, nodeY, nextX, nextY)
                end
            end
        end
    end
end

vgui.Register("VortRNDMenu", PANEL, "DFrame")

-- Add this minigame panel to your cl_vortrnd.lua file

local MINIGAME_PANEL = {}

function MINIGAME_PANEL:Init()
    self:SetSize(600, 400)
    self:Center()
    self:SetTitle("Research Circuit Assembly")
    self:SetDraggable(false)
    self:MakePopup()
    self:SetDeleteOnClose(true)
    
    self.gridSize = 8
    self.cellSize = 40
    self.grid = {}
    self.connections = {}
    self.startPoint = {x = 1, y = 4}
    self.endPoint = {x = 8, y = 4}
    self.currentPath = {}
    self.isDrawing = false
    self.completed = false
    self.timeLimit = 60 -- 60 seconds
    self.startTime = CurTime()
    
    -- Generate random obstacles
    self:GenerateObstacles()
    
    -- Create close button
    local closeBtn = vgui.Create("DButton", self)
    closeBtn:SetSize(80, 25)
    closeBtn:SetPos(self:GetWide() - 90, 10)
    closeBtn:SetText("Cancel")
    closeBtn.DoClick = function()
        self:OnMinigameFailed()
    end
end

function MINIGAME_PANEL:GenerateObstacles()
    -- Initialize empty grid
    for x = 1, self.gridSize do
        self.grid[x] = {}
        for y = 1, self.gridSize do
            self.grid[x][y] = {
                blocked = false,
                connected = false,
                isPath = false
            }
        end
    end
    
    -- Add some random obstacles (but not too many)
    local numObstacles = math.random(8, 12)
    for i = 1, numObstacles do
        local x, y = math.random(2, self.gridSize - 1), math.random(1, self.gridSize)
        
        -- Don't block start/end points or their immediate neighbors
        if not ((x == self.startPoint.x or x == self.startPoint.x + 1) and y == self.startPoint.y) and
           not ((x == self.endPoint.x or x == self.endPoint.x - 1) and y == self.endPoint.y) then
            self.grid[x][y].blocked = true
        end
    end
end

function MINIGAME_PANEL:Paint(w, h)
    -- Background
    surface.SetDrawColor(20, 20, 20, 240)
    surface.DrawRect(0, 0, w, h)
    
    -- Border
    surface.SetDrawColor(100, 150, 200, 255)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
    
    -- Instructions
    draw.SimpleText("Connect the power source to the research terminal!", "DermaDefault", 
        w/2, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    draw.SimpleText("Click and drag to create circuit paths. Avoid obstacles!", "DermaDefault", 
        w/2, 45, Color(200, 200, 200), TEXT_ALIGN_CENTER)
    
    -- Timer
    local timeLeft = math.max(0, self.timeLimit - (CurTime() - self.startTime))
    local timerColor = timeLeft < 10 and Color(255, 100, 100) or Color(255, 255, 255)
    draw.SimpleText("Time: " .. math.ceil(timeLeft) .. "s", "DermaDefaultBold", 
        w - 80, 30, timerColor, TEXT_ALIGN_CENTER)
    
    -- Check if time ran out
    if timeLeft <= 0 and not self.completed then
        self:OnMinigameFailed()
        return
    end
    
    -- Calculate grid offset to center it
    local gridWidth = self.gridSize * self.cellSize
    local gridHeight = self.gridSize * self.cellSize
    local offsetX = (w - gridWidth) / 2
    local offsetY = (h - gridHeight) / 2 + 20
    
    -- Draw grid
    for x = 1, self.gridSize do
        for y = 1, self.gridSize do
            local cellX = offsetX + (x - 1) * self.cellSize
            local cellY = offsetY + (y - 1) * self.cellSize
            local cell = self.grid[x][y]
            
            -- Cell background
            local bgColor = Color(40, 40, 40, 200)
            if cell.blocked then
                bgColor = Color(120, 40, 40, 200) -- Red for obstacles
            elseif cell.connected then
                bgColor = Color(40, 120, 40, 200) -- Green for connected path
            elseif cell.isPath then
                bgColor = Color(60, 60, 120, 200) -- Blue for current path
            end
            
            surface.SetDrawColor(bgColor)
            surface.DrawRect(cellX, cellY, self.cellSize, self.cellSize)
            
            -- Cell border
            surface.SetDrawColor(100, 100, 100, 255)
            surface.DrawOutlinedRect(cellX, cellY, self.cellSize, self.cellSize)
            
            -- Special markers
            if x == self.startPoint.x and y == self.startPoint.y then
                -- Start point (power source)
                surface.SetDrawColor(255, 255, 100, 255)
                surface.DrawRect(cellX + 5, cellY + 5, self.cellSize - 10, self.cellSize - 10)
                draw.SimpleText("PWR", "DermaDefault", cellX + self.cellSize/2, cellY + self.cellSize/2, 
                    Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            elseif x == self.endPoint.x and y == self.endPoint.y then
                -- End point (research terminal)
                surface.SetDrawColor(100, 255, 100, 255)
                surface.DrawRect(cellX + 5, cellY + 5, self.cellSize - 10, self.cellSize - 10)
                draw.SimpleText("END", "DermaDefault", cellX + self.cellSize/2, cellY + self.cellSize/2, 
                    Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
    
    -- Success message
    if self.completed then
        draw.SimpleText("Circuit Complete! Research Finished!", "DermaLarge", 
            w/2, h - 40, Color(100, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function MINIGAME_PANEL:OnMousePressed(mouseCode)
    if mouseCode == MOUSE_LEFT and not self.completed then
        local x, y = self:ScreenToLocal(input.GetCursorPos())
        local gridX, gridY = self:ScreenToGrid(x, y)
        
        if gridX and gridY and gridX == self.startPoint.x and gridY == self.startPoint.y then
            self.isDrawing = true
            self.currentPath = {{x = gridX, y = gridY}}
            self:ClearPath()
            self.grid[gridX][gridY].isPath = true
        end
    end
end

function MINIGAME_PANEL:OnMouseReleased(mouseCode)
    if mouseCode == MOUSE_LEFT and self.isDrawing then
        self.isDrawing = false
        
        -- Check if we reached the end point
        local lastPoint = self.currentPath[#self.currentPath]
        if lastPoint and lastPoint.x == self.endPoint.x and lastPoint.y == self.endPoint.y then
            self:CompleteCircuit()
        else
            -- Failed to connect, clear the path
            self:ClearPath()
        end
    end
end

function MINIGAME_PANEL:Think()
    if self.isDrawing then
        local x, y = self:ScreenToLocal(input.GetCursorPos())
        local gridX, gridY = self:ScreenToGrid(x, y)
        
        if gridX and gridY then
            local lastPoint = self.currentPath[#self.currentPath]
            if lastPoint and (lastPoint.x ~= gridX or lastPoint.y ~= gridY) then
                -- Check if this is a valid move (adjacent cell)
                local dx = math.abs(gridX - lastPoint.x)
                local dy = math.abs(gridY - lastPoint.y)
                
                if (dx == 1 and dy == 0) or (dx == 0 and dy == 1) then
                    -- Check if the cell is not blocked
                    if not self.grid[gridX][gridY].blocked then
                        table.insert(self.currentPath, {x = gridX, y = gridY})
                        self.grid[gridX][gridY].isPath = true
                    else
                        -- Hit an obstacle, stop drawing
                        self.isDrawing = false
                        self:ClearPath()
                    end
                end
            end
        end
    end
end

function MINIGAME_PANEL:ScreenToGrid(screenX, screenY)
    local gridWidth = self.gridSize * self.cellSize
    local gridHeight = self.gridSize * self.cellSize
    local offsetX = (self:GetWide() - gridWidth) / 2
    local offsetY = (self:GetTall() - gridHeight) / 2 + 20
    
    local gridX = math.floor((screenX - offsetX) / self.cellSize) + 1
    local gridY = math.floor((screenY - offsetY) / self.cellSize) + 1
    
    if gridX >= 1 and gridX <= self.gridSize and gridY >= 1 and gridY <= self.gridSize then
        return gridX, gridY
    end
    return nil, nil
end

function MINIGAME_PANEL:ClearPath()
    for x = 1, self.gridSize do
        for y = 1, self.gridSize do
            self.grid[x][y].isPath = false
        end
    end
end

function MINIGAME_PANEL:CompleteCircuit()
    -- Mark the path as connected
    for _, point in ipairs(self.currentPath) do
        self.grid[point.x][point.y].connected = true
        self.grid[point.x][point.y].isPath = false
    end
    
    self.completed = true
    
    -- Play success sound
    surface.PlaySound("oakman/deadspace/ui/hud_save_confirm.wav")
    
    -- Notify server after short delay
    timer.Simple(2, function()
        if IsValid(self) then
            self:OnMinigameCompleted()
        end
    end)
end

function MINIGAME_PANEL:OnMinigameCompleted()
    -- Send success to server
    net.Start("VortMinigameCompleted")
        net.WriteString(self.skillName)
        net.WriteTable(self.skillRequirements)
    net.SendToServer()
    
    self:Close()
end

function MINIGAME_PANEL:OnMinigameFailed()
    -- Play failure sound
    surface.PlaySound("oakman/deadspace/door_locked.mp3")
    
    -- Send failure to server (optional)
    net.Start("VortMinigameFailed")
        net.WriteString(self.skillName)
    net.SendToServer()
    
    self:Close()
end

vgui.Register("VortResearchMinigame", MINIGAME_PANEL, "DFrame")

-- Client-side blueprint tracking with individual booleans
if CLIENT then
    -- Individual blueprint variables (client-side)
    BlueprintUnlocked_OSIAER = BlueprintUnlocked_OSIAER or false
    BlueprintUnlocked_OSIPRMK1 = BlueprintUnlocked_OSIPRMK1 or false
    BlueprintUnlocked_OSIPRMK2E = BlueprintUnlocked_OSIPRMK2E or false
    BlueprintUnlocked_OSIPRMK2R = BlueprintUnlocked_OSIPRMK2R or false
    BlueprintUnlocked_OSIPRMK3 = BlueprintUnlocked_OSIPRMK3 or false
    BlueprintUnlocked_AK47 = BlueprintUnlocked_AK47 or false
    BlueprintUnlocked_FAMAS = BlueprintUnlocked_FAMAS or false
    BlueprintUnlocked_TAU = BlueprintUnlocked_TAU or false
    BlueprintUnlocked_Scanners = BlueprintUnlocked_Scanners or false
    BlueprintUnlocked_BodyArmor = BlueprintUnlocked_BodyArmor or false
    
    -- Function to check if blueprint is unlocked (client-side)
    function impulse.IsVortBlueprintUnlocked(blueprintName)
        local blueprintChecks = {
            ["OSIAER Blueprint"] = function() return BlueprintUnlocked_OSIAER end,
            ["OSIPR MK. I Blueprint"] = function() return BlueprintUnlocked_OSIPRMK1 end,
            ["OSIPR MK. II-E Blueprint"] = function() return BlueprintUnlocked_OSIPRMK2E end,
            ["OSIPR MK. II-R Blueprint"] = function() return BlueprintUnlocked_OSIPRMK2R end,
            ["OSIPR MK. III Blueprint"] = function() return BlueprintUnlocked_OSIPRMK3 end,
            ["AK-47 Blueprint"] = function() return BlueprintUnlocked_AK47 end,
            ["FAMAS Blueprint"] = function() return BlueprintUnlocked_FAMAS end,
            ["TAU Cannon Blueprint"] = function() return BlueprintUnlocked_TAU end,
            ["Scanners"] = function() return BlueprintUnlocked_Scanners end,
            ["Body Armor"] = function() return BlueprintUnlocked_BodyArmor end,
        }
        
        if blueprintChecks[blueprintName] then
            return blueprintChecks[blueprintName]()
        end
        return false
    end
    
    net.Receive("VortBlueprintUpdate", function()
        local blueprintName = net.ReadString()
        local unlocked = net.ReadBool()
        
        -- Update individual boolean variables
        local blueprintMappings = {
            ["OSIAER Blueprint"] = function(val) BlueprintUnlocked_OSIAER = val end,
            ["OSIPR MK. I Blueprint"] = function(val) BlueprintUnlocked_OSIPRMK1 = val end,
            ["OSIPR MK. II-E Blueprint"] = function(val) BlueprintUnlocked_OSIPRMK2E = val end,
            ["OSIPR MK. II-R Blueprint"] = function(val) BlueprintUnlocked_OSIPRMK2R = val end,
            ["OSIPR MK. III Blueprint"] = function(val) BlueprintUnlocked_OSIPRMK3 = val end,
            ["AK-47 Blueprint"] = function(val) BlueprintUnlocked_AK47 = val end,
            ["FAMAS Blueprint"] = function(val) BlueprintUnlocked_FAMAS = val end,
            ["TAU Cannon Blueprint"] = function(val) BlueprintUnlocked_TAU = val end,
            ["Scanners"] = function(val) BlueprintUnlocked_Scanners = val end,
            ["Body Armor"] = function(val) BlueprintUnlocked_BodyArmor = val end,
        }
        
        if blueprintMappings[blueprintName] then
            blueprintMappings[blueprintName](unlocked)
        end
        
        if unlocked then
            LocalPlayer():Notify("Blueprint available: " .. blueprintName, 1)
            surface.PlaySound("oakman/deadspace/ui/hud_save_confirm.wav")
            
            -- Refresh any open crafting menus
            for _, v in ipairs(vgui.GetWorldPanel():GetChildren()) do
                if v:IsValid() and v.ClassName == "impulseCraftingMenu" then
                    if v.RefreshBlueprints then
                        v:RefreshBlueprints()
                    end
                end
            end
        end
    end)
end