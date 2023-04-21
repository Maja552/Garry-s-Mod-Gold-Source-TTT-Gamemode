
local plymeta = FindMetaTable("Player")

tvirus_max_round_zombies = 0
round_starting_players = 100
zombies_exceeded_half_players = false


function plymeta:TurnIntoAZombie()
    self:SetModel("models/player/hl1/zombie.mdl")
    self:EmitSound("gsttt/zombie/zombie_infec"..math.random(1,3)..".wav", 100, 100, 1)
    self:SetHealth(1500)
    self:SetMaxHealth(1500)
    self:SetWalkSpeed(250)
    self:SetRunSpeed(250)
    self:SetCrouchedWalkSpeed(0.3)
    self:SetArmor(0)
    self:StripWeapons()
    self:Give("weapon_ttt_zombie")
    self:SetRole(ROLE_ZOMBIE)
    self:AllowFlashlight(false)
    if self.ForceRemoveFlashlight then
        self:ForceRemoveFlashlight()
    end
    SendFullStateUpdate()



    tvirus_max_round_zombies = tvirus_max_round_zombies + 1

    --print("tvirus_max_round_zombies: " .. tostring(tvirus_max_round_zombies),
    --"round_starting_players: " .. tostring(round_starting_players),
    --"zombies_exceeded_half_players: " .. tostring(zombies_exceeded_half_players))
    if !zombies_exceeded_half_players and tvirus_max_round_zombies >= math.Round(round_starting_players / 2) then
        zombies_exceeded_half_players = true
        GSTTT_CS16_DrawUpperNotification(6, "Over half of humans got infected, human friendly fire disabled...", Color(255, 0, 0))
        --if math.random(1,3) <= 2 then
        --    for k,v in pairs(player.GetAll()) do
        --        v:SendLua('surface.PlaySound("gsttt/zombie/umbrella_music.wav")')
        --    end
        --end
    end
end

tvirus_enabled = false

local round_num = 0
local last_tvirus_round = nil
force_tvirus_round = false

GSTTT_ZOMBIES_ENABLED = false

hook.Add("TTTPrepareRound", "gsttt_tvirus_TTTPrepareRound", function()
    timer.Remove("StartTVirusRound")
    tvirus_max_round_zombies = 0
    zombies_exceeded_half_players = false
    round_starting_players = 0
    
    for k,v in pairs(player.GetAll()) do
        v:AllowFlashlight(true)
        if !v:IsSpec() then
            round_starting_players = round_starting_players + 1
        end
    end


    -- TVIRUS ROUND STUFF
    round_num = round_num + 1

    if force_tvirus_round then
        tvirus_enabled = true
    else
        tvirus_enabled = math.random(1, 100) < 65
        --tvirus_enabled = true
    
        if round_num <= 2 or #player.GetAll() < 4 or (last_tvirus_round and (round_num <= (last_tvirus_round + 2))) then
            tvirus_enabled = false
        end
    end

    --if !GSTTT_ZOMBIES_ENABLED then
       tvirus_enabled = false
    --end

    print(round_num, tvirus_enabled)
end)

local random_t_weapons = {
    "weapon_ttt_sipistol",
    "weapon_ttt_tmp",
    "weapon_ttt_radio",
    "weapon_ttt_knife",
    "weapon_ttt_decoy",
    "weapon_ttt_teleport",
    "weapon_ttt_flaregun",
    "weapon_ttt_flashbang",
    "weapon_ttt_hegrenade"
}

hook.Add("TTTBeginRound", "gsttt_tvirus_TTTBeginRound", function()
    for k,v in pairs(player.GetAll()) do
        if v:IsTraitor() then
            v:Give(table.Random(random_t_weapons))
        end
    end

    if tvirus_enabled then
        GSTTT_CS16_DrawUpperNotification(6, "The T-Virus has been set loose...", Color(8, 127, 231))

        timer.Create("StartTVirusRound", 13, 1, function()
            hook.Call("GSTTT_StartTVirusRound")
        end)

        last_tvirus_round = round_num
    end
end)

hook.Add("GSTTT_StartTVirusRound", "gsttt_tvirus_StartTVirusRound", function()
    if tvirus_enabled then
        print("starting tvirus round")
        local all_possible_players = {}
        for k,v in pairs(player.GetAll()) do
            if v:Alive() and !v:IsTraitor() and !v:IsSpec() and !v:IsDetective() then
                table.ForceInsert(all_possible_players, v)
                --v:TurnIntoAZombie()
            end
        end

        local rnd_ply = table.Random(all_possible_players)
        if rnd_ply then
            rnd_ply:TurnIntoAZombie()
            rnd_ply:SetHealth(2200)
            rnd_ply:SetMaxHealth(2200)
            SendZombieList()
        end
    end
end)

hook.Add("TTTEndRound", "gsttt_tvirus_TTTEndRound", function()
    tvirus_enabled = false
end) 


hook.Add("AllowPlayerPickup", "gsttt_tvirus_AllowPlayerPickup", function(ply, ent)
    if ply:IsZombie() then return false end
end)

hook.Add("PlayerCanPickupWeapon", "gsttt_tvirus_PlayerCanPickupWeapon", function(ply, ent)
    if ply:IsZombie() then return false end
end)

hook.Add("TTTCanOrderEquipment", "gsttt_tvirus_TTTCanOrderEquipment", function(ply)
    if ply:IsZombie() then
        ply:PrintMessage(HUD_PRINTCENTER, "You can't buy anything as a zombie")
        return false
    end
end)

hook.Add("ScalePlayerDamage", "gsttt_tvirus_ScalePlayerDamage", function(ply, hitgroup, dmginfo)
    if tvirus_enabled then
        local attacker = dmginfo:GetAttacker()
        local attacker_valid_zombie = (IsValid(attacker) and attacker:IsPlayer() and attacker:IsZombie())
        local ply_valid_zombie = (IsValid(ply) and ply:IsPlayer() and ply:IsZombie())

        if attacker_valid_zombie and ply:IsZombie() then
            dmginfo:ScaleDamage(0)
            return true
        end

        if ply:IsZombie() then
            local dmgmul = GetConVar("ttt_zombie_scale_dmg")
            if dmgmul then
                dmgmul = dmgmul:GetFloat()
            else
                dmgmul = 2
            end
            --print("dmgmul: " .. dmgmul)
            dmginfo:ScaleDamage(2)
        end

        if attacker_valid_zombie then
            if ply:Health() <= dmginfo:GetDamage() then
                ply:TurnIntoAZombie()
                --ply:SetRole(ROLE_TRAITOR)
                --SendFullStateUpdate()
                return true
            end
            if ply:IsZombie() then
                return true
            end
        elseif zombies_exceeded_half_players and !ply:IsZombie() then
            return true
        end
    end
end)

