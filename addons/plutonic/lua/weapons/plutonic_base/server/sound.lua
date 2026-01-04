util.AddNetworkString("Longsword.EmitSound")
util.AddNetworkString("Longsword.Echo")
function SWEP:EmitWorldSound(snd, pitch)
	pitch = pitch or 100
	net.Start("Longsword.EmitSound")
	net.WriteEntity(self)
	net.WriteEntity(self:GetOwner())
	net.WriteString(snd)
	net.WriteUInt(pitch, 8)
	net.SendPAS(self:GetPos())
end