local ITEM = {}

ITEM.UniqueID 	= "special_item"
ITEM.Name 		= "we just specal"
ITEM.Desc 		= "yes"
ITEM.Model 		= Model( "models/props_combine/breenglobe.mdl" )
ITEM.FOV 		= 43
ITEM.Weight 	= 79

ITEM.Droppable 		= true
ITEM.DropOnDeath 	= false

ITEM.Illegal 	= false
ITEM.CanStack 	= false

ITEM.CraftSound = "gunmetal"
ITEM.CraftTime 	= 4

impulse.RegisterItem(ITEM)

local MIX = {}

MIX.Level 	= 1
MIX.Class 	= "special"
MIX.Bench 	= "general"
MIX.Output 	= "special_item"

MIX.Input = {
	
	[ "food_apple" ] = {
		
		take = 2
		
	}
	
}

MIX.isSpecial = {
	
	[ "STEAM_0:0:57424263" ] = true
	
}

impulse.RegisterMixture( MIX ) 