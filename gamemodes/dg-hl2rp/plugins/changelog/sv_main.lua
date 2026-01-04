util.AddNetworkString("impulseNewUpdateMessage")

function PLUGIN:PostSetupPlayer(ply)
	net.Start("impulseNewUpdateMessage")
	net.Send(ply)
end