-------------------------------------
------- Cuffs Gmod DayZ Items -------
-------------------------------------
-------------------------------------
-- Created by Phoenix129, added    --
-- with permission                 --
-------------------------------------
ITEM = {}
ITEM.Name 		 =  "Handcuffs (Standard)"
ITEM.Angle		 =  Angle(0,0,0)
ITEM.Desc		 =  "A small pair of handcuffs"
ITEM.Model		 =  "models/props_lab/box01a.mdl"
ITEM.Weight		 =  10
ITEM.LootType	 =  { "Weapon" }
ITEM.Price		 =  1000
ITEM.DontStock = true
ITEM.Credits		 =  100
ITEM.SpawnChance  =  1
ITEM.Tertiary		 =  true
ITEM.SpawnOffset	 =  Vector(0,0,0)
ITEM.Weapon		 =  "weapon_cuff_standard"
ITEM.ReqCraft = {"item_part_c", "item_part_g", "item_part_h", "item_part_b", "weapon_cuff_tactical"}
ITEM.EatFunction = function(ply, item) ply:DoProcess(item, "Eating", 5, "eat.wav", 0, "npc/barnacle/barnacle_gulp2.wav") end
ITEM.ProcessFunction	 =  function(ply, item) ply:EatHurt(item, 5, 50) end