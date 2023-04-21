
function ChangeLightingStyle(cli)
	if cli then
		engine.LightStyle(0, cli)
	else
		engine.LightStyle(0, "d")
	end
	BroadcastLua('render.SetAmbientLight(0,0,0)')
	BroadcastLua('render.RedownloadAllLightmaps(true)')
end

function assblastusa()
    for k,v in pairs(player.GetAll()) do
        print(v, v:GetNWBool("body_found", false))
    end
end

hook.Add("Tick", "cs16_playertick", function()
    for k,v in pairs(player.GetAll()) do
        v.nextSwimSound = v.nextSwimSound or 0
        if v.nextSwimSound < CurTime() and v:WaterLevel() > 2 then
            v:EmitSound("cstrike/player/pl_swim"..math.random(1,4)..".wav", 75, 100, 1)
            v.nextSwimSound = CurTime() + 1.5
        end
    end
end)

local function llpos(pos)
    return (render.GetLightColor(pos) * Vector(100,100,100)):Length()
end

local meta_player = FindMetaTable("Player")

function meta_player:CalculateLL()
    local pos = self:GetPos() + Vector(0,0,40)
    local yaw = self:GetAngles().yaw

    if !self:IsOnGround() then
        pos = pos - Vector(0,0,30)
    end

    local light_levels = {
        llpos(pos),
        llpos(pos + Angle(0,yaw,0):Forward() * 50),
        llpos(pos + Angle(0,yaw,0):Forward() * -50),
        llpos(pos + Angle(0,yaw,0):Right() * 50),
        llpos(pos + Angle(0,yaw,0):Right() * -50),
    }
    local averageLL = 0
    for k,v in pairs(light_levels) do
        averageLL = averageLL + v
    end
    averageLL = averageLL / table.Count(light_levels)

    return averageLL
end



if CLIENT then
    surface.CreateFont("CS16_Upper_Notif", {
        font = "Arial",
        extended = false,
        size = 18,
        weight = 600,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    net.Receive("cs16_upper_notif", function()
        local time = net.ReadFloat()
        local text = net.ReadString()
        local color = net.ReadColor()
        GSTTT_CS16_DrawUpperNotification(time, text, color)
    end)

    local upper_notif_alpha = 0
    local upper_notif_stage = 0
    local upper_notif_waituntil = 0
    local upper_notif_text = ""
    local upper_notif_color = Color(255,255,255)
    function GSTTT_CS16_DrawUpperNotification(for_seconds, text, color)
        upper_notif_stage = 1
        upper_notif_alpha = 0
        upper_notif_waituntil = CurTime() + for_seconds
        upper_notif_text = text or ""
        upper_notif_color = color or Color(255,255,255)
    end

    hook.Add("DrawOverlay", "gsttt_tvirus_DrawOverlay", function()
        if upper_notif_stage > 0 then
            -- 1 STAGE - FADE IN
            if upper_notif_stage == 1 then
                upper_notif_alpha = math.Clamp(upper_notif_alpha + 1, 0, 255)
                if upper_notif_alpha == 255 then
                    upper_notif_stage = 2
                end

            -- 2 STAGE - HOLD
            elseif upper_notif_stage == 2 then
                upper_notif_alpha = 255
                if upper_notif_waituntil < CurTime() then
                    upper_notif_stage = 3
                end

            -- 3 STAGE - FADE OUT
            elseif upper_notif_stage == 3 then
                upper_notif_alpha = math.Clamp(upper_notif_alpha - 1, 0, 255)
                if upper_notif_alpha == 0 then
                    upper_notif_stage = 0
                end
            end
            draw.Text({
                text = upper_notif_text,
                pos = {ScrW() / 2, ScrH() / 4},
                font = "CS16_Upper_Notif",
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_TOP,
                color = Color(upper_notif_color.r, upper_notif_color.g, upper_notif_color.b, upper_notif_alpha)
            })

        end
    end)

-- NVG ----------------------------------------

    local next_nvg_update = 0
    cs16_nvg_enabled = false
    cs16_nvg_allowed = false

    local current_ll = 5

    local mat_color = Material("pp/colour")
    hook.Add("RenderScreenspaceEffects", "cs16_screen_effects", function()
        local client = LocalPlayer()
        local contrast = 1
        local colour = 1
        local brightness = 0
        local clr_r = 0
        local clr_g = 0
        local clr_b = 0
        local add_r = 0
        local add_g = 0
        local add_b = 0
        /*
        if next_nvg_update < CurTime() then
            cs16_nvg_allowed = LocalPlayer():GetNWBool("HasNVG") or false
            next_nvg_update = CurTime() + 0.5
        end
        */
    
        local ll = math.Round(client:CalculateLL(), 2)

        local diff = math.abs(math.Round(ll - current_ll, 1))
        local llmul = math.Clamp(6 - current_ll, 1, 10)

        if diff > 0.1 then
            if current_ll < ll then
                current_ll = current_ll + 0.005

            elseif current_ll > ll then
                current_ll = current_ll - 0.005
            end
        end

        --if (cs16_nvg_allowed and cs16_nvg_enabled) or client:IsZombie() then
        if client:IsZombie() then
            contrast = 3 * llmul
            add_g = 0.16
            clr_g = 0.9
            brightness = -0.25
        end
    
    
        render.UpdateScreenEffectTexture()
        mat_color:SetTexture("$fbtexture", render.GetScreenEffectTexture())
        mat_color:SetFloat("$pp_colour_brightness", brightness)
        mat_color:SetFloat("$pp_colour_contrast", contrast)
        mat_color:SetFloat("$pp_colour_colour", colour)
        mat_color:SetFloat("$pp_colour_mulr", clr_r)
        mat_color:SetFloat("$pp_colour_mulg", clr_g)
        mat_color:SetFloat("$pp_colour_mulb", clr_b)
        mat_color:SetFloat("$pp_colour_addr", add_r)
        mat_color:SetFloat("$pp_colour_addg", add_g)
        mat_color:SetFloat("$pp_colour_addb", add_b)
        
        render.SetMaterial(mat_color)
        render.DrawScreenQuad()
    end)

    local function create_dlight(pos)
        local client = LocalPlayer()
        client.Dlight = DynamicLight(client:EntIndex())
        client.Dlight.pos = pos
        client.Dlight.r = 0
        client.Dlight.g = 255
        client.Dlight.b = 0
        client.Dlight.brightness = 1
        client.Dlight.Decay = 1000
        client.Dlight.Size = 256
        client.Dlight.DieTime = CurTime() + 1
    end

    hook.Add("Think", "CS16_Dlight", function()
        local client = LocalPlayer()

        --if (cs16_nvg_allowed and cs16_nvg_enabled) then
        if client:IsZombie() then
            create_dlight(client:GetShootPos())

        elseif client.Dlight then
            client.Dlight = nil
        end
    end)

else
    hook.Add("PlayerInitialSpawn", "InitializeFlashlights", function(ply)
        ply:SendLua("firststartmenu = true CreateStartMenu()")
    end)

    util.AddNetworkString("cs16_upper_notif")

    function GSTTT_CS16_DrawUpperNotification(for_seconds, text, color)
        net.Start("cs16_upper_notif")
            net.WriteFloat(for_seconds)
            net.WriteString(text)
            net.WriteColor(color or Color(255,255,255))
        net.Broadcast()
    end

    local map_monsters = {
        ["monster_zombie"] = {0.27, 1.5},
        ["monster_alien_slave"] = {0.2, 1.5},
        ["monster_headcrab"] = {0.5, 2},
    }

    hook.Add("EntityTakeDamage", "cs16_EntityTakeDamage", function(target, dmginfo)
        local attacker = dmginfo:GetAttacker()

        --ZOMBIE
        if map_monsters[target:GetClass()] then
            dmginfo:ScaleDamage(map_monsters[target:GetClass()][1])

        elseif target:IsPlayer() and IsValid(attacker) and map_monsters[attacker:GetClass()] then
            local mul = map_monsters[attacker:GetClass()][2]
            dmginfo:ScaleDamage(mul)

            /*
            if attacker:GetClass() == "monster_headcrab" and target:Health() <= dmginfo:GetDamage() and GetRoundState() == ROUND_ACTIVE then
                target:TurnIntoAZombie()
                if tvirus_enabled then
                    target:SetHealth(550)
                    target:SetMaxHealth(550)
                else
                    target:SetHealth(200)
                    target:SetMaxHealth(200)
                end
                attacker:Remove()
                return true
            end
            */
        end
    end)

    hook.Add("Tick", "cs16_playertick", function()
        for k,v in pairs(player.GetAll()) do
            if v:Team() == TEAM_SPECTATOR then
                if IsValid(v:GetActiveWeapon()) then
                    v:StripWeapon(v:GetActiveWeapon():GetClass())
                end
            end
        end
    end)

    function GSTTT_GiveRevolvers()
        for k,v in pairs(player.GetAll()) do
            v:Give("weapon_ttt_revolver")
        end
    end
end
