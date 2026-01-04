Plutonic.Network = Plutonic.Network or {}
Plutonic.EmptyFunc = function() end
Plutonic.BenchmarkStart = Plutonic.EmptyFunc
Plutonic.BenchmarkEnd = Plutonic.EmptyFunc
util.AddNetworkString("Plutonic.WeaponIsReliable")
net.Receive(
	"Plutonic.WeaponIsReliable",
	function(len, ply)
		local wep = net.ReadEntity()
		if not IsValid(wep) then return end
		if not wep.IsPlutonic then return end
		wep:SetReliable(true)
		if wep.OnReliable then
			wep:OnReliable()
		end
	end
)