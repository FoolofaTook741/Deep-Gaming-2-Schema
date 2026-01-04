--[[hook.Add( "PlayerDeath", "dropsystem", function(victim, inflictor, attacker) 
    if victim:IsCP() and attacker:IsPlayer() then
        local ply = victim
        local pos = victim:GetPos() + Vector(0, 0, 20)
        local lootpackage = ents.Create("impulse_container")

        local drops = {}

        local meds = {}
        local weps = {}
        local armor = {}
        local ammo = {}
        local attachments = {}

        local meddrop = false
        local supermeddrop = false
        local wepdrop = false
        local armordrop = false
        local superarmordrop = false
        local ammodrop = false
        local attdrop = false
        local circuitboarddrop = false

        local totalmeds = 0
        local totalammo = 0
        local team = ply:Team()
        local class = ply:GetTeamClass() or "NONE"
        local rank = ply:GetTeamRank() or "NONE"
        local roll = math.random(1,10)
        local inv = ply:GetInventory()
        if team then -- weapon drop algorithm
            if team == TEAM_CP then
                if rank then
                    if class then
                        if class == CLASS_UNION then
                            if rank <= RANK_I4 then
                                if roll < 2 then
                                    wepdrop = false
                                elseif roll <= 4 then
                                    weps = {"scrap_stunstick"}
                                    wepdrop = true
                                elseif roll < 7 then
                                    weps = {"scrap_pistol"}
                                    wepdrop = true
                                else 
                                    weps = {"scrap_stunstick", "scrap_pistol"}
                                    wepdrop = true
                                    meddrop = true
                                end
                            elseif rank <= RANK_I3 then
                                if roll == 1 then
                                    weps = {"scrap_stunstick"}
                                    wepdrop = true
                                elseif roll <= 4 then
                                    weps = {"scrap_pistol", "scrap_stunstick"}
                                    wepdrop = true
                                elseif roll <= 8 then
                                    weps = {"wep_pm63", "scrap_stunstick"}
                                    wepdrop = true
                                    meddrop = true
                                else
                                    weps = {"wep_pm63", "scrap_pistol"}
                                    wepdrop = true
                                    attachments = {"att_reflex"}
                                    attdrop = true
                                end
                            elseif rank <= RANK_I1 then
                                if roll == 1 then
                                    weps = {"scrap_stunstick", "scrap_pistol"}
                                    wepdrop = true
                                    meddrop = true
                                elseif roll <= 4 then
                                    weps = {"wep_pm63", "scrap_stunstick"}
                                    wepdrop = true
                                    meddrop = true
                                elseif roll <= 7 then
                                    weps = {"scrap_mp7"}
                                    wepdrop = true
                                    attachments = {"att_cmore"}
                                    attdrop = true
                                elseif roll <= 8 then
                                    weps = {"scrap_mp7", "scrap_pistol"}
                                    wepdrop = true
                                    meddrop = true
                                else
                                    weps = {"scrap_mp7", "scrap_pistol", "scrap_stunstick"}
                                    wepdrop = true
                                end
                            elseif rank <= RANK_SQL then
                                if roll == 1 then
                                    weps = {"scrap_stunstick", "scrap_pistol"}
                                    wepdrop = true
                                elseif roll <= 4 then
                                    weps = {"scrap_mp7", "scrap_stunstick"}
                                    wepdrop = true
                                    meddrop = true
                                elseif roll <= 7 then
                                    weps = {"scrap_mp7", "scrap_pistol"}
                                    wepdrop = true
                                    attachments = {"att_cmore"}
                                    attdrop = true
                                    meddrop = true
                                elseif roll <= 8 then
                                    weps = {"scrap_shotgun", "scrap_pistol"}
                                    wepdrop = true
                                else
                                    weps = {"scrap_shotgun", "scrap_pistol", "scrap_stunstick"}
                                    wepdrop = true
                                    meddrop = true
                                end
                            elseif rank == RANK_DVL then
                                if roll == 1 then
                                    weps = {"scrap_mp7", "scrap_pistol"}
                                    wepdrop = true
                                    meddrop = true
                                elseif roll <= 4 then
                                    weps = {"scrap_shotgun", "scrap_stunstick"}
                                    wepdrop = true
                                    supermeddrop = true
                                elseif roll <= 7 then
                                    weps = {"scrap_mp7", "scrap_deagle"}
                                    wepdrop = true
                                    meddrop = true
                                elseif roll <= 8 then
                                    weps = {"scrap_shotgun", "scrap_pistol"}
                                    wepdrop = true
                                    attachments = {"att_reflex"}
                                    attdrop = true
                                    supermeddrop = true
                                else
                                    weps = {"scrap_shotgun", "scrap_deagle", "scrap_stunstick"}
                                    wepdrop = true
                                    meddrop = true
                                end
                            elseif rank <= RANK_CMD and rank != nil then
                                if roll == 1 then
                                    weps = {"scrap_mp7", "scrap_pistol"}
                                    wepdrop = true
                                    attachments = {"att_cmore"}
                                    attdrop = true
                                    supermeddrop = true
                                elseif roll <= 4 then
                                    weps = {"scrap_shotgun", "scrap_stunstick"}
                                    wepdrop = true
                                    supermeddrop = true
                                elseif roll <= 7 then
                                    weps = {"scrap_mp7", "scrap_357"}
                                    attachments = {"att_cmore"}
                                    attdrop = true
                                    wepdrop = true
                                    supermeddrop = true
                                elseif roll <= 8 then
                                    weps = {"scrap_mp7", "scrap_deagle"}
                                    wepdrop = true
                                    supermeddrop = true
                                else
                                    weps = {"scrap_shotgun", "scrap_357", "scrap_stunstick"}
                                    wepdrop = true
                                    supermeddrop = true
                                end
                            end
                        elseif class == CLASS_SWORD then
                            if rank then
                                meddrop = true
                                if rank <= RANK_I1 then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_deagle"}
                                        wepdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_mp7a8", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_deagle"}
                                        wepdrop = true
                                    else
                                        weps = {"wep_pm63", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank <= RANK_SQL then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_deagle"}
                                        wepdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7", "scrap_deagle"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7a8", "scrap_pistol"}
                                        wepdrop = true
                                    else
                                        weps = {"scrap_xm1014", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank == RANK_DVL then
                                    if roll == 1 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7a8", "scrap_deagle"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_shotgun", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_reflex"}
                                        attdrop = true
                                    else
                                        weps = {"scrap_shotgun", "scrap_deagle", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank <= RANK_CMD and rank != nil then
                                    if roll == 1 then
                                        weps = {"scrap_mp7a8", "scrap_357"}
                                        wepdrop = true
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_xm1014", "scrap_357"}
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_deagle"}
                                        wepdrop = true
                                    else
                                        weps = {"scrap_mp7a8", "scrap_357", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                end
                            end
                        elseif class == CLASS_GHOST then
                            if rank then
                                meddrop = true
                                if rank <= RANK_I1 then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_hb", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    else
                                        weps = {"scrap_mp7", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank <= RANK_SQL then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_hb", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_hb", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    else
                                        weps = {"scrap_xm1014", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank == RANK_DVL then
                                    if roll == 1 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_hb", "scrap_pistol"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_shotgun", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    else
                                        weps = {"scrap_shotgun", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                elseif rank <= RANK_CMD and rank != nil then
                                    if roll == 1 then
                                        weps = {"scrap_hb", "scrap_357"}
                                        wepdrop = true
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_xm1014", "scrap_357"}
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_pistol_silencer"}
                                        attdrop = true
                                    else
                                        weps = {"scrap_hb", "scrap_357", "scrap_stunstick"}
                                        wepdrop = true
                                    end
                                end
                            end
                        else
                            if rank then
                                if rank <= RANK_I4 then
                                    if roll < 2 then
                                        wepdrop = false
                                    elseif roll <= 4 then
                                        weps = {"scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_stunstick"}
                                        wepdrop = true
                                    else 
                                        weps = {"scrap_pistol"}
                                        wepdrop = true
                                    end
                                elseif rank <= RANK_I3 then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_pistol"}
                                        wepdrop = true
                                    else
                                        weps = {"scrap_pistol", "scrap_pistol"}
                                        wepdrop = true
                                        meddrop = true
                                    end
                                elseif rank <= RANK_I1 then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_pistol"}
                                        wepdrop = true
                                    elseif roll <= 4 then
                                        weps = {"wep_pm63", "scrap_stunstick"}
                                        wepdrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7"}
                                        wepdrop = true
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        meddrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        meddrop = true
                                    else
                                        weps = {"scrap_mp7", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    end
                                elseif rank <= RANK_SQL then
                                    if roll == 1 then
                                        weps = {"scrap_stunstick", "scrap_pistol"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_mp7", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        meddrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        meddrop = true
                                    else
                                        weps = {"scrap_shotgun", "scrap_pistol", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    end
                                elseif rank == RANK_DVL then
                                    if roll == 1 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7", "scrap_deagle"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_shotgun", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_reflex"}
                                        attdrop = true
                                        meddrop = true
                                    else
                                        weps = {"scrap_shotgun", "scrap_deagle", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    end
                                elseif rank <= RANK_CMD and rank != nil then
                                    if roll == 1 then
                                        weps = {"scrap_mp7", "scrap_pistol"}
                                        wepdrop = true
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        meddrop = true
                                    elseif roll <= 4 then
                                        weps = {"scrap_shotgun", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 7 then
                                        weps = {"scrap_mp7", "scrap_357"}
                                        attachments = {"att_cmore"}
                                        attdrop = true
                                        wepdrop = true
                                        meddrop = true
                                    elseif roll <= 8 then
                                        weps = {"scrap_mp7", "scrap_deagle"}
                                        wepdrop = true
                                        meddrop = true
                                    else
                                        weps = {"scrap_shotgun", "scrap_357", "scrap_stunstick"}
                                        wepdrop = true
                                        meddrop = true
                                    end
                                end
                            end
                        end
                    end
                end
            elseif team == TEAM_OTA then
                if class then
                    if class == CLASS_ECHO then
                        if rank == RANK_OWG then
                            if roll <= 4 then
                                weps = {"scrap_osips"}
                                wepdrop = true
                                meddrop = true
                            else
                                weps = {"scrap_osips"}
                                wepdrop = true
                                circuitboarddrop = true
                            end
                        elseif rank == RANK_OWS then
                            if roll <= 3 then
                                weps = {"scrap_osips"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_mp7"}
                                wepdrop = true
                                attachments = {"att_cmore"}
                                attdrop = true
                                meddrop = true
                            else
                                weps = {"scrap_mp7"}
                                wepdrop = true
                                armordrop = true
                                meddrop = true
                            end
                        elseif rank == RANK_EOS then
                            if roll <= 3 then
                                weps = {"scrap_mp7"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                                armordrop = true
                                attachments = {"att_cmore"}
                                attdrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                armordrop = true
                                circuitboarddrop = true
                                meddrop = true
                            else
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                                meddrop = true
                            end 
                        elseif rank <= RANK_OSL then
                            if roll <= 3 then
                                weps = {"scrap_hb"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                meddrop = true
                                armordrop = true
                            else
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                meddrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                                circuitboarddrop = true
                            end 
                        elseif rank == RANK_ORD then
                            if roll <= 3 then
                                weps = {"scrap_opiprmk1"}
                                wepdrop = true
                                meddrop = true
                                armordrop = true
                                circuitboarddrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                meddrop = true
                                superarmordrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                            else
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                superarmordrop = true
                                supermeddrop = true
                                circuitboarddrop = true
                            end 
                        elseif rank == RANK_OSC then
                            if roll <= 2 then
                                weps = {"scrap_opiprmk1"}
                                wepdrop = true
                                superarmordrop = true
                                supermeddrop = true
                                circuitboarddrop = true
                            elseif roll <= 7 then
                                weps = {"scrap_opiprmk1"}
                                wepdrop = true
                                supermeddrop = true
                                circuitboarddrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                                superarmordrop = true
                            else
                                weps = {"scrap_ar2"}
                                wepdrop = true
                                supermeddrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                                superarmordrop = true
                                circuitboarddrop = true
                            end 
                        end
                    elseif class == CLASS_RANGER then
                        if rank <= RANK_OWS then
                            if roll <= 3 then
                                weps = {"att_optic"}
                                wepdrop = true
                                armordrop = true
                                meddrop = true
                            elseif roll <= 8 then
                                weps = {"att_optic"}
                                wepdrop = true
                                armordrop = true
                                meddrop = true
                            else
                                weps = {"scrap_osr"}
                                wepdrop = true
                            end 
                        elseif rank <= RANK_OSL then
                            if roll <= 7 then
                                weps = {"att_optic"}
                                wepdrop = true
                                meddrop = true
                            elseif roll <= 8 then
                                weps = {"att_optic"}
                                wepdrop = true
                                armordrop = true
                                meddrop = true
                            else
                                weps = {"scrap_osr"}
                                wepdrop = true
                                armordrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                            end 
                        elseif rank <= RANK_OSC then
                            if roll <= 2 then
                                weps = {"att_optic"}
                                wepdrop = true
                                superarmordrop = true
                                meddrop = true
                            elseif roll <= 7 then
                                weps = {"scrap_osr"}
                                wepdrop = true
                                superarmordrop = true
                                meddrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                            else
                                weps = {"scrap_omr"}
                                wepdrop = true
                                supermeddrop = true
                                superarmordrop = true
                                attachments = {"att_optic"}
                                attdrop = true
                            end 
                        end
                    elseif class == CLASS_MACE then
                        if rank == RANK_OWG then
                            if roll <= 4 then
                                weps = {"scrap_osisg"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                            else
                                weps = {"scrap_osisg"}
                                wepdrop = true
                            end
                        elseif rank <= RANK_EOS then
                            if roll <= 3 then
                                weps = {"scrap_osisg"}
                                wepdrop = true
                                armordrop = true
                                meddrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                meddrop = true
                                armordrop = true
                            else
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                attachments = {"att_slugrounds"}
                                attdrop = true
                                circuitboarddrop = true
                            end 
                        elseif rank <= RANK_OSL then
                            if roll <= 3 then
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                                armordrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_xm1014"}
                                wepdrop = true
                                meddrop = true
                                circuitboarddrop = true
                            else
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                attachments = {"att_slugrounds"}
                                attdrop = true
                                armordrop = true
                            end 
                        elseif rank <= RANK_OSC then
                            if roll <= 2 then
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                circuitboarddrop = true
                                meddrop = true
                                attachments = {"att_slugrounds"}
                                attdrop = true
                            elseif roll <= 6 then
                                weps = {"scrap_xm1014"}
                                wepdrop = true
                                meddrop = true
                                armordrop = true
                                circuitboarddrop = true
                                attachments = {"att_slugrounds"}
                                attdrop = true
                            else
                                weps = {"scrap_shotgun"}
                                wepdrop = true
                                supermeddrop = true
                                circuitboarddrop = true
                                attachments = {"att_dragonsbreath"}
                                attdrop = true
                            end 
                        end
                    elseif class == CLASS_FIST then
                        if roll <= 3 then
                            weps = {"ammo_ar2", "ammo_ar2"}
                            superarmordrop = true
                            wepdrop = true
                            circuitboarddrop = true
                            supermeddrop = true
                        elseif roll <= 7 then
                            weps = {"ammo_ar2", "ammo_ar2", "item_grenade"}
                            superarmordrop = true
                            wepdrop = true
                            circuitboarddrop = true
                            supermeddrop = true
                        else
                            weps = {"ammo_ar2", "ammo_ar2", "item_grenade"}
                            superarmordrop = true
                            wepdrop = true
                            circuitboarddrop = true
                            supermeddrop = true
                        end
                    elseif class == CLASS_APF then
                        if roll <= 4 then
                            weps = {"ammo_lmg", "ammo_lmg", "item_ammocrate"}
                            armordrop = true
                            wepdrop = true
                            circuitboarddrop = true
                            supermeddrop = true
                        else
                            weps = {"ammo_lmg", "ammo_lmg", "ammo_lmg"}
                            superarmordrop = true
                            wepdrop = true
                            circuitboarddrop = true
                            meddrop = true
                        end
                    elseif class == CLASS_PAYBACK then
                        weps = {"ammo_buckshot", "ammo_buckshot", "ammo_buckshot", "scrap_stunstick"}
                        if roll <= 3 then
                            superarmordrop = true
                        else
                            armordrop = true
                        end
                        wepdrop = true
                        supermeddrop = true
                        circuitboarddrop = true
                    elseif class == CLASS_NOMAD then
                        weps = {"scrap_osips"}
                        wepdrop = true
                        meddrop = true
                        circuitboarddrop = true
                        armordrop = true
                    end 
                end
            end
            if wepdrop == true then
                for k,v in pairs(weps) do
                    local chance = math.random(1,10)
                    local wcl = v
                    if wcl == "scrap_357" and team == TEAM_CP and rank == RANK_CMD and chance > 8 then
                        wcl = "scrap_sw500"
                    end
                    if chance >= 4 then
                        table.insert(drops, wcl)
                    end
                end
                for k,v in pairs(weps) do
                    local ammo = "meeman"
                    local amount = math.random(0,3)
                    if team == TEAM_OTA then 
                        amount = math.random(1,4)
                    end
                    if v == "scrap_pistol" or v == "wep_pm63" then
                        ammo = "ammo_pistol"
                    elseif v == "scrap_mp7" or v == "scrap_mp7a8" or v == "scrap_hb" then
                        ammo = "ammo_smg"
                    elseif v == "scrap_deagle" then
                        ammo = "ammo_deagle"
                    elseif v == "scrap_357" or v == "scrap_sw500" then
                        ammo = "ammo_357"
                    elseif v == "scrap_shotgun" or v == "scrap_osisg" or v == "scrap_xm1014" then
                        ammo = "ammo_buckshot"
                    elseif v == "scrap_ar2" or v == "scrap_ar2e" or v == "scrap_omr" then
                        ammo = "ammo_ar2"
                    elseif v == "scrap_osr" then
                        ammo = "ammo_sniper"
                        amount = math.random(0,1)
                    elseif v == "scrap_apf" then
                        ammo = "ammo_lmg"
                    end
                    if ammo != "meeman" then
                        local dropped = 0
                        while dropped < amount do
                            table.insert(drops, ammo)
                            dropped = dropped + 1
                        end
                    end
                end
            end
            if circuitboarddrop == true then
                local chance = math.random(1,10)
                local board = "util_electronics"
                if chance + rank >= 6 then
                    local amount = math.random(0,2)
                    local meeman = 0
                    while meeman < amount do
                        table.insert(drops, board)
                        meeman = meeman + 1
                    end
                end
                local rappelchance = math.random(1,10)
                if rappelchance <= 3 then 
                    table.insert(drops, "item_rappel")
                end
            end
            if attdrop == true then
                for k,v in pairs(attachments) do
                local chance = math.random(1,10)
                    if chance >= 5 then
                        table.insert(drops, v)
                    end
                end
            end
            if armordrop == true then
                local chance = math.random(1,10)
                local armor = "cos_otavest3"
                if chance >= 2 then
                    table.insert(drops, armor)
                end
            end
            if superarmordrop == true then
                local armor = "util_heavyceramicplate"
                local chance = math.random(1,10)
                if chance >= 3 then
                    table.insert(drops, armor)
                end
            end
            if meddrop == true then
                local amount = math.random(0,2)
                if team == TEAM_OTA then
                    amount = math.random(1,4)
                end
                local meds = "item_healthvial"
                local dropped = 0
                if OCAAB_HEALTHVIALS_UPGRADE == true then
                    amount = math.random(0,1)
                    meds = "item_enhancedvial"
                end
                if amount != 0 then
                    while dropped < amount do
                        table.insert(drops, meds)
                        dropped = dropped + 1
                    end
                end
            elseif supermeddrop == true then
                local amount = math.random(0,2)
                if team == TEAM_OTA then
                    amount = math.random(1,4)
                end
                local meds = "item_enhancedvial"
                local dropped = 0
                if amount != 0 then
                    while dropped < amount do
                        table.insert(drops, meds)
                        dropped = dropped + 1
                    end
                end
            end
            for k,v in pairs(inv) do
                if not v.restricted then
                    table.insert(drops, v.class)
                end
            end
            table.insert(drops, "util_combinescrap")
            lootpackage:SetPos(pos) 
            lootpackage:SetModel("models/props_c17/BriefCase001a.mdl")
            lootpackage:Spawn()
            lootpackage:SetCollisionGroup(COLLISION_GROUP_WORLD)
            for k,v in pairs(drops) do
                lootpackage:AddItem(v, 1, false)
            end
            timer.Simple(300, function()
                lootpackage:Remove()
            end)
        end
    end
end)]]