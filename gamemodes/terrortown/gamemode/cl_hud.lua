-- HUD HUD HUD

local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp

--local new16font = "DS-Digital"
--local new16font = "Fake Hope"
local new16font = "Tahoma"

local cstrike_font = {
   ["0"] =			{x = 0, 	y = 0,		w = 20,		h = 24},
   ["1"] =			{x = 24, 	y = 0,		w = 20,		h = 24},
   ["2"] =			{x = 48, 	y = 0, 		w = 20,		h = 24},
   ["3"] =			{x = 72, 	y = 0, 		w = 20,		h = 24},
   ["4"] =			{x = 96, 	y = 0, 		w = 20,		h = 24},
   ["5"] =			{x = 120, 	y = 0, 		w = 20, 	h = 24},
   ["6"] =			{x = 144, 	y = 0, 		w = 20,		h = 24},
   ["7"] =			{x = 168, 	y = 0, 		w = 20,		h = 24},
   ["8"] =			{x = 192, 	y = 0, 		w = 20,		h = 24},
   ["9"] =			{x = 216, 	y = 0, 		w = 20,		h = 24},
   ["separator"] =	{x = 240, 	y = 0, 		w = 2,		h = 24}, -- separator
   ["shield1"] =	{x = 0, 	y = 25, 	w = 24,		h = 23}, -- shield - full
   ["c"] =			{x = 24, 	y = 25, 	w = 24,		h = 23}, -- shield - empty
   ["cross"] =		{x = 48, 	y = 25, 	w = 23,		h = 23}, -- cross
   ["e"] =			{x = 0, 	y = 72, 	w = 24,		h = 24}, -- 12 gauge ammo
   ["ammo_50"] =	{x = 24, 	y = 72, 	w = 24,		h = 24}, -- .50 ammo
   ["ammo_9mm"] =	{x = 48, 	y = 72, 	w = 24,		h = 24}, -- 9mm ammo
   ["h"] =			{x = 72, 	y = 72, 	w = 24,		h = 24}, -- 7.62 ammo
   ["i"] =			{x = 96, 	y = 72, 	w = 24,		h = 24}, -- .45 ammo
   ["ammo_357"] =	{x = 120, 	y = 72, 	w = 24,		h = 24}, -- .357 ammo
   ["ammo_57"] =	{x = 120, 	y = 95, 	w = 24,		h = 24}, -- 5.7 ammo
   ["ammo_556"] =	{x = 0, 	y = 97, 	w = 24,		h = 24}, -- 5.56 ammo
   ["ammo_338"] =	{x = 24, 	y = 97, 	w = 24,		h = 24}, -- 338 ammo
   ["clock"] =		{x = 144, 	y = 72, 	w = 24,		h = 24}, -- clock
   ["l"] =			{x = 168,	y = 72,		w = 20,		h = 20}, -- slot 1
   ["m"] =			{x = 188,	y = 72,		w = 20,		h = 20}, -- slot 2
   ["n"] =			{x = 208,	y = 72,		w = 20,		h = 20}, -- slot 3
   ["o"] =			{x = 168,	y = 92,		w = 20,		h = 20}, -- slot 4
   ["p"] =			{x = 188,	y = 92,		w = 20,		h = 20}, -- slot 5
   ["r"] =			{x = 208,	y = 92,		w = 20,		h = 20}, -- empty box
   ["dollar"] =	{x = 192,	y = 25,		w = 19,		h = 25}, -- empty box
}

local ammodtypes = {
   new_cs_45 = "i",
   new_cs_9mm = "ammo_9mm",
   new_cs_12g = "e", -- shotguns
   new_cs_762 = "h",
   new_cs_50 = "ammo_50",
   new_cs_357 = "ammo_357",
   new_cs_57 = "ammo_57",
   new_cs_556 = "ammo_556",
   new_cs_338 = "ammo_338",
}

surface.CreateFont("zh_cstrike_font", {
   font = "CloseCaption_Bold",
   extended = true,
   size = 20,
   weight = 1000,
   additive = true
})

local fontinfo = {
	font = "TabLarge",
	extended = false,
	size = 20,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
}
surface.CreateFont("CloakHUDShit", fontinfo)
fontinfo.size = 18
surface.CreateFont("HasteModeHUD", fontinfo)

local function zh_texture_uv(x, y, sprite_x, sprite_y, sprite_width, sprite_height, image_width, image_height)
   surface.DrawTexturedRectUV(x, y, sprite_width, sprite_height, sprite_x / image_width, sprite_y / image_height, (sprite_x + sprite_width) / image_width, (sprite_y + sprite_height) / image_height)
end

local double_draw_16 = true

function CStrikeFont(x, y, align_x, align_y, text, color_to_use)
   local pos_x = x
   local pos_y = y
   local new_text = {}
   local size_x = 0
   local size_y = 0
   for k,v in pairs(text) do
       local cur_char = cstrike_font[v]
       if isnumber(v) then
           pos_x = pos_x + v
           size_x = size_x + v
       elseif cur_char != nil then
           --zh_texture_uv(pos_x, pos_y, cur_char.x, cur_char.y, cur_char.w, cur_char.h, 256, 256)
           table.ForceInsert(new_text, {
               pos_x = pos_x,
               pos_y = pos_y,
               char_x = cur_char.x,
               char_y = cur_char.y,
               char_w = cur_char.w,
               char_h = cur_char.h,
           })
           pos_x = pos_x + cur_char.w
           size_x = size_x + cur_char.w
           if size_y < cur_char.h then
               size_y = cur_char.h
           end
       else
           table.ForceInsert(new_text, v)
           pos_x = pos_x + 8
       end
   end
   local add_x = 0
   local add_y = 0
   if align_x == TEXT_ALIGN_CENTER then
       add_x = -(size_x / 2)
   elseif align_x == TEXT_ALIGN_RIGHT then
       add_x = -size_x
   end
   
   if align_y == TEXT_ALIGN_CENTER then
       add_y = -(size_y / 2)
   elseif align_y == TEXT_ALIGN_BOTTOM then
       add_y = -size_y
   end
   surface.SetDrawColor(color_to_use)
   for i,v in ipairs(new_text) do
      for i2=1, 2 do
         if isstring(v) then
            local posx = 0
            local posy = 0
            if new_text[i-1] and new_text[i+1] then
               posx = (new_text[i-1].pos_x + add_x) + ((new_text[i+1].pos_x + add_x) - (new_text[i-1].pos_x + add_x)) - 8
               posy = new_text[i-1].pos_y + add_y
            end
            draw.Text({
               text = v,
               font = "zh_cstrike_font",
               pos = {posx, posy},
               --xalign = align_x,
               --yalign = align_y,
               color = color_to_use
            })
            else
            zh_texture_uv(v.pos_x + add_x, v.pos_y + add_y, v.char_x, v.char_y, v.char_w, v.char_h, 256, 256)
         end
      end
   end
end

local function cstrike_num_to_tab(num)
   if num == 0 then return {"0"} end
   num = tostring(num)
   local tab = {}
   for i=1, #num do
       table.ForceInsert(tab, num[i])
   end
   return tab
end

surface.CreateFont("WepSwitchFont",     {font = "Trebuchet24",
                                    size = 24,
                                    weight = 800})

-- Fonts
surface.CreateFont("TraitorState", {font = new16font,
                                    size = 32,
                                    weight = 1000,
                                    shadow = true,
                                    additive = true
                                 })
surface.CreateFont("TimeLeft",     {font = new16font,
                                    size = 24,
                                    weight = 800})
surface.CreateFont("HealthAmmo",   {font = new16font,
                                    size = 24,
                                    weight = 750})
-- Color presets
local bg_colors = {
   background_main = Color(0, 0, 10, 200),

   noround = Color(50,50,50,180),
   traitor = Color(100, 15, 15, 180),
   innocent = Color(35, 35, 35, 180),
   detective = Color(15, 15, 65, 180),
   zombie = Color(41, 64, 4, 180)
};

local health_colors = {
   border = COLOR_WHITE,
   background = Color(25, 25, 25, 222),
   fill = Color(190, 50, 50, 100)
};

local ammo_colors = {
   border = COLOR_WHITE,
   background = Color(20, 20, 5, 222),
   fill = Color(205, 155, 0, 255)
};


-- Modified RoundedBox
local Tex_Corner8 = surface.GetTextureID( "gui/corner8" )
local function RoundedMeter( bs, x, y, w, h, color)
   surface.SetDrawColor(clr(color))

   surface.DrawRect( x+bs, y, w-bs*2, h )
   surface.DrawRect( x, y+bs, bs, h-bs*2 )

   surface.SetTexture( Tex_Corner8 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + bs/2, bs, bs, 0 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + h -bs/2, bs, bs, 90 )

   if w > 14 then
      surface.DrawRect( x+w-bs, y+bs, bs, h-bs*2 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + bs/2, bs, bs, 270 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + h - bs/2, bs, bs, 180 )
   else
      surface.DrawRect( x + math.max(w-bs, bs), y, bs/2, h )
   end

end

---- The bar painting is loosely based on:
---- http:--wiki.garrysmod.com/?title=Creating_a_HUD

-- Paints a graphical meter bar
local function PaintBar(x, y, w, h, colors, value)
   -- Background
   -- slightly enlarged to make a subtle border
   draw.RoundedBox(8, x-1, y-1, w+2, h+2, colors.background)

   -- Fill
   local width = w * math.Clamp(value, 0, 1)

   if width > 0 then
      RoundedMeter(8, x, y, width, h, colors.fill)
   end
end

local roundstate_string = {
   [ROUND_WAIT]   = "round_wait",
   [ROUND_PREP]   = "round_prep",
   [ROUND_ACTIVE] = "round_active",
   [ROUND_POST]   = "round_post"
};

-- Returns player's ammo information
local function GetAmmo(ply)
   local weap = ply:GetActiveWeapon()
   if not weap or not ply:Alive() then return -1 end

   local ammo_inv = weap:Ammo1() or 0
   local ammo_clip = weap:Clip1() or 0
   local ammo_max = weap.Primary.ClipSize or 0

   return ammo_clip, ammo_max, ammo_inv
end

local function DrawBg(x, y, width, height, client)
   -- Traitor area sizes
   local th = 30
   local tw = 170

   -- Adjust for these
   y = y - th
   height = height + th

   -- main bg area, invariant
   -- encompasses entire area

   -- main border, traitor based
   local col = bg_colors.innocent
   if GAMEMODE.round_state != ROUND_ACTIVE then
      col = bg_colors.noround
   elseif client:GetTraitor() then
      col = bg_colors.traitor
   elseif client:IsZombie() then
      col = bg_colors.zombie
   elseif client:GetDetective() then
      col = bg_colors.detective
   end

   draw.RoundedBox(8, x, y, width, height, col)

  -- draw.RoundedBox(8, x, y, tw, th, col)
end

local sf = surface
local dr = draw

local function ShadowedText(text, font, x, y, color, xalign, yalign)

   dr.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)

   dr.SimpleText(text, font, x, y, color, xalign, yalign)
end

local margin = 10

-- Paint punch-o-meter
local function PunchPaint(client)
   local L = GetLang()
   local punch = client:GetNWFloat("specpunches", 0)

   local width, height = 200, 25
   local x = ScrW() / 2 - width/2
   local y = margin/2 + height

   PaintBar(x, y, width, height, ammo_colors, punch)

   local color = bg_colors.background_main

   dr.SimpleText(L.punch_title, "HealthAmmo", ScrW() / 2, y, color, TEXT_ALIGN_CENTER)

   dr.SimpleText(L.punch_help, "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   local bonus = client:GetNWInt("bonuspunches", 0)
   if bonus != 0 then
      local text
      if bonus < 0 then
         text = interp(L.punch_bonus, {num = bonus})
      else
         text = interp(L.punch_malus, {num = bonus})
      end

      dr.SimpleText(text, "TabLarge", ScrW() / 2, y * 2, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local key_params = { usekey = Key("+use", "USE") }

local function SpecHUDPaint(client)
   local L = GetLang() -- for fast direct table lookups

   -- Draw round state
   local x       = margin
   local height  = 32
   local width   = 250
   local round_y = ScrH() - height - margin

   -- move up a little on low resolutions to allow space for spectator hints
   if ScrW() < 1000 then round_y = round_y - 15 end

   local time_x = x + 170
   local time_y = round_y + 4

   draw.RoundedBox(8, x, round_y, width, height, bg_colors.background_main)
   draw.RoundedBox(8, x, round_y, time_x - x, height, bg_colors.noround)

   local text = L[ roundstate_string[GAMEMODE.round_state] ]
   ShadowedText(text, "TraitorState", x + margin, round_y, COLOR_WHITE)

   -- Draw round/prep/post time remaining
   local text = util.SimpleTime(math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime()), "%02i:%02i")
   ShadowedText(text, "TimeLeft", time_x + margin, time_y, COLOR_WHITE)

   local tgt = client:GetObserverTarget()
   if IsValid(tgt) and tgt:IsPlayer() then
      ShadowedText(tgt:Nick(), "TimeLeft", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)

   elseif IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == client then
      PunchPaint(client)
   else
      ShadowedText(interp(L.spec_help, key_params), "TabLarge", ScrW() / 2, margin, COLOR_WHITE, TEXT_ALIGN_CENTER)
   end
end

local normal_16_color = Color(255, 180, 0, 215)
local normal_16_text_color = Color(255, 180, 0, 255)

local cs_hud_texture = surface.GetTextureID("zombie_hell/cs_hud")

local function InfoPaint(client)
   local L = GetLang()

   local width = 320
   local height = 120

   local x = margin
   local y = ScrH() - margin - height

   DrawBg(x, y, width, height, client)

   local bar_height = 32
   local bar_width = width - (margin*2)

   -- Draw health
   local health = math.max(0, client:Health())
   local health_y = y + margin + 8

   PaintBar(x + margin, health_y, bar_width, bar_height, health_colors, health/100)

   -- Draw traitor state
   local round_state = GAMEMODE.round_state

   local traitor_y = y - 30
   local text = nil
   if round_state == ROUND_ACTIVE then
      text = L[ client:GetRoleStringRaw() ]
   else
      text = L[ roundstate_string[round_state] ]
   end

   draw.Text({
      text = text,
      font = "TraitorState",
      xalign = TEXT_ALIGN_LEFT,
      yalign = TEXT_ALIGN_BOTTOM,
      color = normal_16_text_color,
      pos = {20, ScrH() - 125}
   })

   -- Draw round time
   local is_haste = HasteMode() and round_state == ROUND_ACTIVE
   local is_traitor = client:IsActiveTraitor()

   local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

   local text
   local font = "TimeLeft"
   local color = normal_16_color
   local color_haste = normal_16_text_color
   local rx = x + margin + 170
   local ry = traitor_y + 3
   local overtime = false

   -- Time displays differently depending on whether haste mode is on,
   -- whether the player is traitor or not, and whether it is overtime.
   if is_haste then
      local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
      if hastetime < 0 then
         if (not is_traitor) or (math.ceil(CurTime()) % 7 <= 2) then
            overtime = true

            ry = ry + 5
            rx = rx - 3
         else
            -- traitor and not blinking "overtime" right now, so standard endtime display
            text  = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
            color = Color(255, 0, 0, 255)
            color_haste = Color(255, 0, 0, 255)
         end
      else
         local t = hastetime
         if is_traitor and math.ceil(CurTime()) % 6 < 2 then
            t = endtime
            color = Color(255, 0, 0, 255)
            color_haste = Color(255, 0, 0, 255)
         end
         text = util.SimpleTime(math.max(0, t), "%02i:%02i")

      end
   else
      text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
   end

   surface.SetTexture(cs_hud_texture)

   local hastemodetext = L.hastemode
   local time = {}

   if overtime then
      hastemodetext = hastemodetext .. " - OVERTIME"
      table.Add(time, cstrike_num_to_tab("00:00"))
   else
      table.Add(time, cstrike_num_to_tab(text))
   end
   surface.SetDrawColor(color)
   --CStrikeFont(ScrW() * 0.5, ScrH() - 7, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, time, color)
   CStrikeFont(228, ScrH() - 124, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, time, color)
   CStrikeFont(190, ScrH() - 124, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, {"clock", 15}, color)

   draw.Text({
      text = hastemodetext,
      font = "HasteModeHUD",
      xalign = TEXT_ALIGN_LEFT,
      yalign = TEXT_ALIGN_BOTTOM,
      color = color_haste,
      pos = {224, ScrH() - 152}
   })

   local health = {"cross", 5}
   table.Add(health, cstrike_num_to_tab(client:Health()))
   --CStrikeFont(7, ScrH() - 7, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, health, normal_16_color)
   --CStrikeFont(20, ScrH() - 65, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, health, normal_16_color)
   CStrikeFont(24, ScrH() - 84, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, health, normal_16_color)


   local ammo_caliber = nil
   local wep = client:GetActiveWeapon()
   if IsValid(wep) and wep:Clip1() > -1 and ammodtypes[wep.Primary.Caliber] then
      ammo_caliber = ammodtypes[wep.Primary.Caliber]
   end

   -- Draw ammo
   if client:GetActiveWeapon().Primary then
      local ammo_clip, ammo_max, ammo_inv = GetAmmo(client)
      if ammo_clip != -1 then
         --local ammo_y = health_y + bar_height + margin
         --PaintBar(x+margin, ammo_y, bar_width, bar_height, ammo_colors, ammo_clip/ammo_max)
         local text = string.format("%i + %02i", ammo_clip, ammo_inv)

         local ammo = {}
         table.Add(ammo, cstrike_num_to_tab(ammo_clip))
         table.Add(ammo, {5, "separator", 15})
         table.Add(ammo, cstrike_num_to_tab(ammo_inv))
         if ammo_caliber then
            table.ForceInsert(ammo, ammo_caliber)
         end

         --CStrikeFont(ScrW() - 7, ScrH() - 7, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, ammo, normal_16_color)
         CStrikeFont(20, ScrH() - 22, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, ammo, normal_16_color)

         --ShadowedText(text, "HealthAmmo", bar_width, ammo_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
      end
   end
end

local sft = false
local sft_x = -100

-- Paints player status HUD element in the bottom left
function GM:HUDPaint()
   local client = LocalPlayer()

   if sft then
      draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0,0,0,255))
      draw.RoundedBox(0, sft_x - 100, 0, 200, ScrH(), Color(255,255,255,255))
      sft_x = sft_x + 2
      if sft_x > (ScrW() + 100) then
         sft_x = -100
      end

      if input.IsKeyDown(KEY_N) then
         draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255,0,0,255))
      end

      return
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTargetID" ) then
       hook.Call( "HUDDrawTargetID", GAMEMODE )
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTMStack" ) then
       MSTACK:Draw(client)
   end

   if (not client:Alive()) or client:Team() == TEAM_SPEC then
      if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTSpecHUD" ) then
          SpecHUDPaint(client)
      end

      return
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTRadar" ) then
       RADAR:Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTButton" ) then
       TBHUD:Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTWSwitch" ) then
       WSWITCH:Draw(client)
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTVoice" ) then
       VOICE.Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTDisguise" ) then
       DISGUISE.Draw(client)
   end
   
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTCloak" ) then
       CLOAK.Draw(client)
   end

   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTPickupHistory" ) then
       hook.Call( "HUDDrawPickupHistory", GAMEMODE )
   end

   -- Draw bottom left info panel
   if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTInfoPanel" ) then
       InfoPaint(client)
   end
end

-- Hide the standard HUD stuff
local hud = {["CHudHealth"] = true, ["CHudBattery"] = true, ["CHudAmmo"] = true, ["CHudSecondaryAmmo"] = true}
function GM:HUDShouldDraw(name)
   --if true then return false end
   if hud[name] then return false end

   return self.BaseClass.HUDShouldDraw(self, name)
end

