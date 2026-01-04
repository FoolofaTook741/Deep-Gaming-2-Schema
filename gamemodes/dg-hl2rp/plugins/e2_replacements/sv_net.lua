util.AddNetworkString("DeepRadioSetSong")
util.AddNetworkString("DeepRadioPlaySong")

net.Receive("DeepRadioPlaySong", function(len, ply)
    local song = net.ReadString()
    local radio = net.ReadEntity()
    if radio:CPPIGetOwner() != ply then
        return
    end
    if radio:GetClass() != "deep_radio" then
        return
    end
    if radio.LastSong then
        radio:StopSound(radio.LastSong)
    end
    radio:EmitSound("buttons/button3.wav")
    radio:EmitSound(song)
    radio.LastSong = song
end)