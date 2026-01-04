function SWEP:PlayAnim(act)
	if self:GetOwner():IsNPC() then return end
	if self.CustomEvents[act] then
		act = self.CustomEvents[act]
	end

	if isstring(act) then
		local vmodel = self:GetOwner():GetViewModel()
		local seq = vmodel:LookupSequence(act)
		vmodel:SendViewModelMatchingSequence(seq)
	else
		local vmodel = self:GetOwner():GetViewModel()
		local seq = vmodel:SelectWeightedSequence(act)
		vmodel:SendViewModelMatchingSequence(seq)
	end
end

function SWEP:PlayAnimWorld(act)
	local wmodel = self
	local seq = wmodel:SelectWeightedSequence(act)
	self:ResetSequence(seq)
end

SWEP.VM_LayeredSequences = {}
function SWEP:PlayViewModelSequence(sqid)
	local vm = self:GetOwner():GetViewModel()
	if not IsValid(vm) then return end
	vm:SetCycle(0)
	vm:SetPlaybackRate(1)
	vm:SetSequence(sqid)
end

function SWEP:PlaySequence(seq)
	local vm = self:GetOwner():GetViewModel()
	if not IsValid(vm) then return end
	local sqid = isstring(seq) and vm:LookupSequence(seq) or seq
	local dur = vm:SequenceDuration() --
	if not vm:IsSequenceFinished() then
		timer.Simple(
			dur,
			function()
				if IsValid(self) and IsValid(vm) then
					self:PlayViewModelSequence(sqid)
				end
			end
		)
	else
		self:PlayViewModelSequence(sqid)
	end
end

function SWEP:QueueIdle()
	self:SetNextIdle( CurTime() + self:GetOwner():GetViewModel():SequenceDuration() + 0.1 )
end