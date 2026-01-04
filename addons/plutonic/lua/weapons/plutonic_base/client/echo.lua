net.Receive(
	"Longsword.Echo",
	function()
		local _ = net.ReadUInt(8)
		local snd = net.ReadString()
		surface.PlaySound(snd)
	end
)