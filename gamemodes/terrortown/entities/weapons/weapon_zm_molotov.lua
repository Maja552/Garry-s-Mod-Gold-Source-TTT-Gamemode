AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "grenade_fire"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = true
   SWEP.ViewModelFOV    = 80

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "P"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.Kind               = WEAPON_NADE
SWEP.WeaponID           = AMMO_MOLOTOV

SWEP.UseHands           = true
SWEP.ViewModel          = "models/cs/v_hegrenade.mdl"
SWEP.WorldModel         = "models/cs/p_hegrenade.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_firegrenade_proj"
end
