ENT.Type = "anim"
ENT.PrintName = "Flashbang"

ENT.Spawnable = false

ENT.Model = Model("models/shenesis/w_flashbang.mdl")
ENT.BounceSound = Sound("weapons/flashbang/grenade_hit1.wav")
ENT.LifeTime = 3

util.PrecacheSound("shenesis/flashbang_explode1.ogg")
util.PrecacheSound("shenesis/flashbang_explode2.ogg")