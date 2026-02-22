local ITEM = {}

ITEM.UniqueID = "special_breadman"
ITEM.Name = "Unpoisoned Bread"
ITEM.Desc =  "Tommy Breadman's Unpoisoned Bread"
ITEM.Category = "Food"
ITEM.Model = Model("models/synapse/alyxports/bread03a.mdl")
ITEM.FOV = 35
ITEM.Weight = 1
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 11

ITEM.CraftTime = 0.2

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)

local MIX = {}

MIX.Level 	= 1
MIX.Class 	= "food"
MIX.Bench 	= "general"
MIX.Output 	= "special_breadman"

MIX.Input = {

	[ "food_bread" ] = {

		take = 1

	}

}

MIX.isSpecial = {

	[ "STEAM_0:0:450620288" ] = true

}

impulse.RegisterMixture( MIX ) 
