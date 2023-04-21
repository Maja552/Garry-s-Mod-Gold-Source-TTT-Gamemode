GM.Name = "Trouble in Terrorist Town"
GM.Author = "Bad King Urgrain"
GM.Website = "ttt.badking.net"
GM.Version = "shrug emoji"


GM.Customized = false

-- Round status consts
ROUND_WAIT   = 1
ROUND_PREP   = 2
ROUND_ACTIVE = 3
ROUND_POST   = 4

-- Player roles
ROLE_INNOCENT = 0
ROLE_TRAITOR = 1
ROLE_DETECTIVE = 2
ROLE_ZOMBIE = 3
ROLE_NONE = ROLE_INNOCENT

-- Game event log defs
EVENT_KILL        = 1
EVENT_SPAWN       = 2
EVENT_GAME        = 3
EVENT_FINISH      = 4
EVENT_SELECTED    = 5
EVENT_BODYFOUND   = 6
EVENT_C4PLANT     = 7
EVENT_C4EXPLODE   = 8
EVENT_CREDITFOUND = 9
EVENT_C4DISARM    = 10

WIN_NONE      = 1
WIN_TRAITOR   = 2
WIN_INNOCENT  = 3
WIN_TIMELIMIT = 4
WIN_ZOMBIE    = 5
WIN_HUMAN     = 6

-- Weapon categories, you can only carry one of each
WEAPON_NONE   = 0
WEAPON_MELEE  = 1
WEAPON_PISTOL = 2
WEAPON_HEAVY  = 3
WEAPON_NADE   = 4
WEAPON_CARRY  = 5
WEAPON_EQUIP1 = 6
WEAPON_EQUIP2 = 7
WEAPON_ROLE   = 8

WEAPON_EQUIP = WEAPON_EQUIP1
WEAPON_UNARMED = -1

-- Kill types discerned by last words
KILL_NORMAL  = 0
KILL_SUICIDE = 1
KILL_FALL    = 2
KILL_BURN    = 3

-- Entity types a crowbar might open
OPEN_NO   = 0
OPEN_DOOR = 1
OPEN_ROT  = 2
OPEN_BUT  = 3
OPEN_NOTOGGLE = 4 --movelinear

-- Mute types
MUTE_NONE = 0
MUTE_TERROR = 1
MUTE_ALL = 2
MUTE_SPEC = 1002

COLOR_WHITE  = Color(255, 255, 255, 255)
COLOR_BLACK  = Color(0, 0, 0, 255)
COLOR_GREEN  = Color(0, 255, 0, 255)
COLOR_DGREEN = Color(0, 100, 0, 255)
COLOR_RED    = Color(255, 0, 0, 255)
COLOR_YELLOW = Color(200, 200, 0, 255)
COLOR_LGRAY  = Color(200, 200, 200, 255)
COLOR_BLUE   = Color(0, 0, 255, 255)
COLOR_NAVY   = Color(0, 0, 100, 255)
COLOR_PINK   = Color(255,0,255, 255)
COLOR_ORANGE = Color(250, 100, 0, 255)
COLOR_OLIVE  = Color(100, 100, 0, 255)

include("util.lua")
include("lang_shd.lua") -- uses some of util
include("equip_items_shd.lua")

function DetectiveMode() return GetGlobalBool("ttt_detective", false) end
function HasteMode() return GetGlobalBool("ttt_haste", false) end

-- Create teams
TEAM_TERROR = 1
TEAM_SPEC = TEAM_SPECTATOR

function GM:CreateTeams()
   team.SetUp(TEAM_TERROR, "Terrorists", Color(0, 200, 0, 255), false)
   team.SetUp(TEAM_SPEC, "Spectators", Color(200, 200, 0, 255), true)

   -- Not that we use this, but feels good
   team.SetSpawnPoint(TEAM_TERROR, "info_player_deathmatch")
   team.SetSpawnPoint(TEAM_SPEC, "info_player_deathmatch")
end

-- Everyone's model
ttt_playermodels = {
   Model("models/cs/playermodels/arctic.mdl"),
   Model("models/cs/playermodels/leet.mdl"),
   Model("models/cs/playermodels/guerilla.mdl"),
   Model("models/cs/playermodels/terror.mdl"),

   Model("models/cs/playermodels/gign.mdl"),
   Model("models/cs/playermodels/gsg9.mdl"),
   Model("models/cs/playermodels/sas.mdl"),
   Model("models/cs/playermodels/urban.mdl"),

   --Model("models/player/hl1/helmet.mdl"),
   --Model("models/player/hl1/hgrunt.mdl"),
};

function GetRandomPlayerModel()
   return table.Random(ttt_playermodels)
end

local ttt_playercolors = {
   all = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_GREEN,
      COLOR_DGREEN,
      COLOR_RED,
      COLOR_YELLOW,
      COLOR_LGRAY,
      COLOR_BLUE,
      COLOR_NAVY,
      COLOR_PINK,
      COLOR_OLIVE,
      COLOR_ORANGE
   },

   serious = {
      COLOR_WHITE,
      COLOR_BLACK,
      COLOR_NAVY,
      COLOR_LGRAY,
      COLOR_DGREEN,
      COLOR_OLIVE
   }
};

CreateConVar("ttt_playercolor_mode", "1")
function GM:TTTPlayerColor(model)
   local mode = GetConVarNumber("ttt_playercolor_mode") or 0
   if mode == 1 then
      return table.Random(ttt_playercolors.serious)
   elseif mode == 2 then
      return table.Random(ttt_playercolors.all)
   elseif mode == 3 then
      -- Full randomness
      return Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
   end
   -- No coloring
   return COLOR_WHITE
end

local new_cs16_sounds = {}
new_cs16_sounds["metal"] = "cstrike/"

function GM:PlayerFootstep(ply, pos, foot, sound, volume, rf)
   if CLIENT or !IsValid(ply) or ply:IsSpec() or ply:HasEquipmentItem(EQUIP_BOOTS_STEALTH) then return true end

   local new_fstep = "cstrike/player/pl_step"..math.random(1,4)..".wav"
   
   if ply:Crouching() or ply:GetMaxSpeed() < 150 then
     -- ply:EmitSound(new_fstep, 60, 100, 0.1)
      return true
   end

   if string.find(sound, "wade") then
      new_fstep = "cstrike/player/pl_slosh"..math.random(1,4)..".wav"

   elseif string.find(sound, "slosh") then
      new_fstep = "cstrike/player/pl_slosh"..math.random(1,4)..".wav"

   elseif string.find(sound, "metal") then
      new_fstep = "cstrike/player/pl_metal"..math.random(1,4)..".wav"

   elseif string.find(sound, "duct") then
      new_fstep = "cstrike/player/pl_duct"..math.random(1,4)..".wav"

   elseif string.find(sound, "ladder") then
      new_fstep = "cstrike/player/pl_ladder"..math.random(1,4)..".wav"

   elseif string.find(sound, "tile") then
      new_fstep = "cstrike/player/pl_tile"..math.random(1,5)..".wav"

   elseif string.find(sound, "grass") or string.find(sound, "dirt") or string.find(sound, "sand") then
      new_fstep = "cstrike/player/pl_dirt"..math.random(1,4)..".wav"

   elseif string.find(sound, "snow") then
      new_fstep = "cstrike/player/pl_snow"..math.random(1,6)..".wav"
   end

   ply:EmitSound(new_fstep, 75, 100, volume)
   return true
end

-- Predicted move speed changes
function GM:Move(ply, mv)
   if ply:IsTerror() then
      local basemul = 1
      local slowed = false
      -- Slow down ironsighters
      local wep = ply:GetActiveWeapon()
      if IsValid(wep) and wep.GetIronsights and wep:GetIronsights() then
         basemul = 120 / 220
         slowed = true
      end
      local mul = hook.Call("TTTPlayerSpeedModifier", GAMEMODE, ply, slowed, mv) or 1
      mul = basemul * mul
      mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
      mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
   end
end


-- Weapons and items that come with TTT. Weapons that are not in this list will
-- get a little marker on their icon if they're buyable, showing they are custom
-- and unique to the server.
DefaultEquipment = {
   -- traitor-buyable by default
   [ROLE_TRAITOR] = {
      "weapon_ttt_c4",
      "weapon_ttt_flaregun",
      "weapon_ttt_knife",
      "weapon_ttt_phammer",
      "weapon_ttt_push",
      "weapon_ttt_radio",
      "weapon_ttt_sipistol",
      "weapon_ttt_teleport",
      "weapon_ttt_decoy",
      EQUIP_ARMOR,
      EQUIP_RADAR,
      EQUIP_DISGUISE,
      EQUIP_CLOAK
   },

   [ROLE_ZOMBIE] = {
   },

   -- detective-buyable by default
   [ROLE_DETECTIVE] = {
      "weapon_ttt_binoculars",
      "weapon_ttt_defuser",
      "weapon_ttt_health_station",
      "weapon_ttt_stungun",
      "weapon_ttt_cse",
      "weapon_ttt_teleport",
      EQUIP_ARMOR,
      EQUIP_RADAR
   },

   -- non-buyable
   [ROLE_NONE] = {
      "weapon_ttt_confgrenade",
      "weapon_ttt_m16",
      "weapon_ttt_smokegrenade",
      "weapon_ttt_unarmed",
      "weapon_ttt_wtester",
      "weapon_tttbase",
      "weapon_tttbasegrenade",
      "weapon_zm_carry",
      "weapon_zm_improvised",
      "weapon_zm_mac10",
      "weapon_zm_molotov",
      "weapon_zm_pistol",
      "weapon_zm_revolver",
      "weapon_zm_rifle",
      "weapon_zm_shotgun",
      "weapon_zm_sledge",
      "weapon_ttt_glock"
   }
};

local function sh_init()
   print("Initialization hook called")

   game.AddAmmoType({
      name = "ammo_new_556",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 3,
      maxsplash = 6
   })

   game.AddAmmoType({
      name = "ammo_new_762",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 4,
      maxsplash = 8
   })
   
   game.AddAmmoType({
      name = "ammo_new_57",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 4,
      maxsplash = 8
   })

   game.AddAmmoType({
      name = "ammo_new_50",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 5,
      maxsplash = 10
   })

   game.AddAmmoType({
      name = "ammo_new_9mm",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 2,
      maxsplash = 6
   })

   game.AddAmmoType({
      name = "ammo_new_45",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 3,
      maxsplash = 6
   })

   game.AddAmmoType({
      name = "ammo_new_12g",
      dmgtype = DMG_BULLET,
      tracer = TRACER_LINE,
      plydmg = 0,
      npcdmg = 0,
      force = 100,
      minsplash = 1,
      maxsplash = 3
   })

   if language then
      local all_new_ammo_types = {
         {"ammo_new_556", "5.56×45mm NATO"},
         {"ammo_new_762", "7.62×51mm NATO"},
         {"ammo_new_57", "FN 5.7×28mm"},
         {"ammo_new_50", ".50 Action Express"},
         {"ammo_new_9mm", "9×19mm Parabellum"},
         {"ammo_new_45", ".45 ACP"},
         {"ammo_new_12g", "12 Gauge"}
      }
      
      for k,v in pairs(all_new_ammo_types) do
         language.Add(v[1] .. "_ammo", v[2])
      end
   end
end
hook.Add("Initialize", "sh_initialize_ammos", sh_init)

GSTTT_COMMS_SABOTAGED_TIL = 0
