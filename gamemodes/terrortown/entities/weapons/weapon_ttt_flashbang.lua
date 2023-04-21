AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "flashbang_name"
   SWEP.Slot            = 6

   SWEP.ViewModelFlip   = true
   SWEP.ViewModelFOV    = 80

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "flashbang_desc"
   };

   SWEP.Icon            = "vgui/ttt/icon_flashbang"
   SWEP.IconLetter      = "Q"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.WeaponID           = WEAPON_EQUIP
SWEP.CanBuy             = {ROLE_TRAITOR} -- only traitors can buy
SWEP.Kind               = WEAPON_EQUIP

SWEP.UseHands           = true
SWEP.ViewModel          = "models/cs/v_flashbang.mdl"
SWEP.WorldModel         = "models/cs/p_flashbang.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

SWEP.ShoutAlert = false
SWEP.detonate_timer = 2


function SWEP:GetGrenadeName()
   return "ttt_flashbang_proj"
end


