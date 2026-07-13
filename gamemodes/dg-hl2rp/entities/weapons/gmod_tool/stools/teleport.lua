TOOL.Name = "Teleport Creator"
TOOL.Category = "Gamemaster Tools"

TELEPORTS = TELEPORTS or {}

if SERVER then 
    util.AddNetworkString("DeepSyncTeleports")
    util.AddNetworkString("DeepEditTeleport")

    function TOOL:LeftClick(trace)
        if !self:GetOwner():IsGameMaster() then return end 

        local ang = trace.HitNormal:Angle()
	    ang.pitch = ang.pitch + 90
        ang.yaw = self:GetOwner():GetAngles().yaw

        local tp = ents.Create("deep_teleport")
        tp:SetAngles(ang)
        tp:SetPos(trace.HitPos)
        tp:Spawn()

        tp:CPPISetOwner(self:GetOwner())

        -- maybe not the best way because it's unreliable if a tp is deleted
        table.insert(TELEPORTS, tp)

        if IsValid(self:GetEnt(1)) then 
            tp:SetTeleportType(TP_EXIT)
            tp:SetTeleportID(self:GetEnt(1):GetTeleportID())

            self:ClearObjects()

            local rf = RecipientFilter()
            
            for i, v in player.Iterator() do 
                if v:IsAdmin() or v:IsGameMaster() or v:IsSuperAdmin() then rf:AddPlayer(v) end
            end 

            -- wtf!!
            timer.Simple(0, function()
                net.Start("DeepSyncTeleports")
                net.WriteTable(TELEPORTS, true)
                net.Send(rf)
            end)

            return 
        end 
        
        self:SetObject(1, tp, trace.HitPos, tp:GetPhysicsObjectNum(trace.PhysicsBone), trace.PhysicsBone, trace.HitNormal)

        -- wtf!
        timer.Simple(0, function()
            net.Start("DeepEditTeleport")
            net.WriteEntity(tp)
            net.Send(self:GetOwner())
        end)
    end 
end 

if CLIENT then 
    TP_EDITING = nil

    net.Receive("DeepSyncTeleports", function()
        TELEPORTS = net.ReadTable(true)
    end)

    net.Receive("DeepEditTeleport", function()
        TP_EDITING = net.ReadEntity()
    end)

    language.Add("tool.test.name", "Teleport Creator")
    language.Add("tool.test.desc", "Click to create an entry-teleport, which will highlight green. After that, the next teleport created will form a pair, and an exit teleport. You can manipulate the teleports afterwards as you wish.")
    language.Add("tool.test.1", "Create Teleport")

    local color_d = Color(62, 163, 96)

    function TOOL:Deploy()
        if !self:GetOwner():IsGameMaster() then return end 

        hook.Add("PostDrawEffects", "DeepDrawTeleports", function(d, s)
            if TP_EDITING then 
                outline.Add({TP_EDITING}, color_d, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
            end 

            if not TELEPORTS or #TELEPORTS == 0 then return end

            outline.Add(TELEPORTS, color_white, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
        end)

        hook.Add("HUDPaint", "DeepDrawTeleports", function()
            for i, v in ipairs(TELEPORTS) do 
                if not IsValid(v) then continue end 

                local pos = v:GetPos():ToScreen()
                local tpType = v:GetTeleportType()

                draw.SimpleText((tpType == TP_ENTRY and "ENTRY: " or "EXIT: ") .. v:GetTeleportID(), "DebugOverlay", pos.x, pos.y, color_white)
                
                if tpType == TP_EXIT then 
                    local forward = v:GetPos() + v:GetAngles():Up() * 20
                    local forwardPos = forward:ToScreen()

                    draw.SimpleText(v:GetTeleportID() .. ": Forward", "DebugOverlay", forwardPos.x, forwardPos.y, color_white)
                end 
            end 
        end)
    end 

    function TOOL:Holster()
        hook.Remove("PostDrawEffects", "DeepDrawTeleports")
        hook.Remove("HUDPaint", "DeepDrawTeleports")
    end 
end 

local ang = Angle(0, 0, 0)

-- stolen from thruster tool too lazy to make my own ghosting
function TOOL:UpdateGhostThruster( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) ) then

		ent:SetNoDraw( true )
		return

	end

    local plrAng = RenderAngles()

	local ang = trace.HitNormal:Angle()
	ang.pitch = ang.pitch + 90
    ang.yaw = plrAng.yaw

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( ang )

	ent:SetNoDraw( false )

end

function TOOL:Think()
	if ( !IsValid( self.GhostEntity ) ) then
		self:MakeGhostEntity("models/hunter/plates/plate2x4.mdl", vector_origin, angle_zero)
	end

    self:UpdateGhostThruster( self.GhostEntity, self:GetOwner() )
end 