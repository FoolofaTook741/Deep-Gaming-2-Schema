local self   	= {}
local ipairs 	= ipairs
local tostring 	= tostring
local tonumber 	= tonumber
local print		= print
local table     = table
local math      = math
local unpack    = unpack
local util		= util
local Vector	= Vector
local MASK_SHOT = MASK_SHOT

function self:InternalId ()
    return "ChrononLabs:RecoilDetector"
end

function self:Constructor ()
    local Operations = ChrononLabs ["ChrononLabs:Operations"]
    
    self.AnalyzeRecoil = function (sequence, current_punch, eye_variance)
        local temp = sequence.temp_data
        
        local punch_delta = {
            x = current_punch.p - temp.last_punch_angles.p,
            y = current_punch.y - temp.last_punch_angles.y
        }
        
        table.insert (temp.punch_samples.x, punch_delta.x)
        table.insert (temp.punch_samples.y, punch_delta.y)
        
        table.insert (temp.recoil_compensation.x, eye_variance.x)
        table.insert (temp.recoil_compensation.y, eye_variance.y)
        
        temp.last_punch_angles = current_punch
        
        if #temp.punch_samples.x > 1 then
            sequence.sequence_stats.avg_recoil_compensation.x = Operations:GaussianNoise (
                Operations:CalculateAverage (temp.recoil_compensation.x)
            )
            sequence.sequence_stats.avg_recoil_compensation.y = Operations:GaussianNoise (
                Operations:CalculateAverage (temp.recoil_compensation.y)
            )
            
            local sum_x, sum_y = 0, 0
            local avg_x = sequence.sequence_stats.avg_recoil_compensation.x
            local avg_y = sequence.sequence_stats.avg_recoil_compensation.y
            
            for _, comp_x in ipairs (temp.recoil_compensation.x) do
                sum_x = sum_x + (comp_x - avg_x)^2
            end
            for _, comp_y in ipairs (temp.recoil_compensation.y) do
                sum_y = sum_y + (comp_y - avg_y)^2
            end
            
            sequence.sequence_stats.recoil_consistency.x = Operations:GaussianNoise (
                math.sqrt (sum_x / #temp.recoil_compensation.x)
            )
            sequence.sequence_stats.recoil_consistency.y = Operations:GaussianNoise (
                math.sqrt (sum_y / #temp.recoil_compensation.y)
            )
            
            sequence.sequence_stats.max_recoil_delta.x = Operations:GaussianNoise (
                math.max (unpack (temp.recoil_compensation.x))
            )
            sequence.sequence_stats.max_recoil_delta.y = Operations:GaussianNoise (
                math.max (unpack (temp.recoil_compensation.y))
            )
        end
    end
	
	self.IsCameraVectorAligned = function (ply, target)
		local eyePosition     = ply:EyePos ()
		local eyeDirection    = ply:EyeAngles ():Forward ()
		local targetPosition  = target:GetPos () + Vector (0, 0, 32)

		local projectionEnd   = eyePosition + eyeDirection * 10000
		local targetVector    = targetPosition - eyePosition
		local projectionDist  = targetVector:Dot (eyeDirection)
		local closestPoint    = eyePosition + eyeDirection * projectionDist

		return (closestPoint - targetPosition):Length () <= ChrononLabs ["ChrononLabs:Constants"].RCSConfig.PlayerSphereRadius
	end
	
	self.IsValidHit = function (weapon_owner, bullet, target)
		if not bullet or not bullet.Trace then
			return false, nil
		end

		local trace = bullet.Trace

		if IsValid (trace.Entity) and trace.Entity:IsPlayer () and trace.Entity ~= weapon_owner then
			return true, trace
		end

		return false, nil
	end
	
	
	self.IsTargetInSight = function (ply, target, maxDistance)
		if not IsValid (target) then return false end

		local eyePosition     = ply:EyePos ()
		local targetPosition  = target:WorldSpaceCenter ()
		local distanceToTarget = eyePosition:Distance(targetPosition)

		if maxDistance and distanceToTarget > maxDistance then return false end

		local aimDirection    = ply:GetAimVector ()
		local targetDirection = (targetPosition - eyePosition):GetNormalized ()
		local alignmentFactor = aimDirection:Dot (targetDirection)

		if alignmentFactor < 0.5 then return false end

		local traceFilter = { ply, target }
		local traceResult = util.TraceLine ({
			start  = eyePosition,
			endpos = targetPosition,
			filter = traceFilter,
			mask   = MASK_SHOT
		})
		if not traceResult.Hit then return true end

		traceResult = util.TraceLine ({
			start  = eyePosition,
			endpos = targetPosition + Vector (0, 0, 32),
			filter = traceFilter,
			mask   = MASK_SHOT
		})
		if not traceResult.Hit then return true end

		traceResult = util.TraceLine ({
			start  = eyePosition,
			endpos = targetPosition + Vector (0, 0, -32),
			filter = traceFilter,
			mask   = MASK_SHOT
		})
		if not traceResult.Hit then return true end

		traceResult = util.TraceLine ({
			start  = eyePosition,
			endpos = target:EyePos (),
			filter = traceFilter,
			mask   = MASK_SHOT
		})
		if not traceResult.Hit then return true end

		return false
	end
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())
