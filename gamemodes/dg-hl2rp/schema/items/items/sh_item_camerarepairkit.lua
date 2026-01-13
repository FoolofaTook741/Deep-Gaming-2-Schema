local ITEM = {}

ITEM.UniqueID = "item_camerarepairkit"
ITEM.Name = "Repair Kit"
ITEM.Desc =  "This kit contains replacement parts and tools to repair damaged electronics."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/combine_turrets/floor_turret_gib1.mdl")
ITEM.FOV = 20.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Repair Appliances"

function ITEM:OnUse(ply)
	local pos = ply:GetPos()

    for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
    	if not k:IsCameraEnabled() and k:GetPos():DistToSqr(pos) < (500 ^ 2) then
    		ply:EmitSound("ambient/energy/weld2.wav")
            ply:Notify("You have repaired a broken camera.")

    		k:RepairCombineCamera()
			if ply:Team() == TEAM_CWU then
				ply:GiveMoney(200)
				ply:Notify("You have received 200 credits for repairing this camera.")
				ply:AddSkillXP("metabolism", math.random(5,15))
			end
    		return true
    	end
    end

	for v,k in pairs(ents.FindByClass("deep_commsuplink")) do
		if k:GetPos():DistToSqr(pos) < (500 ^ 2) && impulse.CommsNetWorkOn != true then 
    		impulse.CommsNetWorkOn = true
			if !timer.Exists("emphackcooldown") then 
				timer.Remove("emphackcooldown") 
			end
			ply:EmitSound("ambient/energy/weld2.wav")
			ply:Notify("You have repaired the Combine Comms Uplink.")
    		for k, v in pairs(player.GetAll()) do 
				v:SendCombineMessage("COMBINE COMMS NETWORK REPAIRED BY " .. ply:Name(), Color(0, 150, 0))
			end
			if ply:Team() == TEAM_CWU then
				ply:GiveMoney(400)
				ply:Notify("You have received 400 credits for repairing the comms network.")
				ply:AddSkillXP("metabolism", math.random(20,100))
			end
			return true
		end
    end

	for v,k in pairs(ents.FindByClass("impulse_hl2rp_terminal")) do
		if k:GetPos():DistToSqr(pos) < (500 ^ 2) && k.Emped == true then
			ply:EmitSound("ambient/energy/weld2.wav") 
			k.Emped = false
			ply:Notify("You have repaired a broken terminal.")
			if ply:Team() == TEAM_CWU then
				ply:GiveMoney(200)
				ply:Notify("You have received 200 credits for repairing a terminal.")
				ply:AddSkillXP("metabolism", math.random(10,30))
			end
			return true
		end
    end

    ply:Notify("No broken devices found nearby.")
	return false
end

impulse.RegisterItem(ITEM)
