-- List of SCPs that are burnable, replace with the command of each scp you want, 610 has been placed here for reference, this is infinitely expandable and shrinkable
ValidSCPS = {
    [ "SCP-610" ] = true,
    [ "SCP-076-2" ] = true,
    [ "SCP-682" ] = true,
    [ "SCP-966" ] = true,
    [ "SCP-1048-A" ] = true,
}

hook.Add( "EntityTakeDamage", "SCPBurnScale", function( target, dmginfo )
	if not target:IsPlayer() then return end
        if not ValidSCPS[team.GetName(target:Team())] then return end -- Attempts to find the index of a valid SCP and check if the target is a player (Finding it by the index is far faster than looping through or using table.HasValue)

        if dmginfo:GetDamageType() == 8 then
          dmginfo:ScaleDamage(4)
        end

end )