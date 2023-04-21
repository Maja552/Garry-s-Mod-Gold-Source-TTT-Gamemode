AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "grenade_smoke"
   SWEP.Slot            = 3

   SWEP.ViewModelFlip   = true
   SWEP.ViewModelFOV    = 80

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "Q"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.WeaponID           = AMMO_SMOKE
SWEP.Kind               = WEAPON_NADE

SWEP.UseHands           = true
SWEP.ViewModel          = "models/cs/v_smokegrenade.mdl"
SWEP.WorldModel         = "models/cs/p_smokegrenade.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_smokegrenade_proj"
end
